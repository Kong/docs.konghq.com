const fs = require("fs");
const fg = require("fast-glob");
const semver = require("semver");
const execa = require("execa").sync;
const argv = require("minimist")(process.argv.slice(2));

if (!argv.oldest) {
  throw new Error("Missing --oldest option");
}

const minimumVersion = semver.coerce(argv.oldest).raw;
const diffFile = "__generated.diff";

// Generate and apply the patch
let sourceFile = argv.source;
if (sourceFile.startsWith("../")) {
  sourceFile = sourceFile.slice(3);
}

const sourceFileFull = "../" + sourceFile;

// Work out old versions to apply the change to
const lookup = {
  "gateway-oss": "ce",
  deck: "deck",
  enterprise: "ee",
  "getting-started-guide": "gsg",
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

    // Special case Konnect Platform
    if (info === "konnect_platform") {
      item.type = "konnect-platform";
      item.version = "";
    } else if (info === "konnect") {
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
  .filter((n) => semver.gte(n.version, minimumVersion));

// And remove the latest version
let highestVersion = { version: semver.coerce("0.0.0") };
for (let nav of files) {
  if (semver.gt(nav.version, highestVersion.version)) {
    highestVersion = nav;
  }
}
files = files.filter((n) => n.version != highestVersion.version);

let { stdout } = execa("git", ["diff", sourceFileFull]);
fs.writeFileSync("./" + diffFile, stdout + "\n");

for (let file of files) {
  const targetFile = sourceFile.replace(
    highestVersion.original_version,
    file.original_version
  );

  console.log(`Patching ${targetFile}`);
  try {
    execa(
      "patch",
      [
        "--reject-file=/tmp/discarded.patch.reject",
        "--no-backup-if-mismatch",
        targetFile,
        `backporting/${diffFile}`,
      ],
      {
        cwd: __dirname + "/..",
      }
    );
  } catch (e) {
    console.log("----------------------");
    console.log("ERROR APPLYING PATCH");
    console.log(e.stdout);
  }
}

execa("rm", [diffFile]);
