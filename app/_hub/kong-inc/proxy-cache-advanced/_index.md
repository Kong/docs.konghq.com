---
name: Proxy Caching Advanced
publisher: Kong Inc.
version: 0.5.x
desc: Cache and serve commonly requested responses in Kong
description: |
  This plugin provides a reverse proxy cache implementation for Kong. It caches
  response entities based on configurable response code and content type, as well
  as request method. It can cache per-Consumer or per-API. Cache entities are stored
  for a configurable period of time, after which subsequent requests to the same
  resource will re-fetch and re-store the resource. Cache entities can also be
  forcefully purged via the Admin API prior to their expiration time.
type: plugin
enterprise: true
plus: true
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
params:
  name: proxy-cache-advanced
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - http
    - https
    - grpc
    - grpcs
  dbless_compatible: 'yes'
  config:
    - name: response_code
      required: true
      default: '200, 301, 404'
      value_in_examples:
        - '200'
      datatype: array of type integer
      description: |
        Upstream response status code considered cacheable. The integers must be a value
        between 100 and 900.
    - name: request_method
      required: true
      default: '`["GET","HEAD"]`'
      value_in_examples:
        - GET
        - HEAD
      datatype: array of string elements
      description: |
        Downstream request methods considered cacheable. Available options: `HEAD`, `GET`, `POST`, `PATCH`, `PUT`.
    - name: content_type
      required: true
      default: 'text/plain, application/json'
      value_in_examples:
        - text/plain
        - application/json
      datatype: array of string elements
      description: |
        Upstream response content types considered cacheable. The plugin performs an **exact match** against each specified value; for example, if the upstream is expected to respond with a `application/json; charset=utf-8` content-type, the plugin configuration must contain said value or a `Bypass` cache status is returned.
    - name: vary_headers
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Relevant headers considered for the cache key. If undefined, none of the headers are taken into consideration.
    - name: vary_query_params
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Relevant query parameters considered for the cache key. If undefined, all params are taken into consideration.
    - name: cache_ttl
      required: null
      default: 300
      value_in_examples: null
      datatype: integer
      description: |
        TTL in seconds of cache entities.
    - name: cache_control
      required: true
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        When enabled, respect the Cache-Control behaviors defined in [RFC7234](https://tools.ietf.org/html/rfc7234#section-5.2).
    - name: storage_ttl
      required: false
      default: null
      value_in_examples: null
      datatype: integer
      description: |
        Number of seconds to keep resources in the storage backend. This value is independent
        of `cache_ttl` or resource TTLs defined by Cache-Control behaviors.
    - name: strategy
      required: true
      default: null
      value_in_examples: memory
      datatype: string
      description: |
        The backing data store in which to hold cache entities. Accepted values are: `memory` and `redis`.
    - name: memory.dictionary_name
      required: true
      default: kong_db_cache
      value_in_examples: null
      datatype: string
      description: |
        The name of the shared dictionary in which to hold cache entities when the memory strategy is selected. Note that this dictionary currently must be defined manually in the Kong Nginx template.
    - name: redis.host
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Host to use for Redis connection when the redis strategy is defined.
    - name: redis.port
      required: semi
      default: 6379
      value_in_examples: null
      datatype: integer
      description: |
        Port to use for Redis connections when the `redis` strategy is defined. Must be a
        value between 0 and 65535. Default: 6379.
    - name: redis.ssl
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        If set to `true`, then uses SSL to connect to Redis.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.ssl_verify
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        If set to `true`, then verifies the validity of the server SSL certificate. Note that you need to configure the
        [lua_ssl_trusted_certificate](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate)
        to specify the CA (or server) certificate used by your Redis server. You may also need to configure
        [lua_ssl_verify_depth](/gateway/latest/reference/configuration/#lua_ssl_verify_depth) accordingly.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.server_name
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Specifies the server name for the new TLS extension Server Name Indication (SNI) when connecting over SSL.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.timeout
      required: semi
      default: 2000
      value_in_examples: null
      datatype: number
      description: |
        Connection timeout to use for Redis connection when the `redis` strategy is defined.
    - name: redis.password
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Password to use for Redis connection when the `redis` strategy is defined.
        If undefined, no AUTH commands are sent to Redis.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.database
      required: semi
      default: 0
      value_in_examples: null
      datatype: integer
      description: |
        Database to use for Redis connection when the `redis` strategy is defined.
    - name: redis.sentinel_master
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel master to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
    - name: redis.sentinel_username
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel username to authenticate with a Redis Sentinel instance.
        If undefined, ACL authentication will not be performed. This requires Redis v6.2.0+.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.sentinel_password
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel password to authenticate with a Redis Sentinel instance.
        If undefined, no AUTH commands are sent to Redis Sentinels.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.sentinel_role
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel role to use for Redis connections when the `redis` strategy is defined. Defining this value
        implies using Redis Sentinel. Available options:  `master`, `slave`, `any`.
    - name: redis.sentinel_addresses
      required: semi
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Sentinel addresses to use for Redis connections when the `redis` strategy is defined.
        Defining this value implies using Redis Sentinel. Each string element must
        be a hostname. The minimum length of the array is 1 element.
    - name: redis.cluster_addresses
      required: semi
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Cluster addresses to use for Redis connection when the `redis` strategy is defined.
        Defining this value implies using Redis cluster. Each string element must
        be a hostname. The minimum length of the array is 1 element.
    - name: redis.keepalive_backlog
      required: false
      default: null
      value_in_examples: null
      datatype: integer
      description: |
        If specified, limits the total number of opened connections for a pool. If the 
        connection pool is full, all connection queues beyond the maximum limit go into 
        the backlog queue. Once the backlog queue is full, subsequent connect operations 
        will fail and return `nil`. Queued connect operations resume once the number of 
        connections in the pool is less than `keepalive_pool_size`. Note that queued 
        connect operations are subject to set timeouts.
    - name: redis.keepalive_pool
      required: false
      default: generated from string template
      value_in_examples: null
      datatype: string
      description: |
        The custom name of the connection pool. If not specified, the connection pool
        name is generated from the string template `"<host>:<port>"` or `"<unix-socket-path>"`.
    - name: redis.keepalive_pool_size
      required: false
      default: 30
      value_in_examples: null
      datatype: integer
      description: |
        The size limit for every cosocket connection pool associated with every remote
        server, per worker process. If no `keepalive_pool_size` is specified and no `keepalive_backlog`
        is specified, no pool is created. If no `keepalive_pool_size` is specified and `keepalive_backlog`
        is specified, then the pool uses the default value `30`.
    - name: bypass_on_err
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        Unhandled errors while trying to retrieve a cache entry (such as redis down) are resolved with `Bypass`, with the request going upstream.
  extra: |

    <div class="alert alert-ee red">
    <strong>Warning:</strong> The <code>content_type</code> parameter requires
    an exact match. For example, if your Upstream expects
    <code>application/json; charset=utf-8</code> and the
    <code>config.content_type</code> value is only <code>application/json</code>
    (a partial match), then the proxy cache is bypassed.
    </div>
---
### Strategies

`kong-plugin-enterprise-proxy-cache` is designed to support storing proxy cache data in different backend formats.
Currently, the following strategies are provided:

- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also
used by other plugins and elements of Kong to store unrelated database cache entities.
Using this dictionary is an easy way to bootstrap the proxy-cache-advanced plugin, but it
is not recommended for large-scale installations as significant usage will put pressure on
other facets of Kong's database caching operations. It is recommended to define a separate `lua_shared_dict`
via a custom Nginx template at this time.
- `redis`: Supports Redis and Redis Sentinel deployments.

### Cache Key

Kong keys each cache elements based on the request method, the full client request
(e.g., the request path and query parameters), and the UUID of either the API or Consumer
associated with the request. This also implies that caches are distinct between APIs and/or Consumers.
Currently the cache key format is hard-coded and cannot be adjusted. Internally, cache keys are
represented as a hexadecimal-encoded MD5 sum of the concatenation of the constituent parts calculated as follows:

```
key = md5(UUID | method | request)
```

Where `method` is defined via the OpenResty `ngx.req.get_method()` call, and `request` is defined via the Nginx `$request` variable.
Kong will return the cache key associated with a given request as the `X-Cache-Key` response header.
It is also possible to precalculate the cache key for a given request as noted above.

### Cache Control

When the `cache_control` configuration option is enabled, Kong will respect request and response
Cache-Control headers as defined by [RFC7234](https://tools.ietf.org/html/rfc7234#section-5.2), with a few exceptions:

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

Kong can store resource entities in the storage engine longer than the prescribed `cache_ttl` or `Cache-Control` values indicate.
This allows Kong to maintain a cached copy of a resource past its expiration, which in turn allows clients capable
of using `max-age` and `max-stale` headers to request stale copies of data if necessary.

### Upstream Outages

Due to an implementation in Kong's core request processing model, at this point,
the proxy-cache-advanced plugin cannot be used to serve stale cache data when an upstream is unreachable.
To equip Kong to serve cache data in place of returning an error when an upstream is unreachable,
we recommend defining a very large `storage_ttl` (on the order of hours or days) in order to keep stale data
in the cache. In the event of an upstream outage, stale data can be considered fresh
by increasing the `cache_ttl` plugin configuration value. By doing so, data that
would have previously been considered stale is now served to the client, before Kong attempts to connect to a failed upstream service.

### Admin API

This plugin provides several endpoints to managed cache entities. These endpoints are assigned to the `proxy-cache-advanced` RBAC resource.

The following endpoints are provided on the Admin API to examine and purge cache entities:

#### Retrieve a Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and
another that searches all proxy-cache-advanced plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint get">/proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache-advanced plugin
| `cache_id` | The cache entity key as reported by the X-Cache-Key response header

**Endpoint**

<div class="endpoint get">/proxy-cache-advanced/:cache_id</div>

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

#### Delete a Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and
another that searches all proxy-cache-advanced plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint delete">/proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the proxy-cache-advanced plugin
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header

**Endpoint**

<div class="endpoint delete">/proxy-cache-advanced/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | he cache entity key as reported by the `X-Cache-Key` response header

**Response**

If the cache entity exists:

```
HTTP 204 No Content
```

If the entity with the given key does not exist:

```
HTTP 400 Not Found
```

#### Purge All Cache Entities

**Endpoint**

<div class="endpoint delete">/proxy-cache-advanced/</div>

**Response**

```
HTTP 204 No Content
```

Note that this endpoint purges all cache entities across all `proxy-cache-advanced` plugins.

---

## Changelog

### Kong Gateway 2.8.x (plugin version 0.5.7)

* Added the `redis.sentinel_username` and `redis.sentinel_password` configuration
parameters.

* The `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be
securely stored as [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `1.3-x` and `2.2.x`. They are now updated to align with the
plugin's actual versions, `0.4.x` and `0.5.x`.
