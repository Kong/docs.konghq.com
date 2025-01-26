---
title: apply
---

The `deck gateway apply` commands will create or update entities in {{ site.base_gateway }} without deleting any existing configuration. `deck gateway apply` is useful when building your configuration incrementally.

```bash
echo '_format_version: "3.0"
services:
- name: example-service
  url: http://httpbin.konghq.com' | deck gateway apply
```

We recommend using `deck gateway dump` to backup the complete configuration once you have finished iterating on your configuration. This file can then be used with `deck gateway sync`

