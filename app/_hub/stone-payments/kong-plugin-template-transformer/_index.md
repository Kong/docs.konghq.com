---
name: Template Transformer
publisher: stone-payments
categories:
  - transformations
type: plugin
desc: Kong middleware to transform requests / responses, using pre-configured templates.
description: |
    This is Kong plugins that accepts requests and response templates to completely transform requests and responses with Lua templates.
support_url: https://github.com/stone-payments/kong-plugin-template-transformer/issues
source_code:  https://github.com/stone-payments/kong-plugin-template-transformer
license_type: Apache-2.0
license_url: https://github.com/stone-payments/kong-plugin-template-transformer/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
     - 0.13.x
     - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.32-x
      - 0.33-x
    incompatible:

---
