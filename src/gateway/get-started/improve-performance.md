---
title: Improve Performance with Proxy Caching
---

In this topic, you’ll learn how to use proxy caching to improve response efficiency using the Proxy Caching plugin.

If you are following the getting started workflow, make sure you have completed [Protect your Services](/gateway/{{page.kong_version}}/get-started/comprehensive/protect-services) before continuing.

## What is Proxy Caching?

{{site.base_gateway}} delivers fast performance through caching. The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per Consumer or per API.

Cache entities are stored for a configurable period of time. When the timeout is reached, the gateway forwards the request to the Upstream, caches the result and responds from cache until the timeout. The plugin can store cached data in memory, or for improved performance, in Redis.

## Why use Proxy Caching?

Use proxy caching so that Upstream services are not bogged down with repeated requests. With proxy caching, {{site.base_gateway}} can respond with cached results for better performance.

## Set up the Proxy Caching plugin

Call the Admin API on port `8001` and configure plugins to enable in-memory caching globally, with a timeout of 30 seconds for Content-Type `application/json`.


```sh
curl -i -X POST http://localhost:8001/plugins \
  --data name=proxy-cache \
  --data config.content_type="application/json; charset=utf-8" \
  --data config.cache_ttl=30 \
  --data config.strategy=memory
```

## Validate Proxy Caching

Let’s check that proxy caching works. You'll need the Kong Admin API for this
step.

Access the */mock* route using the Admin API and note the response headers:


```sh
curl -i -X GET http://localhost:8000/mock/request
```

In particular, pay close attention to the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`:
```
HTTP/1.1 200 OK
...
X-Cache-Key: d2ca5751210dbb6fefda397ac6d103b1
X-Cache-Status: Miss
X-Content-Type-Options: nosniff
...
X-Kong-Proxy-Latency: 25
X-Kong-Upstream-Latency: 37
```

Next, access the */mock* route one more time.

This time, notice the differences in the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`. Cache status is a `hit`, which means {{site.base_gateway}} is responding to the request directly from cache instead of proxying the request to the Upstream service.

Further, notice the minimal latency in the response, which allows {{site.base_gateway}} to deliver the best performance:

```
HTTP/1.1 200 OK
...
X-Cache-Key: d2ca5751210dbb6fefda397ac6d103b1
X-Cache-Status: Hit
...
X-Kong-Proxy-Latency: 0
X-Kong-Upstream-Latency: 1
```

To test more rapidly, the cache can be deleted by calling the Admin API:


```sh
curl -i -X DELETE http://localhost:8001/proxy-cache
```

## Summary and Next Steps

In this section, you:

* Set up the Proxy Caching plugin, then accessed the `/mock` route multiple times to see caching in effect.
* Witnessed the performance differences in latency with and without caching.

Next, you’ll learn about [securing services](/gateway/{{page.kong_version}}/get-started/comprehensive/secure-services).
