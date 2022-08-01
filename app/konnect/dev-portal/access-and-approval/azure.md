---
title: Configure Azure SSO 
no_version: true
content_type: how-to
---

Kong Gateway offers OIDC support to allow Single-Sign-on for Konnect and the Developer Portal.


## Create an Application in Azure

Login to [Azure](https://portal.azure.com/), navigate to **App Registration** and follow these steps: 

1. Register a new application:

    ![Register an application](/assets/images/docs/konnect/azure/app-registration.png)

    Give a name, select the supported account type as “Accounts in this organizational directory only (Default Directory only - Single tenant)” 
    select web as application type and enter redirect URI (can be found on portal idp settings as callback url) 
    click “Register”

2. Save the Application (client) ID  for later use, and then click “Add a certificate or secret” 

   ![Add certificate](/assets/images/docs/konnect/azure/add-certificate.png)

## Secrets 
3. Click “new client secret”, enter a value for description, and expires time (note you will need to rotate this secret before it expires), press save.

4. Save the displayed Secret Value ( do not confuse it for the secret id which we do not need) for later use.

5. Click on “Overview” in the sidebar. Click “endpoints” on the top tab

6. Select the “OpenID Connect metadata document” endpoint and visit it in a browser

    ![Endpoints](/assets/images/docs/konnect/azure/endpoints.png)

7.  Find the issuer and save it for use later

    ![Issuer](/assets/images/docs/konnect/azure/issuer.png)

8. Click “token configuration” in the sidebar and click “Add groups claim” checked all checkboxes and group_id for all fields then press **add**. 
    
    ![Group claim](/assets/images/docs/konnect/azure/group-claim.png)

9. Click “add optional claim” select ID token type and check email. Press add, and confirm the dialogue.

    ![Optional claim](/assets/images/docs/konnect/azure/optional-claim.png)

10. Go to the konnect portal identity page and select configure idp, and enter the 3 values

    ![Configure IDP](/assets/images/docs/konnect/azure/configure-idp.png)