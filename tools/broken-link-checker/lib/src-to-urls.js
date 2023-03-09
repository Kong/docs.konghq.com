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
async function srcToUrls(pattern, src) {
  let urls = [];

  const navEntries = await loadNavEntries(pattern);

  for (const entry of navEntries) {
    let r = extractNavWithMeta(entry.items, ``, `app/_src/${entry.product}`);

    // If we provided a specific source, only match that file
    if (src) {
      r = r.filter((u) => {
        return u.src == src;
      });
    }

    urls = urls.concat(
      r.map((u) => {
        const prefix = u.is_absolute
          ? ""
          : `/${entry.product}/${entry.release}`;
        return {
          source: src,
          url: `${prefix}${u.url}`,
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
        const parts = u.url.split("/").filter((n) => n);

        // Special handling for index pages
        if (parts[1].match(/\d+\.\d+\.x/)) {
          parts[1] = "index";
        }

        // Otherwise treat the second segment as the filename e.g.
        // /gateway/changelog.md
        if (parts.length == 2) {
          urls.push({
            src: srcPrefix + "/" + parts[1] + ".md",
            url: u.url,
            is_absolute: true,
          });
        } else {
          urls.push({
            src: u.src || u.url,
            url: u.url,
            is_absolute: true,
          });
        }
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
          is_absolute: false,
        });
      }
    }
  }

  return urls;
}
