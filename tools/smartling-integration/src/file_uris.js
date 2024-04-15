const {
  readIncludeFilesForProduct,
  configLocaleFiles,
  docsNavFiles,
  dataFiles,
  appFiles,
  appSrcFiles
} = require('./file_readers');

async function fileUris(productsConfig) {
  const configLocaleFilesUris = await configLocaleFiles();
  const appFilesUris = [];
  const appSrcFilesUris = [];
  const docsNavFilesUris = [];
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
  };

  return {
    appFilesUris: appFilesUris,
    appSrcFilesUris: appSrcFilesUris,
    configLocaleFilesUris: configLocaleFilesUris,
    dataFilesUris: dataFilesUris,
    docsNavFilesUris: docsNavFilesUris,
    includeFilesUris: Array.from(includeFilesUris)
  };
};

module.exports = { fileUris };
