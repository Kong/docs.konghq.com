const fg = require("fast-glob");
const createPDF = require("./create-pdf");

const path = require("path");
const connect = require("connect");
const serveStatic = require("serve-static");

module.exports = async function (plugin, version) {
  plugin = plugin || "*";
  version = version || "index";
  let files = await fg(`../app/_hub/kong-inc/${plugin}/${version}.md`);
  files = files.map((f) => {
    return f.replace("../app/_hub/", "/hub/").replace(/\.md$/, ".html");
  });

  // Prefix with URL
  files = files.map((f) => {
    return `http://localhost:3000${f}`;
  });

  return files;
};
