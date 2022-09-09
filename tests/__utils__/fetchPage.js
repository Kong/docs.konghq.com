const fetch = require("node-fetch");
const cheerio = require("cheerio");

global.fetchPage = async function(url, baseUrl){
  return cheerio.load(await fetchPageRaw(url));
}

global.fetchPageRaw = async function(url, baseUrl){
  baseUrl = baseUrl || "http://localhost:8888";
  const response = await fetch(baseUrl + url);
  return await response.text();
}