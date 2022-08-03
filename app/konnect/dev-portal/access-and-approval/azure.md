---
title: Configure Azure IDP for Dev Portal
no_version: true
content_type: how-to
---

{{site.base_gateway}} offers OIDC support to allow Single-Sign-on for {{site.konnect_short_name}} and the Dev Portal. This guide shows you how to configure Azure for Dev Portal SSO.


## Create an Application in Azure

Login to [Azure](https://portal.azure.com/), navigate to **App Registration** and follow these steps: 

1. Register a new application:

    ![Register an application](/assets/images/docs/konnect/azure/app-registration.png)

2. Name the application.

3. Select the supported account type: 
    
    **Accounts in this organizational directory only**.

4. Select **web** as the application type, enter the Dev Portal redirect URI and click **Register**.
    
5. Save the application ID for later, and click **Add a certificate or secret**:

   ![Add certificate](/assets/images/docs/konnect/azure/add-certificate.png)

{:.note}
>**Note:** You can find the Dev Portal redirect URI from the Dev Portal menu. For more information read [Access the Dev Portal](/konnect/dev-portal/access/).

## Configuration

1. Click **new client secret**, enter a description, select an expiration value, and **save**.
    
    * Save the secret value for configuring {{site.konnect_short_name}}.


3. Click **Overview** in the sidebar, then select **endpoints**.

4. Select the **OpenID Connect metadata document** URL and access it with your browser:

    ![Endpoints](/assets/images/docs/konnect/azure/endpoints.png)

5.  Your browser will display a large JSON blob object. In the object, find and save the `issuer` value.

    ![Issuer](/assets/images/docs/konnect/azure/issuer.png)
    
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

## Group claims

Group claims automatically add or remove users from group memberships. To configure group claims follow these steps: 

1. Click **token configuration**, then click **Add groups claim** check every checkbox and select `group_id` for every field, then press **add**. 
    
    ![Group claim](/assets/images/docs/konnect/azure/group-claim.png)

2. Click **add optional claim** select the **ID** as the token type, and **email** as the claim.

    ![Optional claim](/assets/images/docs/konnect/azure/optional-claim.png)

3. Press **Add** to save.

## Configure in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), select **Configure provider**, and enter the correct values:

![Configure IDP](/assets/images/docs/konnect/azure/configure-idp.png)

This table maps the {{site.konnect_short_name}} values to the corresponding Azure values. 

| {{site.konnect_short_name}} value      | Azure value |
| ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. |
| Client ID   | Your Azure application ID.        |
|Client Secret | Azure client secret.|