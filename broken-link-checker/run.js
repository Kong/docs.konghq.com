const { Octokit } = require("@octokit/rest");
const { HtmlUrlChecker } = require("broken-link-checker");
(async function () {
  const owner = "kong";
  const repo = "docs.konghq.com";
  //const pull_number = "3453"; // Data file changes
  const pull_number = "3528";

  const baseUrl = `https://deploy-preview-${pull_number}--kongdocs.netlify.app`;

  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });
  // Get pages that have changed in the PR

  const files = await octokit.paginate(
    octokit.rest.pulls.listFiles,
    {
      owner,
      repo,
      pull_number,
    },
    (response) => response.data
  );

  const filenames = files.map((f) => f.filename);

  const urls = [];
  for (let f of filenames) {
    // If any data files have changed, we need to check a page that uses that
    // file to generate the side navigation
    if (f.startsWith("app/_data/docs_nav_")) {
      urls.push(`${baseUrl}${dataFileToUrl(f)}`);
    }

    // Handle any prose changes
    else if (f.startsWith("app/") && !f.startsWith("app/_")) {
      urls.push(
        `${baseUrl}/${f.replace(/^app\//, "").replace(/(index)?\.md$/, "")}`
      );
    }
  }

  // Check all the URLs provided
  const r = await checkUrls(urls);
  console.log(urls);

  // Output report

  //console.log(r);
})();

function checkUrls(urls) {
  return new Promise((resolve, reject) => {
    const brokenLinks = new Set();
    const htmlUrlChecker = new HtmlUrlChecker(
      {
        honorRobotExclusions: false,
        excludedKeywords: [
          "https://linkedin.com/*",
          "https://aws.amazon.com/*",
        ],
        maxSocketsPerHost: 64,
      },
      {
        link: (result) => {
          console.log(result);
          if (result.broken) {
            // Handle HTTP 308 which is a valid response
            if (result.brokenReason === "HTTP_308") {
              return;
            }

            brokenLinks.add({
              page: result.base.resolved,
              target: result.url.resolved,
              reason: result.brokenReason,
              text: result.html.text,
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
  };

  filename = filename.replace("app/_data/docs_nav_", "").replace(/\.yml$/, "");

  const [edition, version] = filename.split("_", 2);

  if (!lookup[edition]) {
    throw new Error(`Unknown product: ${edition}`);
  }

  return `/${lookup[edition]}/${version}/`;
}
