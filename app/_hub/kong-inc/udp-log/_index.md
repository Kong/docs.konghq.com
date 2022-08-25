---
name: UDP Log
publisher: Kong Inc.
desc: Send request and response logs to a UDP server
description: |
  Log request and response data to an UDP server.
type: plugin
categories:
  - logging
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: udp-log
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - http
    - https
    - tcp
    - tls
    - tls_passthrough
    - udp
    - grpc
    - grpcs
  dbless_compatible: 'yes'
  config:
    - name: host
      required: true
      value_in_examples: 127.0.0.1
      datatype: string
      description: The IP address or host name to send data to.
    - name: port
      required: true
      value_in_examples: 9999
      datatype: integer
      description: The port to send data to on the upstream server.
    - name: timeout
      required: false
      default: '`10000`'
      value_in_examples: 10000
      datatype: number
      description: An optional timeout in milliseconds when sending data to the upstream server.
    - name: custom_fields_by_lua
      minimum_version: "2.4.x"
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

{% if_plugin_version gte:2.4.x %}
## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
{% endif_plugin_version %}

---
## Changelog

**{{site.base_gateway}} 2.4.x**

* Added `custom_fields_by_lua` configuration option.
