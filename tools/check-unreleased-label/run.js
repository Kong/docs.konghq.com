const yaml = require("js-yaml");
const fs = require("fs");

const unreleasedProducts = {
  gateway: false,
  deck: false,
  "kubernetes-ingress-controller": false,
};

const versionsFile = __dirname + "/../../app/_data/kong_versions.yml";
const labels = yaml.load(fs.readFileSync(versionsFile, "utf8"));

for (const product of labels) {
  if (product.label == "unreleased") {
    unreleasedProducts[product.edition] = true;
  }
}

let exitCode = 0;
for (const product in unreleasedProducts) {
  if (!unreleasedProducts[product]) {
    console.error(`Error: ${product} is missing an 'unreleased' version`);
    exitCode = 1;
  }
}
