---
title: Services and Routes
content-type: tutorial
book: get-started
chapter: 2
---

{{site.base_gateway}} administrators work with an object model to define their
desired traffic management policies. Two important objects in that model are 
[services](/gateway/latest/admin-api/#service-object) and 
[routes](/gateway/latest/admin-api/#route-object). Services and routes are configured in a 
coordinated manner to define the routing path that requests and responses will take 
through the system.

The high level overview below shows requests arriving at routes and being forward to services,
with responses taking the opposite pathway:

![Services and routes](/assets/images/products/gateway/getting-started-guide/route-and-service.png)

### What is a service

In {{site.base_gateway}}, a service is an abstraction of an existing upstream application. 
Services can store collections of objects like plugin configurations, and policies, and they can be 
associated with routes. 

When defining a service, the administrator provides a *name* and the upstream application connection
information. The connection details can be provided in the `url` field as a single string, or by providing
individual values for `protocol`, `host`, `port`, and `path` individually.

Services have a one-to-many relationship with upstream applications, which allows administrators to 
create sophisticated traffic management behaviors. 

### What is a route

A route is a path to a resource within an upstream application. Routes are added to services to allow 
access to the underlying application. In {{site.base_gateway}}, routes typically map to endpoints that are 
exposed through the {{site.base_gateway}} application. Routes can also define rules that match requests to 
associated services. Because of this, one route can reference multiple endpoints. A basic route should have a 
name, path or paths, and reference an existing service. 

You can also configure routes with:
* Protocols: The protocol used to communicate with the upstream application. 
* Hosts: Lists of domains that match a route
* Methods: HTTP methods that match a route
* Headers: Lists of values that are expected in the header of a request
* Redirect status codes: HTTPS status codes
* Tags: Optional set of strings to group routes with 

See [Routes](/gateway/{{page.kong_version}}/key-concepts/routes/) for a description of how
{{site.base_gateway}} routes requests.

## Managing services and routes

The following tutorial walks through managing and testing services and routes using the 
{{site.base_gateway}} [Admin API](/gateway/latest/admin-api/). {{site.base_gateway}} 
also offers other options for configuration management including
[{{site.konnect_saas}}](/konnect/) and [decK](/deck/latest/).

In this section of the tutorial, you will complete the following steps:
* Create a service pointing to the [httpbin](https://httpbin.org/) API, which provides testing facilities 
  for HTTP requests and responses.
* Define a route by providing a URL path that will be available to clients on the running {{site.base_gateway}}.
* Use the new httpbin service to echo a test request, helping you understand how 
  {{site.base_gateway}} proxies API requests. 

### Prerequisites

This chapter is part of the *Get Started with Kong* series. For the best experience, it is recommended that you follow the
series from the beginning. 

The introduction, [Get Kong](/gateway/latest/get-started/), includes
tool prerequisites and instructions for running a local {{site.base_gateway}}.

If you haven't completed the [Get Kong](/gateway/latest/get-started/) step already, 
complete that before proceeding.

### Managing services

1. **Creating services**

   To add a new service, send a `POST` request to {{site.base_gateway}}'s 
   Admin API `/services` route:

   ```sh
   curl -i -s -X POST http://localhost:8001/services \
     --data name=example_service \
     --data url='http://httpbin.org'
   ```

   This request instructs {{site.base_gateway}} to create a new 
   service mapped to the upstream URL `http://httpbin.org`.
   
   In our example, the request body contained two strings: 
   
   * `name`: The name of the service
   * `url` : An argument that populates the `host`, `port`, and `path` attributes of the service
   
   If your request was successful, you will see a `201` response header from {{site.base_gateway}} 
   confirming that your service was created and the response body will be similar to:

   ```text
   {
     "host": "httpbin.org",
     "name": "example_service",
     "enabled": true,
     "connect_timeout": 60000,
     "read_timeout": 60000,
     "retries": 5,
     "protocol": "http",
     "path": null,
     "port": 80,
     "tags": null,
     "client_certificate": null,
     "tls_verify": null,
     "created_at": 1661346938,
     "updated_at": 1661346938,
     "tls_verify_depth": null,
     "id": "3b2be74e-335b-4f25-9f08-6c41b4720315",
     "write_timeout": 60000,
     "ca_certificates": null
   }
   ```
   
   Fields that are not explicitly provided in the create request are automatically given 
   a default value based on the current {{site.base_gateway}} configuration.  

1. **Viewing service configuration**

   When you create a service, {{site.base_gateway}} assigns it a unique `id` as shown in the response above. 
   The `id` field, or the name provided when creating the service, can be used to identify the service 
   in subsequent requests. This is the service URL and takes the form of `/services/{service name or id}`.

   To view the current state of a service, make a `GET` request to the service
   URL.

   ```sh
   curl -X GET http://localhost:8001/services/example_service
   ```
  
   A successful request will contain the current configuration of your service in the response
   body and will look something like the following snippet:
   
   ```text
   {
     "host": "httpbin.org",
     "name": "example_service",
     "enabled": true,
     ...
   }
   ```
1. **Updating services**

   Existing service configurations can be updated dynamically by sending a `PATCH`
   request to the service URL. 

   To dynamically set the service retries from `5` to `6`, send this `PATCH` request:

   ```sh
   curl --request PATCH \
     --url localhost:8001/services/example_service \
     --data retries=6
   ```
   
   The response body contains the full service configuration including the updated value:
   
   ```sh
   {
     "host": "httpbin.org",
     "name": "example_service",
     "enabled": true,
     "retries": 6,
     ...
   }
   ```

1. **Listing services**

   You can list all current services by sending a `GET` request to the base `/services` URL.

   ```sh
   curl -X GET http://localhost:8001/services
   ```

The [Admin API documentation](/gateway/latest/admin-api/#update-service) provides
the full service update specification. 

You can also view the configuration for your services in the Kong Manager UI by navigating to the following URL in your browser: [http://localhost:8002/default/services](http://localhost:8002/default/services)
   
### Managing routes

1. **Creating routes**

   Routes define how requests are proxied by {{site.base_gateway}}. You can
   create a route associated with a specific service by sending a `POST`
   request to the service URL.

   Configure a new route on the `/mock` path to direct traffic to the `example_service` service
   created earlier:

   <!-- TODO: Following command needs modification post 3.1 release for new router behavior -->
   ```sh
   curl -i -X POST http://localhost:8001/services/example_service/routes \
     --data 'paths[]=/mock' \
     --data name=example_route
   ```

   If the route was successfully created, the API returns a `201` response code and a response body like this:
   
   ```text
   {
     "paths": [
       "/mock"
     ],
     "methods": null,
     "sources": null,
     "destinations": null,
     "name": "example_route",
     "headers": null,
     "hosts": null,
     "preserve_host": false,
     "regex_priority": 0,
     "snis": null,
     "https_redirect_status_code": 426,
     "tags": null,
     "protocols": [
       "http",
       "https"
     ],
     "path_handling": "v0",
     "id": "52d58293-ae25-4c69-acc8-6dd729718a61",
     "updated_at": 1661345592,
     "service": {
       "id": "c1e98b2b-6e77-476c-82ca-a5f1fb877e07"
     },
     "response_buffering": true,
     "strip_path": true,
     "request_buffering": true,
     "created_at": 1661345592
   }
   ```

1. **Viewing route configuration**

   Like services, when you create a route, {{site.base_gateway}} 
   assigns it a unique `id` as shown in the response above. The `id` field, or the name provided
   when creating the route, can be used to identify the route in subsequent requests.
   The route URL can take either of the following forms:
   
   * `/services/{service name or id}/routes/{route name or id}`
   * `/routes/{route name or id}`

   To view the current state of the `example_route` route, make a `GET` request to the route URL:

   ```sh
   curl -X GET http://localhost:8001/services/example_service/routes/example_route
   ``` 

   The response body contains the current configuration of your route:

   ```text
   {
     "paths": [
       "/mock"
     ],
     "methods": null,
     "sources": null,
     "destinations": null,
     "name": "example_route",
     "headers": null,
     "hosts": null,
     "preserve_host": false,
     "regex_priority": 0,
     "snis": null,
     "https_redirect_status_code": 426,
     "tags": null,
     "protocols": [
       "http",
       "https"
     ],
     "path_handling": "v0",
     "id": "189e0a57-205a-4f48-aec6-d57f2e8a9985",
     "updated_at": 1661347991,
     "service": {
       "id": "3b2be74e-335b-4f25-9f08-6c41b4720315"
     },
     "response_buffering": true,
     "strip_path": true,
     "request_buffering": true,
     "created_at": 1661347991
   }
   ```

1. **Updating routes**

   Like services, routes can be updated dynamically by sending a `PATCH`
   request to the route URL. 
   
   Tags are an optional set of strings that can be associated with the route for grouping and filtering. 
   You can assign tags by sending a `PATCH` request to the 
   [services endpoint](/gateway/latest/admin-api/#update-route) and specifying a route.

   Update the route by assigning it a tag with the value `tutorial`:
   
   ```
   curl --request PATCH \
     --url localhost:8001/services/example_service/routes/example_route \
     --data tags="tutorial"
   ```
   
   The above example used the service and route `name` fields for the route URL.
   
   If the tag was successfully applied, the response body will contain the following JSON value: 
   
   ```text
   ...
   "tags":["tutorial"]
   ...
   ```

1. **Listing routes**

   The Admin API also supports the listing of all routes currently configured:

   ```sh
   curl http://localhost:8001/routes
   ```

   This request returns an HTTP `200` status code and a JSON response body object array with all of 
   the routes configured on this {{site.base_gateway}} instance. Your response should look like the following:

   ```text
   {
     "next": null,
     "data": [
       {
         "paths": [
           "/mock"
         ],
         "methods": null,
         "sources": null,
         "destinations": null,
         "name": "example_route",
         "headers": null,
         "hosts": null,
         "preserve_host": false,
         "regex_priority": 0,
         "snis": null,
         "https_redirect_status_code": 426,
         "tags": [
           "tutorial"
         ],
         "protocols": [
           "http",
           "https"
         ],
         "path_handling": "v0",
         "id": "52d58293-ae25-4c69-acc8-6dd729718a61",
         "updated_at": 1661346132,
         "service": {
           "id": "c1e98b2b-6e77-476c-82ca-a5f1fb877e07"
         },
         "response_buffering": true,
         "strip_path": true,
         "request_buffering": true,
         "created_at": 1661345592
       }
     ]
   }
   ```

The [Admin API documentation](/gateway/latest/admin-api/#route-object) has the 
full specification for managing route objects.

You can also view the configuration for your routes in the Kong Manager UI by navigating to the following URL in your browser: [http://localhost:8002/default/routes](http://localhost:8002/default/routes)

## Proxy a request 

Kong is an API Gateway, it takes requests from clients and routes them to the appropriate upstream application 
based on a the current configuration. Using the service and route that was previously configured, you can now 
access `https://httpbin.org/` using `http://localhost:8000/mock`.

By default, {{site.base_gateway}}'s Admin API listens for administrative requests on port `8001`, this is sometimes referred to as the
*control plane*. Clients use port `8000` to make data requests, and this is often referred to as the *data plane*.

Httpbin provides an `/anything` resource which will echo back to clients information about requests made to it.
Proxy a request through {{site.base_gateway}} to the `/anything` resource:

```sh
curl -X GET http://localhost:8000/mock/anything
```

You should see a response similar to the following:
```text
{
  "startedDateTime": "2022-08-24T13:44:28.449Z",
  "clientIPAddress": "172.19.0.1",
  "method": "GET",
  "url": "http://localhost/anything",
  "httpVersion": "HTTP/1.1",
  "cookies": {},
  "headers": {
    "host": "httpbin.org",
    "connection": "close",
    "accept-encoding": "gzip",
    "x-forwarded-for": "172.19.0.1,98.63.188.11, 162.158.63.41",
    "cf-ray": "73fc85d999f2e6b0-EWR",
    "x-forwarded-proto": "http",
    "cf-visitor": "{\"scheme\":\"http\"}",
    "x-forwarded-host": "localhost",
    "x-forwarded-port": "80",
    "x-forwarded-path": "/mock/anything",
    "x-forwarded-prefix": "/mock",
    "user-agent": "curl/7.79.1",
    "accept": "*/*",
    "cf-connecting-ip": "00.00.00.00",
    "cdn-loop": "cloudflare",
    "x-request-id": "1dae4762-5d7f-4d7b-af45-b05720762878",
    "via": "1.1 vegur",
    "connect-time": "0",
    "x-request-start": "1661348668447",
    "total-route-time": "0"
  },
  "queryString": {},
  "postData": {
    "mimeType": "application/octet-stream",
    "text": "",
    "params": []
  },
  "headersSize": 588,
  "bodySize": 0
}
```

