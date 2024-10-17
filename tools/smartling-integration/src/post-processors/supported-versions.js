const fs = require('fs');
const yaml = require('js-yaml');

module.exports = function supportedVersions(content, attributesToTranslate) {
  // Split the file into lines
  const lines = content.split('\n');

  // Process each line to comment out the lines that start and end with {% %}
  const processedLines = lines.map(line => {
    if (line.trim().startsWith('# {%') && line.trim().endsWith('%}')) {
      return line.replace('# ', ' ').trim();
    } else if (line === '---') {
      return '';
    }
    return line;
  });

  return processedLines.join('\n');
}
