---
name: Request Size Limiting
publisher: Kong Inc.
version: 2.0.0
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
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.4.x
      - 0.3.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
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
      required: true
      default: false
      datatype: boolean
      value_in_examples: false
      description: Set to `true` to ensure a valid `Content-Length` header exists before reading the request body.
---

