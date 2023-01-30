---
name: TCP Log
publisher: Kong Inc.
desc: Send request and response logs to a TCP server
description: |
  Log request and response data to a TCP server.
type: plugin
categories:
  - logging
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Log format

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

{% if_plugin_version gte:2.4.x %}
## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
{% endif_plugin_version %}

---

