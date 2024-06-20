---
title: Register and create an application as a developer
---

This guide explains how developers can get started with the developer platform by registering and creating an application. 

The Dev Portal enables developers to integrate applications with APIs from third-party providers. For instance, if you are developing for a company that requires access to two distinct APIs from a third-party provider, you would need to set up an application within the Dev Portal that consumes both APIs.

The following diagram shows how you can register your app in Dev Portal:

{% mermaid %}
flowchart TD
    A[Sign up for Dev Portal] --> B(Create an application)
    B --> C(Add products to the application)
    C --> D(Create application credentials)
    D --> |Generate in Dev Portal| E[Use application] 
    D --> |Create in IdP| E
{% endmermaid %}

> **Figure 1:** To create an application against APIs in the Dev Portal, you must first register an account. You can use APIs in the developer platform to create your own app and register that app with the company's developer platform. Before you can use your app, you must create credentials to access the app.

<details><summary>Key concepts</summary>

{% capture konnect_concepts %}
**Application:** An application enables developers to register and use APIs, whether they are your company’s own or those of a third-party provider. To facilitate diverse integrations, developers can create applications that consume multiple APIs from different providers, streamlining various services into a single offering.

**Application credentials:** Credentials authorize developers to access an application. You can generate credentials automatically, or  manage them manually through an Identity Provider (IdP), like OIDC.

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

1. **Create API credentials for your application**
    
    You can generate credentials using one of the following methods:
    
    * **Generate an API key**: To generate an API key from the Dev Portal, navigate to the **My Apps** page and click the application that you want to generate a credential for. In the **Authentication** pane, click **Generate Credential**.  
    * **Manually create OIDC credentials**: To use [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) without DCR, you must manually create the application in an IdP and use the reference ID (listed on your application in Dev Portal) when creating the application.

    You can use your app once you've added products to you application, created credentials for your application, and a Dev Portal admin has approved your app. You can start making requests to the endpoints in your application, making sure to use the app credentials you configured.

