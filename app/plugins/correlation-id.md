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
  - label: Usage
    items:
      - label: Logs
---

Correlate requests and responses using a unique ID.

----

## Configuration

Configuring the plugin is straightforward. You can associate it with an [API][api-object] by executing the following request to your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=correlation-id"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter      | required     | description
---                 | ---          | ---
`name`              | *required*   | The name of the plugin to use, in this case: `correlation-id`
`header_name`       | *optional*   | The HTTP header name to use for the correlation ID. Defaults to `Kong-Request-ID`
`generator  `       | *optional*   | The generator to use for the correlation ID. Accepted values are `uuid` (which generates a UUID for every request), or `uuid#counter` (which generates a UUID once per Nginx worker, and a count for every request). Defaults to `uuid#counter`.
`echo_downstream`   | *optional*   | Whether to echo the header back to downstream (the API calller). Defaults to `false`.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Logs

The correlation ID will not show up in the Nginx access or error logs. As such, we suggest you use this plugin alongside one of the Logging plugins.
