---
title: Set Up External Portal Application Authentication with Okta and OIDC
---

## Overview

These instructions help you set up Okta as your third-party identity provider
for use with the Kong OIDC and Portal Application Registration plugins.

## Define an authorization server and create a custom claim in Okta {#auth-server-cclaim}

Follow these steps to set up an authorization server in Okta for all authorization types.

1. Sign in to the [Developer Okta site](https://developer.okta.com/).
2. Click **API > Authorization Servers**.

   ![Okta Authorization Server](/assets/images/docs/dev-portal/okta-api-auth-server.png)

   Notice that you already have an authorization server set up named `default`.
   This example uses the default auth server. You can also create as many
   custom authorization servers as necessary to fulfill your requirements. For
   more information, refer to the
   [Okta developer documentation](https://developer.okta.com/docs/guides/customize-authz-server/overview/).

3. Click **default** to view the details for the default auth server. Take note
of the `Issuer` URL, which you will use to associate Kong with your authorization server.

   ![Okta Issuer URL](/assets/images/docs/dev-portal/okta-auth-server-issuer-url.png)

4. Click the **Claims** tab.

   ![Okta Issuer URL](/assets/images/docs/dev-portal/okta-auth-server-claims.png)

5. Click **Add Claim**. Add a custom claim called `application_id` that will attach any successfully authenticated application's `id` to the access token.
    1. Enter `application_id` in the **Name** field.
    2. Ensure the `Include in token type` selection is **Access Token**.
    3. Enter `app.clientId` in the **Value** field.
    4. Click **Create**.

   ![Okta Claim](/assets/images/docs/dev-portal/okta-add-claim.png)

    Now that you have created a custom claim, you can associate the `client_id`
    with a Service via the Application Registration plugin. Start by creating a Service in Kong Manager.

7. Create a Service and a Route and instantiate an OIDC plugin on that Service.
   You can allow most options to use their defaults.

   1. In the `Config.Issuer` field, enter the Issuer URL of the Authorization server from your identity provider.

      ![OIDC with Okta Issuer URL](/assets/images/docs/dev-portal/oidc-issuer-url.png)

   2. In the `Config.Consumer Claim` field, enter your `<application_id>`.

   **Tip:** Because Okta's discovery document does not include all supported
   auth types by default, ensure the
   `config.verify_parameters` option is disabled.

   ![Clear Config Verify Parameters for OIDC with Okta](/assets/images/docs/dev-portal/oidc-clear-verify-params-app-reg.png)

   The core configuration should be:

   ```
   {
     "issuer": "<auth_server_issuer_url>",
     "verify_credentials": false,
     "consumer_claim": "<application_id>",
   }

   ```

8. Configure a Portal Application Registration plugin on the Service as well. See
[Application Registration](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration#config-app-reg-plugin).

## Register an application in Okta

Follow these steps to register an application in Okta and associate the Okta
application with an application in the Kong Developer Portal.

1. Sign in to the [Developer Okta site](https://developer.okta.com/).
2. Click **Applications** > **+ Add Application**.
3. Depending on which authentication flow you want to implement, the setup of
your Okta application will vary:

    - **Client Credentials**: Select `Machine-to-Machine` when prompted for an application type.

     ![Okta Create New Application](/assets/images/docs/dev-portal/okta-client-creds-app.png)

    You will need your `client_id` and `client_secret` later on when you [authenticate with the proxy](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth#cc-flow).

    ![Okta Client Credentials](/assets/images/docs/dev-portal/okta-client-id-secret.png)

    - **Implicit Grant**: Select `Single-Page App`, `Native`, or `Web` when
  prompted for an application type. Make sure `Implicit` is selected for
 `Allowed grant types`. Enter the `Login redirect URIs`, `Logout redirect URIs`, and `Initiate login URI` fields with the correct values, depending on your application's routing. The Implicit Grant flow is not recommended if the Authorization Code flow is possible.

    - **Authorization Code**: Select `Single-Page App`, `Native`, or `Web` when
  prompted for an application type. Make sure `Authorization Code` is selected for `Allowed grant types`. Enter the `Login redirect URIs`, `Logout redirect URIs`, and `Initiate login URI` fields with the correct values, depending on your application's routing.

## Associate the identity provider application with your Kong application

Now that the application has been configured in Okta, you need to associate the
Okta application with the corresponding application in Kong's Developer Portal.

<div class="alert alert-warning">
  <strong>Note:</strong> Each developer should have their own application in both Okta and Kong.  
  Each Okta application has its own `client_id` that maps to its respective application in Kong.
  Essentially, this maps identity provider applications to portal applications.
</div>

This example assumes Client Credentials is the chosen OAuth flow.

1. In the Kong Dev Portal, create an account if you haven't already.
2. After you've logged in, click `My Apps`.
3. On the Applications page, click `+ New Application`.
4. Complete the **Name** and **Description** fields. Paste the `client_id` of your corresponding Okta (or other identity provider) application into the **Reference Id** field.

   ![Kong Create Application with Reference Id](/assets/images/docs/dev-portal/create-app-ref-id.png)

Now that the application has been created, developers can authenticate with the
endpoint using the supported and recommended
[third-party OAuth flows](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth).
