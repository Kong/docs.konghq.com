---
name: Syslog
publisher: Kong Inc.
version: 2.2.x
desc: Send request and response logs to Syslog
description: |
  Log request and response data to Syslog.
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
  name: syslog
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
    - name: successful_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the successful requests with a response
        status code less then 400. Available options: `debug`, `info`, `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.
    - name: client_errors_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the failed requests with a
        response status code 400 or higher but less than 500. Available options: `debug`, `info`, `notice`,
        `warning`, `err`, `crit`, `alert`, `emerg`.
    - name: server_errors_severity
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity assigned to all the failed requests with a
        response status code 500 or higher. Available options: `debug`, `info`, `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.
    - name: log_level
      required: false
      default: '`info`'
      datatype: string
      description: |
        An optional logging severity. Any request with equal or higher severity
        will be logged to System log. Available options: `debug`, `info`, `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.
    - name: custom_fields_by_lua
      required: false
      default: null
      datatype: map
      description: |
        A list of key-value pairs, where the key is the name of a log field and
        the value is a chunk of Lua code, whose return value sets or replaces
        the log field value.
    - name: facility
      required: false
      default: '`user`'
      datatype: string
      description: |
        The facility is used by the operating system to decide how to handle each log message. This
        optional argument defines what must be the facility set by the plugin when logging. Available
        options: `auth`, `authpriv`, `cron`, `daemon`, `ftp`, `kern`, `lpr`, `mail`, `news`, `syslog`,
        `user`, `uucp`, `local0`, `local1`, `local2`, `local3`, `local4`, `local5`, `local6`, `local7`.
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
