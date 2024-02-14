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

4. On the application view, go to **API permissions**, click **Add permissions > Microsoft Graph** and select the following:
   * **Application.Read.All**
   * **Application.ReadWrite.All**
   * **Application.ReadWrite.OwnedBy**
   * **User.Read**

5. Once added, click **Grant admin consent**. An administrator with Global Admin rights is required for this step.

6. Select **Certificates & secrets** and then create a client secret and save it in a secure location. You can only view the secret once.

7. On the **Overview** view, note your Directory (tenant) ID and Application (client) ID.

## Configure the Dev Portal

Once you have Azure configured, you can set up the Dev Portal to use Azure for dynamic client registration (DCR).

1. Log in to {{site.konnect_short_name}} and select the **Dev Portal** {% konnect_icon dev-portal %} from the menu.

2. Go to **Application Auth** to find the authentication settings for your API products.

3. Open the **DCR Providers** to review existing DCR Providers.

4. Select **New DCR Provider** button to create an Azure configuration. Enter a name for internal reference in {{site.konnect_short_name}}. This name, along with the provider type, will remain internal and not be visible to developers on the Dev Portal.

5. Provide the Issuer URL for your Azure tenant, using the format  `https://sts.windows.net/YOUR_TENANT_ID`.

6. For **Provider Type**, select AzureAD.

7. Enter your Application (Client) ID from Azure into the **Initial Client ID** field and the Azure admin application's client secret into the **Intial Client Secret** field. The Initial Client Secret will be stored in isolated, encrypted storage and will not be readable through any Konnect API.

8. After saving, your new DCR Provider will appear in the list.

9. Click the **Auth Strategy** tab, then select **New Auth Strategy** to create an auth strategy that uses the DCR Provider you just added.

10. Name it for internal reference in {{site.konnect_short_name}} and provide a display name for visibility in the Portal. Select DCR as the **Auth Type** and choose your newly created DCR provider from the dropdown. The  **Issuer URL** entered earlier will be will be prepopulated.

11. In the **Credential Claims** field, enter `appid`.

12. Select the relevant **Auth Methods** you need (`client_credentials`, bearer, session).

13. Click **Save**.

## Create an application with DCR

<!-- vale off -->
From the **My Apps** page in the Dev Portal, follow these instructions:
<!-- vale on -->

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name and a description.

3. Click **Create** to save your application.

4. After your application has been created, you will see the **Client ID** and **Client Secret**. 
   Store these values, they will only be shown once.
   
5. Click **Proceed** to continue to the application's details page.

Once your application is created, you will see it in Azure. From your Azure homepage select **App registrations > All applications**. You will see your application that was created in the Dev Portal.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the data plane node.

You can also request a bearer token from Azure using this command, 
using an OAuth2 v1 token endpoint:

```sh
curl --request GET \
  --url https://login.microsoftonline.com/TENANT_ID/oauth2/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=CLIENT_ID \
  --data 'scope=https://graph.microsoft.com/.default' \
  --data 'client_secret=CLIENT_SECRET'
```
