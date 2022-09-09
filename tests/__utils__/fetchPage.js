const fetch = require("node-fetch");
const cheerio = require("cheerio");

global.fetchPage = async function(url, baseUrl){
  baseUrl = baseUrl || "http://localhost:8888";
  const response = await fetch(baseUrl + url);
  const body = await response.text();
  return cheerio.load(body);
}