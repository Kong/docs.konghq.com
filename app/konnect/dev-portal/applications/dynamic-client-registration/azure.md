---
title: Configuring Azure for Dynamic Client Registration
breadcrumb: Azure
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Azure AD account](https://portal.azure.com).

### Azure Setup

In Azure, create the main application:

1. Go to **App registrations**, click on **New registration**.

2. Give it a name, keep **Supported account types** to `Accounts in this organizational directory only`.

3. Click **register**.

4. On the application view, go to **API permissions**, click **Add permissions > Microsoft Graph** and select the following:
   * Application.Read.All
   * Application.ReadWrite.All
   * Application.ReadWrite.OwnedBy
   * User.Read

5. Once added, click `Grant admin consent for your_organization`. An administrator with **Global Admin** rights is required for this step.

6. In **Certificates & secrets**, create a Client secret and save it in a secure location. You can only view the secret once.

7. On the **Overview** view, note you `Directory (tenant) ID` and `Application (client) ID`.

## Configure the Dev Portal

Once you have Azure configured, you can set up the Dev Portal to use Azure for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. In **External IDP provider for applications**, select `Azure`.

5. In the **Issuer URL** field, enter `https://sts.windows.net/YOUR_TENANT_ID`

6. In **Consumer claims**, enter `appid`.

7. Select the **Auth methods** you want to enable amongst `Bearer Access Token` and `Client Credientials Grant`

8. In **Initial Client ID**, paste the value of your `Application (client) ID` from Azure.

9. In **Initial Client Secret**, paste the value of the Client secret you generated earlier.

10. Click **Save**.

   If you previously configured any DCR settings, this will
   overwrite them.

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these instructions:

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name and a description.

3. Click **Create** to save your application.

4. After your application has been created, you will see the **Client ID** and **Client Secret**. 
   Please store these values, they will only be shown once. 
   
   Click **Proceed** to continue to the application's details page.

5. Once your application is created, you will see it in Azure. From your Azure homepage select **App registrations > All applications**. You will see your application that was created in the Dev Portal.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the runtime instance you are running.

You can also request a **Bearer Token** from azure using this command:

```sh
curl --request GET \
  --url https://login.microsoftonline.com/TENANT_ID/oauth2/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=CLIENT_ID \
  --data 'scope=https://graph.microsoft.com/.default' \
  --data 'client_secret=CLIENT_SECRET'
```


