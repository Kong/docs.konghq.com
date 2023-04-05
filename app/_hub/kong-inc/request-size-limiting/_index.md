---
name: Request Size Limiting
publisher: Kong Inc.
desc: Block requests with bodies greater than a specified size
description: |
  Block incoming requests where the body is greater than a specific size in megabytes.

  {:.important}
  > For security reasons, we suggest enabling this plugin for any service you add
  to Kong Gateway to prevent a DOS (Denial of Service) attack.

type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
