---
title: Configuring Curity for Dynamic Client Registration
breadcrumb: Curity
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Curity account](link).

## Configure Curity

To use Curity for dynamic client registration in the Dev Portal, you must first configure Curity.

### Issuer URL

<!--Instructions here-->

### Create a token

<!--Instructions here-->

### Add scopes

<!--Instructions here-->

### Add claim

<!--Instructions here-->

## Configure the Dev Portal

Once you have Curity configured, you can set up the Dev Portal to use Curity for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Enter the **Issuer URL** for your authorization server, and the **Token** that were created in Curity.

5. Enter the names of the **Scopes** and **Claims** as comma-separated values in their corresponding fields. The values should match the scopes or claims that were created in Curity.

   {:.note}
   > **Note:** You can use any of the existing scopes besides **`openid`**, as using the `openid`
   scope prevents you from using client credentials. If the **Scopes** field is empty, `openid`
   will be used.

6. Click **Save**.

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

5. Once your application is created, you will see it in Curity. From your Curity organization, select **Applications** from the menu. You will see your application that was created in the Dev Portal, and its corresponding Client ID.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the runtime instance you are running.