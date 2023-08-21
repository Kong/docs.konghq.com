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
* Two [test developer accounts registered](/konnect/dev-portal/dev-reg/). If you currently have developers in {{site.konnect_short_name}}, you must configure developer teams before enabling Portal RBAC (which is disabled by default). If you enable Portal RBAC before configuring teams for your developers, it will prevent *all* developers from seeing any API products in your Dev Portal. We recommend setting up your teams and permissions before enabling RBAC which will allow for a seamless transition; developers see what they're supposed to, instead of nothing at all.
* A [runtime configured](/konnect/getting-started/configure-runtime)
* A [personal access token](/konnect/getting-started/import/#generate-a-personal-access-token) for authorization

## Configure developer teams 

In this scenario, you are a product manager at a pizza company, responsible for overseeing their online application. Your task is to create a Dev Portal intended for delivery companies. This portal will grant delivery companies access to your APIs, enabling them to incorporate your pizza offerings into their own delivery service offerings. One of your primary objectives is to ensure that only trusted delivery partners are granted access to develop applications using your APIs, and deliver your pizzas.

To achieve this, you create two groups of developers, each with different levels of API access:
* **Authorized Delivery Partners:** This group can access and consume your APIs so they can integrate them into their own delivery applications.
* **Prospective Partners:** These developers are currently undergoing an evaluation process. Since these potential partners have not completed the evaluation process, you grant them restricted view-only access. This allows them to review the API specs, and gain an understanding of how your system operates. 

### Create an API product

In this scenario, before you can configure developer teams, you must have an API product created. This API product will be for your Pizza Ordering API. This API is used at the pizza company's website to take orders. Delivery companies can hook into this to see when orders are placed so they can have drivers ready. 

{% navtabs %}
{% navtab Konnect UI %}
In {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/us/runtime-manager), select a runtime group and follow these steps:

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.

1. From the **Add a Gateway Service** dialog, enter the following to create a new service:
    * **Name:** `classic_pizzas`
    * **Upstream URL:** `http://mockbin.org`
    * Use the defaults for the remaining fields.
1. Click **Save**. 
1. To create an API product for your service, navigate to **API Products** in the sidebar, click **Add API Product** and enter `Pizza Ordering` in the **Product Name** field.
1. Click **Publish to portal** from the **Actions** dropdown menu. This will allow developers to see your API product once you assign them to a team.
1. Click **New Version** from the **Actions** dropdown menu and enter `v1` in the **Version Name** field and then click **Create**.
1. Click the **v1** version and then click **Link** to add a service.
1. Select a runtime from the **Select Runtime Group** dropdown menu, select `classic_pizzas` from the **Gateway Service** dropdown menu, and then click **Save**.
1. Click the **Edit** icon next to the status of your product version and select **Published** from the **Edit version status** dialog and then click **Save**.

{% endnavtab %}
{% navtab API %} 
{:.note}
> **Note:** Make sure to include headers with the personal access token in your requests.

1. [Create the `classic_pizzas` service](https://developer.konghq.com/spec/3c38bff8-3b7b-4323-8e2e-690d35ef97e0/16adcd15-493a-49b2-ad53-8c73891e29bf#/Services/create-service):
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/{runtime-group-id}/core-entities/services \
  --data "name": "classic_pizzas" \
  --data "host": "http://mockbin.org" \
  --data "path": "/classic_pizzas" 
```
1. [Create the `Pizza Ordering` API product](https://developer.konghq.com/spec/d420333f-01b0-464e-a87a-97acc92c2026/941af975-8cfa-40f7-afea-e82d248489a0#/API%20Products/create-api-product):
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/api-products \
  --data "name": "Pizza Ordering" \
  --data "description": "API product for pizza ordering" 
```
  Save the `portal-id` value from the output. This will be used later.
1. [Create the `v1` version for the `Pizza Ordering` API product and publish it](https://developer.konghq.com/spec/d420333f-01b0-464e-a87a-97acc92c2026/941af975-8cfa-40f7-afea-e82d248489a0#/API%20Product%20Version%20Specification/create-api-product-version-spec):
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/api-products/<api-product-id>/product-versions \
  --data "id": "GATEWAY_SERVICE_ID" \
  --data "name": "v1" \
  --data "gateway_service": {
      "runtime_group_id": "RUNTIME_GROUP_ID"
    } \
  --data "publish_status": "published"
```
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
1. On the **Developers** tab of your new team, click **Add developer** and select a developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Pizza Ordering** product from the dropdown menu and select **API Consumer** and **API Viewer** from the **Add roles** dropdown menu.
1. Click **Teams** in the sidebar and click **New Team** again and enter the following:
    * **Team name:** Prospective Partners
    * **Description:** Team of unvetted partners that can only view APIs
1. On the **Developers** tab of your new team, click **Add developer** and select a developer to add to the team.
1. On the **Products** tab of your new team, click **Add Role**.
1. Select the **Pizza Ordering** product from the dropdown menu and select **API Viewer** from the **Add roles** dropdown menu. 
{% endnavtab %}
{% navtab API %}
{:.note}
> **Note:** Make sure to include headers with the personal access token in your requests.

1. [Create the `Authorized Delivery Partners` team](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696#/Teams/create-portal-team):
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --data "name": "Authorized Delivery Partners" \
  --data "description": "Team of vetted delivery partners that can view and consume APIs"
```
  The `portal-id` will be the value from the output of the request you used earlier to create the Pizza Delivery API product.
1. [Create the `Prospective Partners` team](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696#/Teams/create-portal-team):
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --data "name": "Prospective Partners" \
  --data "description": "Team of unvetted partners that can only view APIs"
```
  You can verify that the teams have been created by [making a GET request to the teams endpoint](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696#/Teams/get-portal-team). 
1. Now you can assign roles to your teams. To do so, you must [make a `POST` request to the team roles endpoint](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696#/Team%20Roles/portal-teams-assign-role). The following example shows how to assign the `API Consumer` role to the `Authorized Delivery Partners` created in the previous section for your pizza ordering API product:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --data "role_name": "API Consumer" \
  --data "entity_id": "SERVICE_ID" \
  --data "entity_type_name": "Services"
```
1. Now [assign the `API Viewer` role to the `Prospective Partners` team](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696#/Team%20Roles/portal-teams-assign-role) for the same pizza ordering API product:
```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --data "role_name": "API Viewer" \
  --data "entity_id": "SERVICE_ID" \
  --data "entity_type_name": "Services"
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
  --data "rbac_enabled": true
```

{:.note}
> The `portal-id` can be found in {{site.konnect_short_name}} within the **Dev Portal** section.
{% endnavtab %}
{% endnavtabs %}

### Summary

Now that you've completed the steps in this scenario, you have a developer team for vetted, pizza delivery partners that can view and consume your APIs as well as a read-only developer team for unvetted, potential delivery partners. Since Portal RBAC is enabled, those teams can now view your Pizza Ordering APIs. 

## More information
[Portal RBAC API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/)