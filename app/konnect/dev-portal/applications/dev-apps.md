---
title: Create, Edit, and Delete an Application
no_version: true
toc: true
---

After a Developer is [granted access by an admin](/konnect/dev-portal/access-and-approval/manage-devs/) to the {{site.konnect_short_name}} Dev Portal, they will be able to create, edit, and delete applications.

For more information about registering for a {{site.konnect_short_name}} Dev Portal as a Developer, see [Developer Registration](/konnect/dev-portal/access-and-approval/dev-reg/).

{:.note}
> **Note**: The following is all done through the Dev Portal, not through [konnect.konghq.com](https://konnect.konghq.com). As an admin, find the Dev Portal URL via **Dev Portal** > **Published Services**.

## Create an Application

Developers can create an application and link it to a Service.

1. In the {{site.konnect_short_name}} Dev Portal, click **My Apps** from the dropdown menu in the upper right corner under your login email.

2. On the **My Apps** page, click the **New App** button.

3. Fill out the **Create New Application** form with your application name, reference ID, and description. Note that the Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

4. Click **Create** to save and see your new application's detail page.    

## View Application Details

Access and modify applications from an application's details page. Find a list of your current applications on the **My Apps** page, accessible through the dropdown menu in the top right corner under your login email.

You can do the following through the application details page:

- [Edit](#edit-an-application) the name, reference ID, and description of an application.
- [Generate or delete credentials](/konnect/dev-portal/access-and-approval/dev-gen-creds).
- View a catalog of Services that can be [registered with the application](/konnect/dev-portal/applications/dev-reg-app-service), if no Services are registered yet.
- View the status of an application registration to a Service.

## Edit an Application

Edit the name, reference ID, and description of your application by going to **My Apps** in the dropdown menu under your login email, selecting your application, and clicking **Edit**.

## Delete an Application

You can permanently delete an Application from the Dev Portal:

- On the **My Apps** page in the dropdown menu under your login email, click the cog icon next to an application and click **Delete**.

- Confirm deletion in the pop-up modal.

You can also delete an application from the application details page. See [Edit an Application](#edit-an-application). 
