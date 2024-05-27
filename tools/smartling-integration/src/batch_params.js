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
    .setDirective("yaml_locale_detection", false)
    .setDirective("yaml_locale_substitution", false);

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForApp(fileUri, locale) {
  // TODO: do we need to set the placeholder?
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", "(\{\{.+?\}}|(\{\%.+?\%}))")
    .setDirective("yfm_block_enabled", "on")
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForSrc(fileUri, locale) {
  // TODO: do we need to set the placeholder?
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", "(\{\{.+?\}}|(\{\%.+?\%}))")
    .setDirective("yfm_block_enabled", "on")
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForInclude(fileUri, locale) {
  // Includes don't have frontmatters
  // TODO: do we need to set the placeholder?
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])
    .setDirective("whitespace_trim", "off")
    .setDirective("primary_placeholder_format_custom", "(\{\{.+?\}}|(\{\%.+?\%}))");

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

// TODO: There are two special considerations:
// * categories
// * hub-filters
// we shouldn't translate `slug`, so we might need to edit the content when we upload the files...
async function buildBatchFileParamsForData(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
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
  // TODO: only descriptions
  const batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.JSON)
    .setLocalesToApprove([locale])
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
    .setDirective("primary_placeholder_format_custom", "(\{\{.+?\}}|(\{\%.+?\%}))");

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
