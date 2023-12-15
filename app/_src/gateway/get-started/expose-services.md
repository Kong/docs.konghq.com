---
title: Expose your Services with Kong Gateway
---

In this topic, you’ll learn how to expose your Services using Routes.

If you are following the Getting Started workflow, make sure you have completed
[Prepare to Administer {{site.base_gateway}}](/gateway/{{page.kong_version}}/get-started//prepare)
before moving on.

If you are not following the Getting Started workflow, make sure you have
{{site.base_gateway}} installed and started.

## What are Services and Routes?

**Service** and **Route** objects let you expose your services to clients with
{{site.base_gateway}}. When configuring access to your API, you’ll start by specifying a
Service. In {{site.base_gateway}}, a Service is an entity representing an external
upstream API or microservice &mdash; for example, a data transformation
microservice, a billing API, and so on.

The main attribute of a Service is its **URL**, where the service listens for
requests. You can specify the URL with a single string, or by specifying its
protocol, host, port, and path individually.

Before you can start making requests against the Service, you will need to add
a Route to it. Routes determine how (and if) requests are sent to their Services
after they reach {{site.base_gateway}}. A single Service can have many Routes.

After configuring the Service and the Route, you’ll be able to start making
requests through {{site.base_gateway}}.

This diagram illustrates the flow of requests and responses being routed through
the Service to the backend API.

![Services and routes](/assets/images/products/gateway/getting-started-guide/route-and-service.png)

## Add a Service

For the purpose of this example, you’ll create a Service pointing to the httpbin
API. httpbin is an “echo” type public website that returns requests back to the
requester as responses. This visualization will be helpful for learning how Kong
Gateway proxies API requests.

{{site.base_gateway}} exposes the RESTful Admin API on port `8001`. The gateway’s
configuration, including adding Services and Routes, is done through requests to
the Admin API.

```sh
curl -i -X POST http://localhost:8001/services \
  --data name=example_service \
  --data url='http://httpbin.org'
```

If the service is created successfully, you'll get a 201 success message.

Verify the service’s endpoint:

```sh
curl -i http://localhost:8001/services/example_service
```

## Add a Route

For the Service to be accessible through the API gateway, you need to add a
Route to it.

Define a Route (`/mock`) for the Service (`example_service`) with a specific
path that clients need to request. Note at least one of the hosts, paths, or
methods must be set for the Route to be matched to the service.

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking
```

A `201` message indicates the Route was created successfully.

## Verify the Route is forwarding requests to the Service

By default, {{site.base_gateway}} handles proxy requests on port `8000`. The proxy is often referred to as the data plane.

```sh
curl -i -X GET http://localhost:8000/mock/anything
```
## Summary and next steps

In this section, you:

* Added a Service named `example_service` with a URL of `http://httpbin.org`.
* Added a Route named `/mock`.
* This means if an HTTP request is sent to the {{site.base_gateway}} node on
port `8000`(the proxy port) and it matches route `/mock`, then that request is
sent to `http://httpbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, go on to learn about [enforcing rate limiting](/gateway/{{page.kong_version}}/get-started//protect-services/).
