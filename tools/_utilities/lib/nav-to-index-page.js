/*
Accepts a navigation file + converts it to the index page for that product.
This is enough to start spidering URLs using the sidebar for broken links
*/

module.exports = function (filename) {
  const lookup = {
    deck: "deck",
    kgo: "gatway-operator",
    kic: "kubernetes-ingress-controller",
    konnect: "konnect",
    mesh: "mesh",
    gateway: "gateway",
    "dev-portal": "dev-portal",
    contributing: "contributing",
  };

  filename = filename.replace("app/_data/docs_nav_", "").replace(/\.yml$/, "");

  const [edition, version] = filename.split("_", 2);

  if (!lookup[edition]) {
    throw new Error(`Unknown product: ${edition}`);
  }

  return `/${lookup[edition]}/${version}/`;
};
