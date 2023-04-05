---
name: HMAC Authentication
publisher: Kong Inc.
desc: Add HMAC Authentication to your Services
description: |
  Add HMAC Signature authentication to a Service or a Route
  to establish the integrity of incoming requests. The plugin validates the
  digital signature sent in the `Proxy-Authorization` or `Authorization` header
  (in that order). This plugin implementation is based off the
  [draft-cavage-http-signatures](https://tools.ietf.org/html/draft-cavage-http-signatures)
  draft with a slightly different signature scheme.
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
