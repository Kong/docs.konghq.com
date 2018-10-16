---
redirect_to: /hub/kong-inc/correlation-id


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


id: page-plugin
title: Plugins - Correlation ID
header_title: Correlation ID
header_icon: /assets/images/icons/plugins/correlation-id.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Documentation
    items:
      - label: How it works
      - label: Generators
      - label: FAQ
description: |
  Correlate requests and responses using a unique ID transmitted over an HTTP header.

params:
  name: correlation-id
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: header_name
      required: false
      default: "`Kong-Request-ID`"
      value_in_examples: Kong-Request-ID
      description: |
        The HTTP header name to use for the correlation ID.
    - name: generator
      required: false
      default: "`uuid#counter`"
      value_in_examples: uuid#counter
      description: |
        The generator to use for the correlation ID. Accepted values are `uuid`, `uuid#counter` and `tracker` See [Generators](#generators).
    - name: echo_downstream
      required: false
      default: "`false`"
      value_in_examples: false
      description: |
        Whether to echo the header back to downstream (the client).

---

## How it works

When enabled, this plugin will add a new header to all of the requests processed by Kong. This header bears the name configured in `config.header_name`, and a unique value generated according to `config.generator`.

This header is always added to calls to your upstream services, and optionally echoed back to your clients according to the `config.echo_downstream` setting.

If a header bearing the same name is already present in the client request, it is honored and this plugin will **not** temper with it.

## Generators

#### uuid

Format:
```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Using this format, a UUID is generated in its hexadecimal form for each request.

#### uuid#counter

Format:
```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx#counter
```

In this format, a single UUID is generated on a per-worker basis, and further requests simply append a counter to the UUID after a `#` character. The `counter` value starts at `0` for each worker, and gets incremented independently of the others.

This format provides a better performance, but might be harder to store or process for analyzing (due to its format and low cardinality).

#### tracker

Format:
```
ip-port-pid-connection-connection_requests-timestamp
```

In this format, the correlation id contains more practical implications for each request.

The following is a detailed description of the field

form parameter      | description
---                 | ---
`ip` | an address of the server which accepted a request
`port` | port of the server which accepted a request
`pid` | pid of the nginx worker process
`connection` | connection serial number
`connection_requests` | current number of requests made through a connection
`timestamp` | a floating-point number for the elapsed time in seconds (including milliseconds as the decimal part) from the epoch for the current time stamp from the nginx cached time

## FAQ

#### Can I see my correlation ids in my Kong logs?

The correlation id will not show up in the Nginx access or error logs. As such, we suggest you use this plugin alongside one of the Logging plugins, or store this id on your backend-side.
