const path = require('path');
const {
  UploadBatchFileParameters,
  FileType,
} = require("smartling-api-sdk-nodejs");

const yamlPreProcessor = require('./pre-processors/yaml-files.js');

// Exclude from Frontmatter:
const FRONTMATTER_KEYS_TO_EXCLUDE =  [
  'konnect_cta_card',
  'toc',
  'content-type',
  'content_type',
  'badge',
  'book',
  'chapter',
  'pdk',
  'github_star_button',
  'alpha',
  'beta',
  'overrides',
  'type',
  'disable_image_expand',
  'no_version'
];

const MARKDOWN_PLACEHOLDERS = "\\{\\{.+?\\}\\}|\\{%.+?%\\}";

async function buildBatchFileParamsForConfig(fileUri, locale) {
  // TODO: when we download this, we need to change the name of the file to ja.yml
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.YAML)
    .setLocalesToApprove([locale]);

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForDocsNav(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileContent(yamlPreProcessor(fileUri, ['text', 'title']))
    .setFileUri(fileUri)
    .setFileType(FileType.YAML)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("yaml_locale_detection", "off")
    .setDirective("yaml_locale_substitution", "off");

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForApp(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", MARKDOWN_PLACEHOLDERS)
    .setDirective("yfm_block_enabled", "on")
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForSrc(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", MARKDOWN_PLACEHOLDERS)
    .setDirective("yfm_block_enabled", "on")
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForInclude(fileUri, locale) {
  // Includes don't have frontmatters
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", MARKDOWN_PLACEHOLDERS);

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForData(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters();

  if (fileUri.endsWith('app/_data/extensions.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['name', 'desc']))
  } else {
    batchFileParams.setFileFromLocalFilePath(fileUri)
  }
  batchFileParams
    .setFileUri(fileUri)
    .setFileType(FileType.YAML)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off");

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForPluginsMetadata(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileContent(yamlPreProcessor(fileUri, ['desc', 'dbless_explanation', 'notes']))
    .setFileUri(fileUri)
    .setFileType(FileType.YAML)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off");

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForPluginsSchema(fileUri, locale) {
  const translatePaths = [
    {
      path: "*/description",
      key: "{*}/description"
    },
    {
      path: "*/deprecation/message",
      key: "{*}/deprecation/message"
    }
  ];

  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.JSON)
    .setLocalesToApprove([locale])
    .setDirective("entity_escapting", "true")
    .setDirective("variants_enabled", "true")
    .setDirective("translate_paths", JSON.stringify(translatePaths))
    .setDirective("whitespace_trim", "off");

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForPluginsOverview(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", MARKDOWN_PLACEHOLDERS);

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}
// TODO
// Prep files to send
//
module.exports = {
  buildBatchFileParamsForApp,
  buildBatchFileParamsForConfig,
  buildBatchFileParamsForData,
  buildBatchFileParamsForDocsNav,
  buildBatchFileParamsForInclude,
  buildBatchFileParamsForSrc,
  buildBatchFileParamsForPluginsMetadata,
  buildBatchFileParamsForPluginsOverview,
  buildBatchFileParamsForPluginsSchema
};
