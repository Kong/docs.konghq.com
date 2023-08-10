const { Octokit } = require("@octokit/rest");
const github = require("@actions/github");
const argv = require("minimist")(process.argv.slice(2));
const fg = require("fast-glob");

const convertFilePathsToUrls = require("../_utilities/path-to-url");
const checkUrls = require("./lib/check-url-list");
const srcToUrls = require("../_utilities/lib/src-to-urls");

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

async function main() {
  const type = argv._[0];
  const baseUrl = argv.base_url || "http://localhost:8888";

  if (
    baseUrl.includes("https://docs.konghq.com") ||
    baseUrl.includes("http://docs.konghq.com")
  ) {
    console.log("This tool can not be run against production");
    process.exit(1);
  }

  // Are there any additional patterns to ignore failures on?
  let ignore = argv.ignore || [];
  if (typeof ignore === "string") {
    ignore = [ignore];
  }
  const ignoreFailures = ignore.map((i) => new RegExp(i));

  const options = {
    ignore: ignoreFailures,
    verbose: argv.verbose ? true : false,
  };
  let changes; // This will be set by one of the implementations

  if (type == "pr") {
    options.pull_number = argv.pr || github.context.issue.number;
    options.is_fork =
      argv.is_fork !== undefined
        ? argv.is_fork
        : github.context.payload.pull_request.head.repo.fork;
    console.log(
      `Loading changed files for PR ${options.pull_number} (fork: ${options.is_fork})`,
    );
    changes = await buildPrUrls(options);
  } else if (type == "product") {
    options.nav = argv.nav;
    changes = await buildProductUrls(options);
  } else if (type == "plugins") {
    options.pattern = argv.pattern;
    changes = await buildPluginUrls(options);
  } else {
    console.log(`Unsupported check type: ${type}`);
    return;
  }

  // Run the check
  if (changes.length) {
    // Remove any ignored paths
    const ignoredPaths = require("./config/ignored_paths.json").map(
      (r) => new RegExp(r),
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
        `IGNORING the following URLs:\n\n${ignoredUrls.join("\n")}\n`,
      );
    }

    // List the URLs to be checked
    console.log(
      `Checking the following URLs on ${baseUrl}\n\n${changes
        .map((u) => u.url)
        .join("\n")}\n`,
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
      skip_edit_link: options.is_fork,
      ignore: options.ignore,
      verbose: options.verbose,
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
}

// Implementations for each mode
async function buildPrUrls(options) {
  if (github.context.repo.owner) {
    options = { ...github.context.repo, ...options };
  }

  // Get pages that have changed in the PR
  const files = await octokit.paginate(
    octokit.rest.pulls.listFiles,
    options,
    (response) => response.data,
  );

  return convertFilePathsToUrls(files);
}

async function buildProductUrls(options) {
  if (!options.nav) {
    console.log("Provide a nav file e.g. 'gateway_3.0.x' using --nav");
    process.exit(1);
  }
  return srcToUrls(options.nav);
}

async function buildPluginUrls(options) {
  let navEntries = await (
    await fg(`../../app/_hub/${options.pattern}.md`)
  ).map((u) => {
    return {
      url: u
        .replace(/^\.\.\/\.\.\/app\/_hub\//, "/hub/")
        .replace(/\/_.*\.md$/, "/"),
    };
  });

  return navEntries;
}

// If module main run directly, otherwise export for testing
if (require.main === module) {
  main();
}

module.exports = Object.assign(main, {
  buildPrUrls,
});
