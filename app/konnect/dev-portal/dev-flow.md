---
title: Get started as a developer
---

This guide explains how developers can get started with the developer platform by registering and creating an application. 

Some explanation of Dev Portal. What does it do for me? Why would I want to register? 

<details><summary>Key concepts</summary>

{% capture konnect_concepts %}
[**Application:**](/gateway/latest/key-concepts/services/) An application is ... For example,...

[**Application credentials:**](/gateway/latest/key-concepts/services/) Application credentials are ....

[**Developer platform:**](/gateway/latest/key-concepts/routes/) The developer platform allows developers like you to locate, access, and consume APIs. Using the Dev Portal, you can browse and search API documentation, test API endpoints, and manage your own credentials. 
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

1. **Register or sign in to the developer platform**
    To create an application against APIs in the Dev Portal, you must first register an account.
1. **Create an application against the APIs in the developer platform**
    You can use APIs in the developer platform to create your own app and register that app with the company's developer platform.
1. **Optional: Generate credentials for your application**
    ? idk  what this does for you

## Flow

All developers must register through the {{site.konnect_short_name}} Dev Portal. A {{site.konnect_short_name}} admin can provide you with the correct registration URL.

1. **Register or sign in to the developer platform**
    
    Navigate to Dev Portal and do one of the following:
        * Register for access by navigating to the Dev Portal and creating an account.
        * Sign in to the Dev Portal with single sign-on (SSO).

1. **Create an application**
    
    Once you're approved for access, you can create an application in Dev Portal by clicking **Catalog**. Click **Register** next to the API product version you want to create an application for and fill out the application information. <!-- my apps vs catalog, when do you use each? Looks like one is associated with an API product version, why? different steps once you click "Create" too-->
        {:.note}
        > The Reference ID must be unique. If your organization is using the [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) flow for application registration, enter the ID of your third-party OAuth2 claim.

1. **Optional: Generate API credentials for your application**

    A credential, or API key, generated in the {{site.konnect_short_name}} Dev Portal is a 32-character string associated with an application. An application can have multiple credentials. <!--why would you want a credential?-->
    
    1. To generate an API key from the Dev Portal, navigate to the **My Apps** page and click the application that you want to generate a credential for. 

    1. In the **Authentication** pane, click **Generate Credential**.

