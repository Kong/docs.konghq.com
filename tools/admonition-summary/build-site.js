const fg = require("fast-glob");
const fs = require("fs");

module.exports = function () {
  // Make sure the directory exists
  fs.existsSync("dist/site") || fs.mkdirSync("dist/site");
  fs.existsSync("dist/site/admonition") || fs.mkdirSync("dist/site/admonition");
  fs.existsSync("dist/site/vite") || fs.mkdirSync("dist/site/vite");
  fs.existsSync("dist/site/vite/assets") ||
    fs.mkdirSync("dist/site/vite/assets");

  // Copy the static assets
  let assets = fg.sync(
    `${__dirname}/../../dist/vite/assets/*.{css,ttf,eot,woff}`,
  );
  assets = assets.map((a) => {
    dest = a;
    if (a.endsWith(".css")) {
      dest = a.replace(/[-a-z0-9]{9}((\.\w+)*)$/, "$1");
    }

    dest = dest.split("../../dist/")[1];
    return {
      src: a,
      dest,
    };
  });

  for (let a of assets) {
    fs.copyFileSync(a.src, `dist/site/${a.dest}`);
  }

  // Load the admonitions
  let admonitions = JSON.parse(
    fs.readFileSync(`${__dirname}/dist/admonitions.json`, "utf8"),
  );

  // Sort by the number of occurrences
  admonitions.sort((a, b) => {
    return b.count - a.count;
  });

  const wrapper = `<html>
<head>
  <script src="https://kit.fontawesome.com/1332a92967.js" crossorigin="anonymous"> </script>
  <link rel="stylesheet" href="/vite/assets/application.css">
</head>
<body class="page v2">
<a style="position:fixed;padding:10px;" href="/">&laquo; Home</a>
<div id="documentation" class="container">
<div class="content">
{{content}}
</div>
</div>
</body>
</html>`;

  for (let a of admonitions) {
    const body = wrapper.replace("{{content}}", renderAdmonition(a));
    fs.writeFileSync(`dist/site/admonition/${a.hash}.html`, body);
  }

  // Render admonitions per-product
  let productAdmonitions = {};
  let typeAdmonitions = {};
  let productTypeAdmonitions = {};

  const productCounts = {};
  const typeCounts = {};
  const productTypeCounts = {};

  for (let a of admonitions) {
    // By Product
    productCounts[a.product] = productCounts[a.product] || 0;
    productCounts[a.product] += 1;
    productAdmonitions[a.product] =
      productAdmonitions[a.product] || `<h3>${a.product}</h3>\n\n`;
    productAdmonitions[a.product] += renderAdmonition(a) + `<hr /> \n\n`;

    // By Type
    typeCounts[a.type] = typeCounts[a.type] || 0;
    typeCounts[a.type] += 1;
    typeAdmonitions[a.type] =
      typeAdmonitions[a.type] || `<h3>${a.type}</h3>\n\n`;
    typeAdmonitions[a.type] += renderAdmonition(a) + `<hr /> \n\n`;

    // By Product AND type
    const k = `${a.product} / ${a.type}`;
    productTypeCounts[k] = productTypeCounts[k] || 0;
    productTypeCounts[k] += 1;
    productTypeAdmonitions[k] =
      productTypeAdmonitions[k] || `<h3>${k}</h3>\n\n`;
    productTypeAdmonitions[k] += renderAdmonition(a) + `<hr /> \n\n`;
  }

  for (let p in productAdmonitions) {
    const body = wrapper.replace("{{content}}", productAdmonitions[p]);
    fs.writeFileSync(`dist/site/${p}.html`, body);
  }

  for (let t in typeAdmonitions) {
    const body = wrapper.replace("{{content}}", typeAdmonitions[t]);
    fs.writeFileSync(`dist/site/${t}.html`, body);
  }

  for (let t in productTypeAdmonitions) {
    const body = wrapper.replace("{{content}}", productTypeAdmonitions[t]);
    fs.writeFileSync(`dist/site/${t.replace(" / ", "-")}.html`, body);
  }

  // All on one page
  const all = wrapper.replace(
    "{{content}}",
    admonitions.map((a) => `${renderAdmonition(a)}<hr />`).join("\n"),
  );
  fs.writeFileSync(`dist/site/all.html`, all);

  // Create an index page
  const byProduct = `<h3>By Product</h3>

<ul>
${Object.keys(productAdmonitions)
  .map((p) => {
    return `<li><a href="/${p}.html">${p} (${productCounts[p]})</a></li>`;
  })
  .join("\n")}
</ul>`;

  const byType = `<h3>By Type</h3>

<ul>
${Object.keys(typeAdmonitions)
  .map((p) => {
    return `<li><a href="/${p}.html">${p} (${typeCounts[p]})</a></li>`;
  })
  .join("\n")}
</ul>`;

  const byProductAndType = `<h3>By Product.Type</h3>

<ul>
${Object.keys(productTypeAdmonitions)
  .sort()
  .map((p) => {
    return `<li><a href="/${p.replace(" / ", "-")}.html">${p} (${
      productTypeCounts[p]
    })</a></li>`;
  })
  .join("\n")}
</ul>`;

  const allAdmonitions = `<h3>All Admonitions</h3>
<a href="/all.html">View all admonitions</a>`;

  // Interesting stats
  const topAdmonitions = `<h3>Top Admonitions</h3>
<ul>
${admonitions
  .slice(0, 10)
  .map((p) => {
    return `<li>[${p.type} / ${p.product}] <a href="/admonition/${p.hash}.html">${p.hash} (${p.count})</a></li>`;
  })
  .join("\n")}
</ul>`;

  // Write the index
  const body = wrapper.replace(
    "{{content}}",
    `
    ${byProduct}
    ${byType}
    ${byProductAndType}
    ${topAdmonitions}
    ${allAdmonitions}
    `,
  );
  fs.writeFileSync(`dist/site/index.html`, body);

  function renderAdmonition(a) {
    return `<blockquote class="${a.type}">
  ${a.content}
</blockquote>

<p>
<a href="/admonition/${a.hash}.html"># Permalink</a><br /><br />
Rendered ${a.count} times in across the following documents:
<ul style="max-height:400px; overflow-y: auto;">
${a.urls
  .map((u) => {
    return `<li><a href="${u}">${u}</a></li>`;
  })
  .join("\n")}
</ul>
</p>
`;
  }
};

if (require.main == module) {
  module.exports();
}
