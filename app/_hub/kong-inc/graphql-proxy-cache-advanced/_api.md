---
nav_title: GraphQL Cache API reference
---

## Managing cache entities

The GraphQL Proxy Cache Advanced plugin exposes several endpoints for cache management. 
They are available through the Kong Admin API.

To configure and enable the plugin itself, [use the `/plugins` API endpoint](/hub/kong-inc/graphql-proxy-cache-advanced/how-to/basic-example/).
The `/graphql-proxy-cache-advanced` endpoints only appear once the plugin has been enabled. 

### Retrieve a cache entity

Two endpoints are available: one to look up a known plugin instance, and another that searches all
`graphql-proxy-cache-advanced` plugins data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint get">/graphql-proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the `graphql-proxy-cache-advanced` plugin.
| `cache_id` | The cache entity key as reported by the `X-Cache-Key` response header.

**Endpoint**

<div class="endpoint get">/graphql-proxy-cache-advanced/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header.

**Response**

If the cache entity exists:

```
HTTP 200 OK
```

If the entity with the given key does not exist:

```
HTTP 400 Not Found
```

### Delete cache entity

Two endpoints are available: one to look up a known plugin instance, and another that searches all `graphql-proxy-cache-advanced`
plugins' data stores for the given cache key. Both endpoints have the same return value.

**Endpoint**

<div class="endpoint delete">/graphql-proxy-cache-advanced/:plugin_id/caches/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`plugin_id` | The UUID of the `graphql-proxy-cache-advanced` plugin.
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header.

**Endpoint**

<div class="endpoint delete">/graphql-proxy-cache-advanced/:cache_id</div>

| Attributes | Description
| -------------- | -------
|`cache_id` | The cache entity key as reported by the `X-Cache-Key` response header.

**Response**

If the cache entity exists:

```
HTTP 204 No Content
```

If the entity with the given key does not exist:

```
HTTP 400 Not Found
```

### Purge all cache entities

This endpoint purges all cache entities across **all** `graphql-proxy-cache-advanced` plugin instances.

**Endpoint**

<div class="endpoint delete">/graphql-proxy-cache-advanced/</div>

**Response**

```
HTTP 204 No Content
```

