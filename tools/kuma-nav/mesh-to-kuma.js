const yaml = require("js-yaml");
const fs = require("fs");
const debug = require("debug")("kong");

module.exports = function (path) {
  try {
    const doc = yaml.load(fs.readFileSync(path, "utf8"));

    // Set the top level entries
    doc.product = "kuma";

    // Reformat items
    doc.items = reformatItems(doc.items);

    for (item of doc.items) {
      item.group = true;
    }

    return yaml.dump(doc);
  } catch (e) {
    console.log(e);
  }
};

function reformatItems(items) {
  for (let j in items) {
    const item = items[j];

    // If it's a Mesh only item, delete it
    if (item.url && !item.src) {
      delete items[j];
    }

    // If it has a src, either it's a Kuma page and src needs removing
    // or it's a non-kuma page and the whole item needs removing
    if (item.src) {
      if (item.src.startsWith("/.repos/kuma")) {
        delete item.src;
      } else {
        delete items[j];
        continue;
      }
    }

    if (item.items) {
      item.items = reformatItems(item.items, item);
    }

    // Replace Kong Mesh with Kuma
    if (item.title) {
      item.title = item.title.replace("Kong Mesh", "Kuma");
    }
    if (item.text) {
      item.text = item.text.replace("Kong Mesh", "Kuma");
    }

    if (item.url) {
      item.url = item.url.replace("kong-mesh", "kuma");
    }
  }

  // Remove nulls
  items = items.filter((i) => i);
  return items;
}

if (require.main === module) {
  const output = module.exports(process.argv[2]);
  console.log(output);
}
