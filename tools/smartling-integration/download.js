const fs = require('fs');
const path = require('path');

const projectId = process.env.PROJECT_ID;
const userId = process.env.USER_IDENTIFIER;
const jobId = process.env.JOB_ID;
const userSecret = process.env.USER_SECRET;
const translatedContentPath = process.env.TRANSLATED_CONTENT_PATH;
const locale = process.env.LOCALE || 'ja-JP';

if (!projectId || !userId || !userSecret || !jobId || !translatedContentPath) {
  console.error("Missing environment variables.");
  process.exit(1);
}

const {
  DownloadFileParameters,
  ListJobFilesParameters,
  Logger,
  RetrievalType,
  SmartlingApiClientBuilder,
  SmartlingJobsApi,
  SmartlingFilesApi
} = require("smartling-api-sdk-nodejs");

const processMarkdown = require('./src/post-processors/markdown-files.js');
const { handleRateLimiting } = require('./src/rate_limit');

const apiBuilder = new SmartlingApiClientBuilder()
    .setLogger(console)
    .setBaseSmartlingApiUrl("https://api.smartling.com")
    .setHttpClientConfiguration({ timeout: 300000 })
    .authWithUserIdAndUserSecret(userId, userSecret);

async function getFilesListForJob(projectId, jobId) {
  try {
    const jobsApi = apiBuilder.build(SmartlingJobsApi);
    const limit = 1000;
    let offset = 0;
    let fileUris = [];
    let totalCount = 0;
    let params = new ListJobFilesParameters();

    do {
      params.setOffset(offset).setLimit(limit);
      let response = await jobsApi.getJobFiles(projectId, jobId, params);

      totalCount = response.totalCount;
      fileUris.push(...response.items.map(f => f.uri));
      offset += limit;
    } while (offset <= totalCount)

    return fileUris;
  } catch(e) {
    console.log(e);
    process.exit(1)
  }
}

// Run this only if the Job is Completed
async function downloadFiles() {
  try {
    const filesApi = apiBuilder.build(SmartlingFilesApi);
    const filesUris = await getFilesListForJob(projectId, jobId);

    for (const fileUri of filesUris) {
      const downloadFileParams = new DownloadFileParameters()
        .setRetrievalType(RetrievalType.PUBLISHED);

      // TODO: any post-processing goes here...
      // config/locales/en.yml => config/locales/ja.yml
      let downloadedFileContent = await handleRateLimiting(filesApi.downloadFile.bind(filesApi), projectId, fileUri, locale, downloadFileParams);

      // post-processing
      if (path.extname(fileUri) === '.md') {
        downloadedFileContent  = processMarkdown(downloadedFileContent);
      }

      const filePath = path.join(translatedContentPath, locale, fileUri);
      const dir = path.dirname(filePath);

      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
      fs.writeFileSync(filePath, downloadedFileContent);

      console.log(`Downloaded ${fileUri}`);
    }
  } catch (e) {
    console.log(e);
    process.exit(1)
  }
}

downloadFiles();
