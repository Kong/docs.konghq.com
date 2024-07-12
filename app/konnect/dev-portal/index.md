---
title: Dev Portal Overview
content_type: explanation
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services. The Dev Portal enables developers to browse and search API documentation, test API endpoints, and manage their own credentials. {{site.konnect_short_name}} offers flexible deployment options to support both internal and external APIs that can be managed from {{site.konnect_short_name}}.

## Dev Portal use cases

You can use the following table to help you determine which Dev Portal configurations are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Publish APIs to two Dev Portals, one for internal developers and one for external partner developers | [Multi-portal](/konnect/dev-portal/create-dev-portal/) |
| Allow developers get API keys and start using your APIs | [Enable app reg and Dev Portal](/konnect/dev-portal/applications/enable-app-reg/) |
| Determine which users can see which APIs in Dev Portal | [Assign different APIs and permissions with RBAC Teams](/konnect/api/portal-auth/portal-rbac-guide/#main) |
| Self-host or visually customize your Dev Portal | [Self-hosted Dev Portal](/konnect/dev-portal/customization/self-hosted-portal/) |
| Publish documentation for your APIs | [Add and publish API product documentation](/konnect/dev-portal/publish-service/) |

For more information about developer self-service with Dev Portal, we offer several pieces of documentation depending on your use case.

{% navtabs %}
{% navtab Konnect admin %}
* [Enabling and disabling application registration](/konnect/dev-portal/applications/enable-app-reg/) - This explains how to grant and revoke application registration access.
Manage developer access - This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage developer access](/konnect/dev-portal/access-and-approval/manage-devs/)- This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage application registration requests](/konnect/dev-portal/access-and-approval/manage-devs/) -  When developers want to create applications on your Dev Portal, they will have to create a request. Requests can be managed from within {{site.konnect_short_name}}. This document contains instructions on how to manage application requests. If you are interested in automatically allowing application requests automatically, read our guide on handling [auto approval](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).
{% endnavtab %}
{% navtab Developers %}
For developers, see [Register and create an application as a developer](/konnect/dev-portal/register-and-create-app/).
{% endnavtab %}
{% endnavtabs %}

## Contextual developer application analytics 

You can view analytics for your applications from within the {{site.konnect_short_name}} Dev Portal. This helps you gain insight into your consumption of different API versions, routes, and methods.

Each application has its own dashboard, which provides a high-level summary of the **Number of Requests**, **Average Error Rate**, and **p99 Latency**, and charts for the following data points: 

* Requests by version
* P99 latency by version
* Error code distribution 

All of these metrics can be viewed within a selected time frame of up to **Last 30 days**, over a period of the last 90 days.

{:.note}
> Free accounts only have access to a time frame of 24 hours.


