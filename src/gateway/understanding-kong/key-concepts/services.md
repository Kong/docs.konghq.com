---
title: Services
content_type: explanation
---

In {{site.base_gateway}}, a service is an entity representing an external upstream API or microservice. For example, a data transformation microservice, a billing API, and so on. 

The main attribute of a service is its URL. You can specify the URL with a single string, or by specifying its protocol, host, port, and path individually. 

Service entities are abstractions of each of your own upstream services. Examples of services would be a data transformation microservice or a billing API.

## Service and route interaction

Services, in conjunction with [routes](/gateway/latest/understanding-kong/key-concepts/routes/), let you expose your services to clients with {{site.base_gateway}}. {{site.base_gateway}} abstracts the service from the clients by using routes. Since the client always calls the route, changes to the services(like versioning) don't impact how clients make the call. Routes also allow the same service to be used by multiple clients and apply different policies based on the route used. 

For example, if you have an external client and an internal client that need to access the `hwservice` service, but the external client should be limited in how often it can query the service to assure no denial of service. If a rate limit policy is configured for the service when the internal client calls the service, the internal client is limited as well. Routes solve this problem. 

In the example above, two routes can be created, say `/external` and `/internal`, and both routes can point to `hwservice`. A policy can be configured to limit how often the `/external` route is used and the route can be communicated to the external client for use. When the external client tries to access the service via {{site.base_gateway}} using `/external`, they are rate limited. But when the internal client accesses the service via {{site.base_gateway}} using `/internal`, the internal client will not be limited. 

## Service configuration

When configuring access to your API, you start by specifying a service.

You can configure a service in {{site.base_gateway}} using the following methods:

* [Send an HTTP request using the Admin API](/gateway/latest/get-started/configure-services-and-routes/)
* [Create a service using the Kong Manager user interface](/gateway/latest/kong-manager/get-started/services-routes/)