const { Octokit } = require("@octokit/rest");
const github = require("@actions/github");
const matter = require("gray-matter");
const argv = require("minimist")(process.argv.slice(2));

(async function () {
  const pull_number = argv.pr || github.context.issue.number;

  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });

  // Get pages that have changed in the PR
  const files = await octokit.paginate(
    octokit.rest.pulls.listFiles,
    {
      ...github.context.repo,
      pull_number,
    },
    (response) => response.data.filter((f) => f.filename.endsWith(".md"))
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

    await octokit.rest.issues.createComment({
      ...github.context.repo,
      issue_number: pull_number,
      body: comment,
    });

    await octokit.rest.issues.addLabels({
      ...github.context.repo,
      issue_number: pull_number,
      labels: ["ci:prevent-merge:generated-files"],
    });
  }
})();
