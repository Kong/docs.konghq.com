---
title: Proxy Caching
content-type: tutorial
book: get-started
chapter: 4
---

One of the ways Kong delivers performance is through caching.
The [Proxy Cache plugin](/hub/kong-inc/proxy-cache/) accelerates performance by caching
responses based on configurable response codes, content types, and request methods.
When caching is enabled, upstream services are not bogged down with repetitive requests,
because {{site.base_gateway}} responds on their behalf with cached results. Caching can be
enabled on specific {{site.base_gateway}} objects or for all requests globally.

### Cache Time To Live (TTL)

TTL governs the refresh rate of cached content, which is critical for ensuring
that clients aren't served outdated content. A TTL of 30 seconds means content older than
30 seconds is deemed expired and will be refreshed on subsequent requests.
TTL configurations should be set differently based on the type of the content the upstream
service is serving.

* Static data that is rarely updated can have longer TTL

* Dynamic data should use shorter TTL to avoid serving outdated data  

{{site.base_gateway}} follows [RFC-7234 section 5.2](https://tools.ietf.org/html/rfc7234)
for cached controlled operations. See the specification and the Proxy Cache
plugin [parameter reference](/hub/kong-inc/proxy-cache/#parameters) for more details on TTL configurations.

## Enable caching

The following tutorial walks through managing proxy caching across various aspects in {{site.base_gateway}}.

### Prerequisites

This chapter is part of the *Get Started with Kong* series. For the best experience, it is recommended that you follow the
series from the beginning.

Start with the introduction [Get Kong](/gateway/latest/get-started/), which includes
a list of prerequisites and instructions for running a local {{site.base_gateway}}.

Step two of the guide, [Services and Routes](/gateway/latest/get-started/services-and-routes/),
includes instructions for installing a mock service used throughout this series.

If you haven't completed these steps already, complete them before proceeding.

### Global proxy caching

Installing the plugin globally means *every* proxy request to {{site.base_gateway}}
will potentially be cached.

1. **Enable proxy caching**

   The Proxy Cache plugin is installed by default on {{site.base_gateway}}, and can be enabled by
   sending a `POST` request to the plugins object on the Admin API:

   ```sh
   curl -i -X POST http://localhost:8001/plugins \
     --data "name=proxy-cache" \
     --data "config.request_method=GET" \
     --data "config.response_code=200" \
     --data "config.content_type=application/json; charset=utf-8" \
     --data "config.cache_ttl=30" \
     --data "config.strategy=memory"
   ```

   If configuration was successful, you will receive a `201` response code.

   This Admin API request configured a Proxy Cache plugin for all `GET` requests that resulted
   in response codes of `200` and *response* `Content-Type` headers that *equal*
   `application/json; charset=utf-8`. `cache_ttl` instructed the plugin to flush values after 30 seconds.

   The final option `config.strategy=memory` specifies the backing data store for cached responses. More
   information on `strategy` can be found in the [parameter reference](/hub/kong-inc/proxy-cache/)
   for the Proxy Cache plugin.

1. **Validate**

   You can check that the Proxy Cache plugin is working by sending `GET` requests and examining
   the returned headers. In step two of this guide, [services and routes](/gateway/latest/get-started/services-and-routes/),
   you setup a `/mock` route and service that can help you see proxy caching in action.

   First, make an initial request to the `/mock` route. The Proxy Cache plugin returns status
   information headers prefixed with `X-Cache`, so use `grep` to filter for that information:

   ```
   curl -i -s -XGET http://localhost:8000/mock/anything | grep X-Cache
   ```

   On the initial request, there should be no cached responses, and the headers will indicate this with
   `X-Cache-Status: Miss`.

   ```
   X-Cache-Key: c9e1d4c8e5fd8209a5969eb3b0e85bc6
   X-Cache-Status: Miss
   ```

   Within 30 seconds of the initial request, repeat the command to send an identical request and the
   headers will indicate a cache `Hit`:

   ```
   X-Cache-Key: c9e1d4c8e5fd8209a5969eb3b0e85bc6
   X-Cache-Status: Hit
   ```

   The `X-Cache-Status` headers can return the following cache results:

   |State| Description                                                                                                                                          |
   |---|------------------------------------------------------------------------------------------------------------------------------------------------------|
   |Miss| The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.                 |
   |Hit| The request was satisfied and served from the cache.                                                                                                 |
   |Refresh| The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded `cache_ttl` threshold. |
   |Bypass| The request could not be satisfied from cache based on plugin configuration.                                                                         |

### Service level proxy caching

The Proxy Cache plugin can be enabled for specific services. The request is the same as above, but the request is sent to the service URL:

```sh
curl -X POST http://localhost:8001/services/example_service/plugins \
   --data "name=proxy-cache" \
   --data "config.request_method=GET" \
   --data "config.response_code=200" \
   --data "config.content_type=application/json; charset=utf-8" \
   --data "config.cache_ttl=30" \
   --data "config.strategy=memory"
```

### Route level proxy caching

The Proxy Caching plugin can be enabled for specific routes. The request is the same as above, but the request is sent to the route URL:

```sh
curl -X POST http://localhost:8001/routes/example_route/plugins \
   --data "name=proxy-cache" \
   --data "config.request_method=GET" \
   --data "config.response_code=200" \
   --data "config.content_type=application/json; charset=utf-8" \
   --data "config.cache_ttl=30" \
   --data "config.strategy=memory"
```

### Consumer level proxy caching

In {{site.base_gateway}}, [consumers](/gateway/latest/admin-api/#consumer-object) are an abstraction that defines a user of a service.
Consumer-level proxy caching can be used to cache responses per consumer.

1. **Create a consumer**

Consumers are created using the consumer object in the Admin API.

```sh
curl -X POST http://localhost:8001/consumers/ \
  --data username=sasha
```

1. **Enable caching for the consumer**

```sh
curl -X POST http://localhost:8001/consumers/sasha/plugins \
   --data "name=proxy-cache" \
   --data "config.request_method=GET" \
   --data "config.response_code=200" \
   --data "config.content_type=application/json; charset=utf-8" \
   --data "config.cache_ttl=30" \
   --data "config.strategy=memory"
```

## Manage cached entities

The Proxy Cache plugin supports administrative endpoints to manage cached entities. Administrators can
view and delete cached entities, or purge the entire cache by sending requests to the Admin API.

To retrieve the cached entity, submit a request to the Admin API `/proxy-cache` endpoint with the
`X-Cache-Key` value of a known cached value. This request must be submitted prior to the TTL expiration,
otherwise the cached entity has been purged.

For example, using the response headers above, pass the `X-Cache-Key` value of
`c9e1d4c8e5fd8209a5969eb3b0e85bc6` to the Admin API:

```sh
curl -i http://localhost:8001/proxy-cache/c9e1d4c8e5fd8209a5969eb3b0e85bc6
```

A response with `200 OK` will contain full details of the cached entity.

See the [Proxy Cache plugin documentation](/hub/kong-inc/proxy-cache/#admin-api) for the full list of the
Proxy Cache specific Admin API endpoints.
