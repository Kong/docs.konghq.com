const path = require('path');
const {
  UploadBatchFileParameters,
  FileType,
} = require("smartling-api-sdk-nodejs");

const yamlPreProcessor = require('./pre-processors/yaml-files.js');
const supportedVersionsPreProcessor = require('./pre-processors/supported-versions.js');

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

const MARKDOWN_PLACEHOLDERS = "\\{%\\s?mermaid\\s?%\\}((.|\\n)*?)?\\{%\\s?endmermaid\\s%\\}|\\{\\{.+?\\}\\}|\\{%.+?%\\}|\\{:.+?\\}";

const MARKDOWN_DIRECTIVES = {
  whitespace_trim: "off",
  markdown_code_notranslate: "on",
  primary_placeholder_format_custom: MARKDOWN_PLACEHOLDERS,
  markdown_html_strategy: "restore" // undocumented flag: restores the original file html tags
};

async function buildBatchParamsForMarkdownFile(fileUri, locale) {
  let batchFileParams = new UploadBatchFileParameters()
    .setFileFromLocalFilePath(fileUri)
    .setFileUri(fileUri)
    .setFileType(FileType.MARKDOWN)
    .setLocalesToApprove([locale])

  Object.entries(MARKDOWN_DIRECTIVES).forEach(([directive, value]) => {
    batchFileParams.setDirective(directive, value)
  });

  return batchFileParams;
}

async function buildBatchFileParamsForConfig(fileUri, locale) {
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
  let batchFileParams = await buildBatchParamsForMarkdownFile(fileUri, locale);

  batchFileParams
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForSrc(fileUri, locale) {
  let batchFileParams = await buildBatchParamsForMarkdownFile(fileUri, locale);

  batchFileParams
    .setDirective("yaml_front_matter", "on")
    .setDirective("no_translate_keys", FRONTMATTER_KEYS_TO_EXCLUDE.join(','));

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForInclude(fileUri, locale) {
  // Includes don't have frontmatters
  let batchFileParams = await buildBatchParamsForMarkdownFile(fileUri, locale);

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

async function buildBatchFileParamsForData(fileUri, locale) {
  const batchFileParams = new UploadBatchFileParameters();

  if (fileUri.endsWith('app/_data/extensions.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['name', 'desc']));
  } else if (fileUri.endsWith('app/_data/tables/os_support.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['deprecation_date']));
  } else if (fileUri.endsWith('app/_data/tables/install_options_34.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['subtitle', 'name']));
  } else if (fileUri.endsWith('app/_data/tables/breaking_changes_lts.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['name', 'desc', 'description', 'area', 'action']));
  } else if (fileUri.endsWith('app/_data/tables/features/gateway.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['name', 'tooltip', 'cta']));
  } else if (fileUri.startsWith('app/_data/tables/support/gateway/versions/')) {
    batchFileParams.setFileContent(supportedVersionsPreProcessor(fileUri, ['eol']));
  } else if (fileUri.endsWith('app/_data/tables/support/gateway/packages.yml')) {
    batchFileParams.setFileContent(yamlPreProcessor(fileUri, ['eol']));
  } else {
    batchFileParams.setFileFromLocalFilePath(fileUri);
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
  let batchFileParams = await buildBatchParamsForMarkdownFile(fileUri, locale);

  batchFileParams
    .setDirective("yaml_front_matter", "on")

  return { fileUri: fileUri, batchFileParams: batchFileParams };
}

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
