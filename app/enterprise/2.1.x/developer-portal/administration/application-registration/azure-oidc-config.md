---
title: Set up External Portal Application Authentication with Azure AD and OIDC
---

## Overview

These instructions help you set up Azure AD as your third-party identity provider
for use with the Kong OIDC and Portal Application Registration plugins.

### Prerequisites

- The `portal_app_auth` configuration option is configured for your OAuth provider
  and strategy (`kong-oauth2` or `external-oauth2`). See
  [Configure the Authorization Provider Strategy](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/#portal-app-auth) for the Portal Application Registration plugin.

## Create an Application in Azure

1. Within Azure, go to the **App Registrations** service and register a new application.

   ![Azure App Registrations](/assets/images/docs/dev-portal/ms-azure-app-reg.png)

1. In **Certificates & secrets**, create a Client secret and save it in a
   secure location. You can only view the secret once.

1. Under **Manifest**, update `accessTokenAcceptedVersion=2` (default is null).
   The JSON for your application should look similar to this example:

  ![Azure Manifest](/assets/images/docs/dev-portal/azure-manifest.png)

## Create a Service and a Route in Kong

1. Create a Service example:

   ```bash
   http put :8001/services/httpbin-service-azure url=https://httpbin.org/anything
   ```
1. Create a Route example:

   ```bash
   http -f put :8001/services/httpbin-service-azure/routes/httpbin-route-azure paths=/httpbin-azure
   ```

## Map the OIDC and Application Registration Plugins to the Service

Map the OpenID Connect and Application Registration plugins to the **Service**.
The plugins must be applied to a Service to work properly.

1. Configure the OIDC plugin for the Service:

   ```bash
   http -f :8001/services/httpbin-service-azure/plugins name=openid-connect config.issuer=https://login.microsoftonline.com/<your_tenant_id>/v2.0 config.display_errors=true config.client_id=<your_client_id> config.client_secret="<your_client_secret>" config.consumer_claim=aud config.scopes=openid config.scopes=<your_client_id>/.default
   ```

1. Configure the Application Registration plugin for the Service:

   ```bash
   http -f :8001/services/httpbin-service-azure/plugins name=application-registration config.auto_approve=true config.display_name="For Azure" config.description="Uses consumer claim with various values (sub, aud, etc.) as registration id to support different flows and use cases." config.show_issuer=true
   ```

1. Get an access token using the Client Credential workflow and convert the token
   into a JSON Web Token (JWT). You can get the token from Azure or Kong. Replace
   the placeholder values for `<your_tenant_id>`, `<your_client_id>`, and `<your_client_secret>`.

   - Get a token from Azure:

     ```bash
     https -f POST "https://login.microsoftonline.com/<your_tenant_id>/oauth2/v2.0/token" scope=<your_client_id>/.default grant_type=client_credentials -a <your_client_id>:<your_client_secret>
     ```   

   - Get a token from Kong:

     ```bash
     https -f POST "https://localhost:8443/httpbin-azure/oauth2/v2.0/token" grant_type=client_credentials -a <your_client_id>:<your_client_secret> --verify NO
     ```

1. Paste the access token obtained from the previous step into
   [JWT](https://jwt.io), and copy the value for the
   [aud (audience)](https://tools.ietf.org/html/rfc7519#section-4.1.3) claim to
   your clipboard. You will use the `aud` value as your **Reference ID** for the next step.

## Create an Application in Kong

1. Log in to your Developer Portal and create a new application:
   - Select the **My Apps** menu -> **New Application**.
   - Enter the **Name** of your Azure application.
   - Paste the `aud` value generated in JWT in the **Reference ID** field.
   - (Optional) Enter a **Description**.

   The Create Application form should look similar to this example:

   ![Create Azure Application](/assets/images/docs/dev-portal/azure-app.png)

2. Click **Create**.

3. After you create your application, make sure you activate the Service. In the
   Services section of the Application Dashboard, click **Activate** on the Service
   you want to use.

   The view application details page should look similar to this example:

   ![Azure Example Application](/assets/images/docs/dev-portal/azure-app-details.png)

   Because you enabled
   [Auto-approve](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration##aa)
   on the associated Application Registration Plugin, an admin won't need to
   approve the request.

## Test your Authentication Flows with your Azure Application

Follow these instructions to test your client credentials or authorization code
flows with your Azure AD implementation.

### Test Client Credentials Flow

1. Get a token:

   ```bash
   https -f POST "https://localhost:8443/httpbin-azure/oauth2/v2.0/token" grant_type=client_credentials -a <your_client_id>:<your_client_secret> --verify NO
   ```

2. Use the token in an authorization header to retrieve the data:

   ```bash
   http :8000/httpbin-azure Authorization:'bearer <token_from_above>'
   ```

   Replace `<token_from_above>` with the bearer token you generated in the previous step.

### Test Authorization Code Flow

In your browser, go to `http://localhost:8000/httpbin-azure`. Replace `localhost`
with your host information.

You should be guided through a log in process within Azure and then the results
delivered in your browser.

## Troubleshoot

If you encounter any issues, review your data plane logs. Because you
enabled `display_errors=true` on the OpenID Connect Plugin, you will receive
more verbose error messages that can help pinpoint the issue.
