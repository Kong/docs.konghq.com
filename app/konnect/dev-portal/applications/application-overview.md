---
title: Applications Overview
toc: true
content_type: explanation
---

Multiple services can be registered to a single application as long as they share the same authentication strategy. In the {{site.konnect_short_name}} Dev Portal, services registered to an application are listed in an application's detail page. You can find all applications in your account by clicking **My Apps** from the dropdown menu under your login email in the Dev Portal.

The purpose of registering services to an application is to consume those services using application-level authentication. Grouping authentication enables direct access to multiple services. The application can host multiple credentials or API keys. For more information about application credentials, refer to [Generate Credentials for an Application](/konnect/dev-portal/applications/dev-gen-creds/).

In [cloud.konghq.com](https://cloud.konghq.com), admins can access a list of the installed authentication plugins via the **Gateway Manager**. See [Enable Application Registration for a Service](/konnect/dev-portal/applications/enable-app-reg/) for more information about authentication flows.

Once a developer is [granted access](/konnect/dev-portal/access-and-approval/manage-devs/) to the {{site.konnect_short_name}} Dev Portal, they can create, edit, and delete applications. These modifications are all managed on the **My Apps** page. **My Apps** allows you to view all of your registered applications. Clicking on individual applications from this page opens a detailed overview of an application.

You can perform the following actions from an application's details page:

- [Edit](#edit-an-application) the name, reference ID, and description of an application.
- [Generate or delete credentials](/konnect/dev-portal/applications/dev-gen-creds/).
- View a catalog of services that can be [registered with the application](/konnect/dev-portal/applications/dev-reg-app-service/), if no services are registered yet.
- View the status of an application registration to an API product.
- Open the analytics dashboard and view metrics about an application.

The guides within this section cover these topics:

* [How to create, edit and delete applications](/konnect/dev-portal/applications/dev-apps/)
* [How to enable and disable app registration](/konnect/dev-portal/applications/enable-app-reg/)
* [How to register or unregister an application for a Service](/konnect/dev-portal/applications/dev-reg-app-service/)
* [How to generate credentials for an application](/konnect/dev-portal/applications/dev-gen-creds/)
