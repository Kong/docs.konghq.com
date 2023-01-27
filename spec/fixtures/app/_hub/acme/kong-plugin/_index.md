---
name: Sample plugin
publisher: Acme
categories:
  - logging

type: plugin

desc: Logs Kong requests
description: |
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sollicitudin pharetra luctus.
  In laoreet, libero quis volutpat aliquet, massa leo aliquet eros, id malesuada orci urna sed purus.

kong_version_compatibility: # required
  community_edition:
    compatible:
      - 2.2.x
      - 2.1.x

params:
  name: kong-plugin
  service_id: false
  consumer_id: false
  route_id: false
  protocols: 
    - name: "http"
    - name: "https"
  dbless_compatible: yes

  config:
    - name: log_id
      required: 'no'
      default: 'default-log-id'
      datatype: string
      encrypted: yes
      minimum_version: "0.0.1"
      description: 'The log id'
---

## Usage
Installation:
```
luarocks install acme-kong-plugin
```

## Changelog

Empty for now
