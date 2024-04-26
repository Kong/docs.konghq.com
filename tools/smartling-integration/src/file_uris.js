const {
  readIncludeFilesForProduct,
  configLocaleFiles,
  docsNavFiles,
  dataFiles,
  appFiles,
  appSrcFiles,
  pluginsMetadataFiles,
  pluginsOverviewFiles,
  pluginsSchemaFiles
} = require('./file_readers');

async function fileUris(productsConfig) {
  const configLocaleFilesUris = await configLocaleFiles();
  const appFilesUris = [];
  const appSrcFilesUris = [];
  const docsNavFilesUris = [];
  const pluginsMetadataFilesUris = [];
  const pluginsOverviewFilesUris = [];
  const pluginsSchemaFilesUris = [];
  const includeFilesUris = new Set();
  const dataFilesUris = await dataFiles();

  for (const productConfig of productsConfig) {
    console.log(`Processing ${productConfig.product}`);

    const docsNavPaths = await docsNavFiles(productConfig);
    docsNavFilesUris.push(...docsNavPaths);

    const appPaths = await appFiles(productConfig);
    appFilesUris.push(...appPaths);

    const appSrcPaths = await appSrcFiles(productConfig);
    appSrcFilesUris.push(...appSrcPaths);

    const includePaths = await readIncludeFilesForProduct(productConfig, appPaths.concat(appSrcPaths));
    for (path of includePaths) {
      includeFilesUris.add(path);
    }

    if (productConfig.product === 'gateway') {
      pluginsMetadataFilesUris.push(...await pluginsMetadataFiles(productConfig));
      pluginsOverviewFilesUris.push(...await pluginsOverviewFiles());
      pluginsSchemaFilesUris.push(...await pluginsSchemaFiles(productConfig));
    }
  };

  return {
    appFilesUris: appFilesUris,
    appSrcFilesUris: appSrcFilesUris,
    configLocaleFilesUris: configLocaleFilesUris,
    dataFilesUris: dataFilesUris,
    docsNavFilesUris: docsNavFilesUris,
    includeFilesUris: Array.from(includeFilesUris),
    pluginsMetadataFilesUris: pluginsMetadataFilesUris,
    pluginsOverviewFilesUris: pluginsOverviewFilesUris,
    pluginsSchemaFilesUris: pluginsSchemaFilesUris
  };
};

module.exports = { fileUris };
