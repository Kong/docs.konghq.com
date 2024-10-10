const fs = require('fs');
const yaml = require('js-yaml');

module.exports = function processYAML(filePath, attributesToTranslate) {
  // Read YAML file
  const yamlFile = fs.readFileSync(filePath, 'utf8');

  // Parse YAML
  const data = yaml.load(yamlFile);

  // Initialize variable to store output
  let output = '# smartling.sltrans = notranslate\n';

  // Function to recursively iterate through the object and output key-value pairs
  function processObject(obj, depth = 0) {
    for (const key in obj) {
      const value = obj[key];
      // If value is an object, recursively process it
      if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
        output += `${'  '.repeat(depth)}${key}:\n`;
        processObject(value, depth + 1);
      } else if (Array.isArray(value)) {
        output += `${'  '.repeat(depth)}${key}:\n`;
        value.forEach(item => {
          if (typeof item === 'object' && item !== null) {
            output += `${'  '.repeat(depth + 1)}-\n`;
            processObject(item, depth + 2);
          } else {
            output += `${'  '.repeat(depth + 1)}- ${item}\n`;
          }
        });
      } else {
        // Check if key is in attributesToTranslate
        if (attributesToTranslate.includes(key)) {
          output += `${'  '.repeat(depth)}# smartling.sltrans = translate\n`;
        }
        // Output key-value pair
        if (typeof value === 'string' && value.includes('\n')) {
          output += `${'  '.repeat(depth)}${key}: |\n${value.split('\n').map(line => `${'  '.repeat(depth + 1)}${line}`).join('\n')}\n`;
        } else {
          output += `${'  '.repeat(depth)}${key}: ${value}\n`;
        }
        // If key is in attributesToTranslate, output smartling.sltrans = notranslate
        if (attributesToTranslate.includes(key)) {
          output += `${'  '.repeat(depth)}# smartling.sltrans = notranslate\n`;
        }
      }
    }
  }

  // Start processing the object
  processObject(data);

  // Return the output
  return output;
};
