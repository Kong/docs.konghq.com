---
name: Proxy Cache
publisher: Kong Inc.
desc: Cache and serve commonly requested responses in Kong
description: |
  This plugin provides a reverse proxy cache implementation for Kong. It caches response entities based on configurable response code and content type, as well as request method. It can cache per-Consumer or per-API. Cache entities are stored for a configurable period of time, after which subsequent requests to the same resource will re-fetch and re-store the resource. Cache entities can also be forcefully purged via the Admin API prior to their expiration time.
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
