const fg = require("fast-glob");
const fs = require("fs");
const cheerio = require("cheerio");

const { createHash } = require("crypto");

module.exports = function () {
  let files = fg.sync([`${__dirname}/../../dist/**/*.html`]);
  //files = files.slice(0, 100);

  const admonitionTypes = ["note", "warning", "important"];
  const allAdmonitions = {};

  files.forEach((file) => {
    const content = fs.readFileSync(file, "utf8");
    const $ = cheerio.load(content);

    $("blockquote").each((i, el) => {
      el = $(el);
      const c = el.attr("class");
      if (!c) {
        return;
      }

      const type = c.split(" ").filter((t) => admonitionTypes.includes(t))[0];
      if (!type) {
        return;
      }

      const content = el.html().trim();
      if (
        content.startsWith(
          "You are browsing documentation for an outdated version.",
        )
      ) {
        return;
      }

      const url = file.split("../../dist/")[1].replace("index.html", "");
      const product = url.split("/")[0];
      const hash = md5(type, content, product);

      // We don't want examples in here
      if (product == "contributing") {
        return;
      }

      allAdmonitions[hash] = allAdmonitions[hash] || {
        hash,
        type,
        content,
        product,
        urls: [],
      };

      allAdmonitions[hash].urls.push(`https://docs.konghq.com/${url}`);
    });
  });

  // Make URLs unique
  for (let i in allAdmonitions) {
    allAdmonitions[i].count = allAdmonitions[i].urls.length;
    allAdmonitions[i].urls = [...new Set(allAdmonitions[i].urls)];
  }

  fs.existsSync("dist") || fs.mkdirSync("dist");
  fs.writeFileSync(
    `dist/admonitions.json`,
    JSON.stringify(Object.values(allAdmonitions)),
  );

  function md5(type, content, product) {
    return createHash("md5")
      .update(`${type}::${content}::${product}`)
      .digest("hex");
  }
};

if (require.main == module) {
  module.exports();
}
