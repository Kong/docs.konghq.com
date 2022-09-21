---
title: Configuring Okta for Dynamic Client Registration
no_version: true
toc: true
content-type: how-to
---


## Prerequisites

To use Okta as an external client provider for Dynamic Client Registration (DCR), create or use an existing Okta account [here](http://developer.okta.com). Once you have an account, you will need to create a token, find the Issuer URL, and optionally set any scopes or claims.

### Issuer URL

1. Select **Security** from the menu.

2. Select **Security > API**. The default Issuer URL should be displayed in the Authorization Servers tab. If you are using an Authorization Server that you configured, copy the Issuer URL for that Authorization Server.

### Creating a token

1. Select **Security** from the menu.

2. Select **Security > API**.

3. Click the **Tokens** tab.

4. Click the **Create token** button.

5. Enter a name for your token, and then copy the token value. Make sure you store this in a place you can reference, as it will only be visible as a hash afterwards.

### Scopes & Claims

1. Select **Security** from the menu.

2. Select **Security > API**.

3. Select the Authorization Server that you want to configure.

4. If you would like to create a scope, select the **Scopes** tab, and then click the **Add Scope** button.

5. If you would like to create a claim, select the **Claims** tab. and then click the **Add Claim** button.

## Configuring the Dev Portal

Once you have Okta configured, we can now setup the Dev Portal to use Okta for DCR.

1. Sign in to Konnect, and select **Dev Portal** from the menu.

2. Click **Settings** to open your Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your portal.

4. Enter the **Issuer URL** for your authorization server, and the **Token** that you created in Okta.

5. Optionally, if you created any **Scopes** or **Claims**, enter them as comma-separated values in their corresponding inputs.

6. Click **Save**.

   {:.note}
   > Note that if you previously configured any DCR settings, this will
   overwrite them.

## Create an application with DCR

To create a new application, log in to the Dev Portal and click **My Apps**. From the **My Apps** page, follow these instructions: 

1. Click the **New App** button.

2. Fill out the **Create New Application** form with your application name, redirect URI, and description.

3. Click **Create** to save your application. After your application has been created, you will see the **Client ID** and **Client Secret**. Please store these values, as they will only be shown once. Click **Proceed** to continue to the application's details page.

4. Once your application has created, we will see it in Okta. Visit your Okta organization, and select **Applications** from the menu. You will see your application that was created in the Dev Portal, and the corresponding Client ID.
