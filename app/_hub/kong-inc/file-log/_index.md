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
  name: file-log
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - http
    - https
    - grpc
    - grpcs
    - tcp
    - tls
    - udp
  dbless_compatible: 'yes'
  config:
    - name: path
      required: true
      default: null
      value_in_examples: /tmp/file.log
      datatype: string
      description: |
        The file path of the output log file. The plugin creates the log file if it doesn't exist yet. Make sure Kong has write permissions to this file.
    - name: reopen
      required: true
      default: '`false`'
      datatype: boolean
      description: |
        Determines whether the log file is closed and reopened on every request. If the file
        is not reopened, and has been removed/rotated, the plugin keeps writing to the
        stale file descriptor, and hence loses information.
    - name: custom_fields_by_lua
      minimum_version: "2.4.x"
      required: false
      default: null
      datatype: map
      description: |
        A list of key-value pairs, where the key is the name of a log field and
        the value is a chunk of Lua code, whose return value sets or replaces
        the log field value. Requires Kong 2.4.x or above.
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
## Changelog

**{{site.base_gateway}} 2.4.x**

* Added `custom_fields_by_lua` configuration option.
