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
params:
  name: request-size-limiting
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:
    - name: allowed_payload_size
      required: true
      default: '`128`'
      datatype: integer
      value_in_examples: 128
      description: Allowed request payload size in megabytes. Default is `128` megabytes (128000000 bytes).
    - name: size_unit
      required: true
      default: '`megabytes`'
      datatype: string
      description: 'Size unit can be set either in `bytes`, `kilobytes`, or `megabytes` (default). This configuration is not available in versions prior to Kong Gateway 1.3 and Kong Gateway (OSS) 2.0.'
    - name: require_content_length
      minimum_version: "2.3.x"
      required: true
      default: false
      datatype: boolean
      value_in_examples: false
      description: Set to `true` to ensure a valid `Content-Length` header exists before reading the request body.
---

## Changelog
* Added the `require_content_length` configuration option.
