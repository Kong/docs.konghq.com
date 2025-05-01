---
title: Configure Curity for Dynamic Client Registration
breadcrumb: Curity
content_type: how-to
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

{% navtabs %}
{% navtab Konnect UI %}

Once you have Curity configured, you can set up the Dev Portal to use Curity for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Navigate to **Application Auth** to access the authentication settings for your API Products.

3. Open the **DCR Providers** to view all configured DCR Providers

4. Select **New DCR Provider** button to create a Curity configuration. Provide a name for internal use within {{site.konnect_short_name}}. The name and provider type information will not be exposed to Dev Portal developers.

5. Input the **Issuer URL** of your Curity authorization server, formatted as `https://CURITY_INSTANCE_DOMAIN/oauth/v2/oauth-anonymous/.well-known/openid-configuration`

6. Select Curity as the **Provider Type**.

7. Enter the Client ID of the admin client created in Curity above into the **Initial Client ID** field. Enter the value you saved for the Client secret into the **Initial Client Secret** field.  Note: The Initial Client Secret will be stored in isolated, encrypted storage and will not be readable through any Konnect API.

8. Save your DCR Provider. You should now see it in the list of DCR providers.

9. Click the **Auth Strategy** tab to see all your Auth Strategies. Select **New Auth Strategy** to create an auth strategy that uses the DCR Provider you created.

10. Enter a name for internal use in {{site.konnect_short_name}} and a display name that will be displayed the portal. In the **Auth Type** dropdown menu select DCR. In the **DCR Provider** dropdown, select the name of the DCR Provider config you created. Your **Issuer URL** will be prepopulated with the issuer URL you added to the DCR Provider.

11. If you are using the Curity configuration described in the previous sections, enter the `sub` into the **Claims** field and leave the **Scopes** field empty. If you configured Curity differently, then ensure you add the correct **Scopes** and **Claims**.

12. Select the relevant **Auth Methods** you need (`client_credentials`, `bearer`, `session`) and **Save**.

{% endnavtab %}
{% navtab API %}
After configuring Curity, you can integrate it with the Dev Portal for dynamic client registration (DCR). This process involves two steps: creating the DCR provider and establishing the authentication strategy. DCR providers are designed to be reusable configurations. This means once you've configured the Curity DCR provider, it can be used across multiple authentication strategies without needing to be set up again.

1. Start by creating the DCR provider. Send a `POST` request to the [`dcr-providers`](/konnect/api/application-auth-strategies/latest/#/DCR%20Providers/create-dcr-provider) endpoint with your DCR configuration details:

```sh
curl --request POST \
  --url https://us.api.konghq.com/v2/dcr-providers \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "name": "DCR Curity",
  "provider_type": "Curity",
  "issuer": "https://CURITY_INSTANCE_DOMAIN/oauth/v2/oauth-anonymous/.well-known/openid-configuration",
  "dcr_config": {
    "dcr_token": "my_dcr_token"
  }'
```

You will receive a response that includes a `dcr_provider` object similar to the following:

   ```sh
   "dcr_provider": {
   "id": "33f8380e-7798-4566-99e3-2edf2b57d289",
   "name": "DCR Curity",
   "display_name": "Credentials",
   "provider_type": "Curity"
   }
   ```

Save the `id` value for creating the authentication strategy.

2. With the `dcr_id` obtained from the first step, create an authentication strategy. Sen a `POST` request to the [`create-auth-strategies`](/konnect/api/application-auth-strategies/latest/#/App%20Auth%20Strategies/create-app-auth-strategy) endpoint describing an authentication strategy:

   ```sh
   curl --request POST \
   --url https://us.api.konghq.com/v2/application-auth-strategies \
   --header 'Authorization: $KPAT' \
   --header 'content-type: application/json' \
   --data '{
   "name": "Curity auth strategy",
   "display_name": "Curity",
   "strategy_type": "Curity",
   "configs": {
      "openid-connect": {
         "issuer": "https://my-issuer.auth0.com/api/v2/",
         "credential_claim": [
         "client_id"
         ],
         "scopes": [
         "openid",
         "email"
         ],
         "auth_methods": [
         "client_credentials",
         "bearer"
         ]
      }
   },
   "dcr_provider_id": "93f8380e-7798-4566-99e3-2edf2b57d289"
   }'

   ```

{% endnavtab %}
{% endnavtabs %}

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these instructions:

1. Click **New App**.

2. Fill out the **Create New Application** form with your application name, authentication strategy, and description.

3. Click **Create** to save your application.

4. After your application is created, you will see the **Client ID** and **Client Secret**.
   Store these values, they will only be shown once.

5. Click **Proceed** to continue to the application's details page.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the data plane.
