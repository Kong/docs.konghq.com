---
nav_title: Overview
---

The Proxy Cache plugin provides a reverse proxy cache implementation for {{site.base_gateway}}. 
It caches response entities based on configurable response code and 
content type, as well as request method. It can cache per-consumer or per-service. 

Cache entities are stored for a configurable period of time, after which subsequent requests to the same 
resource will fetch and store the resource again. 
Cache entities can also be forcefully purged via the Admin API prior to their expiration time.

There is also an advanced version of this plugin, available with an Enterprise subscription. 
The [Proxy Cache Advanced plugin](/hub/kong-inc/proxy-cache-advanced/) extends the open-source 
Proxy Cache plugin with Redis and Redis Sentinel support.

## Strategies

`kong-plugin-proxy-cache` is designed to support storing proxy cache data in different backend formats. Currently the following strategies are provided:
- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also used by other plugins and elements of Kong to store unrelated database cache entities. Using this dictionary is an easy way to bootstrap the proxy-cache plugin, but it is not recommended for large-scale installations as significant usage will put pressure on other facets of Kong's database caching operations. It is recommended to define a separate `lua_shared_dict` via a custom Nginx template at this time.

## Cache Key

{% if_version lte:3.0.x %}
Kong keys each cache elements based on the request method, the full client request (e.g., the request path and query parameters), and the UUID of either the API or Consumer associated with the request. This also implies that caches are distinct between APIs and/or Consumers. Currently the cache key format is hard-coded and cannot be adjusted. Internally, cache keys are represented as a hexadecimal-encoded MD5 sum of the concatenation of the constituent parts. This is calculated as follows:

```
key = md5(UUID | method | request)
```

Where `method` is defined via the OpenResty `ngx.req.get_method()` call, and `request` is defined via the Nginx `$request` variable. Kong will return the cache key associated with a given request as the `X-Cache-Key` response header. It is also possible to precalculate the cache key for a given request as noted above.
{% endif_version %}

{% if_version gte:3.1.x %}
Kong keys each cache elements based on the request method, the full client request (e.g., the request path and query parameters), and the UUID of either the API or Consumer associated with the request. This also implies that caches are distinct between APIs and/or Consumers. Currently the cache key format is hard-coded and cannot be adjusted. Internally, cache keys are represented as a hexadecimal-encoded SHA256 sum of the concatenation of the constituent parts. This is calculated as follows:

```
key = sha256(UUID | method | request | query_params | headers)
```

Where `method`, `query_params ` and `headers` are defined via the OpenResty `ngx.req.get_method()`, `ngx.req.get_uri_args()` and `ngx.req.get_headers()` call respectively, and `request` is defined via the Nginx `$request` variable. Kong will return the cache key associated with a given request as the `X-Cache-Key` response header. It is also possible to precalculate the cache key for a given request as noted above.
{% endif_version %}

## Cache Control

When the `cache_control` configuration option is enabled, Kong will respect request and response Cache-Control headers as defined by [RFC7234](https://tools.ietf.org/html/rfc7234#section-5.2), with a few exceptions:

- Cache revalidation is not yet supported, and so directives such as `proxy-revalidate` are ignored.
- Similarly, the behavior of `no-cache` is simplified to exclude the entity from being cached entirely.
- Secondary key calculation via `Vary` is not yet supported.

## Cache Status

Kong identifies the status of the request's proxy cache behavior via the `X-Cache-Status` header. There are several possible values for this header:

- `Miss`: The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.
- `Hit`: The request was satisfied and served from cache.
- `Refresh`: The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded `cache_ttl` threshold.
- `Bypass`: The request could not be satisfied from cache based on plugin configuration.

## Storage TTL

Kong can store resource entities in the storage engine longer than the prescribed `cache_ttl` or `Cache-Control` values indicate. This allows Kong to maintain a cached copy of a resource past its expiration. This allows clients capable of using `max-age` and `max-stale` headers to request stale copies of data if necessary.

## Upstream Outages

Due to an implementation in Kong's core request processing model, at this point the proxy-cache plugin cannot be used to serve stale cache data when an upstream is unreachable. To equip Kong to serve cache data in place of returning an error when an upstream is unreachable, we recommend defining a very large `storage_ttl` (on the order of hours or days) in order to keep stale data in the cache. In the event of an upstream outage, stale data can be considered "fresh" by increasing the `cache_ttl` plugin configuration value. By doing so, data that would have been previously considered stale is now served to the client, before Kong attempts to connect to a failed upstream service.

## Admin API

This plugin provides several endpoints to managed cache entities. These endpoints are assigned to the `proxy-cache` RBAC resource.

The following endpoints are provided on the Admin API to examine and purge cache entities:

### Retrieve a Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and another that searches all proxy-cache plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint get">/proxy-cache/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache plugin
| `cache_id` | The cache entity key as reported by the X-Cache-Key response header

**Endpoint**

<div class="endpoint get">/proxy-cache/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | The cache entity key as reported by the X-Cache-Key response header

**Response**

If the cache entity exists

```
HTTP 200 OK
```

If the entity with the given key does not exist

```
HTTP 400 Not Found
```

### Delete Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and another that searches all proxy-cache plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint delete">/proxy-cache/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache plugin
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header

**Endpoint**

<div class="endpoint delete">/proxy-cache/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header

**Response**

If the cache entity exists

```
HTTP 204 No Content
```

If the entity with the given key does not exist

```
HTTP 400 Not Found
```

### Purge All Cache Entities
**Endpoint**

<div class="endpoint delete">/proxy-cache/</div>

**Response**

```
HTTP 204 No Content
```

Note that this endpoint purges all cache entities across all `proxy-cache` plugins.
