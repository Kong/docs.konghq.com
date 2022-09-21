const { HtmlUrlChecker } = require("broken-link-checker");
const argv = require('minimist')(process.argv.slice(2));

const yaml = require('js-yaml');
const fs   = require('fs');

(async function () {
  let host = argv.host || "http://localhost:8888";
  if (host[host.length -1] == "/"){
    host = host.substring(0, host.length-1)
  }

  if (
    host.includes("https://docs.konghq.com") ||
    host.includes("http://docs.konghq.com")
  ) {
    console.log("This tool can not be run against production");
    process.exit(1);
  }

  const perPage = argv.perPage || 10;
  const page = argv.page;

  const nav = argv.nav;
  if (!nav){
    console.log("Provide a nav file e.g. 'gateway_3.0.x' using --nav");
    process.exit(1);
  }

  let items = yaml.load(fs.readFileSync(`../../app/_data/docs_nav_${nav}.yml`, 'utf8'));

  // If it's a single sourced doc, extract the items directly
  if (items.items) {
    items = items.items;
  }

  const prefix = `/${nav.replace('_','/')}`;
  let urls = extractNav(items, prefix);

  if (page !== undefined){
    const offset = page * perPage;
    urls = urls.slice(offset, offset + perPage);
  }

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

  urls = urls.map(u => `${host}${u}`)

  if (urls.length) {
    console.log(`Checking the following URLs:\n\n${urls.join("\n")}\n`);

    // Are there any patterns to ignore failures on?
    let ignore = argv.ignore || [];
    if (typeof ignore === "string") {
      ignore = [ignore];
    }
    const ignoreFailures = ignore.map(i => new RegExp(i))

    // Check all the URLs provided
    const r = await checkUrls(urls, ignoreFailures);

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

function checkUrls(urls, ignoreFailures) {
  return new Promise((resolve, reject) => {
    const exclusions = require("./excluded.json");
    const brokenLinks = new Set();
    const htmlUrlChecker = new HtmlUrlChecker(
      {
        honorRobotExclusions: false,
        excludedKeywords: exclusions,
        maxSocketsPerHost: 64,
        requestMethod: 'get'
      },
      {
        link: (result) => {
          if (result.broken) {
            // Handle HTTP 308 which is a valid response
            if (result.brokenReason === "HTTP_308") {
              return;
            }

            // Ignore any broken links in the --ignore list
            for (b of ignoreFailures){
              if (result.url.resolved.match(b)){
                return;
              }
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
          resolve(Array.from(brokenLinks));
        },
      }
    );

    for (const u of urls) {
      htmlUrlChecker.enqueue(u);
    }
  });
}

function extractNav(items, base){
  let urls = [];
  for (let u of items){
    if (u.items){
      urls = urls.concat(extractNav(u.items, base))
    } else {
      if (u.absolute_url){
        urls.push(u.url)
      } else {
      urls.push(`${base}${u.url}`)
      }
    }
  }
  return urls;
}