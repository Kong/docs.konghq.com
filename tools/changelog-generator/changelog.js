const fs = require("fs").promises;
const { subDays, startOfDay, format } = require("date-fns");
const groupBy = require("lodash.groupby");

const convertFilePathsToUrls = require("../_utilities/path-to-url");
const now = startOfDay(new Date());
const earliestDate = subDays(now, 7);

(async function () {
  // Create an octokit instance
  const { Octokit } = require("@octokit/rest");
  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });

  const owner = "Kong";
  const repo = "docs.konghq.com";

  let pulls = await octokit.paginate(
    octokit.pulls.list,
    {
      owner,
      repo,
      state: "closed",
      per_page: 100,
    },
    (response, done) => {
      const validPulls = [];

      for (let pr of response.data) {
        //console.log(JSON.stringify(pr));
        //process.exit(0);
        prDate = new Date(pr.merged_at);
        if (prDate > earliestDate && pr.merged_at && pr.base.ref == "main") {
          validPulls.push(pr);
        }
      }

      // If the last prDate we read is < earliestDate then stop fetching
      if (prDate < earliestDate) {
        done();
      }
      return validPulls;
    },
  );

  //pulls = pulls.slice(0, 1);

  let prsWithFiles = (
    await Promise.all(
      pulls.map(async (pr) => {
        const created_at = new Date(pr.merged_at);



        // Load the files for this PR using the API
        const pr_files = await octokit.paginate(
          octokit.rest.pulls.listFiles,
          {
            owner,
            repo,
            pull_number: pr.number,
          },
          (response) => response.data,
        );

        // Convert app, _src, /hub/ etc paths to URLs
        affected_files = (
          await convertFilePathsToUrls(pr_files, { skip_nav_files: true })
        ).map((v) => {
          return {
            url: `https://docs.konghq.com${v.url}`,
            status: v.status,
          };
        });

        return {
          number: pr.number,
          title: pr.title,
          description: extractDescription(pr.body),
          user: pr.user.login,
          url: pr.html_url,
          labels: pr.labels,
          created_at,
          week: format(created_at, "I"),
          affected_files,
        };
      }),
    )
  )
    
    .filter((pr) => pr.affected_files.length > 0)
    .filter((pr) => !pr.labels.map(l => l.name).includes("skip-changelog"));
  prsWithFiles = groupBy(prsWithFiles, "week");

  // Write the changelog
  let changelogContent = `# Changelog\n\n<!--vale off-->\n\n`;

  for (let week of Object.keys(prsWithFiles).reverse()) {
    changelogContent += `## Week ${week}\n\n`;

    for (const pr of prsWithFiles[week]) {
      changelogContent += `### [${pr.title}](${pr.url}) (${format(
        pr.created_at,
        "yyyy-MM-dd",
      )})\n\n`;

      changelogContent += `${pr.description}\n\n`;

      const addedFiles = pr.affected_files.filter((u) => u.status == "added");
      const changedFiles = pr.affected_files.filter(
        (u) => u.status == "modified",
      );

      if (addedFiles.length) {
        changelogContent += `#### Added\n\n`;
        for (const file of addedFiles) {
          changelogContent += `- ${file.url}\n`;
        }
      }

      if (addedFiles.length && changedFiles.length) {
        changelogContent += `\n`;
      }

      if (changedFiles.length) {
        changelogContent += `#### Modified\n\n`;
        for (const file of changedFiles) {
          changelogContent += `- ${file.url}\n`;
        }
      }

      changelogContent += `\n\n`;
    }
  }

  changelogContent = changelogContent.trim();

  // Prepend changelogContent to changelog.md
  const changelogFile = __dirname + "/../../changelog.md";
  let existingChangelog = "";

  try {
    existingChangelog = await fs.readFile(changelogFile, "utf8");
  } catch (e) {
    console.log(e); // for debugging why the file is being overwritten.
  }

  changelogContent = `${changelogContent}\n\n${existingChangelog.replace(
    "# Changelog\n\n<!--vale off-->\n\n",
    "",
  )}`;
  await fs.writeFile(changelogFile, changelogContent);
})();

function extractDescription(body) {
  body = body || "";
  return body
    .split("### Testing instructions")[0]
    .replace("### Description", "")
    .trim();
}
