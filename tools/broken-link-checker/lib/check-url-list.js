import pkg from 'broken-link-checker';
const { HtmlUrlChecker } = pkg;

import ignoredTargets from "../config/ignored_targets.json?type=json" assert { type: 'json' };

export function checkUrls(changes, opts) {
  return new Promise((resolve) => {
    // These are URLs that we might link to, but we don't want to
    // check for validity
    const brokenLinks = new Set();
    const checker = new HtmlUrlChecker(
      {
        honorRobotExclusions: false,
        excludedKeywords: ignoredTargets,
        maxSocketsPerHost: 64,
        requestMethod: "get",
      },
      {
        link: (result, data) => {
          if (opts.verbose) {
            console.log(`${result.base.resolved} :: ${result.url.resolved}`);
          }
          if (result.broken) {
            // Handle HTTP 308 which is a valid response
            if (result.brokenReason === "HTTP_308") {
              return;
            }

            // Ignore any broken links in the opts.ignore list
            for (const b of opts.ignore) {
              if (result.url.resolved.match(b)) {
                return;
              }
            }

            // Don't report on the "Edit this page" links for forks as
            // they'll always be broken
            if (
              opts.skip_edit_link &&
              result.html.text === "Edit this page" &&
              result.url.resolved.match(
                /.*github.com\/Kong\/docs.konghq.com\/edit\/.*/
              )
            ) {
              return;
            }

            brokenLinks.add({
              page: result.base.resolved,
              source: data.source,
              text: result.html.text,
              target: result.url.resolved,
              reason: result.brokenReason,
            });
          }
        },
        end: () => {
          resolve(Array.from(brokenLinks));
        },
      }
    );

    for (const c of changes) {
      checker.enqueue(c.url, c);
    }
  });
};
