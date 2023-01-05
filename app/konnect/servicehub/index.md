---
title: The Konnect Service Hub
subtitle: Track every service accross your architecture
content-type: explanation
---

The Service Hub makes internal APIs discoverable, consumable, and reusable for internal development teams. Catalog all your services through the Service Hub to create a single source of truth for your organization’s service inventory. By leveraging Service Hub, your application developers can search, discover, and consume existing services to accelerate their time-to-market, while enabling a more consistent end-user experience across the organization’s applications.

![{{site.konnect_short_name}} service hub](/assets/images/docs/konnect/konnect-servicehub.png)


**[Access the {{site.konnect_short_name}} service hub](https://cloud.konghq.com/us/servicehub).**
## Service packages

Each entry in the Service Hub is called a _{{site.konnect_short_name}} service package_.
A {{site.konnect_short_name}} service package is an abstraction of an upstream service that can break down into multiple
configuration _versions_, and can be _implemented_ to route to any existing
endpoint. For example a data transformation microservice, or a billing API. You can create new service packages from the **Service Hub Dashboard**.

## Versions

A version is an instance, or implementation, of a service package with a unique configuration. Service packages can have many versions,
and each version can have different configurations, set up for a RESTful API,
gPRC endpoint, GraphQL endpoint, and others.


For information about service packages and versions read the [Service Packages and Versions](/konnect/manage-services/) documentation.