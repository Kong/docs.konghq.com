---
title: Manage Dev Portal Team Access
content_type: how-to
---

A common scenario for a Dev Portal is to restrict developers' ability to view or request access to specific [API products](/konnect/api-products/) based on their permissions. {{site.konnect_short_name}} Dev Portal enables administrators to define Role-Based Access Control (RBAC) for teams of developers through the Konnect UI and API.

Portal RBAC supports two different roles for API products that can be applied to a team of developers:

* **API Viewer:** Provides developers with read access to the documentation associated with an API product.
* **API Consumer:** Includes API Viewer permissions as well as allows developers to register applications to consume versions of an API product.


In this guide, you will set up two developer teams and then enable Portal RBAC using a hypothetical scenario.

## Prerequisites
* Two test [developer accounts registered](/konnect/dev-portal/dev-reg/)
* A [configured control plane](/konnect/getting-started/configure-data-plane-node/)
* A [personal access token](/konnect/getting-started/import/#generate-a-personal-access-token) for authorization. This is only required if you plan to use the API to create developer teams.

If you have existing registered developers in {{site.konnect_short_name}}, you must configure developer teams before enabling Portal RBAC. If you enable Portal RBAC before configuring teams for your developers, it will prevent *all* developers from seeing any API products in your Dev Portal. 

We recommend setting up your teams and permissions before enabling RBAC to allow for a seamless transition; developers see what they're supposed to, instead of nothing at all.

## Configure developer teams 

In this scenario, you are a product manager at a pizza company, responsible for overseeing their online application. Your task is to create a Dev Portal intended for delivery companies. This portal will grant delivery companies access to your APIs, enabling them to incorporate your pizza offerings into their own delivery service offerings. 

![pizza ordering api flow](/assets/images/diagrams/diagram-dev-portal-team-access.png)
> _**Figure 1:** Diagram that shows how the Pizza Ordering API works in this scenario. The diagram shows how a customer, Rosario, orders a pizza through the Pizza App, which triggers the Pizza Ordering API to be sent to the pizza restaurant. Once the restaurant receives the API request, they begin to make the pizza. When the pizza is ready, the Pizza restaurant's Dispatch Driver API alerts the Pizza App. The Pizza App assigns a delivery driver that picks up the pizza and delivers it to Rosario._

One of your primary objectives is to ensure that only trusted delivery partners are granted access to develop applications using your APIs and deliver your pizzas.

To achieve this, you must create two groups of developers, each with different levels of API access:
* **Authorized Delivery Partners:** This group can access and consume your APIs so they can integrate them into their own delivery applications.
* **Prospective Partners:** These developers are currently undergoing an evaluation process. Since these potential partners have not completed the evaluation process, you grant them restricted view-only access. This allows them to review the API specs and gain an understanding of how your system operates. 

### Create an API product

In this scenario, before you can configure developer teams, you must have an API product created. This API product will be for your Pizza Ordering API. This API is used at your pizza company's website to take orders. Delivery companies can hook into this to see when orders are placed so they can have drivers ready. 

{% navtabs %}
{% navtab Konnect UI %}
In {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager), select a control plane and follow these steps:

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.
1. From the **Add a Gateway Service** dialog, enter the following to create a new service:
    * **Name:** `pizza_ordering`
    * **Upstream URL:** `http://httpbin.org`
    * Use the defaults for the remaining fields.
1. Click **Save**. 
1. To create an API product for your service, navigate to **API Products** in the sidebar, click **Add API Product** and enter `Pizza Ordering` in the **Product Name** field.
1. Click **Publish to portal** from the **Actions** dropdown menu. This will allow developers to access the API product once you assign them to a team.
1. Click **New Version** from the **Actions** dropdown menu and enter `v1` in the **Version Name** field and then click **Create**.
1. Click the **v1** version and then click **Link** to add a service.
1. Select a control plane from the **Select Control Plane** dropdown menu, select `pizza_ordering` from the **Gateway Service** dropdown menu, and then click **Save**.
1. Click the **Edit** icon next to the status of your product version and select **Published** from the **Edit version status** dialog and then click **Save**.
1. You need to enable app registration if you want the developer in the Authorized Delivery Partners group to be able to consume your APIs by registering apps. You can use an authentication method of your choice in the [enable or disable application registration](/konnect/dev-portal/applications/enable-app-reg/) documentation.

You now have a published API product for your Pizza Ordering API in your Dev Portal.

{% endnavtab %}
{% navtab API %} 
{:.note}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Create the `pizza_ordering` service:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
          "name": "pizza_ordering",
          "host": "httpbin.org",
          "path": "/pizza_ordering"
      }'
    ```
  
    You can get the `controlPlaneId` by using the [list control planes endpoint](/konnect/api/control-planes/latest/#/Control%20Planes/list-control-planes) to list all control planes and their IDs.

    You should get a `201` response like the following:
    ```json
    {
        "connect_timeout": 60000,
        "created_at": 1692885974,
        "enabled": true,
        "host": "httpbin.org",
        "id": "06acc4f4-c6d8-4daf-bef6-79866e88ca86",
        "name": "pizza_ordering",
        "path": "/pizza_ordering",
        "port": 80,
        "protocol": "http",
        "read_timeout": 60000,
        "retries": 5,
        "updated_at": 1692885974,
        "write_timeout": 60000
    }
    ```

    Save the `id` value from the output. This is your `GATEWAY-SERVICE-ID` and will be used in another step.

1. Create the `Pizza Ordering` API product:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/api-products \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
          "name": "Pizza Ordering",
          "description": "API product for pizza ordering"
      }'
    ```

    You should get a `201` response like the following:
    ```json
    {
        "labels": {},
        "id": "0429aa6b-d789-4c73-bbb1-73a228c69477",
        "name": "Pizza Ordering",
        "description": "API product for pizza ordering",
        "portal_ids": [],
        "created_at": "2023-01-01T00:00:00.000Z",
        "updated_at": "2023-01-01T00:00:00.000Z"
    }
    ```
    Save the `id` value from the output. This is your `api-product-id` and will be used in another step.

