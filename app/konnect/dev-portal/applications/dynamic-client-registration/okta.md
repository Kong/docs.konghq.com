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

5. Enter a name for your token, and then copy the token value.
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

6. Enter a name for this claim, and enter **app.clientId** for value. We can leave the value type as expression, and include it in any scope.

## Configure the Dev Portal

Once you have Okta configured, you can set up the Dev Portal to use Okta for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Enter the **Issuer URL** for your authorization server, and the **Token** that were created in Okta.

5. Enter the names of the **Scopes** and **Claims** as comma-separated values in their corresponding fields. The values should match the scopes or claims that were created in Okta.

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

5. Once your application is created, you will see it in Okta. From your Okta organization select **Applications** from the menu. You will see your application that was created in the Dev Portal, and its corresponding Client ID.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, you must attach this client secret pair in the header. You can do this by using any API product, such as [Insomnia](https://insomnia.rest/), or directly using the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the data plane.
