module.exports = function extractNavWithMeta(items, base, srcPrefix) {
  let urls = [];
  for (let u of items) {
    if (u.items) {
      urls = urls.concat(extractNavWithMeta(u.items, base, srcPrefix));
    } else {
      if (u.absolute_url) {
        const parts = u.url.split("/").filter((n) => n);

        // Special handling for index pages
        if (parts[1].match(/\d+\.\d+\.x/)) {
          parts[1] = "index";
        }

        // Otherwise treat the second segment as the filename e.g.
        // /gateway/changelog.md
        if (parts.length == 2) {
          urls.push({
            src: srcPrefix + "/" + parts[1] + ".md",
            url: u.url,
            is_absolute: true,
          });
        } else {
          urls.push({
            src: u.src || u.url,
            url: u.url,
            is_absolute: true,
          });
        }
      } else {
        const url = `${base}${u.url}`;
        urls.push({
          src:
            srcPrefix +
            (u.src || url)
              .replace(/\/?#.*$/, "") // Remove anchor links
              .replace(/\/$/, "") + // Remove trailing slashes
            ".md",
          url,
          is_absolute: false,
        });
      }
    }
  }

  return urls;
};
