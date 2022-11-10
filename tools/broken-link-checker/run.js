const { Octokit } = require("@octokit/rest");
const github = require("@actions/github");
const argv = require("minimist")(process.argv.slice(2));

const navToProductIndexUrl = require("./lib/nav-to-url");
const checkUrls = require("./lib/check-url-list");
const fileToUrls = require("./lib/src-to-urls");

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

(async function () {
  const type = argv._[0];
  const baseUrl = argv.base_url || "http://localhost:8888";

  const is_fork =
    argv.is_fork !== undefined
      ? argv.is_fork
      : github.context.payload.pull_request.head.repo.fork;

  const options = {};
  let changes; // This will be set by one of the implementations

  if (type == "pr") {
    // Extract PR info from argv
    options.pull_number = argv.pr || github.context.issue.number;
    changes = await buildPrUrls(options);
  } else {
    console.log(`Unsupported check type: ${type}`);
  }

  // Run the check
  if (changes.length) {
    // Remove any ignored paths
    const ignoredPaths = require("./ignored_paths.json").map(
      (r) => new RegExp(r)
    );
    const ignoredUrls = [];
    for (let item of ignoredPaths) {
      changes = changes.filter((u) => {
        const shouldIgnore = u.url.match(item);
        if (shouldIgnore) {
          ignoredUrls.push(`${u.url} (${item})`);
        }
        return !shouldIgnore;
      });
    }

    if (ignoredUrls.length) {
      console.log(
        `IGNORING the following URLs:\n\n${ignoredUrls.join("\n")}\n`
      );
    }

    // Run the check
    console.log(
      `Checking the following URLs on ${baseUrl}:\n\n${changes
        .map((u) => u.url)
        .join("\n")}\n`
    );

    // Prepend the base URL
    changes = changes.map((u) => {
      return {
        ...u,
        url: `${baseUrl}${u.url}`,
      };
    });

    // Check all the URLs provided
    const r = await checkUrls(changes, {
      skip_edit_link: is_fork,
    });

    // Output report
    if (r.length) {
      console.log("Broken links:");
      console.log(JSON.stringify(r, null, 2));
      process.exit(1);
    }

    console.log("No broken links detected");
  } else {
    console.log("No URLs detected to test");
  }
})();

async function buildPrUrls(options) {
  // Get pages that have changed in the PR
  const filenames = (
    await octokit.paginate(
      octokit.rest.pulls.listFiles,
      {
        ...github.context.repo,
        pull_number: options.pull_number,
      },
      (response) => response.data
    )
  ).map((f) => f.filename);

  // Map those to URLs
  let urls = [];
  for (let f of filenames) {
    let urlsToAdd = [];

    // If any data files have changed, we need to check a page that uses that
    // file to generate the side navigation. Let's use the index page
    if (f.startsWith("app/_data/docs_nav_")) {
      urlsToAdd = [
        {
          source: f,
          url: navToProductIndexUrl(f),
        },
      ];
    }

    // Handle any prose changes where file path == URL
    else if (f.startsWith("app/") && !f.startsWith("app/_")) {
      urlsToAdd = [
        {
          source: f,
          url: `/${f.replace(/^app\//, "").replace(/(index)?\.md$/, "")}`,
        },
      ];
    }

    // Any changes in src
    else if (f.startsWith("src/")) {
      urlsToAdd = await fileToUrls(f, "*");
    }

    // Add the URLs
    urls = urls.concat(urlsToAdd);
  }

  return Array.from(new Set(urls));
}
