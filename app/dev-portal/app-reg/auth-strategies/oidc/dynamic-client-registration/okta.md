---
title: Configuring Okta for Dynamic Client Registration
breadcrumb: Okta
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Okta account](http://developer.okta.com).

### Issuer URL

Using your Okta credentials, log in to the Okta portal and follow these steps:

1. Select **Security** from the menu.

2. Select **Security > API**. The default Issuer URL should be displayed in the **Authorization Servers** tab. If you are using an authorization server that you configured, copy the issuer URL for that authorization server.

### Create a token

1. Select **Security** from the menu.

2. Select **Security > API**.

3. From the **Tokens** tab, click the **Create token** button.

4. Enter a name for your token, and then copy the token value.
   {:.important}
   > **Important:** Store the token in a place you can reference, because it will only be visible as a hash afterwards.

### Add scopes

1. Select **Security** from the menu.

2. Select **Security > API**.

3. Select the authorization server that you want to configure.

4. Select the **Scopes** tab, and click the **Add Scope** button.

### Add claim

In order to map an application from the Dev Portal to Okta, you have to create a claim.

1. Select **Security** from the menu.

2. Select **Security > API**.

3. Select the authorization server that you want to configure.

4. Select the **Claims** tab. and then click the **Add Claim** button.

5. Enter a name for this claim, and enter **app.clientId** for value. We can leave the value type as expression, and include it in any scope.

## Configure the Dev Portal

{% navtabs %}
{% navtab Konnect UI %}

After configuring Okta, you can integrate it with the Dev Portal for Dynamic Client Registration (DCR). This process involves two main steps: first, creating the DCR provider, and second, establishing the authentication strategy. DCR providers are designed to be reusable configurations. This means once you've configured the Okta DCR provider, it can be used across multiple authentication strategies without needing to be set up again.

1. Log in to {{site.konnect_short_name}} and select Dev Portal {% konnect_icon dev-portal %} from the menu.

2. Navigate to **Application Auth** to see the authentication strategies for your API Products.

3. Open the **DCR Providers** to see all existing DCR providers.

4. Select **New DCR Provider** to create a new Okta configuration. Name it for internal reference within {{site.konnect_short_name}}. This name and the provider type won't be visible to developers on the Dev Portal.

5. Enter the **Issuer URL** of your authorization server and the **DCR Token** that you created in Okta. Select Okta as the **Provider Type**. The DCR token will be stored in isolated, encrypted storage and will not be readable through any Konnect API.

6. Save your DCR provider. You should now see it in the list of DCR providers.

7. Navigate to the **Auth Strategy** tab, then select **New Auth Strategy** to create an auth strategy that uses the DCR provider.

8. Provide a name for internal use within {{site.konnect_short_name}} and a display name for visibility on your Portal. In the **Auth Type** dropdown menu select DCR. In the **DCR Provider** dropdown, select the name of the DCR provider config you just created. Your **Issuer URL** will be prepopulated with the Issuer URL you added to the DCR provider.

9. Enter the names of the **Scopes** and **Claims** as comma-separated values in their corresponding fields. The values should match the scopes or claims that were created in Okta.

   {:.note}
   > **Note:**  Avoid using the `openid` scope with client credentials as it restricts the use. If no scopes are specified, `openid` will be the default.

10. Select the relevant **Auth Methods** you need (`client_credentials`, `bearer`, `session`), and **Save**.

{% endnavtab %}
{% navtab API %}
After configuring Okta, you can integrate it with the Dev Portal for dynamic client registration (DCR). This process involves two steps: creating the DCR provider and establishing the authentication strategy. DCR providers are designed to be reusable configurations. This means once you've configured the Okta DCR provider, it can be used across multiple authentication strategies without needing to be set up again.

1. Start by creating the DCR provider. Send a `POST` request to the [`dcr-providers`](/konnect/api/application-auth-strategies/latest/#/DCR%20Providers/create-dcr-provider) endpoint with your DCR configuration details:

```sh
curl --request POST \
  --url https://us.api.konghq.com/v2/dcr-providers \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "name": "DCR Okta",
  "provider_type": "okta",
  "issuer": "https://my-issuer.okta.com/default",
  "dcr_config": {
    "dcr_token": "my_dcr_token"
  }'
```

You will receive a response that includes a `dcr_provider` object similar to the following:

```sh
"dcr_provider": {
   "id": "33f8380e-7798-4566-99e3-2edf2b57d289",
   "name": "DCR Okta",
   "display_name": "Credentials",
   "provider_type": "okta"
}
```

Save the `id` value for creating the authentication strategy.

2. Now that you've obtained the `dcr_id` in the first step, create an authentication strategy. Send a `POST` request to the [`create-auth-strategies`](/konnect/api/application-auth-strategies/latest/#/App%20Auth%20Strategies/create-app-auth-strategy) endpoint describing an authentication strategy:

   ```sh
   curl --request POST \
   --url https://us.api.konghq.com/v2/application-auth-strategies \
   --header 'Authorization: $KPAT' \
   --header 'content-type: application/json' \
   --data '{
   "name": "Okta auth strategy",
   "display_name": "Okta",
   "strategy_type": "okta",
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

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name, auth strategy, and description.

3. Click **Create** to save your application.

4. After your application has been created, you will see the **Client ID** and **Client Secret**.
   Please store these values, they will only be shown once.

   Click **Proceed** to continue to the application's details page.

5. Once your application is created, you will see it in Okta. From your Okta organization select **Applications** from the menu. You will see your application that was created in the Dev Portal, and its corresponding Client ID.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the data plane.
