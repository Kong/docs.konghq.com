---
title: Register and create an application as a developer
---

This guide explains how developers can get started with the Dev Portal by registering and creating an application. 

The Dev Portal enables you to quickly get access to your APIs of interest, in a self-serve way. 
Whether you're accessing the Dev Portal of a company you work for, or one that you're interested in, all you need is an application and a set of credentials to start accessing those APIs in minutes.

To create credentials, you must first create an application in which store those credentials.

The following diagram shows how to register your app in Dev Portal:

{% mermaid %}
flowchart TD
    A[Sign up for Dev Portal] --> B(Create an application)
    B --> C(Add APIs to the application)
    C --> D(Create application credentials)
    D --> |Generate in Dev Portal| E[Use application] 
    D --> |Create in IdP| E
{% endmermaid %}

> _**Figure 1:** To use the Dev Portal, you must first register for the Portal with an account. You will receive an email from the Portal admin prompting you to confirm your email address. Then, you can log in, find the API you want to use, create an application with credentials, and start using the API with those credentials._

<details><summary>Key concepts</summary>

{% capture konnect_concepts %}
**Application:** An application enables you to register for APIs in the Dev Portal. For ease of use, you can create applications that consume multiple APIs. After creating the application, you can create a single credential that consumes all the APIs that application is registered for. If you're unable to register more than one API to an application, be sure to check that the authentication strategies of those APIs are the same.

**Application credentials:** Credentials authorize you to access an application. You can generate credentials automatically, or manage them manually through an Identity Provider (IdP), like OIDC.

**Developer Portal:** Using the Dev Portal, you can browse and search API documentation, test API endpoints, manage your own credentials, and view your API consumption in the Analytics page.
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
    
    * **If you want to create an application for one API:** 
        1. Click **Catalog**. 
        1. Find the API product version you want to register for and click **Register**. 
        1. Select **Create an application**. Kong will auto select the appropriate authentication strategy for the API product version you’re registering for.
    <br>
    <br>
    * **If you want to create an application for multiple APIs:** 
        1. Click **My Apps**. 
        1. From the **My Apps** page, click **New App** and fill out the application information. 
        1. Click **Catalog**, click the product version you want to create an application for, and then click **Register**.
        1. In the registration pop-up, select the app you just created and click **Request Access**. Repeat this for as many product versions as you want to add to one application.

        Each application can only work with one authentication strategy. Dev Portal can contain products with different authentication strategies, so keep this in mind when adding more than one product to your application.
    
    {:.note}
    > **Note:** The Reference ID must be unique. If your organization is using the [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) flow for application registration, enter the ID of your third-party OAuth2 claim.

    If you want to edit or delete your app after creating it, go to the app and either click **Edit** or click **Delete** in the app settings. 

1. **Create API credentials for your application**
    
    You can generate credentials using one of the following methods:
    
    * **Generate an API key**: To generate an API key from the Dev Portal, navigate to the **My Apps** page and click the application that you want to generate a credential for. In the **Authentication** pane, click **Generate Credential**.  
    * **Manually create OIDC credentials**: To use [OIDC](/konnect/dev-portal/applications/enable-app-reg#oidc-flow) without DCR, you must manually create the application in an IdP and use the reference ID (listed on your application in Dev Portal) when creating the application.

    You can use your app once you've added products to your application, created credentials for your application, and a Dev Portal admin has approved your app. You can start making requests to the endpoints in your application, making sure to use the app credentials you configured.

