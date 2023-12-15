---
title: Proxy Caching
book: kic-get-started
chapter: 4
type: tutorial
purpose: |
  Using the Proxy Cache plugin to cache response content using Redis
---

One of the ways Kong delivers performance is through caching.
The [Proxy Cache plugin](/hub/kong-inc/proxy-cache/) accelerates performance by caching
responses based on configurable response codes, content types, and request methods.
When caching is enabled, upstream services are not impacted by repetitive requests,
because {{site.base_gateway}} responds on their behalf with cached results. Caching can be
enabled on specific routes for all requests globally.

## Create a proxy-cache KongClusterPlugin

In the previous section you created a `KongPlugin` that was applied to a specific service or route. You can also use a `KongClusterPlugin` which is a global plugin that applies to all services.

This configuration caches all `HTTP 200` responses to `GET` and `HEAD` requests for 300 seconds:

```yaml
echo '
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: proxy-cache-all-endpoints
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: "true"
plugin: proxy-cache
config:
  response_code:
  - 200
  request_method:
  - GET
  - HEAD
  content_type:
  - text/plain; charset=utf-8
  cache_ttl: 300
  strategy: memory
' | kubectl apply -f -
```

## Test the proxy-cache plugin

To test the proxy-cache plugin, send another six requests to `$PROXY_IP/echo`:

```bash
for i in `seq 6`; do curl -sv $PROXY_IP/echo 2>&1 | grep -E "(Status|< HTTP)"; done
```

The first request results in `X-Cache-Status: Miss`. This means that the request is sent to the upstream service. The next four responses return `X-Cache-Status: Hit` which indicates that the request was served from a cache.

The `X-Cache-Status` header can return the following cache results:

|State| Description                                                                                                                                          |
|---|------------------------------------------------------------------------------------------------------------------------------------------------------|
|Miss| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.                 |
|Hit| The request was satisfied and served from the cache.                                                                                                 |
|Refresh| The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded `cache_ttl` threshold. |
|Bypass| The request could not be satisfied from cache based on plugin configuration.                                                                         |


The final thing to note is that when a `HTTP 429` request is returned by the rate-limit plugin, you do not see a `X-Cache-Status` header. This is because `rate-limiting` executes before `proxy-cache`. For more information, see [plugin priority](/gateway/latest/plugin-development/custom-logic/#kong-plugins).

```text
< HTTP/1.1 200 OK
< X-Cache-Status: Miss
< HTTP/1.1 200 OK
< X-Cache-Status: Hit
< HTTP/1.1 200 OK
< X-Cache-Status: Hit
< HTTP/1.1 200 OK
< X-Cache-Status: Hit
< HTTP/1.1 200 OK
< X-Cache-Status: Hit
< HTTP/1.1 429 Too Many Requests
```

