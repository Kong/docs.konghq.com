---
title: Configure Auth0 for Dynamic Client Registration
breadcrumb: Auth0
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Auth0 account](https://auth0.com/)

## Configure Auth0

To use dynamic client registration (DCR) with Auth0 as the identity provider (IdP), there are two important configurations to prepare in Auth0. First, you must authorize an Auth0 application so {{site.konnect_short_name}} can use the Auth0 Management API on your behalf. Next, you will create an API audience that {{site.konnect_short_name}} applications will be granted access to.

To get started configuring Auth0, log in to your Auth0 dashboard and complete the following:

### Configure access to the Auth0 Management API

{{site.konnect_short_name}} will use a client ID and secret from an Auth0 application that has been authorized to perform specific actions in the Auth0 Management API.

1. From the sidebar, select **Applications > Applications**

2. Click the **Create Application** button

3. Give the application a memorable name, like "{{site.konnect_short_name}} Portal DCR Admin"

4. Select the application type **Machine to Machine Applications** and click **create**

5. Authorize the application to access the **Auth0 Management API** by selecting it from the dropdown. It will have a URL of the pattern `https://AUTH0_TENANT_SUBDOMAIN.REGION.auth0.com/api/v2/`

6. In the **Permissions** section, ensure you have selected the following permissions to be granted and click **authorize**:
   * `read:client_grants`
   * `create:client_grants`
   * `delete:client_grants`
   * `update:client_grants`
   * `read:clients`
   * `create:clients`
   * `delete:clients`
   * `update:clients`
   * `update:client_keys`

7. On the application's page, visit the **Settings** tab and note where you can view the values for **Client ID** and **Client Secret**, which you will use in a later step.

### Configure the API audience

{:.note}
> **Note:** You can use an existing API entity if there is one already defined in Auth0 that represents the audience you are/will be serving with {{site.konnect_short_name}}  Dev Portal applications.
In most cases, it is a good idea to create a new API that is specific to your Konnect Portal applications.

To create a new API audience:

1. From the sidebar, select **Applications > APIs**

2. Click the **Create API** button

3. Give the API a **name**, like "{{site.konnect_short_name}} Portal Applications"

4. Set the **identifier** to a value that represents the audience the API is serving

5. Click **create**

6. Note the **identifier** value used above, which is also known as the **audience**, as it will be used as the **Client Token Audience** value in {{site.konnect_short_name}}

## Configure the Dev Portal

Once you have Auth0 configured, you can set up the Dev Portal to use Auth0 for dynamic client registration (DCR).

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Click **Settings** to open the Dev Portal settings.

3. Click the **Application Setup** tab to open the DCR settings for your Dev Portal.

4. Select **Auth0** as the external identity provider.

5. Enter the **Issuer** for your Auth0 tenant, it will look something like `https://AUTH0_TENANT_SUBDOMAIN.us.auth0.com`

   {:.note}
   > **Note:** You can find the value for your `AUTH0_TENANT_SUBDOMAIN` by visiting **Settings** from the Auth0 sidebar and finding the **Tenant Name** in the **General** tab.

6. Enter the **Client Token Audience** as the identifier value you set when configuring the API entity above

7. Enter `openid` into the **Scopes** field

8. Enter `azp` into the **Consumer Claims** field, which will match the client ID of each Auth0 application

9. Enter the Client ID from the admin application created in Auth0 above into the **Initial Client ID** field.

10. Enter the Client secret from the admin application created in Auth0 above into the **Initial Client Secret** field.

11. Click **Save**.

   If you previously configured any DCR settings, this will
   overwrite them.

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these instructions:

1. Click **New App**.

2. Fill out the **Create New Application** form with your application name, redirect URI, and a description.

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
