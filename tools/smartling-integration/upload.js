const fs = require("fs");
const path = require('path');
const yaml = require('js-yaml');

const {
    Logger,
    SmartlingApiClientBuilder,
    SmartlingJobsApi,
    SmartlingJobBatchesApi,
    SmartlingFilesApi,
    CreateJobParameters,
    CreateBatchParameters,
    UploadBatchFileParameters,
    FileType,
    JobProgressParameters,
    DownloadFileParameters,
    RetrievalType
} = require("smartling-api-sdk-nodejs");

const { fileUris } = require('./src/file_uris');

const {
  PRODUCT_MAPPINGS,
  getProductsConfigs,
  readTranslationConfig
} = require('./src/file_readers');

const {
  buildBatchFileParamsForApp,
  buildBatchFileParamsForConfig,
  buildBatchFileParamsForData,
  buildBatchFileParamsForDocsNav,
  buildBatchFileParamsForInclude,
  buildBatchFileParamsForSrc
} = require('./src/batch_params');

const projectId = process.env.PROJECT_ID;
let jobId = process.env.JOB_ID;
const userId = process.env.USER_IDENTIFIER;
const userSecret = process.env.USER_SECRET;
const locale = process.env.LOCALE || 'ja';
const product = process.env.PRODUCT;
const versions = process.env.VERSIONS;

// if (!projectId || !userId || !userSecret) {
//   console.error("Missing environment variables.");
//   process.exit(1);
// }

// Create factory for building API clients.
const apiBuilder = new SmartlingApiClientBuilder()
    .setLogger(console)
    .setBaseSmartlingApiUrl("https://api.smartling.com")
    .setHttpClientConfiguration({ timeout: 10000 })
    .authWithUserIdAndUserSecret(userId, userSecret);

async function buildProductsConfig(locale, product, versions) {
  const configFromFile = readTranslationConfig();
  let productsConfig;

  if (product) {
    if (PRODUCT_MAPPINGS[product] !== undefined) {
      if (versions) {
        // If a product and versions is provided used that.
        const versionsArray = versions.trim().split(',').map(v => v.trim());
        productsConfig = [{ 'product': product, 'versions': versionsArray }];
      } else {
        // If a product is specified but no versions, read the versions from the config file
        const versionsArray = configFromFile[locale][product];
        if (versionsArray) {
          productsConfig = [{ 'product': product, 'versions': versionsArray }];
        } else {
          console.log(`No versions provided or available in the config file for ${product}.`);
          process.exit(1);
        }
      }
    } else {
      console.log(`Invalid product, the possible values are: ${Object.keys(PRODUCT_MAPPINGS)}.`);
      process.exit(1);
    }
  } else {
    // If no product and versions provided, use the config file
    productsConfig = await getProductsConfigs(configFromFile, locale);
  }
  return productsConfig;
};

async function createJobAndSendFiles () {
  try {
    // TODO: handle access token expiration, it's not clear from the docs if the node-sdk
    // refreshes it automatically. However, the code suggests so.
    const jobsApi = apiBuilder.build(SmartlingJobsApi);
    const batchesApi = apiBuilder.build(SmartlingJobBatchesApi);

    const productsConfig = await buildProductsConfig(locale, product, versions);
    console.log('Sending files for the following config for translation.');
    console.log(productsConfig);

    if (!jobId) {
      // Create job
      const createJobParams = new CreateJobParameters()
        .setName(`Docs Translaton job ${Date.now()}`)
        .setDescription(`Translating files to ${locale}`);

      console.log("Creating the job...");
      const job = await jobsApi.createJob(projectId, createJobParams);
      console.log(`Job created. Job ID: ${job.translationJobUid}`);
      jobId = job.translationJobUid;
    }
    // Create job batch.
    const createBatchParams = new CreateBatchParameters()
      .setTranslationJobUid(jobId)
      .setAuthorize(false);
    console.log("Creating Job Batch...");

    const {
      appFilesUris,
      appSrcFilesUris,
      configLocaleFilesUris,
      dataFilesUris,
      docsNavFilesUris,
      includeFilesUris
    } = await fileUris(productsConfig);

    const filesUris = [
      ...appFilesUris,
      ...appSrcFilesUris,
      ...configLocaleFilesUris,
      ...dataFilesUris,
      ...docsNavFilesUris,
      ...includeFilesUris
    ];

    // Create the batch, supplying the URIs of the files that will be uploaded to it
    filesUris.forEach(fileUri => createBatchParams.addFileUri(fileUri));

    const batch = await batchesApi.createBatch(projectId, createBatchParams);
    console.log(`Job batch created. Batch ID ${batch.batchUid}`);

    console.log("Uploading files to batch...")
    for (const file of appFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForApp(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    for (const file of appSrcFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForSrc(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    for (const file of configLocaleFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForConfig(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    for (const file of dataFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForData(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    for (const file of docsNavFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForDocsNav(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    for (const file of includeFilesUris) {
      const { fileUri, batchFileParams } = await buildBatchFileParamsForInclude(file, locale);
      await batchesApi.uploadBatchFile(projectId, batch.batchUid, batchFileParams);
    }

    console.log("Finished adding files to batch");
    console.log("Head to Smartling's Dashboard to authorize the job");
  } catch (e) {
    console.log(e);
    process.exit(1)
  }
}

createJobAndSendFiles();
