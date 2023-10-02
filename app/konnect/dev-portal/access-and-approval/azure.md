---
title: Configure Azure IdP for Dev Portal
content_type: how-to
---

Kong offers OIDC support to allow Single-Sign-on for {{site.konnect_short_name}} and the Dev Portal. This guide shows you how to configure Microsoft Azure for Dev Portal SSO.


## Create an application in Azure

1. In [Azure](https://portal.azure.com/), navigate to **App registrations**. 

1. Click **New registration** to register a new application:

1. Name the application.

1. Select **Accounts in this organizational directory only** for the **Supported account type**. 

1. Select **Web** and enter the Dev Portal [Redirect URI](/konnect/dev-portal/access/). 
    
1. Save the application ID for later.


## Configure the Azure application

1. Click **New client secret**, enter a description, select an expiration value, and click **Add**.
    
    * Save the secret value for configuring {{site.konnect_short_name}}.


1. Click **Overview** in the sidebar, then click the **Endpoints** tab.

1. Copy the **OpenID Connect metadata document** URL and open it in your browser:

1.  Your browser will display a large JSON blob object. In the object, find and save the `issuer` value.
    
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

## Configure group claims in Azure

1. On your new application page in Azure, click **Token configuration** in the sidebar.

1. Click **Add groups claim** and do the following:
    1. Select each checkbox in the **Select group types to include in Access, ID, and SAML tokens** section. 
    1. Select **Group ID** for each section in **Customize token properties by type**.
    1. Click **Add**. 

    ![Group claim](/assets/images/konnect/dev-portal/azure/group-claim.png)

1. Click **Add optional claim**, select **ID** as the token type, and **email** as the claim.

1. Click **Add**.

## Configure SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from Azure.

This table maps the {{site.konnect_short_name}} values to the corresponding Azure values. 

| {{site.konnect_short_name}} value      | Azure value |
| ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. |
| Client ID   | Your Azure application ID.        |
| Client Secret | Azure client secret.|

You can test your configuration by navigating to the Dev Portal and using your Azure credentials to log in. 
