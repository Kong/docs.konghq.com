---
title: Konnect Service Package Dashboard
---

The Konnect Service Package Dashboard is the place to manage service packages, versions, and Documentation. The dashboard is available by clicking any Service Package in the Service Hub. 

Here are some of the things you can do from the Service package Dashboard: 

* Configure a service
* Publish a service to the Developer Portal
* Manage versions and labels. 
* View traffic, error, and latency data. 


![{{site.konnect_short_name}} service hub](/assets/images/docs/konnect/konnect-service-package-versions.png)



Number | Item | Description
-------|------|------------
1 | **Service Versions** | This section displays the status of a service version. From the context menu you can **Delete** a service, or use the **View Details** button to navigate to that versions dashboard. 
2 | **Analytics** | Analytics data for the service. You can configure the analytics options using the [**Analytics tool**](/konnect/analytics/)
3 | **Documentation** | Dashboard for cluster-wide monitoring. Use the dashboard to: <br> &nbsp;&nbsp;&bull; View request activity <br> &nbsp;&nbsp;&bull; Track proxy 

<!-- SHARING IS NOT YET AVAILABLE
## Share a service

If you have a Service Admin or Organization Admin role, you can share any
service that you have access to.

For more information, see [Manage Teams, Roles, and Users](/konnect/org-management/teams-and-roles/#entity-and-role-sharing).

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Click **Share service**.

1. Select a user or team to share the service with.

1. Select a role to grant to the user or team.

1. Click **Share service** to save.
-->

### Service Packages

Each entry in the Service Hub is called a _{{site.konnect_short_name}} service package_.
A {{site.konnect_short_name}} service package is an abstraction of an upstream service that can break down into multiple
configuration _versions_, and can be _implemented_ to route to any existing
endpoint.

* **Service**: The abstraction of one of
your own services. For example, it might represent a data
transformation microservice or a billing API.

* **Service version**: One instance, or implementation, of the
service with a unique configuration. A service can have many versions,
and each version can have different configurations, set up for a RESTful API,
gPRC endpoint, GraphQL endpoint, and others.

* **Service implementation**: A runnable service version. Each service version can only have one implementation.
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
