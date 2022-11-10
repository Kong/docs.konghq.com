module.exports = srcToUrls;
const fg = require("fast-glob");
const yaml = require("js-yaml");
const fs = require("fs");

async function loadNavEntries(pattern) {
  let navEntries = await fg(`../../app/_data/docs_nav_${pattern}.yml`);
  return navEntries
    .map((f) => {
      return yaml.load(fs.readFileSync(f, "utf8"));
    })
    .filter((n) => {
      return n.generate;
    });
}

// Take a file in src and output the URLs that it renders
async function srcToUrls(src, pattern) {
  let urls = [];

  const navEntries = await loadNavEntries(pattern);

  for (const entry of navEntries) {
    const r = extractNavWithMeta(entry.items, ``, `src/${entry.product}`);
    urls = urls.concat(
      r
        .filter((u) => u.src == src)
        .map((u) => {
          return {
            source: src,
            url: `/${entry.product}/${entry.release}${u.url}`,
          };
        })
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
          src:
            srcPrefix +
            (u.src || url)
              .replace(/\/?#.*$/, "") // Remove anchor links
              .replace(/\/$/, "") + // Remove trailing slashes
            ".md",
          url,
        });
      }
    }
  }

  return urls;
}
