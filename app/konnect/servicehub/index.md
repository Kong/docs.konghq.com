---
title: Service Hub Overview
no_version: true
---

The Service Hub is a {{site.konnect_saas}} functionality module that
lets you catalog all of your services in a single system of record. This
catalog represents the single source of truth of your organization’s service
inventory and their dependencies.

Using the Service Hub, you can catalog, manage, and track every service in your
entire architecture.

## Services in the Service Hub catalog

Each entry in the Service Hub is called a _{{site.konnect_short_name}} service_, or _service_.
A {{site.konnect_short_name}} service is an abstraction of an upstream service.

A service in the Service Hub breaks down into multiple
configuration _versions_, and can be _implemented_ to route to any
endpoint.

![{{site.konnect_short_name}} service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

* **Service**: The abstraction of one of
your own services. For example, it might represent a data
transformation microservice or a billing API.

* **Service version**: One instance, or implementation, of the
service with a unique configuration. A service can have many versions,
and each version can have different configurations, set up for a RESTful API,
gPRC endpoint, GraphQL endpoint, and others.

* **Service implementation**: A runnable service version. Each service version can only have one implementation.

A {{site.konnect_short_name}} service isn't associated with any specific runtime group, but every
service version is. When you create a version of the service, you must select a
group for the version to run on.

{:.note}
> **Note:** Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.

The main attribute of a service version is its upstream URL, where the service
listens for requests. You can specify the URL with a single string, or by
specifying its protocol, host, port, and path individually.

[Get started with service management &rarr;](/konnect/servicehub/manage-services)

### {{site.base_gateway}} implementations

When configuring a {{site.base_gateway}} implementation of a service, you'll
need to specify a route. Routes determine how successful requests are sent to
their services after they reach the API gateway. A single service version
can have only one implementation, but potentially many routes.

{:.important}
> **Important**: Starting with {{site.base_gateway}} 3.0.0.0, the router supports logical expressions.
Regex routes must begin with a `~` character. For example: `~/foo/bar/(?baz\w+)`.
Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).

After configuring the service, version, implementation, and at least one route,
you’ll be able to start making requests through {{site.konnect_saas}}.

[Implement a service version &rarr;](/konnect/servicehub/service-implementations)

## Dev Portal

Service Hub natively integrates the Dev Portal into service configuration.
Admins can publish services directly from Service Hub to the Dev Portal, where
application developers can search, discover, and consume existing services.

The Dev Portal in {{site.konnect_product_name}} contains an API catalog,
allowing you to document all of your services and their versions.

Through Service Hub, publish your service to the Dev Portal and set up
the following for any service:
* **Markdown documentation**: A description of your service. Applies to every
service version.
* **Version spec**: An OpenAPI (Swagger) document in YAML or JSON format.
Applies to a specific service version.

[Upload and publish service documentation to the Dev Portal &rarr;](/konnect/servicehub/service-documentation)

## {{site.base_gateway}} plugins

Plugins can be configured to run in a variety of contexts,
ranging from a specific service version or route to all service versions. Plugins
can execute actions inside {{site.konnect_product_name}} before or after a request
has been proxied to the upstream API, as well as on any incoming responses.

[Manage plugins &rarr;](/konnect/servicehub/plugins/)
