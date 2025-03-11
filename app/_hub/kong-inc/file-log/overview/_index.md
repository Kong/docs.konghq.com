---
nav_title: Overview
---

Append request and response data in JSON format to a log file. You can also specify
streams (for example, `/dev/stdout` and `/dev/stderr`), which is especially useful
when running Kong in Kubernetes.

This plugin uses blocking I/O, which could affect performance when writing
to physical files on slow (spinning) disks.

{:.important}
> Log interleaving can occur when logging to stdout. This happens because data
> written through a pipe must fit within the pipe buffer, which is typically 4k
> as defined by the Linux kernel. If the data exceeds this size, the kernel cannot
> guarantee the atomicity of the `write()` system call, leading to interleaved logs. 

## Log format

{% include /md/plugins-hub/log-format.md %}

### Log format definitions 

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

