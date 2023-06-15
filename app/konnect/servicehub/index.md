---
title: The Konnect Service Hub
subtitle: Track every service across your architecture
content-type: explanation
---

The Service Hub makes internal APIs discoverable, consumable, and reusable for internal development teams. Catalog all your services through the Service Hub to create a single source of truth for your organization’s service inventory. By leveraging Service Hub, your application developers can search, discover, and consume existing services to accelerate their time-to-market, while enabling a more consistent end-user experience across the organization’s applications.

**[Access the {{site.konnect_short_name}} service hub](https://cloud.konghq.com/us/servicehub).**

![{{site.konnect_short_name}} service hub](/assets/images/docs/konnect/konnect-servicehub.png)




## Service Package Dashboard


The Service Package Dashboard is the place to manage services, versions, and documentation. The dashboard is available by clicking any Service Package in the Service Hub. 

Here are some of the things you can do from the Service Package Dashboard: 

* Configure a service
* Publish a service to the Dev Portal
* Manage versions and labels. 
* View traffic, error, and latency data. 


![{{site.konnect_short_name}} service hub](/assets/images/docs/konnect/konnect-service-package-versions.png)


Number | Item | Description
-------|------|------------
1 | **Service Versions** | This section displays the status of a service version. From the context menu you can **Delete** a service version, or use the **View Details** button to navigate to that versions dashboard. 
2 | **Analytics** | Analytics data for the service. You can configure the analytics options using the [**Analytics tool**](/konnect/analytics/)
3 | **Documentation** | You can add markdown documentation for your service, as well as an API specification for each version of the service. You can control the individual publishing status of each document you upload to a service.



### Service versions

A {{site.konnect_short_name}} service version is associated with a [runtime group](/konnect/runtime-manager/runtime-groups/). As such, the configurations, plugins, specific implementations that are associated with the runtime group are also associated with the service version. 

Services can have multiple service versions, and each version can be associated with a different runtime group. Services can be made available in multiple environments by creating service versions in different runtime groups.

A common use case is environment specialization.
For example, if you have three runtime groups for `development`, `staging`, and
`production`, you can manage which environment the service is available in by
assigning a version to that group at creation time. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.


### Analytics

The analytics dashboard shown in the **Service Dashboard** is a high level overview of **traffic**, **error**, and **latency** for the service. These reports are generated automatically based on the traffic to the service. 

Learn more: 

* [Analytics overview](/konnect/analytics/)
* [How to analyze services and routes](/konnect/analytics/services-and-routes/)
* [How to generate reports](/konnect/analytics/generate-reports/)

### Documentation

The **Service Dashboard** can be used to manage documentation for your service. Documentation can be either an API spec, or Markdown documentation for the service. Once the documentation is uploaded it can be edited from the dashboard. The documentation can be accessed once the service is published.

Learn more: 

* [Manage service documentation](/konnect/servicehub/service-documentation/)

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

### Plugins

Plugins can be configured to run in a variety of contexts, ranging from a specific service version or route to all service versions. Plugins can execute actions inside Kong Konnect before or after a request has been proxied to the upstream API, as well as on any incoming responses.

Learn more:

* [Manage Plugins](/konnect/servicehub/plugins/)
