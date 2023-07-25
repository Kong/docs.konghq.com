const fs = require("fs").promises;
const { subDays, startOfDay } = require("date-fns");

const { buildPrUrls } = require("../broken-link-checker/run");
const { fileURLToPath } = require("url");
const { cwd } = require("process");

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
      let prDate;
      for (let pr of response.data) {
        prDate = new Date(pr.created_at);
        if (prDate > earliestDate) {
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

  //pulls = [pulls[0]];

  const slimPrs = await Promise.all(
    pulls.map(async (pr) => {
      return {
        number: pr.number,
        title: pr.title,
        user: pr.user.login,
        url: pr.html_url,
        created_at: new Date(pr.created_at),
        affected_files: (
          await buildPrUrls({
            owner,
            repo,
            pull_number: pr.number,
          })
        ).map((v) => {
          return {
            url: `https://docs.konghq.com${v.url}`,
            status: v.status,
          };
        }),
      };
    }),
  );

  // Write the changelog
  let changelogContent = `# Changelog\n\n`;

  for (const pr of slimPrs) {
    changelogContent += `### PR ${pr.number}: [${pr.title}](${
      pr.url
    }) (${pr.created_at.toISOString()})\n`;

    const addedFiles = pr.affected_files.filter((u) => u.status == "added");
    if (addedFiles.length) {
      changelogContent += `## Added\n\n`;
      for (const file of addedFiles) {
        changelogContent += `- ${file.url}\n`;
      }
    }

    const changedFiles = pr.affected_files.filter(
      (u) => u.status == "modified",
    );
    if (changedFiles.length) {
      changelogContent += `## Modified\n\n`;
      for (const file of changedFiles) {
        changelogContent += `- ${file.url}\n`;
      }
    }

    changelogContent += `\n\n`;
  }

  console.log(changelogContent);
})();
