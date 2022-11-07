const yaml = require("js-yaml");
const fs = require("fs");
const debug = require("debug")("kong");

module.exports = function (path) {
  try {
    const doc = yaml.load(fs.readFileSync(path, "utf8"));

    // Set the top level entries
    doc.product = "mesh";

    // Reformat items
    doc.items = reformatItems(doc.items);

    return yaml.dump(doc);
  } catch (e) {
    console.log(e);
  }
};

function reformatItems(items) {
  for (let item of items) {
    delete item.group;

    if (item.items) {
      item.items = reformatItems(item.items, item);
    }

    // Replace Kuma with Kong Mesh in title and URLs
    if (item.title) {
      item.title = item.title.replace("Kuma", "Kong Mesh");
    }
    if (item.text) {
      item.text = item.text.replace("Kuma", "Kong Mesh");
    }

    if (item.url) {
      item.src = `/.repos/kuma/src${item.url}`.replace(/\/$/, "");
      item.url = item.url.replace("kuma", "kong-mesh");
    }

    if (item.url && item.items) {
      debug(
        `WARNING: ${item.title || item.text} contains a URL _and_ child items`
      );
    }
  }
  return items;
}

if (require.main === module) {
  const output = module.exports(process.argv[2]);
  console.log(output);
}
