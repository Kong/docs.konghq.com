---
title: Dev Portal Overview
content_type: explanation
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services. The Dev Portal enables developers to browse and search API documentation, test API endpoints, and manage their own credentials. {{site.konnect_short_name}} offers flexible deployment options to support both internal and external APIs that can be managed from the same {{site.konnect_short_name}} instance.

## Publish service documentation

In {{site.konnect_short_name}}, API products can be published to the Dev Portal with one click. Published services become immediately available to users who have access to the Dev Portal. When a service is published, the API spec and any service document become discoverable. We use the term discoverable here because the Dev Portal can create a unified API experience where a developer can navigate through the different APIs that are available, read documentation, test endpoints within the Dev Portal, and register to create applications using your specific APIs.

* [Getting started guide](/konnect/getting-started/publish-service/): This guide walks you through importing an API spec, publishing your service and corresponding API spec to the Dev Portal, and configuring registration settings so that users can view your services and register applications.

* [API product Documentation](/konnect/api-products/service-documentation/): This doc explains how to upload and publish product documentation using the **API Products** dashboard and publish services to the Dev Portal so they can be publicly consumed.

* [Manage Konnect API product versions](/konnect/api-products/): This explains how to manage the API product version for your services, including the status of the API product version. API product versions can have a status of "Published", "Deprecated", or "Unpublished". 

### API specification

API specifications can be uploaded and attached to a specific API product version within the [**API Product**](https://cloud.konghq.com/api-products/). 
You can have different API specs that correspond to different API product versions.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

Once you've uploaded the spec, you can also preview the way the spec will render, including the methods available, endpoint descriptions, and example values. You'll also be able to filter by tag when in full-page view. 
The Dev Portal lives at a separate URL from {{site.konnect_short_name}} and requires that all users, including Admin roles, [register as a Developer](/konnect/dev-portal/dev-reg/).

## Developer self service

Dev Portals are created for developers to use. The Dev Portal removes the burden of credential management from the API creator, and empowers developers to manage aspects of the application development lifecycle on their own. 

Developers can interact with API product versions that have been exposed through API Products via applications. They can register and unregister applications, manage their own application API keys, and view analytics for their applications from the Dev Portal. 

For more information on this topic, we offer several pieces of documentation depending on your use case.

For {{site.konnect_short_name}} administrators:

* [Enabling and disabling application registration](/konnect/dev-portal/applications/enable-app-reg/) - This explains how to grant and rescind application registration access.
Manage developer access - This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage developer access](/konnect/dev-portal/access-and-approval/manage-devs/)- This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage application registration requests](/konnect/dev-portal/access-and-approval/manage-devs/) -  When developers want to create applications on your Dev Portal, they will have to create a request. Requests can be managed from within {{site.konnect_short_name}}. This document contains instructions on how to manage application requests. If you are interested in automatically allowing application requests automatically, read our guide on handling [auto approval](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).

For developers:

* [Developer registration and account management](/konnect/dev-portal/dev-reg/) - This explains how to register for a Dev Portal as well as the registration process and different registration states, for developers who want to register for the platform. It also explains account management information.

* [Manage Applications](/konnect/dev-portal/applications/dev-apps/) - Managing application registration requests.

* [Generate credentials for an application](/konnect/dev-portal/applications/dev-gen-creds/) - This guide walks you through the process of generating and deleting API keys on the Dev Portal platform.

### Contextual developer analytics 

You can view analytics for developer applications from within the {{site.konnect_short_name}} Dev Portal. This gives developers the ability to gain insights into all of their applications and the relationships between applications and APIs.

Each application has its own dashboard, which provides a high-level summary of the **Number of Requests**, **Average Error Rate**, and **p99 Latency**, and charts for the following data points: 

* Requests by version
* P99 latency by version
* Error code distribution 

All of these metrics can be viewed within a selected time frame of up to **Last 30 days**, over a period of the last 90 days.

{:.note}
> Free accounts only have access to a time frame of 24 hours.


## Customization

{{site.konnect_short_name}} has built-in customization options for managing the Dev Portal so that you can build a consistent experience for the consumers of your API. Customizing your Dev Portal to reflect the likeness of your brand can help convince Developers to create applications with your services. With {{site.konnect_short_name}}, you don’t need to have knowledge of any web frameworks, because you customize everything from the application. {{site.konnect_short_name}} also has built-in themes if customization is not your immediate priority.

For more information please read our doc on [customization](/konnect/dev-portal/customization/).


