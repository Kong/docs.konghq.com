---
title: Configure Azure IdP for Dev Portal
no_version: true
content_type: how-to
---

Kong offers OIDC support to allow Single-Sign-on for {{site.konnect_short_name}} and the Dev Portal. This guide shows you how to configure Microsoft Azure for Dev Portal SSO.


## Create an application in Azure

1. In [Azure](https://portal.azure.com/), navigate to **App registrations**. 

1. Click **New registration** to register a new application:

    ![Register an application](/assets/images/docs/konnect/azure/app-registration.png)

2. Name the application.

3. Select **Accounts in this organizational directory only** for the **Supported account type**. 

4. Select **web** as the application type, enter the Dev Portal redirect URI and click **Register**.
    
5. Save the application ID for later.

   ![Add certificate](/assets/images/docs/konnect/azure/add-certificate.png)

{:.note}
>**Note:** You can find the Dev Portal redirect URI from the Dev Portal menu. For more information read [Access the Dev Portal](/konnect/dev-portal/access/).

## Configure the Azure application

1. Click **New client secret**, enter a description, select an expiration value, and click **Add**.
    
    * Save the secret value for configuring {{site.konnect_short_name}}.


3. Click **Overview** in the sidebar, then click the **Endpoints** tab.

4. Copy the **OpenID Connect metadata document** URL and open it in your browser:

    ![Endpoints](/assets/images/docs/konnect/azure/endpoints.png)

5.  Your browser will display a large JSON blob object. In the object, find and save the `issuer` value.

    ![Issuer](/assets/images/docs/konnect/azure/issuer.png)
    
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

## Configure group claims in Azure

Group claims automatically add or remove users from group memberships. To configure group claims, follow these steps: 

1. On your new application page in Azure, click **Token configuration** in the sidebar.

1. Click **+ Add groups claim** and do the following:
    1. Select each checkbox in the **Select group types to include in Access, ID, and SAML tokens** section. 
    1. Select **Group ID** for each section in **Customize token properties by type**.
    1. Click **Add**. 
    
    ![Group claim](/assets/images/docs/konnect/azure/group-claim.png)

2. Click **+ Add optional claim**, select **ID** as the token type, and **email** as the claim.

    ![Optional claim](/assets/images/docs/konnect/azure/optional-claim.png)

3. Click **Add**.

## Configure SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from Azure.

![Configure IDP](/assets/images/docs/konnect/azure/configure-idp.png)

This table maps the {{site.konnect_short_name}} values to the corresponding Azure values. 

| {{site.konnect_short_name}} value      | Azure value |
| ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. |
| Client ID   | Your Azure application ID.        |
|Client Secret | Azure client secret.|