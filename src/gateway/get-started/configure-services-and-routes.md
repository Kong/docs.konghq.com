---
title: Configure Services and Routes
content-type: tutorial
---

The Kong API Gateway provides a mechanism govern to all of your APIs from a central point of management. Additionally, the Kong API Gateway enables APIs to stay lean and focus on the business logic, by abstracting other requirements like observability, security and many other services away from the API code. At the core a {{site.base_gateway}} is a tool to manage **Services** and **Routes**. You can interface with {{site.base_gateway}} through the [Admin API](linktoadminapi), [kong.conf](linktoconf), or [Konnect](linktoconnect). {{site.base_gateway}} offers [plugins](linktoplugins) and the ability to write [custom plugins](link) to support your usecases. This tutorial is the first part in a series of tutorials designed to help you understand {{site.base_gateway}}. 

Get Started with Kong:

* [How to Install Kong](link)
* [Routes and Services](link)
* [Rate Limiting](link)
* [Key Authentication](link)
* [Configure load-balancing](link)
* [Workspaces and teams](link)


## Prerequisites

* {{site.base_gateway}} installed on your system locally. 

If you do not have {{site.base_gateway}} installed, you can quickly install it using the [How to Install Kong](link) instructions and return to this tutorial. 

## What is a service

In {{site.base_gateway}} a service is a container object. Services can store collections of objects like routes and plugin configurations, and policies. Services can serve as abstractions of upstream applications that are managed by {{site.base_gateway}}. 
Every service must have a *name* and a *URL*. The name is used to refer to the server, and the URL points to an upstream application that you wish to serve using {{site.base_gateway}}.
![Services and routes](/assets/images/docs/getting-started-guide/route-and-service.png)

A service can be configured to interact with multiple upstream applications, including multiple of the same upstream application. 


## What is a route

A route is a path to a resource within an upstream application. Routes are attached to services to make the underlying application accessible. In {{site.base_gateway}} routes typically map to endpoints that are exposed through the Kong Gateway application. Routes can also define rules that match requests to associated services. Because of this, one route can reference multiple endpoints.
A basic route should have a name, path(s), and reference an existing service. 

Paths can also be configured with:
* Protocols
* Host(s) - lists of domains that match a route.
* Method(s) - HTTP methods that match a route.
* Headers - Lists of values that are expected in the header of a request.
* Redirect status codes - HTTPS status codes.
* Tags - Optional set of strings to group rotues with. 

And more, for more information review [Understanding routes](link)


## Configure services and routes

In this tutorial, you will create a service pointing to the [Mockbin](link) API. Then you will create a route with a specific path for requests. The Mockbin API generates custom endpoints to test, mock, and track HTTP requests & responses between libraries, sockets and APIs. The service you create will return your request as a response. This will help in building an understanding of how {{site.base_gateway}} proxies API requests. 

To configure do this, you will be using the Admin API. By default, the Admin API is configured on port `8001`. Interacting with the API can be done using `cURL` or an API client like [Insomnia](https://insomnia.rest/).

## Add a Service

In this tutorial you can create a service using the [services](/gateway/latest/admin-api/#add-service) endpoint. To add a service, send a **POST** request to {{site.base_gateway}}: 

```sh
curl -i -X POST http://<kong-admin-host>:8001/services \
  --data name=example_service \
  --data url='http://mockbin.org'
```
If your request was succesful you will receive a `201` response from Kong gateway confirming that your service was created. 

This request instructed {{site.base_gateway}} to register a service with the name `example_service` and mapped the new service to the `http://mockbin.org` URL. 

The request body contained two strings: 

* `name`: The name of the service.
* `url`: an argument to populate the `host`, `port`, and `path` attributes at once.

You can verify the service's endpoint:

```sh
curl -i http://<admin-hostname>:8001/services/example_service
```

The response body will contain information about your service: 

```
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

When you send the intial **POST** request {{site.base_gateway}}, any field that wasn't discretely configured in the request is automatically given a value based on the existing [kong.conf](link) configuration file. Existing services can be updated at any time.

### Updating a service

Using the value in the `id` field of the request body you received in the previous example, you can send a **PATCH** request to [update](/gateway/latest/admin-api/#update-service) a specific service. For example, to increment `retries` from the default `5` to `6`. 

```sh
curl --request PATCH \
  --url localhost:8001/services/example_id \
  --data retries=6
```

The response body will display the updated change:

```
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

## Add a route

With an active service you can configure a route to point to that service. The router is what helps {{site.base_gateway}} forward requests to upstream services. Now you will configure a route `/mock` for the service `example_service`. This route will have a specific path that users will use to send requests.
A route is configured by sending a **POST** request to the [route object](/gateway/latest/admin-api/#route-object) like this:

```sh
curl -i -X POST http://<admin-hostname>:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking

```

If creating the route was succesful the API will return a `201` response code and a response body like this:

```
{
	"snis": null,
	"updated_at": 1660067503,
	"preserve_host": false,
	"id": "0779078b-e034-4741-9c6b-cac44ab9838e",
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


Define a Route (`/mock`) for the Service (`example_service`) with a specific
path that clients need to request. Note at least one of the hosts, paths, or
methods must be set for the Route to be matched to the service.


Service is a container. It contains routes, plugin configurations. Each route has one or more upstreams which is the endpoint requests that match a route will be forwarded on to



The Kong entity representing an external upstream API or microservice.
Upstream
The Kong entity that refers to your own API/service sitting behind Kong, to which client requests are forwarded.

A service (singular) can have multiple upstreams.


usrbinkat
  3 months ago
A service is a single thing. An upstream can be one of many of the same thing. Upstreams are used for canary deploys.
We should draw a diagram of flows through the route consumer plugin service and upstream chain. Probably a good diagram to publish


Now let’s define a Route in Kong that will route to the Service. This is a fundamental concept in Kong.  Kong abstracts the Service from the clients by using Routes.  Since the client always calls the route, changes to the service(s) say versioning, does not impact how clients make the call.  Routes are also important to allow the same service to be used by multiple clients and based on the route used, apply different policy. 

For example, say we have an external client and an internal client that need to access the hwservice service.  However, the external client should be limited in how often it can query the service to assure no denial of service.   If a rate limit policy is added to the service itself, when the internal client calls the service, they will be limited as well which is not the requirement.  Routes solve this problem.  
In the example above, two Routes can be created, say /external and /internal and both routes can point to the hwservice.  Now a policy can be configured to limit how often the /external route is used and the route can be communicated to the external client for use.  When the external client tries to access the service via Kong using /external, they will be rate limited but when the internal client accesses the service via Kong using /internal, the internal client will not be limited.  
