---
title: Generate Credentials for an Application
no_version: true
toc: true
---

The API key identifies and authenticates the developer application making a call. Use the API key either in the request URL (as a query parameter), or in the request header. An API key generated in the {{site.konnect_short_name}} Dev Portal is a 32-character string associated with an application.

You can generate multiple credentials and delete as needed.

## Prerequisites

[Create an Application](/konnect/dev-portal/developers/dev-apps#create-app-portal).

## General a Credential for an Application

1. From the Dev Portal, click the **Dashboard** menu under your login name.

   This opens the **My Apps** page.

2. Click the application for which you want to generate a credential.

3. In the **Authentication** pane, click **Generate Credential**.

4. Test the generated credential by making a call to the service the
   [application is registered with](/konnect/dev-portal/developers/dev-reg-app-service)
   using your `key-auth` credential (API key).

   ```
   <proxy-url>/<service>/?apikey=<apikey>
   ```

## Delete a Credential for an Application

1. Navigate to the application details page for an application.

2. In the **Authentication** pane, click the icon in the row for the credential you want to delete
   and click **Delete** from the context menu.

   ![Konnect Application Delete API Keys](/assets/images/docs/konnect/konnect-dev-gen-app-cred-api-key.png)
