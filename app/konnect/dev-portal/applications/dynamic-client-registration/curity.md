---
title: Configure Curity for Dynamic Client Registration
breadcrumb: Curity
content_type: how-to
beta: true
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* A [Curity account](https://developer.curity.io/)
* A [Curity instance](https://curity.io/resources/getting-started/) that can be publicly accessed over the internet or from within the network where your gateways are installed.

{% tip %}
This feature requires Curity v7.x.
{% endtip %}

## Configure Curity

To use dynamic client registration (DCR) with Curity as the identity provider (IdP), there are three important configurations to prepare in Curity. In the following sections, you will configure the token issuer, create a client, and enable dynamic client registration for the client.

To get started configuring Curity, log in to your Curity dashboard and complete the following:

1. Select the **Profiles** tab on the dashboard.

2. Select an existing **Token Service Profile** in the **Profiles** diagram, or create a new one if necessary.

3. Complete the following sections using the **Token Service Profile** you selected.

### Configure the token issuer

1. Select **Token Service > Token Issuers** from the menu.

2. Enable the **Use Access Token as JWT** setting.

3. Add a new token issuer by clicking **New Token Issuer**.

4. Fill in the following values for the token issuer, and click **create**:
    * Name: `userinfo`
    * Issuer Type: `jwt`
    * Purpose Type: `userinfo`

5. In the "Edit Custom Token Issuer" form, select the desired values for **Tokens Data Source ID**, **Signing Key**, and **Verification KeyStore**.

### Create a client

1. Select **Token Service > Clients** from the menu.

2. Click **New Client**.

3. Give the client a unique and descriptive name, noting it for later use.

4. Click **Capabilities** in the overview diagram to add a capability to the **client**.

5. Select **Client Credentials** and click **next**.

6. Set the **Authentication Method** to `secret` and generate a secret, copy it for later use, and click **next**.

   {:.important}
   > **Important:** Store the secret in a place you can reference, because it will not be visible after this step.

### Enable Dynamic Client Registration

1. Select **Token Service > General > Dynamic Registration** from the menu.

2. Click **Enable Dynamic Client Registration**.

3. Ensure **Non Templatized** and **Dynamic Client Management** are both enabled, and then click **next**.

4. Select the desired client data source and click **next**.

5. Select `authenticate-client-by` for the **Authentication Method**, add the name of the Client that was created above, and then click **next**.

6. Select the nodes you want to enable DCR on and click **next**.

## Configure the Dev Portal

Once you have Curity configured, you can set up the Dev Portal to use Curity for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Select **Curity** as the external identity provider.

5. Enter the **Issuer URL** for your authorization server, it will look something like `https://CURITY_INSTANCE_DOMAIN/oauth/v2/oauth-anonymous/.well-known/openid-configuration`

6. Enter the Client secret you saved when configuring the client in Curity into the **Token** field.

7. If you are using the Curity configuration described in the previous sections, enter the `sub` into the **Claims** field and leave the **Scopes** field empty. If you configured Curity differently, then ensure you add the correct **Scopes** and **Claims**.

8. Click **Save**.

   If you previously configured any DCR settings, this will
   overwrite them.

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these instructions:

1. Click **New App**.

2. Fill out the **Create New Application** form with your application name, redirect URI, and a description.

3. Click **Create** to save your application.

4. After your application is created, you will see the **Client ID** and **Client Secret**.
   Store these values, they will only be shown once.

5. Click **Proceed** to continue to the application's details page.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the runtime instance you are running.
