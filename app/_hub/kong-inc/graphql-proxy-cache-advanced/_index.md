---
name: GraphQL Proxy Caching Advanced
publisher: Kong Inc.
version: 1.3-x
desc: Cache and serve commonly requested responses in Kong
description: |
  This plugin provides a reverse GraphQL proxy cache implementation for Kong. It caches response entities based on
  configuration. It can cache by GraphQL query or vary headers. Cache entities are stored for a configurable period of
  time, after which subsequent requests to the same resource will re-fetch and re-store the resource. Cache entities
  can also be forcefully purged via the Admin API prior to their expiration time.
type: plugin
enterprise: true
plus: true
categories:
  - traffic-control
kong_version_compatibility:
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
  name: graphql-proxy-cache-advanced
  service_id: true
  route_id: true
  dbless_compatible: 'yes'
  config:
    - name: vary_headers
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Relevant headers considered for the cache key. If undefined, none of the headers are taken into consideration.
    - name: cache_ttl
      required: null
      default: 300
      value_in_examples: null
      datatype: integer
      description: |
        TTL in seconds of cache entities. Must be a value greater than 0.
    - name: strategy
      required: true
      default: memory
      value_in_examples: memory
      datatype: string
      description: |
        The backing data store in which to hold cached entities. Accepted value is `memory`.
    - name: memory.dictionary_name
      required: true
      default: kong_db_cache
      value_in_examples: null
      datatype: string
      description: |
        The name of the shared dictionary in which to hold cache entities when the memory strategy is selected. Note
        that this dictionary currently must be defined manually in the Kong Nginx template.
---
### Strategies

GraphQL Proxy Caching Advanced Plugin  is designed to support storing GraphQL proxy cache data in different backend formats.
Currently the following strategies are provided:
- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also used by other plugins and
elements of Kong to store unrelated database cache entities. Using this dictionary is an easy way to bootstrap the
graphql-proxy-cache-advanced plugin, but it is not recommended for large-scale installations as significant usage will put pressure
on other facets of Kong's database caching operations. It is recommended to define a separate `lua_shared_dict` via a
custom Nginx template at this time.

### Cache Key

Kong keys each cache elements based on the GraphQL query that is being send
in the HTTP request body. Internally, cache keys are represented as a
hexadecimal-encoded MD5 sum of the concatenation of the constituent parts.

```
key = md5(UUID | headers | body)
```

Where `headers` contains the headers defined in vary_headers. `vary_headers` defaults to NONE.

Kong will return the cache key associated with a given request as the
`X-Cache-Key` response header.


### Cache Status

Kong identifies the status of the request's proxy cache behavior via the `X-Cache-Status` header. There are several
possible values for this header:

* `Miss`: The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request
was proxied upstream.
* `Hit`: The request was satisfied and served from cache.
* `Refresh`: The resource was found in cache, but could not satisfy the request, due to `Cache-Control` behaviors or
reaching its hard-coded `cache_ttl` threshold.
* `Bypass`: The request could not be satisfied from cache based on plugin configuration.

### Admin API

This plugin provides several endpoints to managed cache entities. These endpoints are assigned to the `graphql-proxy-cache-advanced`
resource.

The following endpoints are provided on the Admin API to examine and purge cache entities:

### Retrieve a Cache Entity

Two separate endpoints are available: one to look up a known plugin instance, and another that searches all
graphql-proxy-cache-advanced plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint get">/graphql-proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the graphql-proxy-cache-advanced plugin
| `cache_id` | The cache entity key as reported by the X-Cache-Key response header

**Endpoint**

<div class="endpoint get">/graphql-proxy-cache-advanced/:cache_id</div>

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

Two separate endpoints are available: one to look up a known plugin instance, and another that searches all graphql-proxy-cache-advanced
plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint delete">/graphql-proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the graphql-proxy-cache-advanced plugin
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header

**Endpoint**

<div class="endpoint delete">/graphql-proxy-cache-advanced/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | he cache entity key as reported by the `X-Cache-Key` response header

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

<div class="endpoint delete">/graphql-proxy-cache-advanced/</div>

**Response**

```
HTTP 204 No Content
```

Note that this endpoint purges all cache entities across all `graphql-proxy-cache-advanced` plugins.
