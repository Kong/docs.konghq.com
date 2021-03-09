---
title: Working with Applications
no_version: true
toc: true
---

Create, edit, and delete applications in the {{site.konnect_short_name}} Dev Portal.

## Prerequisite

[Register](/konnect/dev-portal/developers/dev-reg) for developer access to the {{site.konnect_short_name}} Dev Portal.

## Create an Application {#create-app-portal}

Developers can create applications from the {{site.konnect_short_name}} Dev Portal.

1. Log in to the {{site.konnect_short_name}} Dev Portal.

2. Click the arrow by your login name to open a menu and click **Dashboard**.

   ![Konnect Dev Portal Dashboard Menu](/assets/images/docs/konnect/konnect-dev-portal-menu.png)

   The My Apps page is displayed. The first time you access this page, it is empty.

   ![Konnect Dev Portal Empty My Apps Page](/assets/images/docs/konnect/konnect-dev-portal-my-apps-empty.png)

3. Click **+ New App**. The Create New Application dialog is displayed.

   ![Konnect Dev Portal Create New App](/assets/images/docs/konnect/konnect-portal-create-app.png)

4. (Required) Enter an **Application name**.

   The application name must be unique.

5. (Required) Enter a **Reference ID**.

   The Reference ID must be unique. If your organization is using the
   [OIDC](/konnect/dev-portal/administrators/app-registration/enable-app-reg#oidc-flow)
   flow for application registration, enter the ID of your third-party OAuth2 claim.

6. (Optional) Enter a **Description** of your application.

7. Click **Create**.

   The [application details](#app-details-page) page is displayed for the newly created application.

   ![Konnect Dev Portal New App Details Page](/assets/images/docs/konnect/konnect-new-app-details-page.png)


## View Application Details {#app-details-page}

The application details page displays the application name, its description, Reference ID,
authentication credentials, and Services with which an application is registered.

To access this page:

1. Click **Dashboard** from the menu under your login name.

2. In the My Apps page, click on an application.

From this page, you can:

- [Edit](#edit-my-app) the name, reference ID, and description of your application.
- [Generate or delete credentials](/konnect/dev-portal/developers/dev-gen-creds).
- View the Catalog of Services you can [register your application](/konnect/dev-portal/developers/dev-reg-app-service) with,
  if no applications have a registration request yet. You can also create an application
  on the fly when registering an application with a Service.
- View the status of an application registration to a Service.

  ![Konnect Dev Portal Populated App Details Page](/assets/images/docs/konnect/konnect-pop-app-details-page.png)

## Edit an Application {#edit-my-app}

Edit basic details like the name, reference ID, and description of your application. You can also
[delete your application](#delete-my-app) from the Update Application dialog.

1. From the [application details page](#app-details-page), click **Edit**.

   The Update Application dialog is displayed.

   ![Update App Details Dialog](/assets/images/docs/konnect/konnect-edit-app.png)

2. Make your changes and click **Update**.

## Delete an Application {#delete-my-app}

Delete your application from the {{site.konnect_short_name}} Dev Portal. You can delete an application
from the following locations:

- In your **Dashboard > My Apps** page, click the icon for the app you want to delete and choose **Delete**.

  ![Konnect Dev Portal Delete an App](/assets/images/docs/konnect/konnect-portal-delete-app.png)

- In the [Update Application](#edit-my-app) dialog, click **Delete**.

You are prompted to confirm the deletion.
