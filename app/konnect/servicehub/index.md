---
title: ServiceHub Overview
no_version: true
---

ServiceHub is a {{site.konnect_short_name}} SaaS functionality module that
lets you catalog all of your services in a single system of record. This
catalog represents the single source of truth of your organization’s service
inventory and their dependencies.

Using ServiceHub, you can catalog, manage, and track every service in your
entire architecture.

## Services in the ServiceHub catalog

Each entry in ServiceHub is called a **Service**.
This is the abstraction of one of your own upstream services.

A Service in ServiceHub breaks down into multiple
configuration **versions**, and can be **implemented** to route to any
endpoint you like.

![{{site.konnect_short_name}} Service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

* **Service**: The abstraction of one of
your own services. For example, it might represent a data
transformation microservice or a billing API.
* **Service Version**: One instance, or implementation, of the
Service with a unique configuration. A Service can have many versions,
and each version can have different configurations, set up for a RESTful API,
gPRC endpoint, GraphQL endpoint, and others.
* **Service Implementation**: The concrete, runnable incarnation of a Service
version. Each Service version can only have one implementation.

<div class="alert alert-ee blue">
<b>Note:</b> Currently, the only supported implementation type is a
{{site.ee_gateway_name}} runtime.
</div>

The main attribute of a Service version is its Upstream URL, where the service
listens for requests. You can specify the URL with a single string, or by
specifying its protocol, host, port, and path individually.

**See more:**
* [Get started with Service management](/konnect/servicehub/manage-services)

### Kong Gateway implementations

When configuring a {{site.ee_gateway_name}} implementation of a Service, you'll
need to specify a Route. Routes determine how (and if) requests get sent to
their Services after they reach the API gateway. A single Service version
can have only one implementation, but potentially many Routes.

After configuring the Service, version, implementation, and at least one Route,
you’ll be able to start making requests through {{site.konnect_short_name}} SaaS.

## Dev Portal

ServiceHub natively integrates the Dev Portal into Service configuration.
Admins can publish Services directly from ServiceHub to the Dev Portal, where
application developers can search, discover, and consume existing Services.

The Dev Portal in {{site.konnect_product_name}} contains an API catalog,
allowing you to document all of your Services and their versions.

Through ServiceHub, publish your Service to the Dev Portal and set up
the following for any Service:
* **Markdown documentation**: A description of your Service. Applies to every
Service version.
* **Version spec**: An OpenAPI (Swagger) document in YAML or JSON format.
Applies to a specific Service version.

**See more:**
* [Upload Service Documentation to the Dev Portal](/konnect/servicehub/dev-portal/service-documentation)
* [Publish a Service to the Dev Portal](/konnect/servicehub/dev-portal/publish)

## Kong Gateway plugins

Plugins can be configured to run in a variety of contexts,
ranging from a specific Service version or Route to all Service versions. Plugins
can execute actions inside {{site.konnect_product_name}} before or after a request
has been proxied to the upstream API, as well as on any incoming responses.

Any {{site.ee_gateway_names}} plugins supported in a self-hosted Hybrid mode
deployment are also accessible through ServiceHub.

### Functionality differences from self-hosted Kong Gateway

The Portal Application Registration plugin is enabled automatically when you
enable application registration for the Dev Portal. You don't need to
enable it directly.

### Plugin limitations

The [Rate Limiting](/hub/kong-inc/rate-limiting) and
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced)
plugins only support the `redis` strategy, for which you must provide your own
Redis cluster.

The following plugins are not available with {{site.konnect_short_name}} SaaS:
* Key Auth Encrypted
* OAuth2 Authentication
* OAuth2 Introspection
* Request Size Limiting
* Apache OpenWhisk
* Datadog
* Zipkin
* Exit Transformer
* Request Transformer
* Request Transformer Advanced
* Response Transformer Advanced
* Route Transformer Advanced

### Custom plugins and serverless functions

Currently, there is no way to add a custom plugin or a serverless function
directly through the {{site.konnect_short_name}} SaaS application. Contact Kong
Support to get them manually added to your organization.

Custom plugins must not have the following:

* Admin API extensions: No `api.lua` file
* Custom plugin database tables: No `dao.lua` file
* Custom function validations: No function definitions in `schema.lua`
* Code that runs on the control plane in the plugin handler:
  * No `init_worker` callback
  * No Lua code outside of the top-level functions
* Third-party library dependencies: No `require()` calls to modules that are
not bundled by default with {{site.konnect_product_name}}

If your plugin meets these requirements and you want to use it in
{{site.konnect_short_name}} SaaS, contact [Kong Support](https://support.konghq.com/).

**See more:**
* [Plugin compatibility](/hub/plugins/compatibility/)
* [Configure a plugin on a Service](/konnect/servicehub/plugins/enable-service-plugin)
* [Configure a plugin on a Route](/konnect/servicehub/plugins/enable-route-plugin)
