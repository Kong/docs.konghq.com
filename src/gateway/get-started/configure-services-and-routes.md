---
title: Configure Services and Routes
content-type: tutorial
---

The Kong API Gateway provides a mechanism govern to all of your APIs from a central point of management. Additionally, the Kong API Gateway enables APIs to stay lean and focus on the business logic, by abstracting other requirements like observability, security and many other services away from the API code. At the core a {{site.base_gateway}} is a tool to manage **Services** and **Routes**. You can interface with {{site.base_gateway}} through the [Admin API](/gateway/latest/admin-api), [kong.conf](/gateway/latest/kong-production/kong-conf), or [{{site.konnect_short_name}}](/konnect/). {{site.base_gateway}} offers [plugins](/hub/) and the ability to write [custom plugins](/gateway/latest/plugin-development/) to support your use case. This tutorial is the first part in a series of tutorials designed to help you understand {{site.base_gateway}}. 

Get Started with Kong:

* [How to Install Kong](/gateway/latest/get-started/get-kong-with-docker)
* [Rate Limiting](/gateway/latest/get-started/protect-services)
* [Key Authentication](/gateway/latest/get-started/secure-services)
* [Configure load-balancing](/gateway/latest/get-started/load-balancing)
* [Workspaces and teams](/gateway/latest/get-started/manage-teams)


## Prerequisites

* {{site.base_gateway}} installed on your system locally. 

If you do not have {{site.base_gateway}} installed, you can quickly install it using the [How to Install Kong](/gateway/latest/get-started/get-kong-with-docker) instructions and return to this tutorial. 

## What is a service

In {{site.base_gateway}} a service is a container object. Services can store collections of objects like routes and plugin configurations, and policies. Services can serve as abstractions of upstream applications that are managed by {{site.base_gateway}}. 
Every service must have a *name* and a *URL*. The name is used to refer to the server, and the URL points to an upstream application that you wish to serve using {{site.base_gateway}}.
![Services and routes](/assets/images/docs/getting-started-guide/route-and-service.png)

A service can be configured to interact with multiple upstream applications, including multiple of the same upstream application. 


## What is a route

A route is a path to a resource within an upstream application. Routes are attached to services to make the underlying application accessible. In {{site.base_gateway}} routes typically map to endpoints that are exposed through the {{site.base_gateway}} application. Routes can also define rules that match requests to associated services. Because of this, one route can reference multiple endpoints.
A basic route should have a name, path(s), and reference an existing service. 

Paths can also be configured with:
* Protocols
* Host(s) - lists of domains that match a route.
* Method(s) - HTTP methods that match a route.
* Headers - Lists of values that are expected in the header of a request.
* Redirect status codes - HTTPS status codes.
* Tags - Optional set of strings to group routes with. 


## Configure services and routes

