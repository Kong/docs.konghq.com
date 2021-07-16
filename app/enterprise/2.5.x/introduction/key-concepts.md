---
title: Key Concepts and Terminology
toc: true
redirect_from:
  - /enterprise/getting-started/{{page.kong_version}}/key-concepts
---

{{site.ee_product_name}} uses common terms for entities and processes that have a specific meaning in context. This topic provides a conceptual overview of terms, and how they apply to Kong’s use cases.

## Admin

An Admin is a {{site.base_gateway}} user account capable of accessing the Admin API or Kong Manager. With RBAC and Workspaces, access can be modified and limited to specific entities.

## Authentication
Authentication is the process by which a system validates the identity of a user account. It is a separate concept from authorization.

API gateway authentication is an important way to control the data that is allowed to be transmitted to and from your APIs. An API may have a restricted list of identities that are authorized to access it. Authentication is the process of proving an identity.

## Authorization
Authorization is the system of defining access to certain resources. In {{site.base_gateway}}, Role-Based Access Control (RBAC) is the main authorization mode. To define authorization to an API, it is possible to use the ACL Plugin in conjunction with an authentication plugin.

## Beta
A Beta designation in Kong software means the functionality of a feature or release version is of high quality and can be deployed in a non-production environment. Note the following when using a Beta feature or version:

* **A Beta feature or version should not be deployed in a production environment.**
* Beta customers are encouraged to engage Kong Support to report issues encountered in Beta testing.  Support requests should be filed with normal priority, but contractual SLA’s will not be applicable for Beta features.
* Support is not available for data recovery, rollback, or other tasks when using a Beta feature or version.
* User documentation might not be complete or reflect entire functionality.

A Beta feature or version is made available to the general public for usability testing and to gain feedback about the feature or version before releasing it as a production-ready, stable feature or version.

## Client
A Kong Client refers to the downstream client making requests to Kong’s proxy port. It could be another service in a distributed application, a user’s identity, a user’s browser, or a specific device.

## Consumer
A Consumer object represents a client of a Service.

A Consumer is also the Admin API entity representing a developer or machine using the API. When using Kong, a Consumer only communicates with Kong which proxies every call to the said upstream API.

You can either rely on Kong as the primary datastore, or you can map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

## Host
A Host represents the domain hosts (using DNS) intended to receive upstream traffic. In Kong, it is a list of domain names that match a Route object.

## Methods
Methods represent the HTTP methods available for requests. It accepts multiple values, for example, `GET`, `POST`, and `DELETE`. Its default value is empty (the HTTP method is not used for routing).

## Permission
A Permission is a policy representing the ability to create, read, update, or destroy an Admin API entity defined by endpoints.

## Plugin
Plugins provide advanced functionality and extend the use of {{site.base_gateway}}, allowing you to add new features to your gateway. Plugins can be configured to run in a variety of contexts, ranging from a specific route to all upstreams. Plugins can perform operations in your environment, such as authentication, rate-limiting, or transformations on a proxied request.

## Proxy
Kong is a reverse proxy that manages traffic between clients and hosts. As a gateway, Kong’s proxy functionality evaluates any incoming HTTP request against the Routes you have configured to find a matching one. If a given request matches the rules of a specific Route, Kong processes proxying the request. Because each Route is linked to a Service, Kong runs the plugins you have configured on your Route and its associated Service and then proxies the request upstream.

![Proxy](/assets/images/docs/ee/proxy.png)

## Proxy Caching
One of the key benefits of using a reverse proxy is the ability to cache frequently-accessed content. The benefit is that upstream services do not need to waste computation on repeated requests.

One of the ways Kong delivers performance is through Proxy Caching, using the [Proxy Cache Advanced Plugin](/hub/kong-inc/proxy-cache-advanced/). This plugin supports performance efficiency by providing the ability to cache responses based on requests, response codes and content type.

Kong receives a response from a service and stores it in the cache within a specific timeframe.

![Proxy caching](/assets/images/docs/ee/proxy-caching.png)

For future requests within the timeframe, Kong responds from the cache instead of the service.

![Proxy caching without service](/assets/images/docs/ee/proxy-caching2.png)

The cache timeout is configurable. Once the time expires, Kong forwards the request to the upstream again, caches the result, and then responds from the cache until the next timeout.

