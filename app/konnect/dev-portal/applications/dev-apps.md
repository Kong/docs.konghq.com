---
title: Create, Edit, and Delete Applications
toc: true
content_type: how-to
---


## Create an application

To create a new application, log in to the Dev Portal and click **My Apps**. From the **My Apps** page, follow these instructions: 

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name, reference ID, and description.

   {:.note}
   > Note that the Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

3. Click **Create** to save your application. You will automatically be sent to the new application's details page. 

From the **Application Page** you can [generate credentials](/konnect/dev-portal/applications/dev-gen-creds/) and view registered services. 

## Edit an Application

Once an application is created, you can edit the name, reference ID, or description from the edit menu.
To edit an application, navigate to the **My Apps** page of the Dev Portal by clicking **My Apps** in the dropdown under your login name, then follow these instructions: 

1. Select the specific application you want to edit. 

2. Use the **Edit** button to open the **Update Application** form. 

3. When you are satisfied with your changes, click **Update**. 

You can edit the **application name**, **reference ID**, and **description**. A reference ID must be unique across all of the registered applications. 

## Delete an Application

To permanently delete an application from the Dev Portal, follow these steps:

1. From the **My Apps** page, click the {% konnect_icon cogwheel %} icon next to an application, then click **Delete**.

2. Confirm deletion from the pop-up modal.

{:.note}
> **Note:** Deleting an application can't be undone. 