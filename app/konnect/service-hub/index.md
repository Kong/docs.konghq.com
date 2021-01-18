---
title: Service Hub Overview
no_search: true
no_version: true
beta: true
---
Using the Service Hub, you can compile a comprehensive catalog of to enable
discovery, consumption, and management of every service across your entire 
architecture.

## What are Services, Service Versions, and Implementations?

In {{site.konnect_product_name}}, Service Versions and Route objects let
you expose your Services to clients. A Service is then comprised of multiple
Service Versions and their implementations.

Each Service entity is an abstraction of each of your own upstream services,
for example, a data transformation microservice or a billing API.

In Konnect, a Service breaks down into multiple components:
* **Service Entity**: the abstraction of one of your own upstream services. In
Konnect, a Service is implemented through one or more Versions.
* **Service Version**: one instance, or implementation of the
Service with a unique configuration. Each version can have different
configurations, set up for a RESTful API, gPRC endpoint, GraphQL endpoint, etc.
* **Service Implementation**: the concrete, runnable incarnation of a Service
Version. Each Service Version can have one implementation.

The main attribute of a Service Version is its Upstream URL, where the service
listens for requests. You can specify the URL with a single string, or by
specifying its protocol, host, port, and path individually.

## What are Routes?

Before you can start making requests against the Service Version, you will
need to add a Route to it. Routes determine how (and if) requests are sent to
their Services after they reach Kong Gateway. A single Service Version
can have many Routes.

After configuring the Service, Version, Implementation, and its Route(s),
you’ll be able to start making requests through Konnect.
