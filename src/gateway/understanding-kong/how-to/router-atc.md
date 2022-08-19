---
title: How to Configure Routes using Expressions
content-type: how-to
---


Expressions can describe routes or paths as patterns using logical expressions.
This how-to guide will walk through switching to the new router, and configuring routes with the new expressive domain specific language.
For a list of all available operators and configurable fields please review the [reference documentation](/gateway/latest/reference/router-operators).

## Prerequisite

Edit [kong.conf](/gateway/latest/kong-production/kong-conf) to contain the line `router_flavor = expressions` and restart {{site.base_gateway}}.
Note: once you enable expressions, the match fields that traditionally exist on the Route object (such as `paths`, `methods`) will no longer
be configurable and you must specify Expressions in the `atc` field.

## Create routes with Expressions

To create a new router object using expressions, send a `POST` request to the [services endpoint](/gateway/latest/admin-api/#update-route) like this: 
```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form  atc='http.path == "/mock"'
```

In this example, you associated a new route object with the path `/mock` to the existing service `example-service`. The Expressions DSL also allows you to create complex router match conditions.

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form 'atc=(http.path == "/mock" || net.protocol == "https")'
```
In this example the || operator created an expression that set variables for the following fields: 

```
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form 'atc=http.path == "/mock" && (net.protocol == "http" || net.protocol == "https")'
```

### Create complex routes with Expressions

You can describe complex route objects using operators within a `POST` request.

```sh

curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form name=complex_object \
  --form 'atc=(net.protocol == "http" || net.protocol == "https") &&
         (http.method == "GET" || http.method == "POST") &&
         (http.host == "example.com" || http.host == "example.test") &&
         (http.path ^= "/mock" || http.path ^= "/mocking") &&
         http.headers.x_another_header == "example_header" && (http.headers.x_my_header == "example" || http.headers.x_my_header == "example2")'
```


For a list of all available operators, see the [reference documentation](/gateway/latest/reference/router-operators/).

## Performance considerations when using Expressions

Generally, Expressions are evaluated sequentially until a match could be found. This means with large number of Routes, the worst case match time
will tends to scale linearly as the number of routes increase. Therefore it is desirable to reduce the number of unique routes by leveraging
the combination capability of the language.

Keep regex usages to a minimum. Regular expressions are much more expensive to build and execute, and can not be optimized easily. Leveraging the
powerful operators provided by the language instead.

### Examples

#### Exact matches

When performing exact (not prefix) matches on paths, traditionally regex has to be used in the following form:

```
paths: ["~/foo/bar$"]
```

Routers with large amount of regexes are expensive to build and execute. With Expressions, avoid using regex by write the following:

```
http.path == "/foo/bar"
```

#### Optional slash at the end

Sometimes it is desirable to match both `/foo` and `/foo/` in the same route. Traditionally, this has been done using the following regex:


```
paths: ["~/foo/?$"]
```

With Expressions, avoid using regex by write the following:

```
http.path == "/foo/bar" || http.path == "/foo/bar/"
```

#### Multiple routes with same Service and Plugin config

If multiple routes results in the same Service and Plugin config being used, they should be combined into a single Expression Route
with logical or operator `||`.

Example:

Route 1:
```
service: example-service
atc: http.path == "/hello"
```

Route 2:
```
service: example-service
atc: http.path == "/world"
```

Should be simply be combined as:

```
service: example-service
atc: http.path == "/hello" || http.path == "/world"
```

This reduces the number of routes the Expressions engine has to consider, which helps with the matching performance at runtime

## More information

* [Expressions repository](https://github.com/Kong/atc-router#table-of-contents)
* [Expressions Reference](/gateway/latest/reference/router-operators)
