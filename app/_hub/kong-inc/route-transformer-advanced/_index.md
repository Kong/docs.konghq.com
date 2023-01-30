---
name: Route Transformer Advanced
publisher: Kong Inc.
desc: 'Transform routing by changing the upstream server, port, or path'
description: |
  This plugin transforms the routing on the fly in Kong, changing the upstream server, port, or path to hit. The substitutions can be configured via flexible templates.
type: plugin
enterprise: true
categories:
  - transformations
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---

_NOTE_: The advanced label is only attached because this is an Enterprise-only
plugin. There is no corresponding community plugin version available.

## Synopsis

This plugin transforms the routing on the fly in Kong, changing the upstream server/port/path to hit. The substitutions can be configured via flexible templates.

## Template as value

The templates that can be used as values are the same as the [request-transformer](/hub/kong-inc/request-transformer-advanced/).

[badge-travis-url]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin-route-transformer-advanced.svg?token=BfzyBZDa3icGPsKGmBHb&branch=master
