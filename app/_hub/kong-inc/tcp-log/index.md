---
name: TCP Log
publisher: Kong Inc.
version: 2.1.x
desc: Send request and response logs to a TCP server
description: |
  Log request and response data to a TCP server.
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
      - 0.2.x
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
  name: tcp-log
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
      datatype: number
      description: An optional timeout in milliseconds when sending data to the upstream server.
    - name: keepalive
      required: false
      default: '`60000`'
      datatype: number
      description: An optional value in milliseconds that defines how long an idle connection lives before being closed.
    - name: tls
      required: true
      default: false
      datatype: boolean
      description: Indicates whether to perform a TLS handshake against the remote server.
    - name: tls_sni
      required: false
      default: null
      datatype: string
      description: An optional string that defines the SNI (Server Name Indication) hostname to send in the TLS handshake.
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
