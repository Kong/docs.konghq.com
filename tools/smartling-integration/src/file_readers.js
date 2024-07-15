const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const fg = require('fast-glob');

const PRODUCT_MAPPINGS = {
  "gateway": "gateway",
  "kgo": "gateway-operator",
  "kic": "kubernetes-ingress-controller",
  "mesh": "mesh",
  "konnect": "konnect",
  "deck": "deck"
};

const DATA_FILES_TO_EXCLUDE = [
  'installation/gateway.yml',
  'pdk_info.yml',
  'konnect_oas_data.json',
  'kong_versions.yml',
  'books.yml',
  'hub_filters.yml',
  'tables/compat.json',
  'tables/version_errors_konnect.yml',
  'tables/install_options_konnect.yml',
  'tables/install_options.yml',
  'tables/features/mesh.yml',
  'tables/support/gateway/versions/28.yml',
  'tables/support/gateway/versions/32.yml',
  'tables/support/gateway/versions/33.yml',
  'tables/support/gateway/versions/35.yml',
  'tables/support/gateway/versions/36.yml',
  'tables/support/gateway/versions/37.yml',
  'tables/support/gateway/versions/38.yml',
  'tables/support/gateway/browsers.yml',
  'tables/support/gateway/third-party.yml'
]

function readTranslationConfig() {
  try {
    const config = path.resolve(__dirname, '../', 'config.yml');
    return yaml.load(fs.readFileSync(config, 'utf8'));
  } catch (error) {
    console.error('Error reading config file', error);
    return null;
  }
}

async function configLocaleFiles() {
  const localesPath = 'config/locales/';
  const localesDir = path.resolve(__dirname, '../../../', localesPath)
  return fs.readdirSync(localesDir).map((file) => {
    return path.join(localesPath, file);
  });
}

async function docsNavFiles(productConfig) {
  console.log(`   app/_data/docs_nav_${productConfig.product}`);

  const srcPath = 'app/_data';
  const root = path.resolve(__dirname, '../../../');
  const { product, versions } = productConfig;
  let fileUris = [];

  if (product === 'konnect') {
    let fileUri = path.join(srcPath, `docs_nav_${product}.yml`);
    if (fs.existsSync(path.join(root, fileUri))) {
      fileUris.push(fileUri);
    } else {
      console.log(`DocsNavFile not found for: ${product} - ${version}`)
      process.exit(1);
    }
  } else {
    for (version of versions) {
      let fileUri = path.join(srcPath, `docs_nav_${product}_${version}.yml`);

      if (fs.existsSync(path.join(root, fileUri))) {
        fileUris.push(fileUri);
      } else {
        console.log(`DocsNavFile not found for: ${product} - ${version}`)
        process.exit(1);
      }
    };
  }
  return fileUris;
}

async function appSrcFiles(productConfig) {
  try {
    let srcPath = 'app/_src';
    const { product, versions } = productConfig;
    const normalizedProductName = PRODUCT_MAPPINGS[product];
    let srcFiles = [];

    let srcDirs = [];
    if (product === 'kic') {
      if (versions.some(v => /^2\./.test(v))) {
        srcDirs.push('kic-v2');
      }
      if (versions.some(v => /^3\./.test(v))) {
        srcDirs.push(normalizedProductName);
      }
    } else {
      srcDirs.push(normalizedProductName);
    }

    for (dir of srcDirs) {
      console.log(`   ${path.join(srcPath, dir)}`);
      let files = await fg('**/*', { cwd: path.resolve(__dirname, '../../../', srcPath, dir), onlyFiles: true });
      srcFiles.push(...files.map((file) => {
        return path.join(srcPath, dir, file);
      }));
    }
    return srcFiles;
  } catch (e) {
    console.log(`There was a problem reading from app/_src/${normalizedProductName}`)
    process.exit(1);
  }
}

async function appFiles(productConfig) {
  let appFiles = [];
  const { product, versions } = productConfig;
  const normalizedProductName = PRODUCT_MAPPINGS[product];
  const srcPath = `app/${normalizedProductName}/`;

  console.log(`   ${srcPath}`);

  try {
    // /<product>/*.md
    let topLevelFiles = await fg(`app/${normalizedProductName}/*.md`);

    appFiles.push(...topLevelFiles);

    if (normalizedProductName === 'konnect') {
      // app/konnect/**/*.md
      const files = await fg(`app/${normalizedProductName}/**/*.md`, {  onlyfiles: true });
      appFiles.push(...files);
    } else {
      //  app/<product>/<version>/**/*.md
      for (let version of versions) {
        let files = await fg(`app/${normalizedProductName}/${version}/**/*.md`, {  onlyfiles: true });
        appFiles.push(...files);
      }
    }
    return appFiles;
  } catch(e) {
    console.log(`There was a problem reading from app/${normalizedProductName}`)
    process.exit(1);
  }
}

