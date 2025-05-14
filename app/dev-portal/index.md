---
title: Dev Portal
---

Konnect Dev Portal is a customizable website for developers to locate, access, and consume API services. The Dev Portal enables developers to browse and search API documentation, try API operations, and manage their own credentials. {{site.konnect_short_name}} offers flexible deployment options to support both internal and external APIs that can be managed from {{site.konnect_short_name}}.

Konnect Dev Portal's **APIs** allows you to publish APIs with OpenAPI specifications and/or Markdown documentation, to enable developers to locate, access, and consume API services. Highly customizable content can be also provided at the site-level, as well as API-level, to provide additional context to the APIs.

{:.note}
> *This is documentation for Konnect's new **Dev Portal BETA**. Be aware of potential instability compared to our [classic Dev Portal](/konnect/dev-portal)*

![KongAir Dev Portal](/assets/images/products/konnect/dev-portal-v3/kongair-example.png)

## Get Started

* [Portals](#portals): create Developer Portals with appropriate visibility & access control for each audience.
* [APIs](#apis): create API specifications & documentation to be published to one or more Dev Portals
* [Developer Self Service](#developer-self-service): create authentication strategies that define how Developers will acquire API keys.

## Portals

{{site.konnect_short_name}} allows you to publish, document and secure APIs to drive adoption for any developer audience. Multiple Dev Portals can be created based on a selection of APIs, set to appropriate visibility and access control. 

[Get started](/dev-portal/portals) creating your first Dev Portal.

## APIs

Konnect Dev Portal APIs are a repository of API specifications and documentation, optionally versioned, which can be published to one or more portals. This allows you to maintain a source of truth for all of your APIs, and publish those APIs to Dev Portals which address developer audiences with appropriate access controls.

[Get started](/dev-portal/apis) creating your APIs.

{:.note}
> **API Products** are not utilized by Beta Dev Portals, API Products are only used in the [classic version](/konnect/dev-portal) of Dev Portal.

## Developer Self-Service

Common ways to get started in configuring appropriate access controls for Developers to acquire API keys.

* [Enabling and disabling application registration](/dev-portal/app-reg/) - This explains how to grant and revoke application registration access.

* [Access and approvals](/dev-portal/access-and-approvals/) - The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal, including Developer and Application registration. Additionally, Teams can be created to provide role-based access to  set of APIs to a set of Developers.

## Analytics

### Contextual developer application analytics

Developers can view analytics for authenticated traffic from their registered applications within the {{site.konnect_short_name}} Dev Portal. These metrics help developers monitor usage patterns and understand how different API are being consumed.

![Dev Portal Analytics](/assets/images/products/konnect/dev-portal-v3/dev-portal-analytics.png)
> _**Figure 1:** An example dashboard for an application_

Each application has its own dashboard, which provides a high-level summary of the **Number of Requests**, **Average Error Rate**, and **Latency**, and charts for the following data points:

* Requests by API
* Latency by API
* Error code distribution

All of these metrics can be viewed within a selected time frame of up to 90 days.

### Konnect contextual analytics

Konnect provides built-in contextual analytics across the Dev Portal, offering insights for portals, APIs, and applications. These platform-wide metrics help administrators monitor overall usage, performance, and traffic trends.

![Konnect Portal Analytics](/assets/images/products/konnect/dev-portal-v3/konnect-portal-analytics.png)
> _**Figure 1:** An example of Konnect contextual analytics for an API version_

In addition to these high-level insights, administrators can explore the Konnect Analytics section to create custom reports, build dashboards, and view detailed request data for a more comprehensive and flexible understanding of portal activity.
