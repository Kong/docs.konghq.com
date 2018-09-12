---
name: Request Size Limiting

desc: Block requests with bodies greater than a specified size
description: |
  <div class="alert alert-warning">
    For security reasons we suggest enabling this plugin for any API you add to Kong to prevent a DOS (Denial of Service) attack.
  </div>

  Block incoming requests whose body is greater than a specific size in megabytes.

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
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
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: request-size-limiting
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: allowed_payload_size
      required: true
      default: "`128`"
      value_in_examples: 128
      description: Allowed request payload size in megabytes, default is `128` (128000000 Bytes)

---
