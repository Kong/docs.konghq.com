---
title: Configure Services and Routes
content-type: tutorial
---

The Kong API Gateway provides a mechanism to govern all of your APIs from a central point of management. Additionally, the Kong API Gateway enables APIs to stay lean, by abstracting other requirements like observability, and security away from the API code.

At its core, {{site.base_gateway}} is a tool to manage **services** and **routes**. You can interface with {{site.base_gateway}} through the [Admin API](/gateway/latest/admin-api), [kong.conf](/gateway/latest/kong-production/kong-conf), or [{{site.konnect_short_name}}](/konnect/). {{site.base_gateway}} offers [plugins](/hub/) and the ability to write [custom plugins](/gateway/latest/plugin-development/) to support your use case. This tutorial is the first part in a series of tutorials designed to help you understand {{site.base_gateway}}. 

Get started with {{site.base_gateway}}:

* [How to install kong](/gateway/latest/get-started/get-kong-with-docker)
* [Configure rate limiting](/gateway/latest/get-started/protect-services)
* [Configure key authentication](/gateway/latest/get-started/secure-services)
* [Configure load-balancing](/gateway/latest/get-started/load-balancing)
* [Workspaces and teams](/gateway/latest/get-started/manage-teams)


## Prerequisites

{{site.base_gateway}} must be installed on your system locally. 

If you do not have {{site.base_gateway}} installed, you can quickly install it using the [How to Install Kong](/gateway/latest/get-started/get-kong-with-docker) instructions and return to this tutorial. 

## What is a service

In {{site.base_gateway}} a service serves as an abstraction of an existing upstream application. Services can store collections of objects like plugin configurations, and policies, and they can be associated with routes. Every service must have a *name* and a *URL*. The name is used to refer to the server, and the URL points to an upstream application that you want to serve using {{site.base_gateway}}.

![Services and routes](/assets/images/docs/getting-started-guide/route-and-service.png)

A service can be configured to interact with multiple upstream applications, including multiple of the same upstream application. 


## What is a route

A route is a path to a resource within an upstream application. Routes are added to services to allow access to the underlying application. In {{site.base_gateway}}, routes typically map to endpoints that are exposed through the {{site.base_gateway}} application. Routes can also define rules that match requests to associated services. Because of this, one route can reference multiple endpoints.
A basic route should have a name, path or paths, and reference an existing service. 

You can also configure routes with:
* Protocols: The protocol used to communicate with the upstream application. 
* Hosts: Lists of domains that match a route
* Methods: HTTP methods that match a route
* Headers: Lists of values that are expected in the header of a request
* Redirect status codes: HTTPS status codes
* Tags: Optional set of strings to group routes with 


## Configure services and routes

In this tutorial, you will complete the following steps:

* Create a service pointing to the [Mockbin](https://mockbin.org/) API. The Mockbin API generates custom endpoints to test, mock, and track HTTP requests and responses between libraries, sockets, and APIs.
* Create a route with a specific path for requests. 
* Use the service you created to return your request as a response. This will help you understand how {{site.base_gateway}} proxies API requests. 

To do this, you will use the Admin API. By default, the Admin API is configured on port `8001`. You can interact with the API using `cURL` or an API client like [Insomnia](https://insomnia.rest/).

### Add a service

In this tutorial, you can create a service using the [services](/gateway/latest/admin-api/#add-service) endpoint. 

To add a service, send a **POST** request to {{site.base_gateway}}: 

```sh
curl -i -X POST http://localhost:8001/services \
  --data name=example_service \
  --data url='http://mockbin.org'
```
If your request was successful, you will see a `201` response from {{site.base_gateway}} confirming that your service was created. 

This request instructed {{site.base_gateway}} to register a service with the name `example_service` and mapped the new service to the [Mockbin](http://mockbin.org) URL. 

The request body contained two strings: 

* `name`: The name of the service
* `url`: An argument that populates the `host`, `port`, and `path` attributes

You can verify the service's endpoint:

```sh
curl -i http://localhost:8001/services/example_service
```

The response body contains information about your service: 

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
Every attribute that is returned within the response body is configurable. Descriptions of each field is available in the [API documentation](/gateway/latest/admin-api/#request-body)

When you send the initial **POST** request {{site.base_gateway}}, any field that wasn't discretely configured in the request is automatically given a value based on the existing [kong.conf](/gateway/latest/kong-production/kong-conf) configuration file. Existing services can be updated at any time.

### Update the service

Using the value in the `id` field of the request body you received in the previous example, you can send a **PATCH** request to [update](/gateway/latest/admin-api/#update-service) a specific service. For example, to increment `retries` from the default `5` to `6`. 

```sh
curl --request PATCH \
  --url localhost:8001/services/example_id \
  --data retries=6
```

The response body displays the updated change:

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

You can configure a route to point to an active service. The router helps {{site.base_gateway}} forward requests to upstream services. Now, you will configure the `/mock` route for the `example_service` service. This route has a specific path that users will use to send requests. 
A route is configured by sending a **POST** request to the [route object](/gateway/latest/admin-api/#route-object):

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking
```

If the route was successfully created, the API returns a `201` response code and a response body like this:

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

Tags are an optional set of strings that can be associated with the route for grouping and filtering. You can assign tags by sending a **PATCH** request to the [services endpoint](/gateway/latest/admin-api/#update-route) and specifying a route:

```
curl --request PATCH \
  --url localhost:8001/services/example_service/routes/mocking \
  --data tags="tutorial"
```

In this example, use the `id` field from the service output and the name of the route to build the request. If the tag was successfully applied, the response body will contain the tag: 

```sh
"tags": [
		"\"tutorial\""
	],
```

You can also use the [routes object](/gateway/latest/admin-api/#route-object) to query for all configured routes in {{site.base_gateway}}:

```sh
curl -i -X GET http://localhost:8001/routes
```

This request returns an HTTP `200` status code and a JSON response body object array with all of the routes configured on this {{site.base_gateway}} instance. 

## Proxy a request 

Kong is an API Gateway, it takes API calls from clients and routes forwards them to the appropriate upstream application based on a series of configurations. Using the service and route that was previously configured, you can now access `https://mockbin.org/` using `http://localhost:8000/mock`.

```sh
curl -i -X GET http://localhost:8000/mock
```

You can use `cURL` or access the URL from your web browser because {{site.base_gateway}} forwarded your request through the configured service and forwarded the response at the URL of the route. This request was sent to port `8000` instead of port `8001`. {{site.base_gateway}}'s Admin API is configured to run on `8001` by default, so {{site.base_gateway}} uses port `8000` to communicate with clients. 


### Next steps 

The next part of this tutorial walks you through how and why to [configure rate limiting](/gateway/latest/get-started/protect-services/).

