---
redirect_to: /hub/kong-inc/proxy-cache/0.31-x.html

title: HTTP Proxy Caching
---
# HTTP Proxy Caching

## Synopsis
This plugin provides a reverse proxy cache implementation for Kong. It caches response entities based on configurable response code and content type, as well as request method. It can cache per-Consumer or per-API. Cache entities are stored for a configurable period of time, after which subsequent requests to the same resource will re-fetch and re-store the resource. Cache entities can also be forcefully purged via the Admin API prior to their expiration time.

## Configuration
Configuring the plugin is straightforward, you can add it on top of an existing API by executing the following request on your Kong server:

```
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=proxy-cache" \
    --data "config.strategy=memory"
```

`api`: The `id` or `name` of the API that this plugin configuration will target.

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint.

| Form Parameter | Default | Description
| -------------- | ------- | -----------
|`name` || The name of the plugin to use, in this case: proxy-cache
|`config.response_code`| `200`, `301`, `404` |	Upstream response status code considered cacheable.
|`config.request_method`|	`GET`, `HEAD` |	Downstream request methods considered cacheable.
|`config.content_type`|	`text/plain` | Upstream response content types considered cachable.
|`config.cache_ttl`|	`300` |	TTL, in seconds, of cache entities.
|`config.cache_control`| `false` | When enabled, respect the Cache-Control behaviors defined in RFC 7234.
|`config.storage_ttl`| | Number of seconds to keep resources in the storage backend. This value is independent of cache_ttl or resource TTLs defined by Cache-Control behaviors.
|`config.strategy`|	| The backing data store in which to hold cache entities.
|`config.memory.dictionary_name` |	`kong_cache` |	The name of the shared dictionary in which to hold cache entities when the memory strategy is selected. Note that this dictionary currently must be defined manually in the Kong Nginx template.
|`config.redis.host`(semi-optional)|	| Host to use for Redis connection when the redisstrategy is defined.
|`config.redis.port`(semi-optional)|	| Port to use for Redis connection when the redisstrategy is defined.
|`config.redis.timeout` (semi-optional)|	`2000`	Connection timeout to use for Redis connection when the redis strategy is defined.
|`config.redis.password` (semi-optional)|	|	Password to use for Redis connection when the redisstrategy is defined. If undefined, no AUTH commands are sent to Redis.
|`config.redis.database` (semi-optional)|	`0` |	Database to use for Redis connection when the redisstrategy is defined.
|`config.redis.sentinel_master`(semi-optional)| | Sentinel master to use for Redis connection when the redis strategy is defined. Defining this value implies using Redis Sentinel.
|`config.redis.sentinel_role`(semi-optional)|	|	Sentinel role to use for Redis connection when the redisstrategy is defined. Defining this value implies using Redis Sentinel.
|`config.redis.sentinel_addresses`(semi-optional)	| |	Sentinel addresses to use for Redis connection when the redis strategy is defined. Defining this value implies using Redis Sentinel.

## Notes
### Strategies

`kong-plugin-enterprise-proxy-cache` is designed to support storing proxy cache data in different backend formats. Currently the following strategies are provided:
- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_cache`, is also used by other plugins and elements of Kong to store unrelated database cache entities. Using this dictionary is an easy way to bootstrap the proxy-cache plugin, but it is not recommended for large-scale installations as significant usage will put pressure on other facets of Kong's database caching operations. It is recommended to define a separate `lua_shared_dict` via a custom Nginx template at this time.
- `redis`: Supports Redis and Redis Sentinel deployments.

### Cache Key

Kong keys each cache elements based on the request method, the full client request (e.g., the request path and query parameters), and the UUID of either the API or Consumer associated with the request. This also implies that caches are distinct between APIs and/or Consumers. Currently the cache key format is hard-coded and cannot be adjusted. Internally, cache keys are represented as a hexadecimal-encoded MD5 sum of the concatenation of the constituent parts. This is calculated as follows:

```
key = md5(UUID | method | request)
```

Where `method` is defined via the OpenResty `ngx.req.get_method()` call, and `request` is defined via the Nginx `$request` variable. Kong will return the cache key associated with a given request as the `X-Cache-Key` response header. It is also possible to precalculate the cache key for a given request as noted above.

### Cache Control

When the `cache_control` configuration option is enabled, Kong will respect request and response Cache-Control headers as defined by RFC7234, with a few exceptions:

- Cache revalidation is not yet supported, and so directives such as `proxy-revalidate` are ignored.
- Similarly, the behavior of `no-cache` is simplified to exclude the entity from being cached entirely.
- Secondary key calculation via `Vary` is not yet supported.

### Cache Status

Kong identifies the status of the request's proxy cache behavior via the `X-Cache-Status` header. There are several possible values for this header:

- `Miss`: The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request was proxied upstream.
- `Hit`: The request was satisfied and served from cache.
- `Refresh`: The resource was found in cache, but could not satisfy the request, due to Cache-Control behaviors or reaching its hard-coded cache_ttl threshold.
- `Bypass`: The request could not be satisfied from cache based on plugin configuration.

### Storage TTL

Kong can store resource entities in the storage engine longer than the prescribed `cache_ttl` or `Cache-Control` values indicate. This allows Kong to maintain a cached copy of a resource past its expiration. This allows clients capable of using `max-age` and `max-stale` headers to request stale copies of data if necessary.

### Upstream Outages

Due to an implementation in Kong's core request processing model, at this point the proxy-cache plugin cannot be used to serve stale cache data when an upstream is unreachable. To equip Kong to serve cache data in place of returning an error when an upstream is unreachable, we recommend defining a very large `storage_ttl` (on the order of hours or days) in order to keep stale data in the cache. In the event of an upstream outage, stale data can be considered "fresh" by increasing the `cache_ttl` plugin configuration value. By doing so, data that would have been previously considered stale is now served to the client, before Kong attempts to connect to a failed upstream service.

### Admin API

This plugin provides several endpoints to managed cache entities. These endpoints are assigned to the `proxy-cache` RBAC resource.

The following endpoints are provided on the Admin API to examine and purge cache entities:

### Retrieve a Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and another that searches all proxy-cache plugins data stores for the given cache key. Both endpoints have the same return value.

#### Endpoint

<div class="endpoint get">/proxy-cache/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache plugin
| `cache_id` | The cache entity key as reported by the X-Cache-Key response header

#### Endpoint

<div class="endpoint get">/proxy-cache/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | The cache entity key as reported by the X-Cache-Key response header

#### Response

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

#### Endpoint

<div class="endpoint delete">/proxy-cache/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache plugin
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header

#### Endpoint

<div class="endpoint delete">/proxy-cache/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | he cache entity key as reported by the `X-Cache-Key` response header

#### Response

If the cache entity exists

```
HTTP 204 No Content
```

If the entity with the given key does not exist

```
HTTP 400 Not Found
```

### Purge All Cache Entities
#### Endpoint

<div class="endpoint delete">/proxy-cache/</div>

#### Response

```
HTTP 204 No Content
```

Note that this endpoint purges all cache entities across all `proxy-cache` plugins.
