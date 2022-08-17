---
title: Routes
concept_type: explanation
---

Routes determine how (and if) requests are sent to their services after they reach {{site.base_gateway}}. Where a service represents the backend API, a route defines what is exposed to clients. 

A single service can have many routes. Once a route is matched, {{site.base_gateway}} proxies the request to its associated service.

## Route and service interaction

Routes, in conjunction with [services](/gateway/{{page.kong_version}}/understanding-kong/key-concepts/services/), let you expose your services to applications with {{site.base_gateway}}. {{site.base_gateway}} abstracts the service from the applications by using routes. Since the application always uses the route to make a request, changes to the services, like versioning, don't impact how applications make the request. Routes also allow the same service to be used by multiple applications and apply different policies based on the route used.

For example, if you have an external application and an internal application that need to access the `example_service` service, but the external application should be limited in how often it can query the service to assure no denial of service. If a rate limit policy is configured for the service when the internal application calls the service, the internal application is limited as well. Routes can solve this problem.

In the example above, two routes can be created, say `/external` and `/internal`, and both routes can point to `example_service`. A policy can be configured to limit how often the `/external` route is used and the route can be communicated to the external client for use. When the external client tries to access the service via {{site.base_gateway}} using `/external`, they are rate limited. But when the internal client accesses the service using {{site.base_gateway}} using `/internal`, the internal client will not be limited.

## Dynamically rewrite request URLs with routes

Routes can be configured dynamically to rewrite the requested URL to a different URL for the upstream. For example, your legacy upstream endpoint may have a base URI like `/api/old/`. However, you want your publicly accessible API endpoint to now be named `/new/api`. To route the service's upstream endpoint to the new URL, you could set up a service with the path `/api/old/` and a route with the path `/new/api`. 

{{site.base_gateway}} can also handle more complex URL rewriting cases by using regular expression capture groups in the route path and the [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) plugin. For example, this can be used when you must replace `/api/<function>/old` with `/new/api/<function>`.

{{site.base_gateway}} 3.0.x or later ships with a new router. The new router can use regex expression capture groups to describe routes using a domain-specific language called Expressions. Expressions can describe routes or paths as patterns using regular expressions. For more information about how to configure the router using Expressions, see [How to configure routes using expressions](/gateway/{{page.kong_version}}/understanding-kong/how-to/router-atc/).

## Plugins for routes

You can also use plugins to interface with routes. This allows you to further your routing capabilities in {{site.base_gateway}}. 

See the following plugins for more information:

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/): Secure {{site.base_gateway}} clusters, routes, and services with username and password protection.
* [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/): Secure routes and services with client certificate and mutual TLS authentication.
* [Route By Header](/hub/kong-inc/route-by-header/): Route request based on request headers.
* [Route Transformer Advanced](/hub/kong-inc/route-transformer-advanced/): Transform routing by changing the upstream server, port, or path.

## Route configuration
Before you can start making requests against a service, you must add a route to it.

You can add routes to a service in {{site.base_gateway}} using the following methods:

* [Send an HTTP request using the Admin API](/gateway/{{page.kong_version}}/get-started/configure-services-and-routes/)
* [Create a route using the Kong Manager user interface](/gateway/{{page.kong_version}}/kong-manager/get-started/services-routes/)
