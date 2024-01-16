import fg from "fast-glob";

export default async function (plugin, version) {
  plugin = plugin;
  version = version || '';

  let urls = [
    `/hub/kong-inc/${plugin}/${version}/`,
    `/hub/kong-inc/${plugin}/${version}/changelog/`,
    `/hub/kong-inc/${plugin}/${version}/configuration/`,
    `/hub/kong-inc/${plugin}/${version}/how-to/basic-example/`,
  ];

  let urlsFromFiles = await fg(`../app/_hub/kong-inc/${plugin}/how-to/*`);
  urlsFromFiles = urlsFromFiles.map((f) => {
    return f
      .replace('../app/_hub/', '/hub/')
      .replace('/how-to/', `/${version}/how-to/`)
      .replace('_index', '')
      .replace('.md', '');
  });

  urls = urls.concat(urlsFromFiles).map((u) => {
    return u.replace('//', '/');
  });

  // Prefix with URL
  urls = urls.map((u) => {
    return `http://localhost:8888${u}`;
  });

  return urls;
}
