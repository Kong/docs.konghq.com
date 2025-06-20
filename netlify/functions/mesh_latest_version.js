const fetch = require("node-fetch");

exports.handler = async (event) => {
  try {
    // Netlify function to pul the latest version from the developer site
    // The allow-control headers weren't set in the 301 reponse
    // Adding the headers back and including the response here from the dev site here
    // fixes the CORS issue
    const targetUrl = "https://developer.konghq.com/mesh/latest_version/";

    const response = await fetch(targetUrl);
    const data = await response.text();

    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET",
        "Access-Control-Allow-Headers": "Content-Type",
        "Content-Type": "text/plain",
      },
      body: data,
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
      },
      body: "Error fetching latest version",
    };
  }
};
