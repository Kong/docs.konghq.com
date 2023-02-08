---
name: TLS Handshake Modifier
publisher: Kong Inc.

desc: Requests a client to present its client certificate
description: |
  The plugin requests, but does not require the client certificate. No validation
  of the client certificate is performed. If a client certificate exists,
  the plugin makes the certificate available to other plugins acting on this request.  

  This plugin must be used in conjunction with the TLS Metadata Headers plugin.

enterprise: true
plus: false
cloud: true
type: plugin
categories:
  - security
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