1. Using the`api-product-id` of the newly created API product, publish the `Pizza Ordering` API product:
  
    ```bash
    curl --request PATCH \
      --url https://{region}.api.konghq.com/v2/api-products/{id} \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "portal_ids":[
        "DEV_PORTAL_ID"
      ]
    }'
    ```

    The `DEV_PORTAL_ID` can be found in the {{site.konnect_short_name}} UI in the [**Dev Portal** section](https://cloud.konghq.com/us/portal/published-products).

    You should get a `200` response like the following:
    ```json
    {
        "labels": {},
        "id": "38219b88-28fb-4a51-aaca-ea5b931939d8",
        "name": "Pizza Ordering",
        "description": "API product for pizza ordering",
        "portal_ids": [
          "a060b86d-593b-4e7e-9cc4-188d2f13265e"
        ],
        "created_at": "2023-01-01T00:00:00.000Z",
        "updated_at": "2023-01-01T00:00:00.000Z"
    }
    ```

1. Using the`api-product-id` of the newly created API product, create a `v1` version for the `Pizza Ordering` API product and publish it:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/api-products/{id}/product-versions \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "name":"v1",
      "publish_status":"published",
      "gateway_service":{
        "control_plane_id":"CONTROL_PLANE_ID",
        "id":"GATEWAY_SERVICE_ID"
        }
      }'
    ```

    You should get a `201` response like the following:
    ```json
    {
        "id": "0a8eebb6-0ed4-4382-c366-c1f4ea01f295",
        "name": "v1",
        "publish_status": "published",
        "deprecated": false,
        "created_at": "2023-01-01T00:00:00.000Z",
        "updated_at": "2023-01-01T00:00:00.000Z",
        "gateway_service": {
          "id": "0f5a6eaa-1267-4259-b226-fd2520926ee2",
          "control_plane_id": "5b32f5e1-6c0e-448d-bd94-14c770c4ffbd"
        }
    }
    ```
1. You need to enable app registration if you want the developer in the Authorized Delivery Partners group to be able to consume your APIs by registering apps. Currently, the only way to enable app registration is by using the {{site.konnect_short_name}} UI. You can use an authentication method of your choice in the [enable or disable application registration](/konnect/dev-portal/applications/enable-app-reg/) documentation.

You now have a published API product for your Pizza Ordering API in your Dev Portal.

So far, you've used the following endpoints:

* [Create a new service](https://developer.konghq.com/spec/3c38bff8-3b7b-4323-8e2e-690d35ef97e0/16adcd15-493a-49b2-ad53-8c73891e29bf#/Services/create-service)
* [Create API product](https://developer.konghq.com/spec/d420333f-01b0-464e-a87a-97acc92c2026/941af975-8cfa-40f7-afea-e82d248489a0#/API%20Products/create-api-product)
* [Update an individual API product](https://developer.konghq.com/spec/d420333f-01b0-464e-a87a-97acc92c2026/941af975-8cfa-40f7-afea-e82d248489a0#/API%20Products/update-api-product)
* [Create API product version specification](https://developer.konghq.com/spec/d420333f-01b0-464e-a87a-97acc92c2026/941af975-8cfa-40f7-afea-e82d248489a0#/API%20Product%20Version%20Specification/create-api-product-version-spec)

Review the API documentation to see what other features are available.
{% endnavtab %}
{% endnavtabs %}

### Create developer teams

Next, let's create two developer teams: "Authorized Delivery Partners" with API Viewer and Consumer permissions and "Prospective Partners" with API Consumer permissions.

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon dev-portal %} **Dev Portal**.
1. Click **Teams** in the sidebar and then click **Add team**.
1. Enter the following:
    * **Team name:** Authorized Delivery Partners
    * **Description:** Team of vetted delivery partners that can view and consume APIs
1. On the **Developers** tab of your new team, click **Add developer** and select a test developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Pizza Ordering** product from the dropdown menu and select **API Consumer** and **API Viewer** from the **Add roles** dropdown menu.
1. Click **Teams** in the sidebar and click **New Team** again and enter the following:
    * **Team name:** Prospective Partners
    * **Description:** Team of unvetted partners that can only view APIs
1. On the **Developers** tab of your new team, click **Add developer** and select a test developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Pizza Ordering** product from the dropdown menu and select **API Viewer** from the **Add roles** dropdown menu. 

You now have added your test developer accounts to two teams with different access permissions for your Dev Portal. These developers won't be able to access anything in Dev Portal yet, though, because we need to enable Portal RBAC next.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Create the `Authorized Delivery Partners` team:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portal-id}/teams \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "name": "Authorized Delivery Partners",
      "description": "Team of vetted delivery partners that can view and consume APIs"
      }'
    ```
    The `portal-id` can be found in the {{site.konnect_short_name}} UI in the **Dev Portal** section. 

    You should get a `201` response like the following:
    ```json
    {
        "id": "4bfe2ae8-42d9-46a3-a5de-80b054ae8a44",
        "name": "Authorized Delivery Partners",
        "description": "Team of vetted delivery partners that can view and consume APIs",
        "created_at": "2023-01-01T00:00:00.000Z",
        "updated_at": "2023-01-01T00:00:00.000Z"
    }
    ```
    The `portal-id` will be the value from the output of the request you used earlier to create the Pizza Delivery API product.

    Save the `id` value from the output. This is your `teamId` for the `Authorized Delivery Partners` team and will be used in another step.

