const argv = require("minimist")(process.argv.slice(2));

const yaml = require("js-yaml");
const fs = require("fs");

const fetch = require("node-fetch");
const cheerio = require("cheerio");

(async function () {
  let host = argv.host || "http://localhost:8888";
  if (host[host.length - 1] == "/") {
    host = host.substring(0, host.length - 1);
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
  if (!nav) {
    console.log("Provide a nav file e.g. 'gateway_3.0.x' using --nav");
    process.exit(1);
  }

  let items = yaml.load(
    fs.readFileSync(`../../app/_data/docs_nav_${nav}.yml`, "utf8"),
  );

  const prefix = `/${items.product}/${items.release}`;

  // If it's a single sourced doc, extract the items directly
  if (items.items) {
    items = items.items;
  }

  let urls = extractNav(items, prefix);

  if (page !== undefined) {
    const offset = page * perPage;
    urls = urls.slice(offset, offset + perPage);
  }

  urls = urls.map((u) => {
    if (u.startsWith("http")) {
      return u;
    }
    return `${host}${u}`;
  });

  if (urls.length) {
    console.log(`Checking the following URLs:\n\n${urls.join("\n")}\n`);

    // Check all the URLs provided
    const r = await checkUrls(urls, host);

    // Output report
    if (r.length) {
      console.log(
        "-----------------------------------------------------------------",
      );
      console.log(
        "Pages that link to themselves (no moved_urls.yml entry set):",
      );
      console.log(
        "-----------------------------------------------------------------",
      );
      console.log(r.join("\n"));
      process.exit(1);
    }

    console.log("No broken latest URLs detected");
  } else {
    console.log("No URLs detected to test");
  }
})();

async function checkUrls(urls, host) {
  const broken = [];

  for (let u of urls) {
    u = normaliseUrl(u);
    const response = await fetch(u);
    const body = await response.text();
    const $ = cheerio.load(body);
    const notice = $("#version-notice a");

    // If the page doesn't contain a notice, skip it
    if (!notice.length) {
      continue;
    }

    // Ensure both URLs are normalised
    const href = normaliseUrl(notice.attr("href"), host);

    // If it links to itself
    if (u == href) {
      broken.push(u);
    }
  }
  return broken;
}

function extractNav(items, base) {
  let urls = [];
  for (let u of items) {
    if (u.items) {
      urls = urls.concat(extractNav(u.items, base));
    } else {
      if (u.absolute_url) {
        urls.push(u.url);
      } else {
        urls.push(`${base}${u.url}`);
      }
    }
  }
  return urls;
}

function normaliseUrl(u, prefix) {
  prefix = prefix || "";
  if (u[u.length - 1] == "/") {
    u = u.substring(0, u.length - 1);
  }

  return `${prefix}${u}/`;
}
