---
title: Application Overview
no_version: true
toc: true
---

Applications consume Services in {{site.konnect_short_name}} via Application-level authentication. Developers use Applications they create through the {{site.konnect_short_name}} Dev Portal. 

Admins [enable application registration](konnect/dev-portal/administrators/app-registration/enable-app-reg/) through [konnect.konghq.com](https://konnect.konghq.com) so that Developers can associate Services with Applications. 

For a Developer to be able to manage Applications, they must be [granted access by an admin](/konnect/dev-portal/administrators/manage-devs/) to the {{site.konnect_short_name}} Dev Portal. For more information about registering for a {{site.konnect_short_name}} Dev Portal as a Developer, see [Developer Registration](/konnect/dev-portal/developers/dev-reg/). 

## Applications and Services

Multiple Services can be registered to a single Application. In the {{site.konnect_short_name}} Dev Portal, Services registered to an Application will be listed in the Application detail page, available through **My Apps** in the top-right corner dropdown menu beneath the Developer's login email. 

The purpose of registering Services to an Application is to consume those Services using the Application-level authentication. Grouping authentication enables most succinct access to the Services, and a more organized Application interface with many different Services.  

As an example, the Application can represent a mobile banking app and the Services I may use are a billing API, users API, and legal agreements API. 

## Application authentication

Generate Application credentials through the {{site.konnect_short_name}} Dev Portal in the Application detail page. The Application can have multiple credentials, or API keys. For more information about Application Credentials, refer to [Generate Credentials for an Application](/konnect/dev-portal/developers/dev-gen-creds/). 

In [konnect.konghq.com](https://konnect.konghq.com), admins can access a list of the installed authentication plugins via **Shared Config**. See [Enable Application Registration for a Service](/konnect/dev-portal/administrators/app-registration/enable-app-reg/) for more information about authentication flows. 
