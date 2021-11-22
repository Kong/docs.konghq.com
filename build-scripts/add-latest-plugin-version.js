const fg = require("fast-glob");
const fs = require("fs").promises;
const matter = require("gray-matter");

const releaseType = process.env.RELEASE_TYPE || process.argv[2];
const versionToAdd = process.env.VERSION_TO_ADD || process.argv[3];

(async function () {
  const allowedTypes = ["community_edition", "enterprise_edition"];
  if (!allowedTypes.includes(releaseType)) {
    console.log(
      `Invalid release type. Expected one of: ${allowedTypes.join(", ")}`
    );
    process.exit(1);
  }

  if (!versionToAdd) {
    console.log("Expected a version to add to be specified.");
    process.exit(1);
  }

  const baseDir = `../app/_hub/`;
  const entries = await fg([`${baseDir}/kong-inc/*/index.md`]);

  // For each entry, edit the front matter
  for (let entry of entries) {
    const c = await fs.readFile(entry);
    const fm = matter(c);

    // Some plugins (e.g. ee-openid-connect-rp) are just redirects and
    // don't have a compatibility table
    if (!fm.data.kong_version_compatibility) {
      continue;
    }

    const compatibilityList =
      fm.data.kong_version_compatibility[releaseType]?.compatible;

    // If there's a compatibility list for the provided `releaseType`, edit that
    if (!compatibilityList) {
      continue;
    }

    // Skip if it's already in the list
    if (compatibilityList.includes(versionToAdd)) {
      continue;
    }

    compatibilityList.unshift(versionToAdd);

    await fs.writeFile(
      entry,
      // lineWidth of -1 forces js-yaml to use | rather than > for multiline strings
      matter.stringify(fm.content, fm.data, { lineWidth: -1 })
    );
  }
})();
