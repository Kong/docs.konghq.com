---
title: Set Up External Portal Application Authentication with Azure AD and OIDC
badge: enterprise
---

These instructions help you set up Azure AD as your third-party identity provider
for use with the Kong OIDC and Portal Application Registration plugins.

## Prerequisites

- The `portal_app_auth` configuration option is configured for your OAuth provider
  and strategy (`kong-oauth2` or `external-oauth2`). See
  [Configure the Authorization Provider Strategy](/gateway/{{page.release}}/kong-enterprise/dev-portal/applications/auth-provider-strategy/) for the Portal Application Registration plugin.

## Create an application in Azure

1. Within Azure, go to the **App registrations** service and register a new application.

2. In **Certificates & secrets**, create a Client secret and save it in a
   secure location. You can only view the secret once.

3. Under **Manifest**, update `accessTokenAcceptedVersion=2` (default is null).
   The JSON for your application should look similar to this example:

## Create a service in Kong

```bash
curl -i -X PUT http://localhost:8001/services/httpbin-service-azure \
  --data 'url=https://httpbin.org/anything'
```

## Create a route in Kong

```bash
curl -i -X PUT http://localhost:8001/services/httpbin-service-azure/routes/httpbin-route-azure \
  --data 'paths=/httpbin-azure'
```

## Map the OIDC and Application Registration plugins to the service

Map the OpenID Connect and Application Registration plugins to the **Service**.
The plugins must be applied to a Service to work properly.

1. Configure the OIDC plugin for the service:

    ```bash
    curl -X POST http://localhost:8001/services/httpbin-service-azure/plugins \
      --data name=openid-connect \
      --data config.issuer="https://login.microsoftonline.com/<your_tenant_id>/v2.0" \
      --data config.display_errors="true" \
      --data config.client_id="<your_client_id>" \
      --data config.client_secret="<your_client_secret>" \
      --data config.redirect_uri="https://example.com/api" \
      --data config.consumer_claim=aud \
      --data config.scopes="openid" \
      --data config.scopes="YOUR_CLIENT_ID/.default" \
      --data config.verify_parameters="false"
    ```

    For more information, see [OIDC plugin](/hub/kong-inc/openid-connect/).


2. Configure the Application Registration plugin for the service:

    ```bash
    curl -X POST http://localhost:8001/services/httpbin-service-azure/plugins \
      --data "name=application-registration"  \
      --data "config.auto_approve=true" \
      --data "config.description=Uses consumer claim with various values (sub, aud, etc.) as registration id to support different flows and use cases." \
      --data "config.display_name=For Azure" \
      --data "config.show_issuer=true"
    ```

3. Get an access token from Azure using the Client Credential workflow and convert the token
into a JSON Web Token (JWT). Replace the placeholder values with your values for
`<your_tenant_id>`, `<your_client_id>`,`<your_client_secret>`, and
`<admin-hostname>`.

    ```bash
    curl -X POST https://login.microsoftonline.com/<your_tenant_id>/oauth2/v2.0/token \
      --data scope="<your_client_id>/.default" \
      --data grant_type="client_credentials" \
      --data client_id="<your_client_id>" \
      --data client_secret="<your_client_secret>" \
    ```

4. Convert an access token into a JWT token:

    1. Paste the access token obtained from the previous step into
    [JWT](https://jwt.io).

    2. Click **Share JWT** to copy the value for the
    [aud (audience)](https://tools.ietf.org/html/rfc7519#section-4.1.3) claim to
    your clipboard. You will use the `aud` value as your **Reference ID** in the
    next procedure.

## Create an Application in Kong

1. Log in to your Dev Portal and create a new application:
   1. Select the **My Apps** menu -> **New Application**.
   2. Enter the **Name** of your Azure application.
   3. Paste the `aud` value generated in JWT in the **Reference ID** field.
   4. (Optional) Enter a **Description**.

2. Click **Create**.

3. After you create your application, make sure you activate the Service. In the
   Services section of the Application Dashboard, click **Activate** on the Service
   you want to use.

   Because you enabled
   [Auto-approve](/gateway/{{page.release}}/kong-enterprise/dev-portal/applications/enable-application-registration##aa)
   on the associated Application Registration Plugin, an admin won't need to
   approve the request.

## Test your Authentication Flows with your Azure Application

Follow these instructions to test your client credentials or authorization code
flows with your Azure AD implementation.

1. Get a token:

    ```bash
    curl -X POST "https://login.microsoftonline.com/<your_tenant_id>/oauth2/v2.0/token" \
    --data scope="<your_client_id>/.default" \
    --data grant_type="client_credentials" \
    --data client_id="<your_client_id>" \
    --data client_secret="<your_client_secret>"
    ```

2. Use the token in an authorization header to retrieve the data:

    ```bash
    curl --header 'Authorization: bearer <token_from_above>' '<admin-hostname>:8000/httpbin-azure'
    ``` 

    Replace `<token_from_above>` with the bearer token you generated in the previous step.

3. Test the authorization code flow. In your browser, go to `http://localhost:8000/httpbin-azure`.

    You should be guided through a login process within Azure with the results
    delivered in your browser.

## Troubleshoot

If you encounter any issues, review your data plane logs. Because you
enabled `display_errors=true` on the OpenID Connect plugin, you will receive
more verbose error messages that can help pinpoint any issues.
