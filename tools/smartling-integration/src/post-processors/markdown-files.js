// We use Kramdown https://kramdown.gettalong.org/
// to render our Markdown content into html.
// It adds a few features to Markdown that Smartling can't recognize because they
// support the Github Flavored Markdown spec.
// https://github.github.com/gfm/
//
// Note about Smartling:
// Markdown translation is accomplished by transforming content into HTML so that it can be manipulated in translation tools.
// Once translation is complete, the content is converted from HTML back into Markdown while the translated content is downloaded.
// As a result, your original Markdown document may differ in some ways from what is downloaded in the translated documents.
// See https://help.smartling.com/hc/en-us/articles/360012489774-Markdown
//
// Some post-processing is required to get the downloaded content to render correctly.

// Regular tables are processed fine by Smartling but there's a problem when a table uses the
// {% if_version %} tag for conditionally rendering rows.
// Technically, it's not a valid table anymore, so Smartling correctly parses the part of the table that is valid
// and the rest (rows inside the {% if_version %} {% endif_version %} block and the ones that come after) are returned as
// markdown content with the cells delimiters `|` escaped, i.e. `\|`.
//
// e.g. The following table
//
// | Feature            | Free Mode | Enterprise Subscription |
// |--------------------|:---------:|:-----------------------:|
// | Manager            | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
//
// {% if_version lte:3.4.x %}
// | Dev Portal         | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |
// {% endif_version %}
//
// | Enterprise plugins | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |
//
// is returned as:
//
// |  Feature  | Free Mode | Enterprise Subscription |
// |-----------|:---------:|:-----------------------:|
// | Manager   |           |                         |
//
// {% if_version lte:3.4.x %}
// \| Dev Portal         \|  \|  \|
// {% endif_version %}
//
// \| Enterprise plugins \|  \|  \|
//
// The following function is an attempt at removing the escaping from table cells delimeters.
function processTables(fileContent) {
  // Regex to match a line that resembles a markdown table row with escaped pipes
  const tableRowRegex = /^\\\|([^\n]+\\\|)+$/gm;

  // Replace escaped pipes only in lines matching the structure of a table row
  return fileContent.replace(tableRowRegex, (match) => {
    return match.replace(/\\\|/g, '|');
  });
}

// We use block attributes for adding badges to headings
// https://kramdown.gettalong.org/quickref.html#block-attributes
//
// e.g.
// ## Title
// {:.enterprise }
//
// The problem is that Smartling adds an extra newline between the heading and the block attribute
// causing the styles to break.
// This Function removes the extra newline between a heading and its corresponding blockquote
function processHeadings(fileContent) {
  function removeExtraNewline(regexp, content) {
    return content.replace(regexp, (match) => {
      return match.replace(/\n\n/g, '\n');
    });
  }
  // Fix css classes for h1 and h2s
  let modifiedContent = removeExtraNewline(/^(([^\n]+)\n=+\n|^([^\n]+)\n-+\n)\n{:\.(?!warning|note|important).*}/gm, fileContent);

  // Fix css classes for h3+
  modifiedContent = removeExtraNewline(/^#+\s.*\n\n{:\.(?!warning|note|important).*}/gm, modifiedContent);

  return modifiedContent;
}

function processLists(input) {
  // Split the input into lines
  let lines = input.split('\n');
  let ifVersionResult = [];
  let result = [];

  // Regular expression to match list items with '{% if_version ... -%}' at the end
  const ifVersionRegex = /^(\s*[*]\s.*)\s+({%\s*if_version\s.*-%\})(\n|\s)?$/;
  const endIfVersionRegex = /^(\s*[*]\s.*)\s+({%\s*endif_version\s*-%\})(\n|\s)?$/;
  // Regular expression to match list items (considering possible leading spaces)
  const listItemRegex = /^(\s*)[*]\s/;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const match = line.match(ifVersionRegex);

    if (match) {
      ifVersionResult.push(match[1].trimEnd()); // Push the content of the list item
      // Check the next line to determine indentation
      const nextLine = lines[i + 1] || '';
      const nextLineMatch = nextLine.match(listItemRegex);

      if (nextLineMatch) {
        const indentation = nextLineMatch[1]; // Capture indentation from the next list item
        ifVersionResult.push(indentation + match[2].trim()); // Apply the indentation to the version tag
      } else {
        // If the next line isn't a list item, move the tag to the next line without indentation
        ifVersionResult.push(match[2].trim());
      }
    } else {
      // Push the line as is if no match is found
      ifVersionResult.push(line);
    }
  }

  lines = ifVersionResult;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const match = line.match(endIfVersionRegex);

    if (match) {
      result.push(match[1].trimEnd()); // Push the content of the list item

      // Check the next line to determine indentation
      const nextLine = lines[i + 1] || '';
      let nextLineMatch = nextLine.match(listItemRegex);
      if (!nextLineMatch) {
        nextLineMatch = nextLine.match(/^(\s*){%\s*if_version\s.*-%\}(\n|\s)?$/);
      }

      if (nextLineMatch) {
        const indentation = nextLineMatch[1]; // Capture indentation from the next list item
        result.push(indentation + match[2].trim()); // Apply the indentation to the version tag
      } else {
        // If the next line isn't a list item, move the tag to the next line without indentation
        result.push(match[2].trim());
      }
    } else {
      // Push the line as is if no match is found
      result.push(line);
    }
  }
  // Join the result array back into a string
  return result.join('\n');
}

module.exports = function processMarkdown(fileContent) {
  let processedContent = processHeadings(fileContent);
  processedContent = processTables(processedContent);
  processedContent = processLists(processedContent);
  return processedContent;
}
