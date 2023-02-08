---
name: GraphQL Proxy Caching Advanced
publisher: Kong Inc.
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
    compatible: true
---
