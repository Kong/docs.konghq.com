---
title: How to Configure Routes using Expressions
content-type: how-to
---

Configuring routes using expressions allows for more flexibility and better performance
when dealing with complex or large configurations.
This how-to guide explains how to switch to the expressions router and how to configure routes with the new expressive domain specific language.
Familiar yourself with the [Expressions Language Reference](/gateway/latest/reference/expressions-language/)
before proceeding through the rest of this guide.

## Prerequisites

Edit the [kong.conf](/gateway/latest/production/kong-conf/) to contain the line `router_flavor = expressions` and restart {{site.base_gateway}}.
{:.note}
> **Note:** Once you enable expressions, the match fields that traditionally exist on the route object (such as `paths` and `methods`) will no longer be configurable and you must specify Expressions in the `expression` field. A new field `priority` will be made available that allows specifying the order of evaluation of configured Expression routes.

## Create routes with expressions

To create a new route object using expressions, send a `POST` request to the [services endpoint](/gateway/latest/admin-api/#update-route):
```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string expression='http.path == "/mock"'
```

In this example, you associated a new route object with the path `/mock` to the existing service `example-service`.
The Expressions DSL also allows you to create complex router match conditions:

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form-string 'expression=(http.path == "/mock" || net.protocol == "https")'
```

### Create complex routes with expressions

You can describe complex route objects using operators within a `POST` request:

```sh

curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form-string name=complex_object \
  --form-string 'expression=(net.protocol == "http" || net.protocol == "https") &&
                (http.method == "GET" || http.method == "POST") &&
                (http.host == "example.com" || http.host == "example.test") &&
                (http.path ^= "/mock" || http.path ^= "/mocking") &&
                http.headers.x_another_header == "example_header" && (http.headers.x_my_header == "example" || http.headers.x_my_header == "example2")'
```

See the [expressions language overview](/gateway/latest/reference/expressions-language/) page for common use cases
and how to write expressions routes for them.

For a list of all available language features, see the [expressions language reference](/gateway/latest/reference/expressions-language/language-references/).

## Matching fields

The following table describes the available matching fields, as well as their associated type when using an expressions based router.

<!-- TO DO: Remove the "unless" tags when we have support for eq/neq OR if all of these changes get backported into 3.5 as well-->
<!-- There are two separate tables because Liquid's whitespace handling breaks tables when using if tags -->

{% unless page.release == '3.5.x' %}
{% if_version gte:3.4.x %}
| Field                                                | Type       | Available in HTTP Subsystem | Available in Stream Subsystem | Description |
|------------------------------------------------------|------------|-----------------------------|-------------------------------|-------------|
| `net.protocol`                                       | `String`   | ✅  | ✅  | Protocol of the route. Roughly equivalent to the `protocols` field on the `Route` entity.  **Note:** Configured `protocols` on the `Route` entity are always added to the top level of the generated route but additional constraints can be provided by using the `net.prococol` field directly inside the expression. |
| `tls.sni`                                            | `String`   | ✅  | ✅  | If the connection is over TLS, the `server_name` extension from the ClientHello packet. |
| `http.method`                                        | `String`   | ✅  | ❌  | The method of the incoming HTTP request. (for example, `"GET"` or `"POST"`) |
| `http.host`                                          | `String`   | ✅  | ❌  | The `Host` header of the incoming HTTP request. |
| `http.path`                                          | `String`   | ✅  | ❌  | The normalized request path according to rules defined in [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986#section-6). This field value does **not** contain any query parameters that might exist. |
| `http.path.segments.<segment_index>`                 | `String`   | ✅  | ❌  | A path segment extracted from the incoming (normalized) `http.path` with zero-based index. For example, for request path `"/a/b/c/"` or `"/a/b/c"`, `http.path.segments.1` will return `"b"`. |
| `http.path.segments.<segment_index>_<segment_index>` | `String`   | ✅  | ❌  | Path segments extracted from the incoming (normalized) `http.path` within the given closed interval joined by `"/"`. Indexes are zero-based. For example, for request path `"/a/b/c/"` or `"/a/b/c"`, `http.path.segments.0_1` will return `"a/b"`. |
| `http.path.segments.len`                             | `Int`      | ✅  | ❌  | Number of segments from the incoming (normalized) `http.path`. For example, for request path `"/a/b/c/"` or `"/a/b/c"`, `http.path.segments.len` will return `3`. |
| `http.headers.<header_name>`                         | `String[]` | ✅  | ❌  | The value(s) of request header `<header_name>`. **Note:** The header name is always normalized to the underscore and lowercase form, so `Foo-Bar`, `Foo_Bar`, and `fOo-BAr` all become values of the `http.headers.foo_bar` field. |
| `http.queries.<query_parameter_name>`                | `String[]` | ✅  | ❌  | The value(s) of query parameter `<query_parameter_name>`. |
| `net.src.ip`                          | `IpAddr`   | ✅  | ✅  | IP address of the client.                                                          |
| `net.src.port`                        | `Int`      | ✅  | ✅  | The port number used by the client to connect.                                     |
| `net.dst.ip`                          | `IpAddr`   | ✅  | ✅  | Listening IP address where {{site.base_gateway}} accepts the incoming connection.  |
| `net.dst.port`                        | `Int`      | ✅  | ✅  | Listening port number where {{site.base_gateway}} accepts the incoming connection. |
{% endif_version %}
{% endunless %}

{% unless page.release == '3.4.x' %}
{% if_version lte:3.5.x %}
| Field                                                | Type       | Available in HTTP Subsystem | Available in Stream Subsystem | Description |
|------------------------------------------------------|------------|-----------------------------|-------------------------------|-------------|
| `net.protocol`                                       | `String`   | ✅  | ✅  | Protocol of the route. Roughly equivalent to the `protocols` field on the `Route` entity.  **Note:** Configured `protocols` on the `Route` entity are always added to the top level of the generated route but additional constraints can be provided by using the `net.prococol` field directly inside the expression. |
| `tls.sni`                                            | `String`   | ✅  | ✅  | If the connection is over TLS, the `server_name` extension from the ClientHello packet. |
| `http.method`                                        | `String`   | ✅  | ❌  | The method of the incoming HTTP request. (for example, `"GET"` or `"POST"`) |
| `http.host`                                          | `String`   | ✅  | ❌  | The `Host` header of the incoming HTTP request. |
| `http.path`                                          | `String`   | ✅  | ❌  | The normalized request path according to rules defined in [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986#section-6). This field value does **not** contain any query parameters that might exist. |
| `http.headers.<header_name>`                         | `String[]` | ✅  | ❌  | The value(s) of request header `<header_name>`. **Note:** The header name is always normalized to the underscore and lowercase form, so `Foo-Bar`, `Foo_Bar`, and `fOo-BAr` all become values of the `http.headers.foo_bar` field. |
| `http.queries.<query_parameter_name>`                | `String[]` | ✅  | ❌  | The value(s) of query parameter `<query_parameter_name>`. |
| `net.src.ip`                          | `IpAddr`   | ❌  | ✅  | IP address of the client.                                                          |
| `net.src.port`                        | `Int`      | ❌  | ✅  | The port number used by the client to connect.                                     |
| `net.dst.ip`                          | `IpAddr`   | ❌  | ✅  | Listening IP address where {{site.base_gateway}} accepts the incoming connection.  |
| `net.dst.port`                        | `Int`      | ❌  | ✅  | Listening port number where {{site.base_gateway}} accepts the incoming connection. |
{% endif_version %}
{% endunless %}


## More information

* [Expressions Language Reference](/gateway/latest/reference/expressions-language/)
* [Repository for the Expressions router engine](https://github.com/Kong/atc-router)
