---
name: File Log
publisher: Kong Inc.
desc: Append request and response data to a log file
description: |
  Append request and response data in JSON format to a log file. You can also specify
  streams (for example, `/dev/stdout` and `/dev/stderr`), which is especially useful
  when running Kong in Kubernetes.

  This plugin uses blocking I/O, which could affect performance when writing
  to physical files on slow (spinning) disks.
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

