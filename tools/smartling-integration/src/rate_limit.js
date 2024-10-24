const MAX_RETRIES = 10;
const MAX_DELAY = 60 * 1000;

const { SmartlingException } = require("smartling-api-sdk-nodejs");

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
};

async function handleRateLimiting(apiCall, ...args) {
  let attempt = 0;
  do {
    try {
      let response = await apiCall(...args);
      return response;
    } catch (e) {
      if (e instanceof SmartlingException && e.statusCode === 429) {
        attempt++;
        let randomizedExponentialDelay = ((2 ** attempt) + Math.random()) * 1000;
        let timeToSleep = Math.min(randomizedExponentialDelay, MAX_DELAY);

        console.log(e.errorResponse);
        console.log(`Rate limited. Retrying in ${timeToSleep / 1000} seconds... (Attempt ${attempt})`);
        await sleep(timeToSleep);
      } else {
        throw e;
      }
    }
  } while (attempt <= MAX_RETRIES)

  throw new Error('Rate Limit: Max retries exceeded');
};

module.exports = { handleRateLimiting };
