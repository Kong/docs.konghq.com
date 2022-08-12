---
title: Configure Routes with expressions
content-type: how-to
---


With the release of version 3.0, {{site.base_gateway}} now ships with a new router. The new router can describe routes using a domain-specific languaged called Expressions. Expressions can describe routes or paths as patterns using regular expressions. This how-to guide will walk through switching to the new router, and configuring routes with the new expressive domain specific language, expressions. For a list of all available operators and configurable fields please review the [reference documentation](/gateway/latest/reference/router-operators).


Kong’s Route object has carried its legacy from the early days. Over the years we have added a lot of new capability and fields to the existing router which makes the router interface quite complex and relations between different fields hard to understand. With the requirement of incremental rebuilds and more efficient runtime behavior, it is clear the existing Lua based router implementation will not be enough. With 3.0 approaching, now is the best time to address both problems at once with a new implementation.

Compatibility with existing Router interface and config
The intention is for the new router implementation to be fully compatible with existing Route objects. To achieve this, the following will be done:
The existing Route schema will be mostly left alone
A new field matchers will be added to the Route schema, that is mutually exclusive with all existing matching conditions
When building the Router, Kong can convert any Route object not using the matchers field to the appropriate ATC DSL representation automatically


## Prerequisite

* Edit [kong.conf](/gateway/latest/kong-production/kong-conf) to contain the line `router_flavor = atc` and restart {{site.base_gateway}}.


## Route creation

In previous versions of Kong Gateway, creating a route was done by sending a `POST` request to the Admin API and describing a route: 


```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking
```

With the introduction of Expressions, the same route request can be written like 


To create a new router object using expressions send a `POST` request to the [services endpoint](/gateway/latest/admin-api/#update-route) like this: 

```sh
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form  atc='http.path == "/mock"
```

This example creates a route to the service `example-service` with the `http.path` `/mock`. In this example, `http.path` is an available [router configuration field](/gateway/latest/reference/router-operators). 

Before the introduction of this router, the same expression would have 







```
curl --location --request POST 'https://localhost:8444/services/:serviceNameOrId/routes' \
--header 'Content-Type: application/json' \
--data-raw '{
	"name": "httpbin-api",
	"url": "https://httpbin.org/"
}'

```
```

curl --location -g --request POST '{{gateway}}/routes' \
--header 'Content-Type: application/json' \
--data-raw '{
	"name": "my-route",
	"protocols": [
		"http",
		"https"
	],
	"methods": [
		"GET",
		"POST"
	],
	"hosts": [
		"example.com",
		"foo.test"
	],
	"paths": [
		"/foo",
		"/bar"
	],
	"headers": {
		"x-another-header": [
			"bla"
		],
		"x-my-header": [
			"foo",
			"bar"
		]
	},
	"https_redirect_status_code": 426,
	"regex_priority": 0,
	"strip_path": true,
	"path_handling": "v0",
	"preserve_host": false,
	"tags": [
		"user-level",
		"low-priority"
	],
	"service": {
		"id": "c8b8f724-7e73-4df6-b1a8-8df19642d388"
	}
}'

```


```sh

atc='http.path == "/" && http.host == "mockbin.org"
```

```sh

curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form 'atc=(http.path == "/mock" || net.protocol == "https") && (http.method == "GET" || http.method == "POST") '

```

In this example, the `||` and `&&` operators are used to create an expression that will 


src/gateway/kong-production/kong-conf.md
"protocols": ["http", "https"],
"methods": ["GET", "POST"],
"hosts": ["example.com", "foo.test"],
"paths": ["/foo", "/bar"],
"headers": {"x-another-header":["bla"], "x-my-header":["foo", "bar"]},


3.0 

(net.protocol == "http" || net.protocol == "https") &&

(http.method == "GET" || http.method == "POST") &&

(http.host == "example.com" || http.host == "foo.test") &&

(http.path ^= "/foo" || http.path ^= "/bar") &&

http.headers.x_another_header == "bla" && (http.headers.x_my_header == "foo" || http.headers.x_my_header == "bar")
i might be reading it wrong, but it seems like an iterative feature where we just describe paths as patterns rather than creating some crazy new feature

path based routing is normal, this just looks like a semantic evolution to enable regex pattern paths (edited) 


The new router supports strict matching for paths without Regex. But it is not compatiable with the existing config interface. They will have to use the DSL directly.



```
curl http://localhost:8001/services/mock/routes -d atc='http.path == "/mock" && http.method == "GET"'
{"name":"schema violation","message":"schema violation ( http: unknown field)","code":2,"fields":{" http":"unknown field"}}
```


curl http://localhost:8001/services/mock/routes -d atc='http.method == "GET" || http.method == "POST"'


http :8001/services/6a81044e-9524-4316-b6fc-b3dbbacce7d1/routes atc='http.path == "/mock" && http.method == "GET"'