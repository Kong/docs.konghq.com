---
name: Rate Limiting
publisher: Kong Inc.
desc: Rate-limit how many HTTP requests can be made in a period of time
description: |
  Rate limit how many HTTP requests can be made in a given period of seconds, minutes, hours, days, months, or years.
  If the underlying Service/Route (or deprecated API entity) has no authentication layer,
  the **Client IP** address will be used; otherwise, the Consumer will be used if an
  authentication plugin has been configured.

  **Tip:** The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
    plugin provides the ability to apply
    [multiple limits in sliding or fixed windows](/hub/kong-inc/rate-limiting-advanced/#multi-limits-windows).
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
