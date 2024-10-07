---
name: HTTP Log
publisher: Kong Inc.
version: 2.1.x
desc: Send request and response logs to an HTTP server
description: |
  Send request and response logs to an HTTP server.
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
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
params:
  name: http-log
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
    - name: http_endpoint
      required: true
      default: null
      value_in_examples: 'http://mockbin.org/bin/:id'
      datatype: string
      encrypted: true
      description: The HTTP URL endpoint (including the protocol to use) to which the data is sent.
    - name: method
      required: false
      default: '`POST`'
      value_in_examples: POST
      datatype: string
      description: |
        An optional method used to send data to the HTTP server. Supported values are
        `POST` (default), `PUT`, and `PATCH`.
    - name: content_type
      required: false
      default: '`application/json`'
      value_in_examples: null
      datatype: string
      description: |
        Indicates the type of data sent. The only available option is `application/json`.
    - name: timeout
      required: false
      default: '`10000`'
      value_in_examples: 1000
      datatype: number
      description: An optional timeout in milliseconds when sending data to the upstream server.
    - name: keepalive
      required: false
      default: '`60000`'
      value_in_examples: 1000
      datatype: number
      description: An optional value in milliseconds that defines how long an idle connection will live before being closed.
    - name: flush_timeout
      required: false
      default: '`2`'
      value_in_examples: 2
      datatype: number
      description: |
        Optional time in seconds. If `queue_size` > 1, this is the max idle time before sending a log with less than `queue_size` records.    
    - name: retry_count
      required: false
      default: 10
      value_in_examples: 15
      datatype: integer
      description: Number of times to retry when sending data to the upstream server.
    - name: queue_size
      required: false
      default: 1
      datatype: integer
      description: Maximum number of log entries to be sent on each message to the upstream server.
    - name: headers
      required: false
      default: empty table
      datatype: array of string elements
      description: |
        An optional table of headers added to the HTTP message to the upstream server. The following
        headers are not allowed: `Host`, `Content-Length`, `Content-Type`.

        **Note:** This parameter is only available for versions
        2.3.x and later.
  extra: |
    **NOTE:** If the `config.http_endpoint` contains a username and password (for example,
    `http://bob:password@example.com/logs`), then Kong Gateway automatically includes
    a basic-auth `Authorization` header in the log requests.
    - name: custom_fields_by_lua
      required: false
      default:
      datatype: map
      description: |
        A list of key-value pairs, where the key is the name of a log field and
        the value is a chunk of Lua code, whose return value sets or replaces
        the log field value.
---

## Log format

**Note:** If the `queue_size` argument > 1, a request is logged as an array of JSON objects.

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}


## Custom Headers

The log server that receives these messages might require extra headers, such as for authorization purposes.

```yaml
...
  - name: http-log
    config:
      headers:
        Authorization: "Bearer <token>"
...
```

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

---

## Changelog

### 2.2.1

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.http_endpoint` parameter value will be encrypted.
