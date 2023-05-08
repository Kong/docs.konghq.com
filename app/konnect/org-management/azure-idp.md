---
title: Set up SSO with Azure
content_type: how-to
---

As an alternative to {{site.konnect_product_name}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} through an identity provider (IdP) with OpenID Connect. This authentication method allows your users to log in to {{site.konnect_short_name}} using their IdP credentials, without needing a separate login.

You can’t mix authentication methods in {{site.konnect_short_name}}. With IdP authentication enabled, all non-admin {{site.konnect_short_name}} users have to log in through your IdP. Only the {{site.konnect_short_name}} org owner can continue to log in with {{site.konnect_short_name}}’s native authentication.

{:.note}
> This guide shows you how to configure SSO for {{site.konnect_short_name}} with Microsoft Azure. See [Configure Azure IdP for Dev Portal](/konnect/dev-portal/access-and-approval/azure/) for those instructions.


## Prerequisites
### Create an application in Azure

1. In [Azure](https://portal.azure.com/), navigate to **App registrations**. 

1. Click **New registration** to register a new application:

1. Name the application.

1. Select **Accounts in this organizational directory only** for the **Supported account type**. 

1. Select **Web** and enter the (ADD CORRECT URL FOR KONNECT HERE)
    
1. Save the application ID for later.


### Configure the Azure application

1. Click **New client secret**, enter a description, select an expiration value, and click **Add**.
    
    * Save the secret value for configuring {{site.konnect_short_name}}.


1. Click **Overview** in the sidebar, then click the **Endpoints** tab.

1. Copy the **OpenID Connect metadata document** URL and open it in your browser:

1.  Your browser will display a large JSON blob object. In the object, find and save the `issuer` value.
    
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

### Configure group claims in Azure

Group claims automatically add or remove users from group memberships. To configure group claims, follow these steps: 

1. On your new application page in Azure, click **Token configuration** in the sidebar.

1. Click **+ Add groups claim** and do the following:
    1. Select each checkbox in the **Select group types to include in Access, ID, and SAML tokens** section. 
    1. Select **Group ID** for each section in **Customize token properties by type**.
    1. Click **Add**. 

    ![Group claim](/assets/images/docs/konnect/azure/group-claim.png)

1. Click **Add optional claim**, select **ID** as the token type, and **email** as the claim.

1. Click **Add**.

## Set up SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from Azure.

This table maps the {{site.konnect_short_name}} values to the corresponding Azure values. 

| {{site.konnect_short_name}} value      | Azure value |
| ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. |
| Client ID   | Your Azure application ID.        |
|Client Secret | Azure client secret.|

Requirements:

* The path must be unique across all {{site.konnect_short_name}} organizations. If your desired path is already taken, you must to choose another one.
* The path can be any alphanumeric string.
* The path does not require a slash (/).

## Test and apply the configuration

{:.important}
> Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

You can test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: cloud.konghq.com/login/examplepath. If your configuration is set up correctly, you will see the IdP sign-in window.

You can now manage your organization's user permissions entirely from the IdP application.
