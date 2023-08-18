const scrape = require("./scrape");
const buildSite = require("./build-site");
const serve = require("./serve");

console.log("==> Scraping Admonitions");
scrape();
console.log("==> Building Site");
buildSite();
console.log("==> Running Site");
serve();
