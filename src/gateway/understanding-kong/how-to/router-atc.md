---
title: How to Configure Routes using Expressions
content-type: how-to
---


Expressions can describe routes or paths as patterns using regular expressions. This how-to guide will walk through switching to the new router, and configuring routes with the new expressive domain specific language, expressions. For a list of all available operators and configurable fields please review the [reference documentation](/gateway/latest/reference/router-operators).

## Prerequisite

Edit [kong.conf](/gateway/latest/kong-production/kong-conf) to contain the line `router_flavor = expressions` and restart {{site.base_gateway}}.

## Create routes with Expressions

To create a new router object using expressions, send a `POST` request to the [services endpoint](/gateway/latest/admin-api/#update-route) like this: 
```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form  atc='http.path == "/mock"
```

In this example, you associated a new route object with the path `/mock` to the existing service `example-service`. The Expressions DSL also allows you to create complex router objects using operators.  

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form 'atc=(http.path == "/mock" || net.protocol == "https")'
```
In this example the || operator created an expression that set variables for the following fields: 

```
"protocols": ["http", "https"]
AND
"paths": ["/mock"]
```

You can use attributes that are unrelated to expressions within the same `POST` request:

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --header 'Content-Type: multipart/form-data' \
  --form 'atc=(http.path == "/mock" || net.protocol == "https") \
  --form name=mocking
```

This would define a router object with the following attributes:


```
"atc": "(http.path == \"\/mock\" || net.protocol == \"https\"),
"name": "mocking",

```
You can view the list of available attributes in the [reference documentation](/gateway/latest/admin-api/#request-body). 



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

This request returns a `200` status code with the following values: 

```sh
"protocols": ["http", "https"],
"methods": ["GET", "POST"],
"hosts": ["example.com", "example.test"],
"paths": ["/mock", "/mocking"],
"headers": {"x-another-header":["example_header"], "x-my-header":["example", "example2"]},
```

For a list of all available operators, see the [reference documentation](/gateway/latest/reference/router-operators/).


## More information

* [Expressions repository](https://github.com/Kong/atc-router#table-of-contents)
* [Expressions Reference](/gateway/latest/reference/router-operators)