async function dataFiles() {
  let dataFiles = [];
  try {
    const dataPath = 'app/_data';
    const srcDir = path.resolve(__dirname, '../../../', dataPath);

    if (fs.existsSync(srcDir)) {
      const files = await fg('**/*', { cwd: srcDir, onlyFiles: true });
      files.map((file) => {
        if (!DATA_FILES_TO_EXCLUDE.includes(file) && !file.startsWith('docs_nav_')) {
          dataFiles.push(path.join(dataPath, file));
        }
      });
    } else {
      console.log(`The folder ${srcDir} doesn't exist.`)
      process.exit(1);
    }
    return dataFiles;
  } catch (e) {
    console.log("There was a problem reading from app/_data")
    process.exit(1);
  }
}

async function dfsExtractIncludeFilePaths(filePath, includeFilePaths = new Set()) {
  try {
    const data = await fs.promises.readFile(filePath, 'utf8');
    const regex = /{%\s*include(_cached)?\s+(\/?md\/.*.md)/g;
    const interpolationRegex = /\/{{\s*.*?\s*}}\//g;
    let match;

    while ((match = regex.exec(data)) !== null) {
      const fullPath = path.join('app/_includes', match[2]);

      if (interpolationRegex.test(fullPath)) {
        const expandedPath = fullPath.replace(interpolationRegex, '/**/');
        const files = await fg(expandedPath);
        files.forEach(file => {
          if (!includeFilePaths.has(file)) {
            includeFilePaths.add(file);
            dfsExtractIncludeFilePaths(file, includeFilePaths);
          }
        });
      } else {
        if (!includeFilePaths.has(fullPath)) {
          includeFilePaths.add(fullPath);
          await dfsExtractIncludeFilePaths(fullPath, includeFilePaths);
        }
      }
    }
  } catch (error) {
    console.error('Error reading file:', error);
  }
  return includeFilePaths;
}

async function readIncludeFilesForProduct(productConfig, srcFiles) {
  try {
    let includes = new Set();
    for (file of srcFiles) {
      await dfsExtractIncludeFilePaths(file, includes);
    }

    return Array.from(includes);
  } catch (e) {
    console.log(`There was a problem reading include files for: ${productConfig.product}`)
    process.exit(1);
  }
}

async function getProductsConfigs(config, locale) {
  const  { plugins, ...entries } = config[locale];

  return Object.entries(entries).map(([product, versions]) => {
    return { product, versions };
  });
}

async function pluginsMetadataFiles(gatewayConfig, pluginsConfig) {
  // non-kong plugins only have one version
  // check if there's a specific file or index.md
  let srcPath = 'app/_hub';
  let metadataFiles = [];

  for (const plugin of pluginsConfig['kong-inc']) {
    let folders = await fg(`kong-inc/${plugin}/_metadata/`, { cwd: path.resolve(__dirname, '../../../', srcPath), onlyDirectories: true });

    folders.forEach((folder) => {
      let files = [];
      gatewayConfig.versions.forEach((v) => {
        let filePath = path.join(srcPath, folder, `_${v}.yml`);
        if (fs.existsSync(filePath)) {
          files.push(filePath);
        }
      });
      if (files.length === 0) {
        files.push(path.join(srcPath, folder, '_index.yml'));
      }
      metadataFiles.push(...files);
    });
  }
  return metadataFiles;
}

async function pluginsOverviewFiles(pluginsConfig) {
  // non-kong and kong plugins only have one version
  let srcPath = 'app/_hub';
  let overviewFiles = [];

  for (const plugin of pluginsConfig['kong-inc']) {
    let files = await fg(`kong-inc/${plugin}/overview/_index.md`, { cwd: path.resolve(__dirname, '../../../', srcPath), onlyFiles: true });
    overviewFiles.push(...files.map((file) => {
      return path.join(srcPath, file);
    }));
  }

  return overviewFiles;
}

async function pluginsSchemaFiles(gatewayConfig, pluginsConfig) {
  // non-kong plugins only have _index.md if any
  // kong-inc: have version specific files
  let schemaFiles = [];

  let srcPath = 'app/_hub';

  // let thirdPartySchemas = await fg('**/schemas/_index.json', { cwd: path.resolve(__dirname, '../../../', srcPath), onlyFiles: true });
  // schemaFiles.push(...thirdPartySchemas.map((file) => {
  //   return path.join(srcPath, file);
  // }));

  let versions = gatewayConfig.versions.join(',');
  srcPath = 'app/_src/.repos/kong-plugins/schemas/';

  for (const plugin of pluginsConfig['kong-inc']) {
    let kongSchemas = await fg(`${plugin}/{${versions},}.json`, { cwd: path.resolve(__dirname, '../../../', srcPath), onlyFiles: true });
    schemaFiles.push(...kongSchemas.map((file) => {
      return path.join(srcPath, file);
    }));
  }
  return schemaFiles;
}

module.exports = {
  PRODUCT_MAPPINGS,
  appFiles,
  appSrcFiles,
  configLocaleFiles,
  dataFiles,
  dfsExtractIncludeFilePaths,
  docsNavFiles,
  getProductsConfigs,
  pluginsMetadataFiles,
  pluginsOverviewFiles,
  pluginsSchemaFiles,
  readIncludeFilesForProduct,
  readTranslationConfig
}
