---
title: Manage Dev Portal Teams
content_type: how-to
---

A common scenario for a Dev Portal is to restrict developers' ability to view or request access to specific API products based on their permissions. {{site.konnect_short_name}} Portal enables administrators to define Role-Based Access Control (RBAC) for teams of developers through the Konnect UI and API.

Portal RBAC supports two different roles for API products that can be applied to a team of developers:

* **API Viewer:** Provides developers with read access to the documentation associated with an API product.
* **API Consumer:** Includes API Viewer permissions as well as allows developers to register applications to consume versions of an API product.

You can use the API and UI to create a team, assign a role to the team, and finally, add developers to the team.

In this guide, you will set up two developer teams and then enable Portal RBAC using a hypothetical scenario.

## Prerequisites
* Two [test developer accounts registered](/konnect/dev-portal/dev-reg/)
* A [runtime configured](/konnect/getting-started/configure-runtime)

## Configure developer teams 

In this scenario, you are a product manager at a pizza company, responsible for overseeing their online application. Your task is to create a Developer Portal intended for delivery companies. This portal will grant delivery companies access to your APIs, enabling them to incorporate your pizza offerings into their own delivery service offerings. One of your primary objectives is to ensure that only trusted delivery partners are granted access to develop applications using your APIs, and deliver your pizzas.

To achieve this, you create two groups of developers, each with different levels of API access:
* **Authorized Delivery Partners:** This group can access and consume your APIs so they can integrate them into their own delivery applications.
* **Prospective Partners:** These developers are currently undergoing an evaluation process. Since these potential partners have not completed the evaluation process, you grant them restricted view-only access. This allows them to review the API specs, and gain an understanding of how your system operates. 

{:.important}
> **Important:** If you currently have developers in {{site.konnect_short_name}}, you must configure developer teams before enabling Portal RBAC (which is disabled by default). If you enable Portal RBAC before configuring teams for your developers, it will prevent *all* developers from seeing any API products in your Dev Portal. We recommend setting up your teams and permissions before enabling RBAC which will allow for a seamless transition; developers see what they're supposed to, instead of nothing at all.

### Create an API product

In this scenario, before you can configure developer teams, you must have an API product created. This API product will be for your classic pizzas APIs.

{% navtabs %}
{% navtab Konnect UI %}
In {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/us/runtime-manager), select a runtime group and follow these steps:

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.

1. From the **Add a Gateway Service** dialog, enter the following to create a new service:
    * **Name:** classic_pizzas
    * **Upstream URL:** `http://mockbin.org`
    * Use the defaults for the remaining fields.
1. Click **Save**. 
1. To create an API product for your service, navigate to **API Products** in the sidebar, click **Add API Product** and enter `Classic Pizzas` in the **Product Name** field.
1. Click **Publish to portal** from the **Actions** dropdown menu. This will allow developers to see your API product once you assign them to a team.
1. Click **New Version** from the **Actions** dropdown menu and enter `v1` in the **Version Name** field and then click **Create**.
1. Click the **v1** version and then click **Link** to add a service.
1. Select a runtime from the **Select Runtime Group** dropdown menu, select **classic_pizzas** from the **Gateway Service** dropdown menu, and then click **Save**.
1. Click the **Edit** icon next to the status of your product version and select **Published** from the **Edit version status** dialog and then click **Save**.

{% endnavtab %}
{% navtab API %}
{:.note}
> **Note:** Make sure you replace the placeholders in the following API requests with information specific to your environment. 

1. Create the `classic_pizzas` service:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/{runtime-group-id}/core-entities/services \
  --data '{
    "name": "classic_pizzas",
    "retries": 5,
    "protocol": "http",
    "host": "example.com",
    "port": 80,
    "path": "/classic_pizzas",
    "connect_timeout": 6000,
    "write_timeout": 6000,
    "read_timeout": 6000,
    "tags": [
      "user-level"
    ],
    "client_certificate": {
      "id": "CERTIFICATE_ID"
    },
    "tls_verify": true,
    "tls_verify_depth": null,
    "ca_certificates": [
      "CA_CERTIFICATE_ID"
    ],
    "enabled": true
  }'
