---
title: Create, Edit, and Delete Applications
toc: true
content_type: how-to
---


## Create an application

### Using the catalog

1. Sign in to the Dev Portal and click **Catalog**. Find the API product version you want to register for and click **Register**

1. Select **Create an application**. 

1. Complete the Create New Application form by providing your application's name, unique reference ID, and a brief description. Kong will auto select the appropriate auth strategy for the API product version you're registering for.

   {:.note}
   > The Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

1. After filling out the form, click **Create**. This will direct you back to the registration modal.

1. Choose your application from the list and click **Request Access** to proceed with the registration.


### Using My Apps 

1. Sign in to the Dev Portal and click **My Apps**. From the **My Apps** page, click the **New App** button to start creating a new application.

1. Complete the Create New Application form by entering your application's name, choosing an authentication strategy, providing a unique reference ID, and adding a description.

   {:.note}
   > The Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

   {:.important}
   > Your application may only be able to register for API Product versions that shares the same auth strategy.

1. After filling in the details, click **Create**. You'll be directed to your new application's details page where you can [generate credentials](/konnect/dev-portal/applications/dev-gen-creds/) and view registered services. 


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
