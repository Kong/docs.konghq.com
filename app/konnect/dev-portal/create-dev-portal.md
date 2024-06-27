---
title: Create a Dev Portal
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services. You can create both public and private Dev Portals, depending on your use case. With a public Dev Portal, anyone with the URL can view the APIs you add to your Dev Portal. With a private Dev Portal, only those who have signed in to the Dev Portal can see the APIs you add to your Dev Portal. Additionally, when you configure private Dev Portals, you can also allow developers to register apps with your APIs. You can also publish your APIs to both a private Dev Portal as well as a public one, such as if you want to have one Dev Portal for internal developers at your company as well as allow external developers at other companies to create apps with some of your APIs.

## Prerequisites

Configure an authentication strategy if you plan to use one. This auth strategy will be how developers authenticate when they use your APIs. <!-- tried searching for a link to a doc for this, is it just setting up an auth plugin?-->

## Steps
{% navtabs %}
{% navtab Konnect UI %}
1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click **Dev Portal** on the top right.
1. In the Create Dev Portal dialog, configure your Dev Portal settings:
    1. Enter general information for your Dev Portal, including a name and optional description.
    1. Select if you want the Dev Portal to be private or public. Developers can only register apps to private Dev Portals.
    1. Private Dev Portal only: Configure the following settings:
        * **Auto Approve Developers**: If you enable this setting, this will allow developers to automatically be approved when they sign up for your private Dev Portal. If you don't enable this, you must configure single sign-on or manually approve developers as they register. 
        * **Auto Approve Applications**: If you enable this setting, apps that developers create with your APIs will be automatically approved. If you don't enable this, you must manually approve or deny application registrations.
        * **Portal RBAC**: You must enable this setting if you plan to allow developers to register with your Dev Portal. Portal RBAC allows you to assign developers to teams and roles that determine if they can only view or view and consume the APIs in your Dev Portal.
        * **Default Application Auth Strategy**: Select the auth strategy you want the APIs in your Dev Portal to use if they require authentication. This auth strategy will be how developers authenticate when they use your APIs.
    1. Optional: Configure the visual customization settings, such as a Dev Portal logo, favicon, and home page header image.
    1. Optional: Add labels to your Dev Portal. Labels will help you identify and search for your Dev Portal in {{site.konnect_short_name}}.
1. Click **Save**. 
1. Repeat steps 1-3 to create additional Dev Portals. 
{% endnavtab %}
{% navtab Konnect API %}
{:.note}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

To create a Dev Portal, do one of the following:
    
* Create a private Dev Portal using the `/portals` endpoint:
    ```sh
    curl --request POST \
    --url https://{region}.api.konghq.com/v2/portals \
    --header 'Authorization: <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --data '{
        "name": "DEV_PORTAL_NAME",
        "is_public": false,
        "rbac_enabled": true,
        "auto_approve_applications": true,
        "auto_approve_developers": true,
        "custom_domain": "api.example.com",
        "custom_client_domain": "portal.example.com",
        "default_application_auth_strategy_id": "41f3adcb-5f5b-4c97-ab08-3ac2777aa6ab"
    }'
    ```
    Be sure to replace the PAT as well as the following placeholders with your own values: 
    * `name`: The name you want to display for your Dev Portal.
    * `rbac_enabled`: You must enable this setting if you plan to allow developers to register with your Dev Portal. Portal RBAC allows you to assign developers to teams and roles that determine if they can only view or view and consume the APIs in your Dev Portal.
    * `auto_approve_applications`: If you enable this setting, apps that developers create with your APIs will be automatically approved. If you don't enable this, you must manually approve or deny application registrations.
    * `auto_approve_developers`: If you enable this setting, this will allow developers to automatically be approved when they sign up for your private Dev Portal. If you don't enable this, you must configure single sign-on or manually approve developers as they register. 
    * `custom_domain`: Optional, you can configure this if you want to use a different URL for hosting your Dev Portal instead of {{site.konnect_short_name}}. A CNAME for the portal's default domain must be able to be set for the custom domain for it to be valid. After setting a valid CNAME, an SSL/TLS certificate will be automatically manged for the custom domain, and traffic will be able to use the custom domain to route to the portal's web client and API.
    * `custom_client_domain`: Optional, you can configure this if you want to use a different URL for your Dev Portal other than the default one.
    * `default_application_auth_strategy_id`: Enter the auth strategy ID you want the APIs in your Dev Portal to use if they require authentication. This auth strategy will be how developers authenticate when they use your APIs. You can find the app auth strategy ID by ?
    
    You should get a `201` response like the following:
    ```sh
    {
        "name": "My Dev Portal",
        "id": "94e5fba1-ac2f-4f07-9fd7-9e2a91ad2c27",
        "created_at": "2024-06-21T20:13:21.462Z",
        "updated_at": "2024-06-21T20:13:21.462Z",
        "custom_domain": "api.example.com",
        "custom_client_domain": "portal.example.com",
        "description": null,
        "display_name": "Developer Portal",
        "is_public": false,
        "auto_approve_developers": true,
        "auto_approve_applications": true,
        "rbac_enabled": true,
        "labels": {},
        "application_count": 0,
        "developer_count": 0,
        "published_product_count": 0,
        "default_domain": "5h0347374cb8.us.portal.konghq.com",
        "default_application_auth_strategy_id": "eae9r3ab-0378-4558-9444-ca3091541cff"
    }
    ```