1. Create the `Prospective Partners` team:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portal-id}/teams \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "name": "Prospective Partners",
      "description": "Team of unvetted partners that can only view APIs"
      }'
    ```
    The `portal-id` can be found in the {{site.konnect_short_name}} UI in the **Dev Portal** section. 

    You should get a `201` response like the following:
    ```json
    {
        "id": "4bfe2ae8-42d9-46a5-a5de-80b054ae8a44",
        "name": "Prospective Partners",
        "description": "Team of unvetted partners that can only view APIs",
        "created_at": "2023-01-01T00:00:00.000Z",
        "updated_at": "2023-01-01T00:00:00.000Z"
    }
    ```
    Save the `id` value from the output. This is your `teamId` for the `Prospective Partners` team and will be used in another step. 

1. Assign the `API Consumer` role to the `Authorized Delivery Partners` created in the previous section for your pizza ordering API product:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portal-id}/teams/{team-id}/assigned-roles \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "role_name": "API Consumer",
      "entity_id": "GATEWAY_SERVICE_ID",
      "entity_type_name": "Services"
      }'
    ```

    The `portal-id` can be found in the {{site.konnect_short_name}} UI in the **Dev Portal** section. 

    You should get a `201` response like the following:
    ```json
    {
        "id": "091260a3-1e96-40c9-86c2-c7cbe795dfdb",
        "role_name": "API Consumer",
        "entity_id": "0f5a6eaa-1967-4269-b226-fd2520926ee2",
        "entity_type_name": "Services",
        "entity_region": "us"
    }
    ```
