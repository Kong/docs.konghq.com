---
id: page-plugin
title: Plugins - Request Size Limiting
header_title: Request Size Limiting
header_icon: /assets/images/icons/plugins/request-size-limiting.png
breadcrumbs:
  Plugins: /plugins

description: |
  <div class="alert alert-warning">
    For security reasons we suggest enabling this plugin for any API you add to Kong to prevent a DOS (Denial of Service) attack.
  </div>
  
  Block incoming requests whose body is greater than a specific size in megabytes.

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
