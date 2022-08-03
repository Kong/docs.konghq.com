---
title: Services
content_type: explanation
---

## overview of services (just services)

In {{site.base_gateway}}, a service is an entity representing an external upstream API or microservice. For example, a data transformation microservice, a billing API, and so on. 

The main attribute of a service is its URL, where Kong should proxy traffic to. You can specify the URL with a single string, or by specifying its protocol, host, port, and path individually. 

Service entities are abstractions of each of your own upstream services. Examples of Services would be a data transformation microservice, a billing API, etc.

## Generically, how you configure a service

When configuring access to your API, you start by specifying a service.

You can configure a service in {{site.base_gateway}} using the following methods:

* Admin API
* Kong Manager

## How services and routes interact (maybe share this with "Routes"?)

In conjunction with routes, services let you expose your services to clients with {{site.base_gateway}}.

## See also

* how to configure in API
* How to configure in Kong Manager
* anything else related