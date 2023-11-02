---
title: How to Configure Routes using Expressions
content-type: how-to
---

Configuring routes using Expressions allows for more flexibility and performance
when dealing with complex or large sized configurations.
This how-to guide will walk through switching to the Expressions router, and configuring routes with the new expressive domain specific language.
Please be sure to familiar yourself with the [Expressions Language Reference](/gateway/latest/reference/expressions-language/overview/)
before processing through the rest of this guide.

## Prerequisite

Edit [kong.conf](/gateway/latest/production/kong-conf/) to contain the line `router_flavor = expressions` and restart {{site.base_gateway}}.
> **Note:** Once you enable expressions, the match fields that traditionally exist on the Route object (such as `paths`, `methods`) will no longer
  be configurable and you must specify Expressions in the `expression` field. A new field `prioriry` will be made available
  that allows specifying the order of evaluation of configured Expression routes.

## Create routes with Expressions

To create a new Route object using expressions, send a `POST` request to the [services endpoint](/gateway/latest/admin-api/#update-route) like this:
```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string expression='http.path == "/mock"'
```

In this example, you associated a new route object with the path `/mock` to the existing service `example-service`.
The Expressions DSL also allows you to create complex router match conditions.

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form-string 'expression=(http.path == "/mock" || net.protocol == "https")'
```

### Create complex routes with Expressions

You can describe complex route objects using operators within a `POST` request.

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

Please refer to the [Expressions Language Quickstart](/gateway/latest/reference/expressions-language/quickstart/#examples-http) page for common use cases
and how to write Expressions route for them.

For a list of all available language features, see the [Expressions Language References](/gateway/latest/reference/expressions-language/language-references/).

## Matching fields

Here are the available matching fields, as well as their associated type when using Expressions based router.

| Field                                 | Type       | Available in HTTP Subsystem | Available in Stream Subsystem | Description                                                                                                                                                                                                                                                                                                            |
|---------------------------------------|------------|-----------------------------|-------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `net.protocol`                        | `String`   | ✅                           | ✅                             | Protocol of the route. Roughly equivalent to the `protocols` field on the `Route` entity. **Note:** Configured `protocols` on the `Route` entity are always added to the top level of the generated route but additional constraints can be provided by using the `net.prococol` field directly inside the expression. |
| `tls.sni`                             | `String`   | ✅                           | ✅                             | If the connection is over TLS, the `server_name` extention from the ClientHello packet.                                                                                                                                                                                                                                |
| `http.method`                         | `String`   | ✅                           | ❌                             | The method of the incoming HTTP request. (e.g. `"GET"`, `"POST"`)                                                                                                                                                                                                                                                      |
| `http.host`                           | `String`   | ✅                           | ❌                             | The `Host` header of the incoming HTTP request.                                                                                                                                                                                                                                                                        |
| `http.path`                           | `String`   | ✅                           | ❌                             | The normalized request path. This field value does **not** contain any query parameters that might exist.                                                                                                                                                                                                              |
| `http.headers.<header_name>`          | `String[]` | ✅                           | ❌                             | The value(s) of request header `<header_name>`. **Note:** The header name is always normalized to the underscore and lowercase form, so `Foo-Bar`, `Foo_Bar` and `fOo-BAr` all becomes value of the `http.headers.foo_bar` field.                                                                                      |
| `http.queries.<query_parameter_name>` | `String[]` | ✅                           | ❌                             | The value(s) of query parameter `<query_parameter_name>`.                                                                                                                                                                                                                                                              |
| `net.src.ip`                          | `IpAddr`   | ❌                           | ✅                             | IP address of the client.                                                                                                                                                                                                                                                                                              |
| `net.src.port`                        | `Int`      | ❌                           | ✅                             | The port number using by the client to connect.                                                                                                                                                                                                                                                                        |
| `net.dst.ip`                          | `IpAddr`   | ❌                           | ✅                             | Listening IP address where Kong accepted the incoming connection.                                                                                                                                                                                                                                                      |
| `net.dst.port`                        | `Int`      | ❌                           | ✅                             | Listening port number where Kong accepted the incoming connection.                                                                                                                                                                                                                                                     |

## More information

* [Expressions Language Reference](/gateway/latest/reference/expressions-language/overview/)
* [Repository for the Expressions router engine](https://github.com/Kong/atc-router)
