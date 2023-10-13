const fg = require("fast-glob");
const semver = require("semver");
const argv = require("minimist")(process.argv.slice(2));

const { SiteChecker } = require("broken-link-checker");

(async function () {
  const host = argv.host;

  if (!host) {
    console.log("Please provide the --host argument");
    process.exit(1);
  }

  if (
    host.includes("https://docs.konghq.com") ||
    host.includes("http://docs.konghq.com")
  ) {
    console.log("This tool can not be run against production");
    process.exit(1);
  }

  // We only want to test the latest version of each product, so exclude all
  // old versions by extracting versions from _data
  const lookup = {
    deck: "deck",
    kic: "kubernetes-ingress-controller",
    konnect: "konnect",
    mesh: "mesh",
    gateway: "gateway",
  };
  const path = "*";
  let files = await fg(`../../app/_data/docs_nav_${path}.yml`);
  files = files
    .map((f) => {
      if (f.includes("docs_nav_contributing")) {
        return;
      }
      const item = { path: f };
      const info = f
        .replace("../../app/_data/docs_nav_", "")
        .replace(/\.yml$/, "");

      // Special case Konnect
      if (info === "konnect") {
        item.type = "konnect";
        item.version = "";
      } else {
        const x = info.split("_");
        item.type = lookup[x[0]];

        // Handle kuma_dev gracefully
        if (semver.valid(semver.coerce(x[1]))) {
          item.version = semver.coerce(x[1]).raw;
        } else {
          item.version = x[1];
        }
        item.original_version = x[1];
      }
      return item;
    })
    .filter((n) => n);

  const ignored = [];
  const current = {};

  for (let nav of files) {
    const t = nav.type;
    const existing = current[t];
    if (existing) {
      if (semver.valid(nav.version)) {
        if (semver.gt(nav.version, existing.version)) {
          ignored.push(existing);
          current[t] = nav;
        } else {
          ignored.push(nav);
        }
      }
    } else {
      current[t] = nav;
    }
  }

  // Build ignore list for old versions
  let excluded = ignored.flatMap((i) => {
    return [
      `/${i.type}/${i.original_version}`,
      `/${i.type}/${i.original_version}/*`,
    ].map((l) => `${host}${l}`);
  });

  // Add known list of exclusions
  excluded = excluded.concat(require("./config/ignored_targets.json"));

  // Excluded external sites for full scan only
  excluded.push("https://github.com/*");

  let processed = 0;
  const outputInterval = 1000;

  const broken = await new Promise((resolve, reject) => {
    const brokenLinks = new Set();
    const siteChecker = new SiteChecker(
      {
        honorRobotExclusions: false,
        excludedKeywords: excluded,
        maxSocketsPerHost: 128,
      },
      {
        link: (result) => {
          processed++;
          if (processed % outputInterval === 0) {
            console.log(`Processed ${processed} links`);
          }

          if (result.broken) {
            // Handle HTTP 308 which is a valid response
            if (result.brokenReason === "HTTP_308") {
              return;
            }

            brokenLinks.add({
              page: result.base.resolved,
              text: result.html.text,
              target: result.url.resolved,
              reason: result.brokenReason,
            });
          }
        },
        end: () => {
          console.log("Done!")
          resolve(Array.from(brokenLinks));
        },
      }
    );

    console.log("Starting check...");
    siteChecker.enqueue(host);
  });

  // Output report
  if (broken.length) {
    console.log("Broken links:");
    console.log(JSON.stringify(broken, null, 2));
    process.exit(1);
  }

  console.log("No broken links detected");
})();