The plugin can store cached data in-memory. The tradeoff is that it competes for memory with other processes, so for improved performance, use Redis for caching.

## Rate Limiting
Rate Limiting allows you to restrict how many requests your upstream services receive from your API consumers, or how often each user can call the API. Rate limiting protects the APIs from inadvertent or malicious overuse. Without rate limiting, each user may request as often as they like, which can lead to spikes of requests that starve other consumers. After rate limiting is enabled, API calls are limited to a fixed number of requests per second.  

![Rate limiting](/assets/images/docs/ee/rate-limiting.png)

In this workflow, we are going to enable the [Rate Limiting Advanced Plugin](/hub/kong-inc/rate-limiting-advanced/). This plugin provides support for the sliding window algorithm to prevent the API from being overloaded near the window boundaries and adds Redis support for greater performance.  

## Role
A Role is a set of permissions that may be reused and assigned to Admins. For example, this diagram shows multiple admins assigned to a single shared role that defines permissions for a set of objects in a workspace.

![Role](/assets/images/docs/ee/role.png)

## Route
A Route, also referred to as Route object, defines rules to match client requests to upstream services. Each Route is associated with a Service, and a Service may have multiple Routes associated with it. Routes are entry-points in Kong and define rules to match client requests. Once a Route is matched, Kong proxies the request to its associated Service. See the [Proxy Reference](/enterprise/{{page.kong_version}}/proxy) for a detailed explanation of how Kong proxies traffic.

## Service
A Service, also referred to as a Service object, is the upstream APIs and microservices Kong manages. Examples of Services include a data transformation microservice, a billing API, and so on. The main attribute of a Service is its URL (where Kong should proxy traffic to), which can be set as a single string or by specifying its protocol, host, port and path individually. The URL can be composed by specifying a single string or by specifying its protocol, host, port, and path individually.

Before you can start making requests against a Service, you need to add a [Route](#route) to it. Routes specify how (and if) requests are sent to their Services after they reach Kong. A single Service can have many Routes. After configuring the Service and the Route, you’ll be able to make requests through Kong using them.

## Stable
A Stable release designation in Kong software means the functionality of the version is of high quality, production-ready, and released as general availability (GA). The version has been thoroughly tested, considered reliable to deploy in a production environment, and is fully supported. If updates or bug fixes are required, a patch version or minor release version is issued and fully supported.

## Super Admin
A Super Admin, or any Role with read and write access to the `/admins` and `/rbac` endpoints, creates new Roles and customize Permissions. A Super Admin can:
* Invite and disable other Admin accounts
* Assign and revoke Roles to Admins
* Create new Roles with custom Permissions
* Create new Workspaces

![Super Admin](/assets/images/docs/ee/super-admin.png)

## Tags
Tags are customer defined labels that let you manage, search for, and filter core entities using the `?tags` querystring parameter. Each tag must be composed of one or more alphanumeric characters, `\_\`, `-`, `.` or `~`. Most core entities can be tagged via their tags attribute, upon creation or edition.

## Teams
Teams organize developers into working groups, implements policies across entire environments, and onboards new users while ensuring compliance. Role-Based Access Control (RBAC) and Workspaces allow users to assign administrative privileges and grant or limit access privileges to individual users and consumers, entire teams, and environments across the Kong platform.

## Upstream
An Upstream object refers to your upstream API/service sitting behind Kong, to which client requests are forwarded. An Upstream object represents a virtual hostname and can be used to load balance incoming requests over multiple services (targets). For example, an Upstream named `service.v1.xyz` for a Service object whose host is `service.v1.xyz`. Requests for this Service object would be proxied to the targets defined within the upstream.

## Workspaces
Workspaces enable an organization to segment objects and admins into namespaces. The segmentation allows teams of admins sharing the same Kong cluster to adopt roles for interacting with specific objects. For example, one team (Team A) may be responsible for managing a particular service, whereas another team (Team B) may be responsible for managing another service.

Many organizations have strict security requirements. For example, organizations need the ability to segregate the duties of an administrator to ensure that a mistake or malicious act by one administrator does not cause an outage.

![Workspaces](/assets/images/docs/ee/workspaces.png)
