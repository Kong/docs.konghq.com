---
title: Applications and Services
no_version: true
toc: true
---

Multiple Services can be registered to a single Application. In the {{site.konnect_short_name}} Dev Portal, Services registered to an Application will be listed in the Application detail page, available through **My Apps** in the top-right corner dropdown menu beneath the Developer's login email.

The purpose of registering Services to an Application is to consume those Services using the Application-level authentication. Grouping authentication enables direct access to multiple Services. The Application can have multiple credentials, or API keys. For more information about Application Credentials, refer to [Generate Credentials for an Application](/konnect/dev-portal/applications/dev-gen-creds/).

In [cloud.konghq.com](https://cloud.konghq.com), admins can access a list of the installed authentication plugins via **Shared Config**. See [Enable Application Registration for a Service](/konnect/dev-portal/applications/enable-app-reg/) for more information about authentication flows.

Once a developer is [granted access](/konnect/dev-portal/access-and-approval/manage-devs/) to the {{site.konnect_short_name}} Dev Portal, they will be able to create, edit, and delete applications. These modifications are all managed on the **My Apps** page. The **My Apps** allows you to view all of the registered applications. Clicking on individual applications from this page opens a detailed overview of an application. You can do the following through the application details page:

- [Edit](#edit-an-application) the name, reference ID, and description of an application.
- [Generate or delete credentials](/konnect/dev-portal/access-and-approval/dev-gen-creds).
- View a catalog of Services that can be [registered with the application](/konnect/dev-portal/applications/dev-reg-app-service), if no Services are registered yet.
- View the status of an application registration to a Service.

{:.note}
> **Note**: The following steps are all done through the Dev Portal, not through [cloud.konghq.com](https://cloud.konghq.com). You can find the Dev Portal URL from the **Dev Portal** menu in the left-hand menu.

## Create an Application

1. In the {{site.konnect_short_name}} Dev Portal, click  the dropdown menu in the upper right corner of the application, from there, click **My Apps**.

2. On the **My Apps** page, click the **New App** button.

3. Fill out the **Create New Application** form with your application name, reference ID, and description.

   {:.note}
   > Note that the Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

4. Click **Create** to save and your application. You will automatically be sent to your new application's detail page. 

## Edit an Application

Once an application is created, you can edit the name, reference ID, or description of your application from the edit menu. 

1. Navigate to the **My Apps** page of the Dev Portal by clicking **My Apps** in the dropdown under your login name.

2. From the **My Apps** page, select the specific application you want to edit. 

3. Use the **Edit** button in right portion of the screen to open the **Update Application** page. 

4. When you are satisfied with your changes, click **Update**. 

## Delete an Application

Applications can be permanently deleted from the Developer Portal. Applications can be deleted from the **Update Application** page.They can also be deleted from the **My Apps** page.  

1. From the **My Apps** page, click the cog icon next to an application and click **Delete**.

2. Confirm deletion in the pop-up modal.

