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

Configuring the plugin is straightforward. You can associate it with an [API][api-object] by executing the following request to your Kong server:

```bash
$ curl -X POST --url http://kong:8001/apis/{api}/plugins \
    --data "name=correlation-id" \
    --data "config.header_name=Kong-Request-ID" \
    --data "config.generator=uuid#counter" \
    --data "config.echo_downstream=false"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter      | required     | description
---                 | ---          | ---
`name`              | *required*   | The name of the plugin to use, in this case: `correlation-id`
`header_name`       | *optional*   | The HTTP header name to use for the correlation ID. Defaults to `Kong-Request-ID`
`generator  `       | *optional*   | The generator to use for the correlation ID. Accepted values are `uuid` and `uuid#counter` See [Generators](#generators). Defaults to `uuid#counter`.
`echo_downstream`   | *optional*   | Whether to echo the header back to downstream (the client). Defaults to `false`.

[api-object]: /docs/latest/admin-api/#api-object

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

## FAQ

#### Can I see my correlation ids in my Kong logs?

The correlation id will not show up in the Nginx access or error logs. As such, we suggest you use this plugin alongside one of the Logging plugins, or store this id on your backend-side.