* Create a public Dev Portal using the `/portals` endpoint:
    ```sh
    curl --request POST \
    --url https://{region}.api.konghq.com/v2/portals \
    --header 'Authorization: <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --data '{
    "name": "DEV_PORTAL_NAME",
    "is_public": true,
    "custom_domain": "api.example.com",
    "custom_client_domain": "portal.example.com"
    }'
    ```
    Be sure to replace the PAT as well as the following placeholders with your own values:
    * `name`: The name you want to display for your Dev Portal.
    * `custom_domain`: Optional, you can configure this if you want to use a different URL for hosting your Dev Portal instead of {{site.konnect_short_name}}. A CNAME for the portal's default domain must be able to be set for the custom domain for it to be valid. After setting a valid CNAME, an SSL/TLS certificate will be automatically manged for the custom domain, and traffic will be able to use the custom domain to route to the portal's web client and API.
    * `custom_client_domain`: Optional, you can configure this if you want to use a different URL for your Dev Portal other than the default one.

    You should get a `201` response like the following:
    ```sh
    {
        "name": "My Dev Portal",
        "is_public": true,
        "custom_domain": "api.example.com",
        "custom_client_domain": "portal.example.com",
        "id": "4959b8cc-92fb-4197-b836-3eab20b16147",
        "created_at": "2024-06-24T16:36:01.397Z",
        "updated_at": "2024-06-24T16:36:01.397Z",
        "description": null,
        "display_name": "Developer Portal",
        "auto_approve_developers": false,
        "auto_approve_applications": false,
        "rbac_enabled": false,
        "labels": {},
        "application_count": 0,
        "developer_count": 0,
        "published_product_count": 0,
        "default_domain": "e7edf6822f8a.us.portal.konghq.com",
        "default_application_auth_strategy_id": "eae8d5ab-0378-3958-9444-ca3091541cff"
    }
    ```

{% endnavtab %}
{% endnavtabs %}

## Access the Dev Portal

You can access the Dev Portal using the Dev Portal URL. The URL is displayed when you click {% konnect_icon dev-portal %} **Dev Portal** to open the **Published API Products** overview page.
The Dev Portal URL looks like this: 
    
    https://example.us.portal.konghq.com/

Your Dev Portal URL may vary. Keep the following in mind:

* The Dev Portal URL varies based on geo.
* If you're hosting your Dev Portal through Netlify, the Dev Portal URL is the one you specify in the **Dev Portal** sidebar under **Settings** > **Portal Domain** > **Custom Self-Hosted UI Domain**.

## Next steps

### Configure developer settings

* [Enable or Disable Application Registration for an API Product Version](/konnect/dev-portal/applications/enable-app-reg/)
* [Dynamic Client Registration Overview](/konnect/dev-portal/applications/dynamic-client-registration/): Dynamic Client Registration (DCR) within Konnect Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).

### Configure Dev Portal customization

* [Customize the Konnect Dev Portal](/konnect/dev-portal/customization/)
* [Host your Dev Portal with Netlify](/konnect/dev-portal/customization/netlify/)

### Publish APIs to Dev Portals

* [Add and publish API product documentation](/konnect/dev-portal/publish-service/)