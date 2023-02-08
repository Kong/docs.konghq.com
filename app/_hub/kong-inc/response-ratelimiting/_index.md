---
name: Response Rate Limiting
publisher: Kong Inc.
version: 2.0.x
desc: Rate-limiting based on a custom response header value
description: |
  This plugin allows you to limit the number of requests a developer can make
  based on a custom response header returned by the upstream service. You can
  arbitrarily set as many rate-limiting objects (or quotas) as you want and
  instruct Kong to increase or decrease them by any number of units. Each custom
  rate-limiting object can limit the inbound requests per seconds, minutes, hours,
  days, months, or years.

  If the underlying Service/Route has no authentication
  layer, the **Client IP** address will be used; otherwise, the Consumer will be
  used if an authentication plugin has been configured.
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
