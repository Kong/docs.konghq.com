---
title: Register and create an application as a developer
---

This guide explains how developers can get started with the developer platform by registering and creating an application. 

Some explanation of Dev Portal. What does it do for me? Why would I want to register? 

{% mermaid %}
flowchart TD
    A[Sign up for Dev Portal] -->|Access approved| B(Create an application)
    B --> |Registration approved| C(Add products to the application)
    C --> D(Create application credentials)
    D --> |Generate in Dev Portal| E[Use application] 
    D --> |Create in IdP| E
{% endmermaid %}

> **Figure 1:** To create an application against APIs in the Dev Portal, you must first register an account. You can use APIs in the developer platform to create your own app and register that app with the company's developer platform. Before you can use your app, you must create credentials to access the app.

<details><summary>Key concepts</summary>

{% capture konnect_concepts %}
**Application:** An application allows developers to register with APIs. These can be your company's APIs or the APIs of another company. For example, I'm a developer for an airline company. My airline is forming a partnership with a hotel and a theme park so that you can get a vacation package that includes airplane tickets, theme park tickets, and hotel tickets. To make this possible, I'd need to create an application that consumes both the hotel's API as well as the theme park API so that when they buy airplane tickets, my application would use the other companies' APIs to also purchase the theme park tickets and hotel.

**Application credentials:** Application credentials are what allow the developer to access the app. You can either generate credentials or manually manage them in an IdP with OIDC.

**Developer platform:** The developer platform allows developers like you to locate, access, and consume APIs. Using the Dev Portal, you can browse and search API documentation, test API endpoints, and manage your own credentials. 
{% endcapture %}

{{ konnect_concepts | markdownify }}

</details>

## Register and create an application

All developers must register through the {{site.konnect_short_name}} Dev Portal. A {{site.konnect_short_name}} admin can provide you with the correct registration URL.

1. **Register or sign in to the developer platform**
    
    Navigate to Dev Portal and do one of the following:
    * Register for access by navigating to the Dev Portal and creating an account.
    * Sign in to the Dev Portal with single sign-on (SSO).

    Once you're approved for access, you can create an application in Dev Portal.

1. **Create an application**

    Click **My Apps**. From the **My Apps** page, click **New App** and fill out the application information. 
    
    {:.note}
    > **Note:** The Reference ID must be unique. If your organization is using the [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) flow for application registration, enter the ID of your third-party OAuth2 claim.

1. **Add products to your application**

    Click **Catalog**, click the product version you want to create an application for, and then click **Register**. In the registration pop-up, select the app you just created and click **Request Access**. Repeat this for as many product versions as you want to add to one application.

    Each application can only work with one auth strategy. Dev Portal can contain products with different auth strategies, so keep this in mind when adding more than one product to your application.
    
    {:.note}
    > **Note:** The Reference ID must be unique. If your organization is using the [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) flow for application registration, enter the ID of your third-party OAuth2 claim.

1. **Create API credentials for your application**

    Every application must have credentials so that you can access your app. An application can have multiple credentials. You can generate credentials using one of the following methods:
    * **Generate credentials**: A credential, or API key, generated in the {{site.konnect_short_name}} Dev Portal is a 32-character string associated with an application. 
        1. To generate an API key from the Dev Portal, navigate to the **My Apps** page and click the application that you want to generate a credential for. 

        1. In the **Authentication** pane, click **Generate Credential**.
        
    * **Manually create OIDC credentials**: To use ODIC without DCR, you must manually create the application in an IdP and use the reference ID (listed on your application in Dev Portal) when creating the application.

    You can use your app once you've added products to you application, created credentials for your application, and a Dev Portal admin has approved your app.

1. **Use your application**
    
    <!--how do I USE the application?-->

