---
name: File Log
publisher: Kong Inc.
version: 2.1.x
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
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.4.x
      - 0.3.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
params:
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
      required: false
      default: null
      datatype: map
      description: |
        A list of key-value pairs, where the key is the name of a log field and
        the value is a chunk of Lua code, whose return value sets or replaces
        the log field value.
---

## Log format

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
