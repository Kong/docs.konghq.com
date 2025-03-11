const fs = require('fs');
const yaml = require('js-yaml');

module.exports = function supportedVersions(filePath, attributesToTranslate) {
  const content = fs.readFileSync(filePath, "utf8");
  // Split the file into lines
  const lines = content.split('\n');

  // Process each line to comment out the lines that start and end with {% %}
  const processedLines = lines.map(line => {
    if (line.trim().startsWith('{%') && line.trim().endsWith('%}')) {
      return `# ${line}`;
    }
    return line;
  });

  // Add the line "# smartling.sltrans = notranslate" at the beginning
  processedLines.unshift('# smartling.sltrans = notranslate');

  // Add specific comments before and after lines containing the "eol" key
  const finalLines = [];
  processedLines.forEach(line => {
    const trimmedLine = line.trim();
    const key = trimmedLine.split(':')[0];
    if (attributesToTranslate.includes(key)) {
      finalLines.push('            # smartling.sltrans = translate');
      finalLines.push(line);
      finalLines.push('            # smartling.sltrans = notranslate');
    } else {
      finalLines.push(line);
    }
  });

  // Join the final lines into a single string
  return finalLines.join('\n');
}
