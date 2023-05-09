---
name: HTTP Log
publisher: Kong Inc.
desc: Send request and response logs to an HTTP server
description: |
  Send request and response logs to an HTTP server.
type: plugin
categories:
  - logging
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: http-log
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
    - name: tcp
    - name: tls
    - name: tls_passthrough
      minimum_version: "2.7.x"
    - name: udp
    - name: ws
      minimum_version: "3.1.x"
    - name: wss
      minimum_version: "3.1.x"
  dbless_compatible: 'yes'
  config:
    - name: http_endpoint
      required: true
      default: null
      value_in_examples: 'http://mockbin.org/bin/:id'
      datatype: string
      encrypted: true
      description: |
        The HTTP URL endpoint (including the protocol to use) to which the data is sent.

        If the `http_endpoint` contains a username and password (for example,
        `http://bob:password@example.com/logs`), then Kong Gateway automatically includes
        a basic-auth `Authorization` header in the log requests.
    - name: method
      required: false
      default: '`POST`'
      value_in_examples: POST
      datatype: string
      description: |
        An optional method used to send data to the HTTP server. Supported values are
        `POST` (default), `PUT`, and `PATCH`.
    
    - name: content_type # old param version
      maximum_version: "3.2.x"
      required: false
      default: '`application/json`'
      value_in_examples: null
      datatype: string
      description: |
        Indicates the type of data sent. The only available option is `application/json`.
    - name: content_type # current param version
      minimum_version: "3.3.x"
      required: false
      default: '`application/json`'
      value_in_examples: null
      datatype: string
      description: |
        Indicates the type of data sent. The available options are `application/json` and `application/json; charset=utf-8`.
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
      maximum_version: "3.2.x"
    - name: retry_count
      required: false
      default: 10
      value_in_examples: 15
      datatype: integer
      description: Number of times to retry when sending data to the upstream server.
      maximum_version: "3.2.x"
    - name: queue_size
      required: false
      default: 1
      datatype: integer
      description: Maximum number of log entries to be sent on each message to the upstream server.
      maximum_version: "3.2.x"
{% include /md/plugins-hub/queue-parameters.md %}

    # ----- Old version of the 'headers' parameter -----
    - name: headers
      required: false
      default: empty table
      datatype: table
      description: |

        An optional table of headers added to the HTTP message to the upstream server.
        The table contains arrays of values, indexed by the header name (multiple values per header).

        The following headers are not allowed: `Host`, `Content-Length`, `Content-Type`.

      minimum_version: "2.3.x"
      maximum_version: "2.8.x"
    # ---------------------------------------------------

    - name: headers
      required: false
      default: empty table
      datatype: table
      description: |
        An optional table of headers included in the HTTP message to the
        upstream server. Values are indexed by header name, and each header name
        accepts a single string.

        The following headers are not allowed: `Host`, `Content-Length`, `Content-Type`.

        > **Note:** Before version 3.0.0, the values were arrays of strings (multiple values per header name).

      minimum_version: "3.0.x"
    - name: custom_fields_by_lua
      required: false
      default:
      datatype: map
      description: |
        A list of key-value pairs, where the key is the name of a log field and
        the value is a chunk of Lua code, whose return value sets or replaces
        the log field value.
      minimum_version: "2.4.x"
---

## Queueing

The HTTP Log plugin uses internal queues to decouple the production of
log entries from their transmission to the upstream log server.  In
contrast to other plugins that use queues, it shares one queue
between all plugin instances that use the same log server parameter.
The equivalence of the log server is determined by the parameters
`http_endpoint`, `method`, `content_type`, `timeout`, and `keepalive`.
All plugin instances that have the same values for these parameters
share one queue.


## Log format

{:.note}
> **Note:** If the `max_batch_size` argument > 1, a request is logged as an array of JSON objects.

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}


{% if_plugin_version gte:2.3.x %}

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

{% endif_plugin_version %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}


{% if_plugin_version gte:2.4.x %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

{% endif_plugin_version %}

---

## Changelog

**{{site.base_gateway}} 3.3.x**

* This plugin now supports the `application/json; charset=utf-8` content type.

**{{site.base_gateway}} 3.0.x**

* The `headers` parameter now takes a single string per header name, where it
previously took an array of values.

**{{site.base_gateway}} 2.7.x**

* If keyring encryption is enabled, the `config.http_endpoint` parameter value
will be encrypted.

**{{site.base_gateway}} 2.4.x**

* Added the `custom_fields_by_lua` parameter.

**{{site.base_gateway}} 2.3.x**

* Custom headers can now be specified for the log request using the `headers` parameter.
