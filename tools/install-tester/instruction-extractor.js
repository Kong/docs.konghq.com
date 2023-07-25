const fetch = require("node-fetch");
const cheerio = require("cheerio");
const yaml = require("js-yaml");

const typeToPackage = {
  "kong-gateway": "enterprise",
  "kong-gateway-oss": "oss",
};

async function extractV3(version, os) {
  return extract(
    `${process.env.BASE_URL}/gateway/${version}/install/linux/${os}`,
    os,
  );
}

async function extractV2(version, os) {
  return extract(
    `${process.env.BASE_URL}/gateway/${version}/install-and-run/${os}`,
    os,
  );
}

async function extract(url, os) {
  // Fetch instructions from the page
  const response = await fetch(url);
  const body = await response.text();
  // Parse the HTML
  const $ = cheerio.load(body);

  const packages = ["kong-gateway", "kong-gateway-oss"];
  const types = ["package"];

  const aptDistros = ["ubuntu", "debian"];
  if (aptDistros.includes(os)) {
    types.push("apt-repository");
  }

  const yumDistros = ["centos", "rhel", "amazon-linux"];
  if (yumDistros.includes(os)) {
    types.push("yum-repository");
  }

  const output = [];
  for (let package of packages) {
    for (let type of types) {
      const blocks = [];
      // Grab the first navtabs
      $("div[data-panel='" + type + "']")
        .find(
          "li > .language-bash pre code, div[data-panel='" +
            package +
            "'] pre code",
        )
        .toArray()
        .forEach((c) => {
          blocks.push($(c).text().trim());
        });

      //if (blocks.join("\n").includes("download.konghq.com")) {
      //  console.error(
      //    "ERROR: download.konghq.com found in instructions on " + url,
      //  );
      //  process.exit(1);
      //}

      output.push({
        url,
        package: typeToPackage[package],
        type,
        blocks,
      });
    }
  }
  return output;
}

module.exports = {
  extractV2,
  extractV3,
};
