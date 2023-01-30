---
name: Request Size Limiting
publisher: Kong Inc.
desc: Block requests with bodies greater than a specified size
description: |
  <div class="alert alert-warning">
    For security reasons, we suggest enabling this plugin for any Service you add
    to Kong Gateway to prevent a DOS (Denial of Service) attack.
  </div>

  Block incoming requests whose body is greater than a specific size in megabytes.
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