In this tutorial, you will create a service pointing to the [Mockbin](https://mockbin.org/) API. Then you will create a route with a specific path for requests. The Mockbin API generates custom endpoints to test, mock, and track HTTP requests & responses between libraries, sockets and APIs. The service you create will return your request as a response. This will help in building an understanding of how {{site.base_gateway}} proxies API requests. 

To configure do this, you will be using the Admin API. By default, the Admin API is configured on port `8001`. Interacting with the API can be done using `cURL` or an API client like [Insomnia](https://insomnia.rest/).

### Add a Service

In this tutorial you can create a service using the [services](/gateway/latest/admin-api/#add-service) endpoint. To add a service, send a **POST** request to {{site.base_gateway}}: 

```sh
curl -i -X POST http://localhost:8001/services \
  --data name=example_service \
  --data url='http://mockbin.org'
```
If your request was successful you will receive a `201` response from {{site.base_gateway}} confirming that your service was created. 

This request instructed {{site.base_gateway}} to register a service with the name `example_service` and mapped the new service to the [Mockbin](http://mockbin.org) URL. 

The request body contained two strings: 

* `name`: The name of the service.
* `url`: an argument to populate the `host`, `port`, and `path` attributes at once.

You can verify the service's endpoint:

```sh
curl -i http://localhost:8001/services/example_service
```

The response body will contain information about your service: 

```sh
{
	"updated_at": 1660063550,
	"path": null,
	"connect_timeout": 60000,
	"write_timeout": 60000,
	"id": "example_id",
	"tls_verify": null,
	"host": "mockbin.org",
	"tls_verify_depth": null,
	"created_at": 1660063550,
	"name": "example_service1",
	"retries": 5,
	"client_certificate": null,
	"read_timeout": 60000,
	"ca_certificates": null,
	"port": 80,
	"protocol": "http",
	"enabled": true,
	"tags": null
}
```

When you send the initial **POST** request {{site.base_gateway}}, any field that wasn't discretely configured in the request is automatically given a value based on the existing [kong.conf](/gateway/latest/kong-production/kong-conf) configuration file. Existing services can be updated at any time.

### Update the service

Using the value in the `id` field of the request body you received in the previous example, you can send a **PATCH** request to [update](/gateway/latest/admin-api/#update-service) a specific service. For example, to increment `retries` from the default `5` to `6`. 

```sh
curl --request PATCH \
  --url localhost:8001/services/example_id \
  --data retries=6
```

The response body will display the updated change:

```sh
{
	"updated_at": 1660065439,
	"path": null,
	"connect_timeout": 60000,
	"write_timeout": 60000,
	"id": "example_id",
	"tls_verify": null,
	"host": "mockbin.org",
	"tls_verify_depth": null,
	"created_at": 1660063550,
	"name": "example_service1",
	"retries": 6,
	"client_certificate": null,
	"read_timeout": 60000,
	"ca_certificates": null,
	"port": 80,
	"protocol": "http",
	"enabled": true,
	"tags": null
}
```

### Add a route

With an active service you can configure a route to point to that service. The router is what helps {{site.base_gateway}} forward requests to upstream services. Now you will configure a route `/mock` for the service `example_service`. This route will have a specific path that users will use to send requests.
A route is configured by sending a **POST** request to the [route object](/gateway/latest/admin-api/#route-object) like this:

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking
```

If creating the route was successful the API will return a `201` response code and a response body like this:

```sh
{
	"snis": null,
	"updated_at": 1660067503,
	"preserve_host": false,
	"id": "example_service_id",
	"protocols": [
		"http",
		"https"
	],
	"created_at": 1660067503,
	"service": {
		"id": "example_service"
	},
	"hosts": null,
	"headers": null,
	"name": "mocking",
	"tags": null,
	"paths": [
		"/mock"
	]
}
```

### Update a route

Routes can be tagged. Tags are an optional set of strings associated with the route that can be used for grouping and filtering. You can assign tags by sending a **PATCH** request to the [services endpoint](/gateway/latest/admin-api/#update-route) and specifying a route. 

```
curl --request PATCH \
  --url localhost:8001/services/example_service/routes/mocking \
  --data tags="tutorial"
```

In this example, use the `id` field from the service output, and the name of the route to build the request. If the tag was applied successfully the response body will contain the tag. 

```sh
"tags": [
		"\"tutorial\""
	],
```

You can also use the [routes endpoint](/gateway/latest/admin-api/route) to query for all of the configured routes:

```sh
curl -i -X GET http://localhost:8001/routes
```

This request will return a `200` and a JSON response body object array with all of the routes configured on this {{site.base_gateway}} instance. 

## Proxy a request 

Kong is an API Gateway, it takes API calls from clients and routes them to the appropriate upstream application based on a series of configurations. Setting up services and routes models, on a small scale, how {{site.base_gateway}} works. Using the service and route that was configured you can now access `https://mockbin.org/` using `http://localhost:8000/mock`.

```sh
curl -i -X GET http://localhost:8000/mock
```

Using `cURL` or accessing the URL from your web browser is possible because Kong has forwarded your request through the configured service and forwarded you the response at the URL of the route. This request was sent to port `8000` instead of port `8001`. Kong's Admin API is configured to run on `8001` by default, {{site.base_gateway}} uses port `8000` to communicate with clients. 


### Configure rate limiting 

The next part of this tutorial walks you through the how and the why of configuring rate limiting. You can move to that section here: [Configure rate limiting](/gateway/latestr/get-started/rate-limiting) 

