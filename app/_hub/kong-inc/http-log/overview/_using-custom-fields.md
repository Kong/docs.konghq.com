---
nav_title: Custom fields and headers
title: Custom fields and headers
---

## Custom headers

The log server that receives these messages might require extra headers, such as for authorization purposes.

{% if_plugin_version gte:3.0.x %}
```yaml
...
  - name: http-log
    config:
      headers:
        Authorization: "Bearer <token>"
...
```
{% endif_plugin_version %}
{% if_plugin_version lte:2.8.x %}
```yaml
...
  - name: http-log
    config:
      headers:
        Authorization: 
          - "Bearer <token>"
...
```
{% endif_plugin_version %}


## Custom fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
