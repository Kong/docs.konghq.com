---
id: page-plugin
title: Plugins - Correlation ID
header_title: Correlation ID
header_icon: /assets/images/icons/plugins/correlation-id.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Documentation
    items:
      - label: How it works
      - label: Generators
      - label: FAQ
---

Correlate requests and responses using a unique ID transmitted over an HTTP header.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of
a [Service][service-object], a [Route][route-object], an [API][api-object]
or a [Consumer][consumer-object] by executing the following request on
your Kong server:


```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=correlation-id" \
    --data "consumer_id={consumer}"  \
    --data "service_id={service}"  \
    --data "route_id={route}"  \
    --data "api_id={api}"  \
    --data "config.header_name=Kong-Request-ID" \
    --data "config.generator=uuid#counter" \
    --data "config.echo_downstream=false"
```

`consumer`: The `id` of the Consumer that this plugin configuration will target
`service`: The `id` of the Service that this plugin configuration will target
`route`: The `id` of the Route that this plugin configuration will target
`api`: The `id` of the API that this plugin configuration will target

The term `target` is used to refer any of the possible targets for the plugin.

You can also apply it globally using the `http://kong:8001/plugins/` by not
specifying the target. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin)
for more information.

form parameter                  | default           | description
---                             | ---               | ---
`name`                          |                   | The name of the plugin to use, in this case: `correlation-id`
`header_name`<br>*optional*     | `Kong-Request-ID` | The HTTP header name to use for the correlation ID. 
`generator`<br>*optional*       | `uuid#counter`    | The generator to use for the correlation ID. Accepted values are `uuid`, `uuid#counter` and `tracker` See [Generators](#generators).
`echo_downstream`<br>*optional* | `false`           | Whether to echo the header back to downstream (the client).

----

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

In this format, a single UUID is generated on a per-worker basis, and further requests simply append a counter to the UUID after a `#` character. The `counter` value starts at `0` for each worker, and gets incremented independantly of the others.

This format provides a better performance, but might be harder to store or process for analizing (due to its format and low cardinality).

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

[consumer-object]: /docs/latest/admin-api/#consumer-object
[service-object]: /docs/latest/admin-api/#service-object
[route-object]: /docs/latest/admin-api/#route-object
[api-object]: /docs/latest/admin-api/#api-object
