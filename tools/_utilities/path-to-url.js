const convertNavFileToUrl = require("./lib/nav-to-index-page");
const convertSrcFileToUrls = require("./lib/src-to-urls");

module.exports = async function (files, options = {}) {
  files = files.map((f) => {
    return {
      filename: f.filename,
      status: f.status,
    };
  });

  // Map those to URLs
  let urls = [];
  for (let file of files) {
    let urlsToAdd = [];

    const f = file.filename;

    // If any data files have changed, we need to check a page that uses that
    // file to generate the side navigation. Let's use the index page
    if (!options.skip_nav_files && f.startsWith("app/_data/docs_nav_")) {
      urlsToAdd = [
        {
          source: f,
          url: convertNavFileToUrl(f),
          status: file.status,
        },
      ];
    }

    // Handle any prose changes where file path == URL
    else if (f.startsWith("app/") && !f.startsWith("app/_")) {
      urlsToAdd = [
        {
          source: f,
          url: `/${f.replace(/^app\//, "").replace(/(index)?\.md$/, "")}`,
          status: file.status,
        },
      ];
    }

    // Handle plugins. This does _not_ handle non _index plugins
    // as we'd need to read versions.yml and process the source key
    // Given how few plugins use non-index files, we'll skip this for now
    else if (f.startsWith("app/_hub/")) {
      urlsToAdd = [
        {
          source: f,
          url: `/${f
            .replace(/^app\/_hub\//, "hub/")
            .replace(/\/_.*\.md$/, "/")}`,
          status: file.status,
        },
      ];
    }

    // Any changes in app/_src
    else if (f.startsWith("app/_src/")) {
      urlsToAdd = await convertSrcFileToUrls("*", file);
    }

    // Add the URLs
    urls = urls.concat(urlsToAdd);
  }

  return Array.from(new Set(urls));
};
