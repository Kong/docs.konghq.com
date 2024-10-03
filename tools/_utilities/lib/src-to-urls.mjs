/*
Accepts a file path in app/_src and returns all URLs that the file renders
*/

import fg from "fast-glob";
import { load } from "js-yaml";
import { readFileSync } from "fs";
import extractNavWithMeta from "./nav-to-urls.mjs";

import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function loadNavEntries(pattern) {
  let navEntries = await fg(
    `${__dirname}/../../../app/_data/docs_nav_${pattern}.yml`,
  );
  return navEntries
    .map((f) => {
      return load(readFileSync(f, "utf8"));
    })
    .filter((n) => {
      // Skip inherited nav files
      return n.generate && !n.inherit;
    });
}

async function loadKongVersions() {
  let versions = await fg(`${__dirname}/../../../app/_data/kong_versions.yml`);
  return load(readFileSync(versions[0], "utf8"));
}

function getReleaseData(release, versions) {
  let releaseData = versions.find((v) => {
    return v.release == release.release && v.edition == release.product;
  });

  return releaseData;
}

// Take a file in src and output the URLs that it renders
export default async function(pattern, file) {
  let urls = [];

  if (!file) {
    file = {};
  }

  let src = file.filename;

  const navEntries = await loadNavEntries(pattern);
  const kongVersions = await loadKongVersions();

  for (const entry of navEntries) {
    let r = extractNavWithMeta(entry.items, ``, `app/_src/${entry.product}`);

    // If we provided a specific source, only match that file
    if (src) {
      r = r.filter((u) => {
        return u.src == src;
      });
    }

    let version = entry.release;
    const releaseData = getReleaseData(entry, kongVersions);
    if (releaseData && releaseData.label) {
      version = releaseData.label;
    }

    urls = urls.concat(
      r.map((u) => {
        const prefix = u.is_absolute ? "" : `/${entry.product}/${version}`;

        const data = {
          url: `${prefix}${u.url}`,
        };

        if (src) {
          data.source = src;
        }

        if (file.status) {
          data.status = file.status;
        }

        return data;
      }),
    );
  }

  urls = Array.from(new Set(urls));

  return urls;
}
