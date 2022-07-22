---
title: Protect your Services
---
In this topic, you’ll learn how to enforce rate limiting using the Rate Limiting plugin.

If you are following the getting started workflow, make sure you have completed [Exposing Your Services](/gateway/{{page.kong_version}}/get-started/comprehensive/expose-services) before moving on.

## What is Rate Limiting?

Kong's [Rate Limiting plugin](/hub/kong-inc/rate-limiting) lets you restrict how many requests your upstream services receive from your API consumers, or how often each user can call the API.

{:.note}
> The [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced) <span class="badge enterprise"></span> plugin provides support for the sliding window algorithm to prevent the API from being overloaded near the window boundaries, and adds Redis support for greater performance.

## Why Use Rate Limiting?

Rate limiting protects the APIs from accidental or malicious overuse. Without rate limiting, each user may request as often as they like, which can lead to spikes of requests that starve other consumers. After rate limiting is enabled, API calls are limited to a fixed number of requests per second.
## Set up Rate Limiting

{:.note}

Call the Admin API on port `8001` and configure plugins to enable a limit of five (5) requests per minute, stored locally and in-memory, on the node.


```sh
curl -i -X POST http://localhost:8001/plugins \
  --data name=rate-limiting \
  --data config.minute=5 \
  --data config.policy=local
```



## Validate Rate Limiting

To validate rate limiting, send a request to the API six (6) times from the CLI to confirm the requests are rate limited.

```sh
curl -i -X GET http://localhost:8000/mock/request
```

Or with follow these instructions from your web browser:

1. Enter `localhost:8000/mock` and refresh your browser six times.
    After the sixth request, you’ll receive an error message.
2. Wait at least 30 seconds and try again.
    The service will be accessible until the sixth access attempt within a 30-second window.


After the 6th request, you should receive a 429 "API rate limit exceeded" error:
```
{
"message": "API rate limit exceeded"
}
```


## Summary and next steps

In this section:

* When you used the Admin API or decK, you enabled the Rate Limiting plugin,
setting the rate limit to 5 times per minute.

Next, head on to learn about [proxy caching](/gateway/{{page.kong_version}}/get-started/comprehensive/improve-performance).
