---
title: Create a Dev Portal
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services.

You can create both public and private Dev Portals, depending on your use case. Public Dev Portals don't require users to login to see published APIs, and are discoverable on the internet. Private Dev Portals require users to create an account and log in to see published APIs. <!-- commenting out for now: Coming soon, Konnect will support Dev Portals that contain pages that are public _and_ private, allowing the public to browse the publicly available catalog, but requiring users to login to see a full catalog, and begin consuming those APIs.-->

When Dev Portal admins require developers to create an account and log in to use the Dev Portal, developers can "self serve" their API consumption. Developers can create applications, register them to their target APIs, and generate credentials to start consuming those APIs.

## Prerequisites

Configure an [authentication strategy](/konnect/dev-portal/applications/enable-app-reg/) if you plan to use one. This auth strategy will be how developers authenticate when they use your APIs. 

## Steps
{% navtabs %}
{% navtab Konnect UI %}
1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click **Dev Portal** on the top right.
1. In the Create Dev Portal dialog, configure your Dev Portal settings:
    1. Enter general information for your Dev Portal, including a name and optional description.
    1. Select if you want the Dev Portal to be private or public. Anyone can see APIs published to a public portal while only registered and logged in users can see APIs in a private portal. Developers can only get credentials and start consuming APIs through self service in a private Dev Portal.
    1. **Private Dev Portal only**: Configure the following settings:
        * **Auto Approve Developers**: If you enable this setting, this will allow developers to automatically be approved when they sign up for your private Dev Portal. If you don't enable this, you must configure single sign-on or manually approve developers as they register. 
        * **Auto Approve Applications**: If you enable this setting, apps that developers create with your APIs will be automatically approved. If you don't enable this, you must manually approve or deny application registrations.
        * **Portal RBAC**: Portal RBAC allows you to assign developers to teams and roles that determine if they can only view or view and consume the APIs in your Dev Portal.
        * **Default Application Auth Strategy**: Select the auth strategy you want the APIs in your Dev Portal to use if they require authentication. This auth strategy will be how developers authenticate when they register to consume your APIs. Selecting a default auth strategy makes it easier for your API Product owners to publish an API to a Dev Portal that requires authentication, because the default auth strategy will be auto selected for them. If you're not sure which auth strategy to use, you can select the pre-created key-auth strategy.
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
    * `name`
    * `rbac_enabled`
    * `auto_approve_applications`
    * `auto_approve_developers`
    * `custom_domain`
    * `custom_client_domain`
    * `default_application_auth_strategy_id`
    Refer to the API spec for more information. 
    
    You should receive a `201` response containing information about your Dev Portal.



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
    Be sure to replace the PAT token and placeholder values. You can use the following two values to further configure the Dev Portal: 
    * `custom_domain`: Optional, you can configure this if you want to use a different URL for hosting your Dev Portal instead of {{site.konnect_short_name}}. A CNAME for the portal's default domain must be able to be set for the custom domain for it to be valid. After setting a valid CNAME, an SSL/TLS certificate will be automatically manged for the custom domain, and traffic will be able to use the custom domain to route to the portal's web client and API.
    * `custom_client_domain`: Optional, you can configure this if you want to use a different URL for your Dev Portal other than the default one.

{% endnavtab %}
{% endnavtabs %}

## Access the Dev Portal

You can access the Dev Portal using the Dev Portal URL. The URL is displayed when you click {% konnect_icon dev-portal %} **Dev Portal** to open the **Published API Products** overview page.
The Dev Portal URL looks like this: 
    
    https://{portalId}.{region}.portal.konghq.com/

Your Dev Portal URL may vary. Keep the following in mind:

* The Dev Portal URL varies based on geographic location.
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