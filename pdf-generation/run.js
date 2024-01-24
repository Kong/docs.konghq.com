import buildUrls from "./build-urls.js";
import createPDF from "./create-pdf.js";
import listVersions from "./list-versions.js";
import listPlugins from "./list-plugins.js";

async function run() {
  if (process.env.KONG_DOC_VERSIONS) {
    return await printDocs(process.env.KONG_DOC_VERSIONS);
  }

  if (process.env.KONG_PLUGIN_NAME) {
    return await printPlugin(
      process.env.KONG_PLUGIN_NAME,
      process.env.KONG_PLUGIN_VERSION,
    );
  }
}

async function printDocs(nav) {
  const versions = await listVersions(nav);

  for (const v of versions) {
    const title = `${v.type}-${v.version}`;
    const urls = buildUrls(v);
    await createPDF(title, urls);
  }
}

async function printPlugin(plugin, version) {
  const urls = await listPlugins(plugin, version);
  let title = plugin;
  if (version) {
    title = `${title}-${version}`;
  }
  await createPDF(title, urls);
}

run();
