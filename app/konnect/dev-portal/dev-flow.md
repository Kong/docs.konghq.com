---
title: Developer Flow
---

## Happy path

1. I somehow know I need to sign up for access to Dev Portal (internal: my manager tells me to so I can do my job, external: I'm partnering with this company and want to use their APIs for my app)
1. I sign up for Dev Portal
    * how do I know where to go to access the Dev Portal? Can the URL always be predicted, like `https://example.us.portal.konghq.com/`?
1. I get approved
1. I create my application with APIs in Dev Portal
    * what's an application? How do they relate to services and APIs?
1. My application is approved.

## Actual content below

Some explanation of Dev Portal. What does it do for me? Why would I want to register? Maybe what is an application.

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

