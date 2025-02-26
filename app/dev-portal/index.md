---
title: Dev Portal
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services. The Dev Portal enables developers to browse and search API documentation, try API operations, and manage their own credentials. {{site.konnect_short_name}} offers flexible deployment options to support both internal and external APIs that can be managed from {{site.konnect_short_name}}.

The Konnect Dev Portal allows you to publish APIs with OpenAPI specifications and/or Markdown documentation, to enable developers to locate, access, and consume API services. Highly customizable content can be also provided at the site-level, as well as API-level, to provide additional context to the APIs.

* [Portals](#portals): create Developer Portals with appropriate visibility & access control for each audience.
* [APIs](#apis): create API specifications & documentation to be published to one or more Dev Portals
* [Developer Self Service](#developer-self-service): create authentication strategies that define how Developers will acquire API keys.

## Portals

{site.konnect_short_name} Dev Portals allow you to publish, document and secure APIs to drive adoption for any developer audience. Multiple Dev Portals can be created based on a selection of APIs, set to appropriate visibility and access control. 

[Get started](portals) creating your first Dev Portal.

## APIs

Konnect Dev Portal APIs are a repository of API specifications and documentation, optionally versioned, which can be published to one or more portals. This allows you to maintain a source of truth for all of your APIs, and publish those APIs to Dev Portals which address developer audiences with appropriate access controls.

[Get started](APIs) creating your APIs.

{:.note}
> **API Products are not utilized by Beta Dev Portals, API Products are only used in the previous version of Dev Portals


## Developer Self-Service

Common ways to get started in configuring appropriate access controls for Developers to acquire API keys.

* [Enabling and disabling application registration](app-reg/) - This explains how to grant and revoke application registration access.

* [Access and approvals](access-and-approvals/) - The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal, including Developer and Application registration. Additionally, Teams can be created to provide role-based access to  set of APIs to a set of Developers.


<!--
TODO: Update analytics for Beta, add screenshots
## Contextual developer application analytics 

You can view analytics for your applications from within the {{site.konnect_short_name}} Dev Portal. This helps you gain insight into your consumption of different API versions, routes, and methods.

TODO: Needs screenshot

Each application has its own dashboard, which provides a high-level summary of the **Number of Requests**, **Average Error Rate**, and **Latency**, and charts for the following data points: 

* Requests by version
* Latency by version
* Error code distribution 

All of these metrics can be viewed within a selected time frame of up to **30 days**, over a period of the last 90 days.
 -->