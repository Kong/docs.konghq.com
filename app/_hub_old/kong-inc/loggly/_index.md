---
name: Loggly
publisher: Kong Inc.
version: 2.1.x
desc: Send request and response logs to Loggly
description: |
  Log request and response data over UDP to [Loggly](https://www.loggly.com).
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
  name: loggly
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
      required: false
      default: '`logs-01.loggly.com`'
      datatype: string
      description: The IP address or hostname of Loggly server.
    - name: port
      required: false
      default: '`514`'
      datatype: integer
      description: The UDP port to send data to on the Loggly server.
    - name: key
      required: true
      default: null
      value_in_examples: YOUR_LOGGLY_SERVICE_TOKEN
      datatype: string
      encrypted: true
      description: |
        Loggly [customer token](https://www.loggly.com/docs/customer-token-authentication-token/).
    - name: tags
      required: false
      default: '`kong`'
      datatype: set of string elements
      description: |
        An optional list of [tags](https://www.loggly.com/docs/tags/) to support segmentation and filtering of logs.
    - name: timeout
      required: false
      default: '`10000`'
      datatype: number
      description: An optional timeout in milliseconds when sending data to the Loggly server.
    - name: successful_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the successful requests with a response
        status code 400. Available options: `debug`, `info`, `notice`, `warning`, `err`,
        `crit`, `alert`, `emerg`.
    - name: client_errors_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the failed requests with a response
        status code 400 or higher but less than 500. Available options: `debug`, `info`,
        `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.
    - name: server_errors_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the failed requests with response status
        code 500 or higher. Available options: `debug`, `info`, `notice`, `warning`, `err`,
        `crit`, `alert`, `emerg`.
    - name: log_level
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity, any request with equal or higher severity will be
        logged to Loggly. Available options: `debug`, `info`, `notice`, `warning`, `err`,
        `crit`, `alert`, `emerg`.
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

Every request is logged to the System log in [SYSLOG](https://en.wikipedia.org/wiki/Syslog) standard, with the
with `message` component formatted as described below.

**Note:** Make sure the Syslog daemon is running on the instance and it's configured with the
logging level severity the same as or lower than the set `config.log_level` for this plugin.

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

---

## Changelog

### 2.1.0

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `key` parameter value will be encrypted.
