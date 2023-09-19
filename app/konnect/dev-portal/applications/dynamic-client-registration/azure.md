---
title: Configuring Azure for Dynamic Client Registration
breadcrumb: Azure
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Azure AD account](https://portal.azure.com).

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

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Select **Azure** as the external identity provider..

5. Enter the Issuer for your Azure tenant, it will look something like `https://sts.windows.net/YOUR_TENANT_ID`.

6. Enter `appid` in the **Consumer claims** field.

7. Select the auth method you want to enable.

8. Enter your Application (client) ID from Azure in the **Initial Client ID** field.

9. Enter the Client secret from the admin application created in Azure into the **Initial Client Secret** field..

10. Click **Save**.

   If you previously configured any DCR settings, this will
   overwrite them.

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

Where `example.com` is the address of the runtime instance you are running.

You can also request a Bearer Token from Azure using this command:

```sh
curl --request GET \
  --url https://login.microsoftonline.com/TENANT_ID/oauth2/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=CLIENT_ID \
  --data 'scope=https://graph.microsoft.com/.default' \
  --data 'client_secret=CLIENT_SECRET'
```


{:.note}
> **Note:** Supports Azure OAuth v1 token endpoints only; v2 not supported.


