---
title: Improve Performance with Proxy Caching
---


One of the ways Kong delivers performance is through caching.  The proxy caching  plug-in delivers fast performance by providing the ability to cache responses based on requests, response codes, and content type. This means the upstream services are not bogged down with repeated requests, because {{site.base_gateway}} can respond with cached results. {{site.base_gateway}} offers the [Proxy Caching plugin](/hub/kong-inc/proxy-cache/). The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per consumer or per API. With that level of granularity you can create caching rules that match your specific use case. 


The cache timeout is configurable and once its reached, Kong will forward the request to the upstream again, cache the result and respond from cache until the timeout. The plug-in can store cached data in memory or for improved performance, Redis.  More details on the caching can be found here.      





{{site.base_gateway}} delivers fast performance through caching. The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per Consumer or per API.

Cache entities are stored for a configurable period of time. When the timeout is reached, the gateway forwards the request to the Upstream, caches the result and responds from cache until the timeout. The plugin can store cached data in memory, or for improved performance, in Redis.

## Configure Proxy Caching plugin

Configuring the Proxy Caching plugin is done by sending a `POST` request to the admin API and describing the caching rules:


```sh

curl -i -X POST http://localhost:8001/plugins \
  --data name=proxy-cache \
  --data config.content_type="application/json" \
  --data config.cache_ttl=30 \
  --data config.strategy=memory

```

If configuration was succesful, you will receive a `201` response code. The request you sent configured Proxy Caching for all `application/json` content, with a time to live (TTL) of 30 seconds. Because this plugin did not specify a route or a service, {{site.base_gateway}} has applied this configuration globally accross all services and routes. The Proxy Caching plugin can also be configured at service-level, route-level, or consumer-level. 

## Validate the configuration

You can check that the Proxy Caching plugin is working by checking by sending a `GET` request to the route that was created in the[configure services and routes](/gateway/latest/get-started/configure-services-and-routes) guide and examining the headers. If you did not follow the guide, edit the example to reflect your configuration. Send the following request once: 


```
curl -i -X GET http://localhost:8000/mock/request
```

Depending on your configuration, the response header will be composed of many different fields. Notice the integer values in the following fields

* `X-Kong-Proxy-Latency`

* `X-Kong-Upstream-Latency`

If you were to send two requests in succession, the values would be lower in the second request. That demonstrates that the content is cached, and {{site.base_gateway}} is not returning the information directly from the upstream service that your route is pointing to.

* `X-Cache-Status`

This header can return the following states:

|state| Description|
|---|---|
|Miss| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.|
|Hit| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.|
* Miss: The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.
* Hit: The request was satisfied and served from cache.
* Refresh: The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded cache_ttl threshold.
* Bypass: The request could not be satisfied from cache based on plugin configuratio

### Cache Status

In the validation step the client returned several validation headers. The values in these headers can help you understand how Proxy Caching is working on your system. `X-Cache-Status` 





This time, notice the differences in the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`. Cache status is a `hit`, which means {{site.base_gateway}} is responding to the request directly from cache instead of proxying the request to the Upstream service.


Note the: `X-Kong-Upstream-Latency` header and then send the exact request again. You will notice that the latency displayed is lower in the second request. That is because your content is cached and {{site.base_gateway}} is not returning the information directly from the upstream service that your route is pointing to. 



```

Content-Type: text/html; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
X-RateLimit-Limit-30: 5
X-RateLimit-Remaining-30: 3
RateLimit-Limit: 5
RateLimit-Remaining: 3
RateLimit-Reset: 43
X-RateLimit-Limit-Minute: 5
X-RateLimit-Remaining-Minute: 3
X-Cache-Key: 9728b2210d52756a68e7cbb6fd2d734b
X-Cache-Status: Bypass
Date: Fri, 19 Aug 2022 14:33:17 GMT
Vary: Accept-Encoding
Via: kong/3.0.0.0-enterprise-edition
CF-Cache-Status: DYNAMIC
Report-To: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report\/v3?s=dPo3cl6sbSjgBM5%2FuXu9WxzgPKJEhP6sgP%2FKsZv3IfCs1LEsrBatjF72ZwXA1t%2BqxCnGnb39W4HbFP2aBr7XWN1%2FWzNLXa7RNnDozCn%2BIfV5DIvkJa811bcun78Yzw%3D%3D"}],"group":"cf-nel","max_age":604800}
NEL: {"success_fraction":0,"report_to":"cf-nel","max_age":604800}
Server: cloudflare
CF-RAY: 73d39a7d3a741788-EWR
alt-svc: h3=":443"; ma=86400, h3-29=":443"; ma=86400
X-Kong-Upstream-Latency: 158
X-Kong-Proxy-Latency: 10

```

### Time to live

Time to live (TTL) governs the refresh rate of cached content, this ensures that people requesting information from your upstream services aren't served old content. A TTL of 30 seconds means that content is refreshed every 30 seconds. TTL rules should vary based on the resource type of the content the upstream service is serving. 

* Static files that are rarely updated should have a longer TTL. 

* Dynamic files can use shorter TTL's to account for the complexity in updating. 

Kong can store resource entities in the storage engine longer than the prescribed cache_ttl or Cache-Control values indicate. This allows {{site.base_gateway}} to maintain a cached copy of a resource past its expiration. This allows clients capable of using max-age and max-stale headers to request stale copies of data if necessary.


In this context, TTL governs the refresh rate of these copies, ideally ensuring that “stale” versions of your content aren’t served to your website visitors.

Call the Admin API on port `8001` and configure plugins to enable in-memory caching globally, with a timeout of 30 seconds for Content-Type `application/json`.

[Proxy Caching plugin](/hub/kong-inc/proxy-cache/)


Let’s call the Admin API on port 8001 and endpoint plugins to enable in memory caching globally with a timeout of 30 seconds for Content-Type application/json.
$ http -f :8001/plugins name=proxy-cache config.strategy=memory \
config.content_type="application/json"
$ curl -i -X POST http://localhost:8001/plugins \
--data name=proxy-cache \
--data config.content_type="application/json" \
--data config.cache_ttl=30 \
--data config.strategy=memory




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
