---
title: Configuring Azure for Dynamic Client Registration
breadcrumb: Azure
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Azure AD account](https://portal.azure.com).

{:.note}
> **Note:** Dynamic client registration supports Azure OAuth v1 token endpoints only.
> v2 is not supported.

## Configure Azure

In Azure, create the main application:

1. In Azure Active Directory, click **App registrations** and then click **New registration**.

2. Enter a name for the application.
3. Ensure **Accounts in this organizational directory only** is selected for **Supported account types**.

4. Click **Register**.

5. On the application view, go to **API permissions**, click **Add permissions > Microsoft Graph** and select the following:
   * **Application.Read.All**
   * **Application.ReadWrite.All**
   * **Application.ReadWrite.OwnedBy**
   * **User.Read**

6. Once added, click **Grant admin consent**. An administrator with Global Admin rights is required for this step.

7. Select **Certificates & secrets** and then create a client secret and save it in a secure location. You can only view the secret once.

8. In the **Overview** view, make a note of your Directory (tenant) ID and Application (client) ID.

## Configure the Dev Portal

{% navtabs %}
{% navtab Konnect UI %}
Once you have Azure configured, you can set up the Dev Portal to use Azure for Dynamic Client Registration (DCR). This process involves two steps: creating the DCR provider and establishing the authentication strategy. DCR providers are designed to be reusable configurations. This means once you've configured the Azure DCR provider, it can be used across multiple authentication strategies without needing to be set up again.

1. Log in to {{site.konnect_short_name}} and select the **Dev Portal** {% konnect_icon dev-portal %} from the menu.

2. Go to **Application Auth** to find the authentication settings for your API products.

3. Open the **DCR Providers** to review existing DCR Providers.

4. Select **New DCR Provider** button to create an Azure configuration. Enter a name for internal reference in {{site.konnect_short_name}}. This name, along with the provider type, will remain internal and not be visible to developers on the Dev Portal.

5. Provide the Issuer URL for your Azure tenant in the following format: `https://sts.windows.net/YOUR_TENANT_ID`.

6. For **Provider Type**, select AzureAD.

7. Enter your Application (Client) ID from Azure into the **Initial Client ID** field, and the client secret of the Azure admin application into the **Initial Client Secret** field.

    {:.note}  
    > **Note:** The Initial Client Secret will be stored in isolated, encrypted storage and will not be accessible through any Konnect API.

8. After saving, your new DCR Provider will appear in the list.

9. Click the **Auth Strategy** tab, then select **New Auth Strategy** to create an auth strategy that uses the DCR Provider you just added.

10. Enter a name for internal reference in {{site.konnect_short_name}} and a display name for visibility in the Portal. Select **DCR** as the **Auth Type**, and choose your newly created DCR provider from the dropdown. The **Issuer URL** you entered earlier will be prepopulated.

11. In the **Credential Claims** field, enter `appid`.

12. Select the relevant **Auth Methods** you need (`client_credentials`, `bearer`, `session`), and **save**.

{% endnavtab %}
{% navtab API %}

1. Start by creating the DCR provider. Send a `POST` request to the [`dcr-providers`](/konnect/api/application-auth-strategies/latest/#/DCR%20Providers/create-dcr-provider) endpoint with your DCR configuration details:

```sh
   curl --request POST \
   --url https://us.api.konghq.com/v2/dcr-providers \
   --header 'Authorization: $KPAT' \
   --header 'content-type: application/json' \
   --data '{
   "name": "Azure DCR Provider",
   "provider_type": "Azure",
   "issuer": "https://sts.windows.net/YOUR_TENANT_ID",
   "dcr_config": {
      "initial_client_id": "abc123",
      "initial_client_secret": "abc123xyz098!",
      "initial_client_audience": "https://my-custom-domain.com/api/v2/"
   }
   }'
```

You will receive a response that includes a `dcr_provider` object similar to the following:

```sh
{
   "created_at": "2024-02-29T23:38:00.861Z",
   "updated_at": "2024-02-29T23:38:00.861Z",
   "id": "93f8380e-7798-4566-99e3-2edf2b57d289",
   "name": "Azure DCR Provider",
   "provider_type": "Azure",
   "issuer": "https://sts.windows.net/YOUR_TENANT_ID",
   "dcr_config": {
      "initial_client_id": "abc123",
      "initial_client_audience": "https://my-custom-domain.com/api/v2/"
   },
   "active": false
}
```

Save the `id` value for creating the authentication strategy.

2. With the `dcr_id` obtained from the first step, create an authentication strategy. Send a `POST` request to the [`create-auth-strategies`](/konnect/api/application-auth-strategies/latest/#/App%20Auth%20Strategies/create-app-auth-strategy) endpoint describing an authentication strategy:

   ```sh
      curl --request POST \
      --url https://us.api.konghq.com/v2/application-auth-strategies \
      --header 'Authorization: $KPAT' \
      --header 'content-type: application/json' \
      --data '{
      "name": "Azure Auth",
      "display_name": "Azure Auth",
      "strategy_type": "openid_connect",
      "configs": {
         "openid-connect": {
            "issuer": "https://sts.windows.net/YOUR_TENANT_ID",
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
      }
   ```

{% endnavtab %}
{% endnavtabs %}

## Create an application with DCR

<!-- vale off -->
From the **My Apps** page in the Dev Portal, follow these instructions:
<!-- vale on -->

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name, authentication strategy, and description.

3. Click **Create** to save your application.

4. After your application has been created, you will see the **Client ID** and **Client Secret**.
   Store these values, they will only be shown once.

5. Click **Proceed** to continue to the application's details page.

Once your application is created, you will see it in Azure. From your Azure homepage select **App registrations > All applications**. You will see your application that was created in the Dev Portal.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, include the client credentials in the header. You can do this using any API client, such as [Insomnia](https://insomnia.rest/), or directly from the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the data plane node.

You can also request a bearer token from Azure using the following command, targeting the OAuth 2.0 v1 token endpoint:

```sh
curl --request GET \
  --url https://login.microsoftonline.com/TENANT_ID/oauth2/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=CLIENT_ID \
  --data 'scope=https://graph.microsoft.com/.default' \
  --data 'client_secret=CLIENT_SECRET'
```