```
1. Create the `Classic Pizzas` API product:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/api-products \
  --data '{
    "id": "GATEWAY_SERVICE_ID",
    "name": "Classic Pizzas",
    "description": "API product for classic pizzas",
    "portal_ids": "PORTAL_ID",
    "labels": {
        "env": "test"
    }
  }'
```
1. Create the `v1` version for the `Classic Pizzas` API product and publish it:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/api-products/<api-product-id>/product-versions \
  --data '{
    "id": "GATEWAY_SERVICE_ID",
    "name": "v1",
    "gateway_service": {
        "runtime_group_id": "RUNTIME_GROUP_ID"
    },
    "publish_status": "published"
  }'
```
{% endnavtab %}
{% endnavtabs %}

### Create developer teams

Next, let's create two developer teams: "Delivery Partners" with API Viewer and Consumer permissions and "New Partners" with API Consumer permissions.

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon dev-portal %} **Dev Portal**.
1. Click **Teams** in the sidebar and then click **Add team**.
1. Enter the following:
    * **Team name:** Delivery Partners
    * **Description:** Team of vetted delivery partners that can view and consume APIs
1. On the **Developers** tab of your new team, click **Add developer** and select a developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Classic Pizzas** product from the dropdown menu and select **API Consumer** and **API Viewer** from the **Add roles** dropdown menu.
1. Click **Teams** in the sidebar and click **New Team** again and enter the following:
    * **Team name:** New Partners
    * **Description:** Team of unvetted partners that can only view APIs
1. On the **Developers** tab of your new team, click **Add developer** and select a developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Classic Pizzas** product from the dropdown menu and select **API Viewer** from the **Add roles** dropdown menu. 
{% endnavtab %}
{% navtab API %}
{:.note}
> **Note:** Make sure you replace the placeholders in the following API requests with information specific to your environment. 

1. Create the `Delivery Partners` team:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
    "name": "Delivery Partners",
    "description": "Team of vetted delivery partners that can view and consume APIs"
  }'
```
1. Create the `New Partners` team:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
    "name": "New Partners",
    "description": "Team of unvetted partners that can only view APIs"
  }'
```
1. You can verify that the teams have been created by making a GET request to the teams endpoint:
```bash
curl --request GET \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>'
```
1. Now you can assign roles to your teams. To do so, you must make a `POST` request to the team roles endpoint. The following example shows how to assign the `API Viewer` and `API Consumer` roles to the `Delivery Partners` created in the previous section for your classic pizza API product:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "role_name": "API Viewer, API Consumer",
  "entity_id": "SERVICE_ID",
  "entity_type_name": "Services",
  }'
```
1. Now assign the `API Viewer` role to the `New Partners` team for the same classic pizzas API product:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "role_name": "API Viewer",
  "entity_id": "SERVICE_ID",
  "entity_type_name": "Services",
  }'
```
{% endnavtab %}
{% endnavtabs %}
 

### Enable Portal RBAC

Now that you've configured your two different teams and assigned permissions to those teams, you can enable Portal RBAC to let those permissions take affect. Portal RBAC is disabled by default in the {{site.konnect_short_name}} portal. 

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon dev-portal %} **Dev Portal** and click **Settings** in the sidebar.
1. To turn on Portal RBAC, click the **Portal RBAC** toggle.
{% endnavtab %}
{% navtab API %}
To enable RBAC, you must make a `PATCH` request to the portal configuration endpoint. The following example shows how to enable RBAC in the portal. For more details on how to create your personal access token, see [Authentication](/konnect/api/#authentication). 

```bash
curl --request PATCH \
  --url https://<region>.api.konghq.com/konnect-api/api/portals/<portal-id> \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
    "rbac_enabled": true
  }'
```

{:.note}
> The `portal-id` can be found in {{site.konnect_short_name}} within the **Dev Portal** section.
{% endnavtab %}
{% endnavtabs %}

### Summary

In this scenario, you learned how enable Portal RBAC for two different developer teams, one with viewing and consumption permissions and one with only viewing permissions. These different teams can be useful if you want to allow one group to consume your APIs to use in their apps and if you want another group to only view your APIs. 

## More information
[Portal RBAC API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/)