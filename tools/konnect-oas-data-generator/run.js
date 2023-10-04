const axios = require("axios");
const portalSDK = require("@kong/sdk-portal-js");
const argv = require("minimist")(process.argv.slice(2));
const fs = require("fs");

(async function () {
  const konnectPortalApiUrl = argv.url;

  const client = axios.create({
    baseURL: konnectPortalApiUrl,
    withCredentials: false,
    headers: {
      accept: "application/json",
    },
  });

  const config = new portalSDK.Configuration({
    basePath: "",
    accessToken: "",
  });

  let products = await fetchProducts(config, konnectPortalApiUrl, client);
  let data = await fetchProductVersions(
    config,
    konnectPortalApiUrl,
    client,
    products,
  );

  writeProductsToFile(data);
  console.log("Done.");
})();

async function fetchProducts(baseConfig, baseURL, client) {
  const searchApi = new portalSDK.SearchApi(baseConfig, baseURL, client);

  try {
    console.log("Fetching products...");
    const { data: portalEntities } = await searchApi.searchPortalEntities({
      indices: "product-catalog",
      q: "",
      pageNumber: 1,
      pageSize: 100,
      join: "versions",
    });
    const { data: sources, meta } = portalEntities;

    return sources.map(({ source }) => {
      return {
        id: source.id,
        title: source.name,
        latestVersion: source.latest_version,
        description: source.description,
        documentCount: source.document_count,
        versionCount: source.version_count,
      };
    });
  } catch (e) {
    console.error("Failed to load products", e);
  }
}

async function fetchProductVersions(baseConfig, baseURL, client, products) {
  const versionsApi = new portalSDK.VersionsApi(baseConfig, baseURL, client);

  try {
    console.log("Fetching versions...");
    const promises = products.map(async (product) => {
      let versions = await fetchAll((meta) =>
        versionsApi.listProductVersions({ ...meta, productId: product.id }),
      );

      return { ...product, versions };
    });

    return await Promise.all(promises);
  } catch (e) {
    console.error("Failed to load versions", e);
  }
}

async function fetchAll(fn) {
  const meta = {
    pageSize: 100,
    pageNumber: 1,
  };

  const { data } = await fn(meta);
  const results = [...data.data];

  while (results.length <= data?.meta?.total) {
    meta.pageNumber++;
    const { data: newData } = await fn(meta);

    results.push(...newData.data);
  }

  return results;
}

function writeProductsToFile(products) {
  const data = JSON.stringify(products, null, 2);

  fs.writeFile("../../app/_data/konnect_oas_data.json", data, (error) => {
    if (error) {
      console.error(error);

      throw error;
    }
  });
}
