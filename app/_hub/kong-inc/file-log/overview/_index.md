---
nav_title: Overview
---

Append request and response data in JSON format to a log file. You can also specify
streams (for example, `/dev/stdout` and `/dev/stderr`), which is especially useful
when running Kong in Kubernetes.

This plugin uses blocking I/O, which could affect performance when writing
to physical files on slow (spinning) disks.

## Log format

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

