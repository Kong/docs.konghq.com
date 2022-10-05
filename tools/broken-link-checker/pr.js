const { Octokit } = require("@octokit/rest");
const { HtmlUrlChecker } = require("broken-link-checker");
const github = require("@actions/github");
const argv = require("minimist")(process.argv.slice(2));

const yaml = require("js-yaml");
const fs = require("fs");
const fg = require("fast-glob");

(async function () {
  const pull_number = argv.pr || github.context.issue.number;
  const is_fork =
    argv.is_fork !== undefined
      ? argv.is_fork
      : github.context.payload.pull_request.head.repo.fork;

  const baseUrl = `https://deploy-preview-${pull_number}--kongdocs.netlify.app`;

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
    (response) => response.data
  );

  const filenames = files.map((f) => f.filename);

  // Generate a list of URLs to test
  let urls = [];

  const source = {};

  let navEntries = await fg(`../../app/_data/docs_nav_*.yml`);
  navEntries = navEntries
    .map((f) => {
      return yaml.load(fs.readFileSync(f, "utf8"));
    })
    .filter((n) => {
      return n.generate;
    });

  for (let f of filenames) {
    let urlsToAdd = [];
    // If any data files have changed, we need to check a page that uses that
    // file to generate the side navigation
    if (f.startsWith("app/_data/docs_nav_")) {
      urlsToAdd = [`${baseUrl}${dataFileToUrl(f)}`];
    }

    // Handle any prose changes
    else if (f.startsWith("app/") && !f.startsWith("app/_")) {
      urlsToAdd = [
        `${baseUrl}/${f.replace(/^app\//, "").replace(/(index)?\.md$/, "")}`,
      ];
    }

    // Any changes in src
    else if (f.startsWith("src/")) {
      urlsToAdd = (await srcToUrls(f, navEntries)).map((u) => `${baseUrl}/${u}`);
    }

    for (let u of urlsToAdd) {
      source[u] = f;
    }

    // Add the URLs
    urls = urls.concat(urlsToAdd);
  }

  urls = Array.from(new Set(urls));

  const blockList = [/.*\/changelog\/?/];
  const ignoredUrls = [];

  for (let item of blockList) {
    urls = urls.filter((u) => {
      const shouldIgnore = u.match(item);
      if (shouldIgnore) {
        ignoredUrls.push(`${u} (${item})`);
      }
      return !shouldIgnore;
    });
  }

  if (ignoredUrls.length) {
    console.log(`IGNORING the following URLs:\n\n${ignoredUrls.join("\n")}\n`);
  }

  if (urls.length) {
    console.log(`Checking the following URLs:\n\n${urls.join("\n")}\n`);
    // Check all the URLs provided
    const r = await checkUrls(urls, is_fork, source);

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

function checkUrls(urls, is_fork, source) {
  return new Promise((resolve, reject) => {
    const exclusions = require("./excluded.json");
    const brokenLinks = new Set();
    const htmlUrlChecker = new HtmlUrlChecker(
      {
        honorRobotExclusions: false,
        excludedKeywords: exclusions,
        maxSocketsPerHost: 64,
      },
      {
        link: (result) => {
          if (result.broken) {
            // Handle HTTP 308 which is a valid response
            if (result.brokenReason === "HTTP_308") {
              return;
            }

            // Don't report on the "Edit this page" links for forks as
            // they'll always be broken
            if (
              is_fork &&
              result.html.text === "Edit this page" &&
              result.url.resolved.match(
                /.*github.com\/Kong\/docs.konghq.com\/edit\/.*/
              )
            ) {
              return;
            }

            brokenLinks.add({
              page: result.base.resolved,
              source: source[result.base.resolved],
              text: result.html.text,
              target: result.url.resolved,
              reason: result.brokenReason,
            });
          }
        },
        queue: (a) => {
          console.log(require("util").inspect(a));
        },
        end: () => {
          resolve(Array.from(brokenLinks));
        },
      }
    );

    for (const u of urls) {
      htmlUrlChecker.enqueue(u);
    }
  });
}

function dataFileToUrl(filename) {
  const lookup = {
    ce: "gateway-oss",
    deck: "deck",
    ee: "enterprise",
    gsg: "getting-started-guide",
    kic: "kubernetes-ingress-controller",
    konnect: "konnect",
    mesh: "mesh",
    gateway: "gateway",
    contributing: "contributing",
  };

  filename = filename.replace("app/_data/docs_nav_", "").replace(/\.yml$/, "");

  const [edition, version] = filename.split("_", 2);

  if (!lookup[edition]) {
    throw new Error(`Unknown product: ${edition}`);
  }

  return `/${lookup[edition]}/${version}/`;
}

async function srcToUrls(src, navEntries) {
  let urls = [];

  // Build a map of src files to URLs
  for (const entry of navEntries) {
    const r = extractNavWithMeta(entry.items, ``, `src/${entry.product}`);
    urls = urls.concat(
      r
        .filter((u) => u.src == src)
        .map((u) => `${entry.product}/${entry.release}${u.url}`)
    );
  }

  urls = Array.from(new Set(urls));

  return urls;
}

function extractNavWithMeta(items, base, srcPrefix) {
  let urls = [];
  for (let u of items) {
    if (u.items) {
      urls = urls.concat(extractNavWithMeta(u.items, base, srcPrefix));
    } else {
      if (u.absolute_url) {
        urls.push({
          src: u.src || u.url,
          url: u.url,
        });
      } else {
        const url = `${base}${u.url}`;
        urls.push({
          src: srcPrefix + (u.src || url)
                .replace(/\/?#.*$/, "") // Remove anchor links
                .replace(/\/$/,"") // Remove trailing slashes
                + ".md",
          url,
        });
      }
    }
  }

  return urls;
}
