---
nav_title: Overview
---

This plugin provides a reverse GraphQL proxy cache implementation for {{site.base_gateway}}. 
It caches response entities based on configuration. It can cache by GraphQL query or Vary headers. 

Cache entities are stored for a configurable period of time, after which subsequent requests to the 
same resource will re-fetch and re-store the resource. 
Cache entities can also be forcefully purged via the Admin API prior to their expiration time.

Kong also provides a [GraphQL Rate Limiting Advanced plugin](/hub/kong-inc/graphql-rate-limiting-advanced/).

## Strategies

The GraphQL Proxy Caching Advanced Plugin is designed to support storing GraphQL proxy cache data in different backend formats.
Currently the following strategies are provided:
- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also used by other plugins and
elements of Kong to store unrelated database cache entities. Using this dictionary is an easy way to bootstrap the
graphql-proxy-cache-advanced plugin, but it is not recommended for large-scale installations as significant usage will put pressure
on other facets of Kong's database caching operations. It is recommended to define a separate `lua_shared_dict` via a
custom Nginx template at this time.

## Cache Key

Kong keys each cache elements based on the GraphQL query that is being send
in the HTTP request body. Internally, cache keys are represented as a
hexadecimal-encoded MD5 sum of the concatenation of the constituent parts.

```
key = md5(UUID | headers | body)
```

Where `headers` contains the headers defined in vary_headers. `vary_headers` defaults to NONE.

Kong will return the cache key associated with a given request as the
`X-Cache-Key` response header.

## Cache Status

Kong identifies the status of the request's proxy cache behavior via the `X-Cache-Status` header. There are several
possible values for this header:

* `Miss`: The request could be satisfied in cache, but an entry for the resource was not found in cache, and the request
was proxied upstream.
* `Hit`: The request was satisfied and served from cache.
* `Refresh`: The resource was found in cache, but could not satisfy the request, due to `Cache-Control` behaviors or
reaching its hard-coded `cache_ttl` threshold.
* `Bypass`: The request could not be satisfied from cache based on plugin configuration.


## Get started with the GraphQL Proxy Cache Advanced plugin

* [Configuration reference](/hub/kong-inc/graphql-proxy-cache-advanced/configuration/)
* [Basic configuration example](/hub/kong-inc/graphql-proxy-cache-advanced/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/graphql-proxy-cache-advanced/how-to/)
* [GraphQL Cache API reference](/hub/kong-inc/graphql-proxy-cache-advanced/api/)
