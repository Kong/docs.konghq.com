import fs from "fs";
import fg from "fast-glob";
import semver from "semver";
import {execaSync as execa} from 'execa';
import minimist from "minimist";

const argv = minimist(process.argv.slice(2));

if (argv.help || !argv.source) {
  console.log(`
  usage: node run.js --source ../app/<product>/<version>/path/to/file.md [--ignore 1.2.x]
  `);
  process.exit(1);
}

const ignore = (argv.ignore || "").split(",");

let sourceFile = argv.source;
if (sourceFile.startsWith("../")) {
  sourceFile = sourceFile.slice(3);
}

const sourceFileFull = "../" + sourceFile;

// Work out old versions to apply the change to
const lookup = {
  deck: "deck",
  "kubernetes-ingress-controller": "kic",
  konnect: "konnect",
  mesh: "mesh",
  gateway: "gateway",
};

if (!argv.source) {
  throw new Error("Missing --source option");
}

// Check if the file exists
if (!fs.existsSync(sourceFileFull)) {
  throw new Error(sourceFile + " does not exist");
}

// Extract product from the source file (it's the segment after `app`)
const parts = sourceFile.split("/");
const appIndex = parts.findIndex((n) => n == "app");
if (appIndex === -1) {
  throw new Error(
    `Invalid --source provided: [${source}]. Must start with [app]`
  );
}

const product = parts[appIndex + 1];
const shortProduct = lookup[product];

if (!lookup[product]) {
  console.log(
    `Invalid --product: [${product}]. Valid values:\n${Object.keys(lookup)
      .map((n) => `* ${n}`)
      .join("\n")}`
  );
}

const path = product + "_*";
let files = fg.sync(`../app/_data/docs_nav_${path}.yml`);
files = files
  .map((f) => {
    if (f.includes("docs_nav_contributing")) {
      return;
    }
    const item = { path: f };
    const info = f.replace("../app/_data/docs_nav_", "").replace(/\.yml$/, "");

    // Special case Konnect
    if (info === "konnect") {
      item.type = "konnect";
      item.version = "";
    } else {
      const x = info.split("_");
      item.type = lookup[x[0]];
      item.version = semver.coerce(x[1]).raw;
      item.original_version = x[1];
    }
    return item;
  })
  .filter((n) => n)
  // Remove anything older than the minimum version
  .filter((n) => !ignore.includes(n.original_version))
  // Sort oldest to newest
  .sort((a, b) => (semver.gte(a.version, b.version) ? 1 : -1));

const newestVersion = files[files.length - 1].original_version;
for (let i in files) {
  const current = files[i];
  const next = files[++i];
  //console.log(next);
  if (!next) {
    continue;
  }
  const currentPath = sourceFileFull.replace(
    newestVersion,
    current.original_version
  );
  const nextPath = sourceFileFull.replace(newestVersion, next.original_version);
  try {
    const output = execa("git", [
      "--no-pager",
      "diff",
      "--ignore-all-space",
      "--color=always",
      "--no-index",
      "--unified=1",
      currentPath,
      nextPath,
    ]);
    console.log(
      `No differences between ${currentPath} and ${nextPath}\n-----------------\n`
    );
  } catch (e) {
    const output = e.message || e.stdout;
    // Diff always returns exit code 1, so we have to catch
    console.log(
      `##########################################\n${currentPath}\n${nextPath}\n##########################################`
    );
    if (output.length > 0) {
      console.log(output.split("\n").slice(4).join("\n"));
    } else {
      console.log("No changes");
    }
  }
}
