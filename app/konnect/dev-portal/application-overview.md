---
title: Application Overview
no_version: true
toc: true
---

Applications contain Services and authentication settings. Admins [enable application registration](konnect/dev-portal/administrators/app-registration/enable-app-reg/) so that Developers can associate Services with Applications. 

For a Developer to be able to manage applications, they must be [granted access by an admin](/konnect/dev-portal/administrators/manage-devs/) to the {{site.konnect_short_name}} Dev Portal, they will be able to manage applications. For more information about registering for a {{site.konnect_short_name}} Dev Portal as a Developer, see [Developer Registration](/konnect/dev-portal/developers/dev-reg/). 

{:.note}
> **Note**: The following is all done through the Dev Portal, not through [konnect.konghq.com](https://konnect.konghq.com). As an admin, find the Dev Portal URL via **Dev Portal** > **Published Services**. 

## Application summary

What are “applications” in this context?

How do they relate to Dev Portal? How do they relate to Konnect?

Applications are created through Dev Portal through **My Apps** in the top right dropdown menu under your login email. 

On the admin side through [konnect.konghq.com](https://konnect.konghq.com), admins can enable app registration on a Service-by-Service basis. At this time, admins also select the authentication type that applies to that Service. Going back to the Dev Portal, Developers are then able to go to a Service, and click **Register**. 

Who works with applications? Who manages them?

Developers work with applications and admins manage them. 

What can you do with applications in Konnect?

## Services and applications

How are services and applications related? What’s the purpose of tying an application to a service? What benefit does that provide?

Services optionally belong to Applications. The purpose of tying a Service to an Application is to gain the configurations on the Application level. The benefits of registering a Service to an Application is gaining another layer of authentication. 

Services that are registered to Applications will receive top-level configurations, including authentication. 

## Application authentication

What are the authentication options? Why would you choose one over another (unsure if this is relevant, or if this is just dependent on the user’s existing environment)
