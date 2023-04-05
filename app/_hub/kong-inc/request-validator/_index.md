---
name: Request Validator
publisher: Kong Inc.
desc: Validates requests before they reach the Upstream service
description: |
  Validate requests before they reach their Upstream service. Supports validating
  the schema of the body and the parameters of the request using either Kong's own
  schema validator (body only) or a JSON Schema Draft 4-compliant validator.
enterprise: true
plus: true
type: plugin
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
