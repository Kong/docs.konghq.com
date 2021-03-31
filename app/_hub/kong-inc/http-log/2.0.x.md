---
name: HTTP Log
publisher: Kong Inc.
version: 2.0.x
# internal handler version 2.0.1

desc: Send request and response logs to an HTTP server
description: |
  Send request and response logs to an HTTP server.

type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
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
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: http-log
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https", "grpc", "grpcs", "tcp", "tls", "udp"]
  dbless_compatible: yes
  config:
    - name: http_endpoint
      required: true
      default:
      value_in_examples: http://mockbin.org/bin/:id
      datatype: string
      description: The HTTP URL endpoint (including the protocol to use) to which the data is sent.
    - name: method
      required: false
      default: "`POST`"
      value_in_examples: POST
      datatype: string
      description: |
        An optional method used to send data to the HTTP server. Supported values are
        `POST` (default), `PUT`, and `PATCH`.
    - name: content_type
      required: false
      default: "`application/json`"
      value_in_examples:
      datatype: string
      description: |
        Indicates the type of data sent. The only available option is `application/json`.
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples: 1000
      datatype: number
      description: An optional timeout in milliseconds when sending data to the upstream server.
    - name: keepalive
      required: false
      default: "`60000`"
      value_in_examples: 1000
      datatype: number
      description: An optional value in milliseconds that defines how long an idle connection will live before being closed.
    - name: flush_timeout
      required: false
      default: "`2`"
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

---

## Log format

**Note:** If the `queue_size` argument > 1, a request is logged as an array of JSON objects.

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}
