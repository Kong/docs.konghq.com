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
const { handleRateLimiting } = require('./src/rate_limit');

const {
  PRODUCT_MAPPINGS,
  getProductsConfigs,
  readTranslationConfig
} = require('./src/file_readers');

const {
  buildBatchFileParamsForData,
  buildBatchFileParamsForDocsNav,
  buildBatchFileParamsForSrc,
  buildBatchFileParamsForPluginsMetadata,
  buildBatchFileParamsForPluginsOverview,
  buildBatchFileParamsForPluginsSchema
} = require('./src/batch_params');

const projectId = process.env.PROJECT_ID;
const userId = process.env.USER_IDENTIFIER;
const userSecret = process.env.USER_SECRET;
let jobId = process.env.JOB_ID;
const locale = process.env.LOCALE || 'ja-JP';

// Create factory for building API clients.
const apiBuilder = new SmartlingApiClientBuilder()
    .setLogger(console)
    .setBaseSmartlingApiUrl("https://api.smartling.com")
    .setHttpClientConfiguration({ timeout: 10000 })
    .authWithUserIdAndUserSecret(userId, userSecret);

async function createJobAndSendFiles () {
  try {
    const jobsApi = apiBuilder.build(SmartlingJobsApi);
    const batchesApi = apiBuilder.build(SmartlingJobBatchesApi);

    if (jobId === undefined) {
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
    console.log("Creating Job Batch...");
    const createBatchParams = new CreateBatchParameters()
      .setTranslationJobUid(jobId)
      .setAuthorize(false);


    const files = [
      'app/_src/gateway/index.md',
      'app/_src/gateway/get-started/index.md', // lists and codes
      'app/_src/gateway/licenses/index.md', // table with conditional
      'app/_data/docs_nav_gateway_3.6.x.yml',
      'app/_data/extensions.yml',
      'app/_hub/kong-inc/jwt-signer/_metadata/_index.yml',
      'app/_hub/kong-inc/jwt-signer/overview/_index.md',
      'app/_src/.repos/kong-plugins/schemas/jwt-signer/3.7.x.json',
    ];

    // Create the batch, supplying the URIs of the files that will be uploaded to it
    files.forEach((fileUri) => {
      console.log(fileUri)
      createBatchParams.addFileUri(fileUri)
    });

    const batch = await batchesApi.createBatch(projectId, createBatchParams);
    console.log(`Job batch created. Batch ID ${batch.batchUid}`);

    console.log("Uploading files to batch...")
    for (const file of files) {
      let fileUri, batchFileParams;

      switch(true) {
        case (/^app\/_src/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForSrc(file, locale));
          break;
        case (/^app\/data/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForData(file, locale));
          break;
        case (/^app\/_includes/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForInclude(file, locale));
          break;
        case (/^app\/_data\/docs_nav/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForDocsNav(file, locale));
          break;
        case (/^app\/_data/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForData(file, locale));
          break;
        case (/^app\/_hub\/.*\/.*\/_metadata/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForPluginsMetadata(file, locale));
          break;
        case (/^app\/_hub\/.*\/.*\/overview/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForPluginsOverview(file, locale));
          break;
        case (/^app\/_src\/\.repos\/kong-plugins\/schemas/.test(file)):
          ({ fileUri, batchFileParams } = await buildBatchFileParamsForPluginsSchema(file, locale));
          break;
        default:
          throw new Error(`Unsupported file: ${file}`)
      }
      console.log(fileUri)
      await handleRateLimiting(batchesApi.uploadBatchFile.bind(batchesApi), projectId, batch.batchUid, batchFileParams);
    }

    console.log("Finished adding files to batch");
    console.log("Head to Smartling's Dashboard to authorize the job");
  } catch (e) {
    console.log(e);
    process.exit(1)
  }
}

createJobAndSendFiles();
