---
title: Create a Dev Portal
---

intro paragraph, mention multi-portal

public vs private? help me choose



## Prerequisites

Configure an authentication strategy if you plan to use one. This auth strategy will be how developers authenticate when they use your APIs.

The following aren't required to create a Dev Portal, but we recommend that you do these first to streamline publishing to your Dev Portal:
* Create an API product that you want to publish
* Create an API product version for that product
* Publish documentation and/or specs to the API product version

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

1. To create a Dev Portal, do one of the following:
    1. Create a public Dev Portal using the `/portals` endpoint:
        ```sh
        curl --request POST \
        --url https://us.api.konghq.com/v2/portals \
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
    

    1. Create a private Dev Portal using the `/portals` endpoint:
{% endnavtab %}
{% endnavtabs %}

## Next steps
add some links about what they should next, maybe fancy cards with text that explains who would want to do the next thing? Or break links/cards into section based on use case?
* publish stuff to dev portal
* configure all the things for developer access to the portal
* self-host/customize portal