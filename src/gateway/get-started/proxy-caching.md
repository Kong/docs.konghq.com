---
title: Improve Performance with Proxy Caching
content-type: tutorial
---


One of the ways Kong delivers performance is through caching. The proxy caching  plug-in delivers fast performance by providing the ability to cache responses based on requests, response codes, and content type. This means the upstream services are not bogged down with repeated requests, because {{site.base_gateway}} can respond with cached results. {{site.base_gateway}} offers the [Proxy Caching plugin](/hub/kong-inc/proxy-cache/). The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per consumer or per API. With that level of granularity you can create caching rules that match your specific use case. 



## Configure Proxy Cache plugin

Configuring the Proxy Caching plugin is done by sending a `POST` request to the admin API and describing the caching rules:


```sh

curl -i -X POST http://localhost:8001/plugins \
  --data name=proxy-cache \
  --data config.content_type="application/json" \
  --data config.cache_ttl=30 \
  --data config.strategy=memory

```

If configuration was successful, you will receive a `201` response code. The request you sent configured Proxy Caching for all `application/json` content, with a time to live (TTL) of 30 seconds. The final option `config.strategy=memory` specifies where the cache will be stored, you can read more about this option in the strategy section of the [Proxy Caching plugin](/hub/kong-inc/proxy-cache/) documentation.Because this request did not specify a route or a service, {{site.base_gateway}} has applied this configuration globally across all services and routes. The Proxy Caching plugin can also be configured at service-level, route-level, or consumer-level. You can read more about the other configurations and how to apply them in the [Proxy Caching plugin](/hub/kong-inc/proxy-cache/) page.

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

This will display `hit` expressing that proxy caching worked correctly, but this header can also return the following states:

|State| Description|
|---|---|
|Miss| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.|
|Hit| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.|
|Refresh| The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded `cache_ttl` threshold.|
|Bypass| The request could not be satisfied from cache based on plugin configuration.|

In the initial request the value for `config.content_type` was set to "application/json". The proxy cache plugin will only cache the specific data type that was set in the initial configuration request. 


## Time to live

Time to live (TTL) governs the refresh rate of cached content, this ensures that people requesting information from your upstream services aren't served old content. A TTL of 30 seconds means that content is refreshed every 30 seconds. TTL rules should vary based on the resource type of the content the upstream service is serving. 

* Static files that are rarely updated should have a longer TTL. 

* Dynamic files can use shorter TTL's to account for the complexity in updating. 

Kong can store resource entities in the storage engine longer than the prescribed `cache_ttl` or `Cache-Control`values indicate. This allows {{site.base_gateway}} to maintain a cached copy of a resource past its expiration. This allows clients capable of using max-age and max-stale headers to request stale copies of data if necessary.



## Next steps

Next, you’ll learn about the [Key-Authentication plugin](/gateway/{{page.kong_version}}/get-started/comprehensive/secure-services).
