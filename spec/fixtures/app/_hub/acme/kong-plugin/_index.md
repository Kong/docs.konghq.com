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
---

## Usage
Installation:
```
luarocks install acme-kong-plugin
```