1. Now assign the `API Viewer` role to the `Prospective Partners` team for the same pizza ordering API product:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portal-id}/teams/{team-id}/assigned-roles \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --header 'accept: application/json' \
      --data '{
      "role_name": "API Viewer",
      "entity_id": "GATEWAY_SERVICE_ID",
      "entity_type_name": "Services",
      "entity_region": "us"
      }'
    ```
    The `portal-id` can be found in the {{site.konnect_short_name}} UI in the **Dev Portal** section.
    
    You should get a `201` response like the following:
    ```json
    {
        "id": "091268a3-1e96-40c9-86c2-c7cbe795dfdb",
        "role_name": "API Viewer",
        "entity_id": "0f5a6eac-1967-4269-b226-fd2520926ee2",
        "entity_type_name": "Services",
        "entity_region": "us"
    }
    ```

1. Add a test developer to the `Authorized Delivery Partners` team:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portalId}/teams/{teamId}/developers \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --data '{"id":"DEVELOPER-ID"}'
    ```

    If you don't remember the IDs for your test developers, you can send a [GET request to list developers](/konnect/api/portal-management/latest/#/Portal%20Developers/list-portal-developers).
    
    You should get a `201` response like the following:
    ```bash
    Created
    ```
1. Add a test developer to the `Prospective Partners` team:

    ```bash
    curl --request POST \
      --url https://{region}.api.konghq.com/v2/portals/{portalId}/teams/{teamId}/developers \
      --header 'Authorization: Bearer <personal-access-token>' \
      --header 'Content-Type: application/json' \
      --data '{"id":"DEVELOPER-ID"}'
    ```
      
    If you don't remember the IDs for your test developers, you can send a [GET request to list developers](/konnect/api/portal-management/latest/#/Portal%20Developers/list-portal-developers).<br><br>
    You should get a `201` response like the following:
    ```bash
    Created
    ```

You now have added your test developer accounts to two teams with different access permissions for your Dev Portal. These developers won't be able to access anything in Dev Portal yet, though, because we need to enable Portal RBAC next.

So far, you've used the following endpoints:
* [Create team](/konnect/api/portal-management/latest/#/Portal%20Teams/create-portal-team)
* [Assign role](/konnect/api/portal-management/latest/#/Portal%20Team%20Roles/assign-role-to-portal-teams)

{% endnavtab %}
{% endnavtabs %}
 

### Enable Portal RBAC

Now that you've configured your two different teams and assigned permissions to those teams, you can enable Portal RBAC to let those permissions take affect. Portal RBAC is disabled by default in the {{site.konnect_short_name}} portal. 

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon dev-portal %} **Dev Portal** and click **Settings** in the sidebar.
1. To turn on Portal RBAC, click the **Portal RBAC** toggle.

Now, if you access your Dev Portal as one of the test developer accounts, you should see that the one assigned to the "Prospective Partners" team can only view the Pizza Ordering API while the one assigned to the "Authorized Delivery Partners" team can both view and consume the Pizza Ordering API.
{% endnavtab %}
{% navtab API %}
To enable RBAC, you must make a `PATCH` request to the portal configuration endpoint. The following example shows how to enable RBAC in the portal. For more details on how to create your personal access token, see [Authentication](/konnect/api/#authentication). 

```bash
curl --request PATCH \
  --url https://{region}.api.konghq.com/konnect-api/api/portals/{portal-id} \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"rbac_enabled": true}'
```

The `portal-id` can be found in the {{site.konnect_short_name}} UI in the **Dev Portal** section. <br><br>

Now, if you access your Dev Portal as one of the test developer accounts, you should see that the one assigned to the "Prospective Partners" team can only view the Pizza Ordering API while the one assigned to the "Authorized Delivery Partners" team can both view and consume the Pizza Ordering API.
{% endnavtab %}
{% endnavtabs %}

### Summary

Now that you've completed the steps in this scenario, you have a developer team for vetted, pizza delivery partners that can view and consume your APIs as well as a read-only developer team for unvetted, potential delivery partners. Since Portal RBAC is enabled, those teams can now view your Pizza Ordering APIs. 

## More information
[Portal RBAC API documentation](/konnect/api/portal-management/latest/)
