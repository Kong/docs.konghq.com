---
title: Generate Credentials for an Application
no_version: true
toc: true
---

A credential, or API key, identifies and authenticates the developer application making a request. Use the API key either in the request URL as a query parameter, or in the request header.

You can permanently delete any credential at any time. See [Delete a credential](#delete-a-credential).

## Generate a credential

A credential, or API key, generated in the {{site.konnect_short_name}} Dev Portal is a 32-character string associated with an Application. An Application can have multiple credentials.

1. In the Dev Portal, click **My Apps** from the dropdown menu under your login email.

2. Click the Application for which you want to generate a credential.

3. In the **Authentication** pane, click **Generate Credential**.

4. Test the generated credential by making a call to the service the
   [Application is registered with](/konnect/dev-portal/applications/dev-reg-app-service)
   using your `key-auth` credential:

   ```
   {PROXY_URL_OR_PROXY_IP}/{ROUTE}?apikey={APIKEY}
   ```

## Delete a credential

You can permanently delete a credential. Note that the credential cannot be restored.

1. Navigate to an application's details page.

2. In the **Authentication** pane, click the cog icon of the credential you want to permanently delete and click **Delete**.
