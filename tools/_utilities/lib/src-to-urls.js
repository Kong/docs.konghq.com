/*
Accepts a file path in app/_src and returns all URLs that the file renders
*/

// This is a hack to enable utilities to access node_modules out of tree
module.paths.unshift(process.mainModule.paths[0]);

module.exports = srcToUrls;

const fg = require("fast-glob");
const yaml = require("js-yaml");
const fs = require("fs");

const extractNavWithMeta = require("./nav-to-urls");

async function loadNavEntries(pattern) {
  let navEntries = await fg(
    `${__dirname}/../../../app/_data/docs_nav_${pattern}.yml`,
  );
  return navEntries
    .map((f) => {
      return yaml.load(fs.readFileSync(f, "utf8"));
    })
    .filter((n) => {
      // Skip inherited nav files
      return n.generate && !n.inherit;
    });
}

// Take a file in src and output the URLs that it renders
async function srcToUrls(pattern, file) {
  let urls = [];

  if (!file) {
    file = {};
  }

  src = file.filename;

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

        const data = {
          url: `${prefix}${u.url}`,
        };

        if (src) {
          data.source = src;
        }

        if (file.status) {
          data.status = file.status;
        }

        return data;
      }),
    );
  }

  urls = Array.from(new Set(urls));

  return urls;
}
