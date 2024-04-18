import { load } from "js-yaml";
import { readFileSync } from "fs";

function extractUrls(input) {
  return input.flatMap((item) => {
    if (item.items) {
      return extractUrls(item.items);
    }
    return item;
  });
}

export default function (input) {
  let nav = load(readFileSync(input.path, "utf8"));

  // If it's single sourced, the nav is under nav.items
  if (nav.product && nav.items) {
    nav = nav.items;
  }

  let urls = extractUrls(nav);
  const urlVersion = input.version ? `/${input.version}` : "";

  // Build a full URL if absolute_url isn't set
  urls = urls.map((url) => {
    if (url.absolute_url) {
      return url.url;
    }
    return `/${input.type}${urlVersion}${url.url}`;
  });

  // Normalise URLs to remove fragments + add trailing slash
  urls = urls.map((url) => {
    return url.split("#")[0].replace(/\/$/, "") + "/";
  });

  // Unique list of URLs
  urls = [...new Set(urls)];

  // Remove any non-relative URLs
  urls = urls.filter((url) => {
    return !(url.includes("http://") || url.includes("https://"));
  });

  // Build full URLs
  urls = urls.map((x) => {
    return `http://localhost:8888${x}`;
  });

  return urls;
}
