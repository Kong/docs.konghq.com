---
title: ServiceHub Overview
no_version: true
---

The ServiceHub is a {{site.konnect_saas}} functionality module that
lets you catalog all of your services in a single system of record. This
catalog represents the single source of truth of your organization’s service
inventory and their dependencies.

Using the ServiceHub, you can catalog, manage, and track every service in your
entire architecture.

## Services in the ServiceHub catalog

Each entry in the ServiceHub is called a **Konnect Service**, or **Service**
for short. This is the abstraction of one of your own upstream services.

A Service in the ServiceHub breaks down into multiple
configuration **versions**, and can be **implemented** to route to any
endpoint you like.

![{{site.konnect_short_name}} Service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

* **Service**: The abstraction of one of
your own services. For example, it might represent a data
transformation microservice or a billing API.

* **Service version**: One instance, or implementation, of the
Service with a unique configuration. A Service can have many versions,
and each version can have different configurations, set up for a RESTful API,
gPRC endpoint, GraphQL endpoint, and others.

* **Service implementation**: The concrete, runnable incarnation of a Service
version. Each Service version can only have one implementation.

A Konnect service isn't associated with any specific runtime group, but every
Service version is. When you create a version of the Service, you must select a
group for the version to run on.

{:.note}
> **Note:** Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.

The main attribute of a Service version is its Upstream URL, where the service
listens for requests. You can specify the URL with a single string, or by
specifying its protocol, host, port, and path individually.

[Get started with Service management &rarr;](/konnect/configure/servicehub/manage-services)

### Kong Gateway implementations

When configuring a {{site.base_gateway}} implementation of a Service, you'll
need to specify a Route. Routes determine how (and if) requests get sent to
their Services after they reach the API gateway. A single Service version
can have only one implementation, but potentially many Routes.

After configuring the Service, version, implementation, and at least one Route,
you’ll be able to start making requests through {{site.konnect_saas}}.

[Implement a Service version &rarr;](/konnect/configure/servicehub/manage-services/#implement-service-version)

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

[Upload Service Documentation to the Dev Portal &rarr;](/konnect/dev-portal/service-documentation)

[Publish a Service to the Dev Portal &rarr;](/konnect/dev-portal/publish)

## Kong Gateway plugins

Plugins can be configured to run in a variety of contexts,
ranging from a specific Service version or Route to all Service versions. Plugins
can execute actions inside {{site.konnect_product_name}} before or after a request
has been proxied to the upstream API, as well as on any incoming responses.

[Manage plugins &rarr;](/konnect/configure/servicehub/plugins/)
