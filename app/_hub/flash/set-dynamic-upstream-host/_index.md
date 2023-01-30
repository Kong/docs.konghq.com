---
name: Set Dynamic Upstream Host
publisher: Flash
version: 1.0.0

desc: Constructs the upstream hostname dynamically based on the incoming request parameters
description: |
  This plugin can dynamically construct the upstream hostname and 
  port number based on the key identifier passed in the incoming request. If the same 
  upstream API is deployed in different servers or data centers, then this plugin can 
  form the hostname for the upstream API dynamically to route it to a particular 
  server or data center without making any changes in Kong Route or Service 
  configuration.
  
  
support_url: https://github.com/anup-krai/kong-plugin-set-dynamic-target-host/issues
source_code: https://github.com/anup-krai/kong-plugin-set-dynamic-target-host
license_type: Apache-2.0 

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.5.x
        - 2.4.x
---
