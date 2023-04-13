module.exports = function(filename) {
  const lookup = {
    ce: "gateway-oss",
    deck: "deck",
    ee: "enterprise",
    gsg: "getting-started-guide",
    kic: "kong-ingress-controller",
    konnect: "konnect",
    mesh: "mesh",
    gateway: "gateway",
    contributing: "contributing",
  };

  filename = filename.replace("app/_data/docs_nav_", "").replace(/\.yml$/, "");

  const [edition, version] = filename.split("_", 2);

  if (!lookup[edition]) {
    throw new Error(`Unknown product: ${edition}`);
  }

  return `/${lookup[edition]}/${version}/`;
}