---
title: Create, Edit, and Delete Applications
toc: true
content_type: how-to
---


## Create an application


Flow 1: From Catalog (if you're not sure which auth strategy to use)

1. Log into the Dev Portal and click **Catalog**. After you've found the API Product version you wish to register for, click **Register**

2. If you have existing applications that can register for this API Product version, skip to step 5. Otherwise, you will see a prompt that you currently have no applications to register with. Click **Create an application** to create a new application

3. Fill out the **Create New Application** form with your application name, reference ID, and description. Note: Kong will auto select the appropriate auth strategy for the API product version you're registering for.

   {:.note}
   > Note that the Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

5. Click **Create** and you will be redirected back to the Register modal.

6. Select your application name and click **Request Access**


Flow 2: From My Apps (if you know which auth strategy to use)

1. To create a new application, log in to the Dev Portal and click **My Apps**. From the **My Apps** page, click the **New App** button.

2. Fill out the **Create New Application** form with your application name, auth strategy, reference ID, and description. 

   {:.note}
   > Note that the Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

   {:.note}
   > Note: your application be only be able to register for API Product versions that share the same auth strategy.

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
