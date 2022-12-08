---
title: Configuring Curity for Dynamic Client Registration
breadcrumb: Curity
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* A [Curity account](https://developer.curity.io/)
* A [Curity instance](https://curity.io/resources/getting-started/) that can be publicly accessed over the internet, or from within the network your Kong Gateways are installed in.

### Issuer URL

Using your Curity credentials, log in to your Curity dashboard and follow these steps:

1. Select the **Profiles** tab near the top of the dashboard.

### Configure token issuer

1. Select **Token Service > Token Issuers** from the menu.

2. Enable the setting **Use Access Token as JWT**.

3. Add a new token issuer using **New Token Issuer** button.

4. Fill in the following values for the token issuer, and click **create**:
    * Name: `userinfo`
    * Issuer Type: `jwt`
    * Purpose Type: `userinfo`

5. In the displayed "Edit Custom Token Issuer" form, select the desired values for **Tokens Data Source ID**, **Signing Key**, and **Verification KeyStore**.

### Create a client

1. Select **Token Service > Clients** from the menu.

2. Click **New Client** to add a new client.

3. Give the client a unique and descriptive name, noting it for later use.

4. Click the **Capabilities** in the overview diagram to add a capability to the **client**.

5. Select **Client Credentials** and click **next**.

6. Set the **Authentication Method** to `secret` and generate a secret, copy it for later use, and click **next**.

   {:.important}
   > **Important:** Store the secret in a place you can reference, because it will not be visible after this step.

### Enable Dynamic Client Registration

1. Select **Token Service > General > Dynamic Registration** from the menu.

2. Click **Enable Dynamic Client Registration**.

3. Ensure **Non Templatized** and **Dynamic Client Management** are both enabled and click **next**.

4. Select the desired client data source and click **next**.

5. Select the **Authentication Method** `authenticate-client-by`, add the name of the Client that was created above, and click **next**.

6. Select the desired nodes to enable DCR on and click **next**.

## Configure the Dev Portal

Once you have Curity configured, you can set up the Dev Portal to use Curity for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Select **Curity** as the external identity provider.

5. Enter the **Issuer URL** for your authorization server, it will look something like `https://<YOUR_CURITY_INSTANCE_DOMAIN>/oauth/v2/oauth-anonymous/.well-known/openid-configuration`

6. Enter the Client secret you saved when configuring the client in Curity into the **Token** field.

7. If using the configuration described above, enter the `sub` into the **Claims** field and leave the **Scopes** field empty. If you have configured Curity differently, then ensure you add the correct **Scopes** and **Claims**.

8. Click **Save**.

   If you previously configured any DCR settings, this will
   overwrite them.

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these instructions:

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name, redirect URI, and a description.

3. Click **Create** to save your application.

4. After your application has been created, you will see the **Client ID** and **Client Secret**.
   Please store these values, they will only be shown once.

   Click **Proceed** to continue to the application's details page.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the runtime instance you are running.
