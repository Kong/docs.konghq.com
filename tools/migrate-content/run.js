const fs = require("fs");
const fg = require("fast-glob");
const yaml = require("js-yaml");

const pattern = "*kic_2.*";
const prefix = "/kic-v2/";

// Get all data files
const navDir = `${__dirname}/../../app/_data`;
const files = fg.sync(`${navDir}/${pattern}`);

// Add src entry to every data file that matches the provided glob
let content;
for (let f of files) {
  content = yaml.load(fs.readFileSync(f, "utf8"));
  if (!content.generate) {
    continue;
  }
  content.items = addSrc(content.items);

  fs.writeFileSync(f, yaml.dump(content));
}

console.log(`git mv app/_src/${content.product} app/_src${prefix}`);

function addSrc(items) {
  for (let item of items) {
    if (item.items) {
      item.items = addSrc(item.items);
    }

    if (item.absolute_url) {
      // Special handling for the overview page
      if (item.url.startsWith(`/${content.product}/`)) {
        item.src = `${prefix}`;
      }

      continue;
    }

    if (!item.src && item.url) {
      item.src = item.url;
    }

    if (item.src) {
      item.src = prefix + item.src.replace(/^\//, "");
    }
  }

  return items;
}
