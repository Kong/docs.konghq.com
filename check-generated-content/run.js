const { Octokit } = require("@octokit/rest");
const github = require("@actions/github");
const matter = require("gray-matter");
const argv = require("minimist")(process.argv.slice(2));

(async function () {
  const pull_number = argv.pr || github.context.issue.number;
  const MAX_CHANGED_FILES = 50; // This means we can run 20 times per hour if needed

  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });

  // Get the PR changes to check that it's < MAX_CHANGED_FILES files
  const { data: pr } = await octokit.rest.pulls.get({
    ...github.context.repo,
    pull_number
  });

  // If there are more than that, add a label and don't check anything else
  if (pr.changed_files > MAX_CHANGED_FILES){
    await octokit.rest.issues.addLabels({
      ...github.context.repo,
      issue_number: pull_number,
      labels: ["ci:check-skipped:generated-files"],
    });
    return;
  }

  // Get pages that have changed in the PR
  const files = await octokit.paginate(
    octokit.rest.pulls.listFiles,
    {
      ...github.context.repo,
      pull_number,
      per_page: 50
    },
    (response) => response.data.filter((f) => f.status != "removed" && f.filename.endsWith(".md") )
  );

  // Load contents for each file
  const frontmatter = await Promise.all(
    files.map(async (file) => {
      const { data: c } = await octokit.rest.repos.getContent({
        ...github.context.repo,
        path: file.filename,
        ref: github.context.sha,
      });
      return {
        filename: file.filename,
        data: matter(Buffer.from(c.content, "base64").toString()).data,
      };
    })
  );

  const comments = {};
  for (let file of frontmatter) {
    if (file.data.source_url) {
      const url = file.data.source_url;
      if (!comments[url]) {
        comments[url] = [];
      }
      comments[url].push(file.filename);
    }
  }

  // If we have any generated files, add a comment
  if (Object.keys(comments).length) {
    // Is there an existing comment?
    const { data: existing } = await octokit.rest.issues.listComments({
      ...github.context.repo,
      issue_number: pull_number,
    });

    const generatedComment = existing.find((c) =>
      c.body.includes(":warning: This PR edits generated files.")
    );

    // Add or edit a comment
    let comment =
      ":warning: This PR edits generated files. Please make sure that the source file is updated.\n\n";

    const sourceFiles = [];
    for (let source in comments) {
      let body = `**${source}:**\n\n`;
      for (let file of comments[source]) {
        body += `* ${file}\n`;
      }
      sourceFiles.push(body);
    }

    comment += sourceFiles.join(`\n----------\n\n`);

    const params = {
      ...github.context.repo,
      issue_number: pull_number,
      body: comment,
    };

    // If we have a comment ID let's update the text on that
    // comment instead of creating a new one
    let method = "createComment";
    if (generatedComment) {
      method = "updateComment";
      params.comment_id = generatedComment.id;
    }
    await octokit.rest.issues[method](params);

    await octokit.rest.issues.addLabels({
      ...github.context.repo,
      issue_number: pull_number,
      labels: ["ci:prevent-merge:generated-files"],
    });
  }
})();
