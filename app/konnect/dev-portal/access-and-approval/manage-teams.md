---
title: Manage Dev Portal Teams
content_type: how-to
---

A common scenario for a Dev Portal is to restrict developers' ability to view or request access to specific services based on their permissions.

{{site.konnect_short_name}} Portal enables administrators with the ability to define Role-Based Access Control (RBAC) for teams of developers through the Konnect API.

Portal RBAC supports two different roles for Services that can be applied to a Team of developers:

* API Viewer: provides read access to the documentation associated with a Service.
* API Consumer: can register applications to consume versions of a Service.

You can use the API to create a team, assign a role to the team, and finally, add developers to the team.

In this guide, you will set up two developer teams (more info about the scenario) and then enable Portal RBAC using a hypothetical scenario.

## Prerequisites
* Two [test developer accounts registered](/konnect/dev-portal/dev-reg/)

## Configure developer teams 

In this scenario, you are a product manager at a pizza company who is in charge of their online app. You're asked to create a Dev Portal that allows delivery companies to use their APIs to deliver the company's pizzas. However, you want to make sure only trusted delivery partners can build apps using your APIs and deliver your pizzas. 

You've decided to create two groups of developers with different access levels to your APIs: 
* Delivery Partners: This developer team will be able to view and consume your APIs so they can use them in their own apps to deliver your pizzas.
* New Partners: This developer team will contain delivery groups that the company is still in the process of vetting and you don't want to allow them to consume your APIs in their apps yet. You give this group view-only privileges so they can see what your API specs look like. 

{:.important}
> **Important:** If you currently have developers in your {{site.konnect_short_name}}, you must configure developer teams before enabling Portal RBAC (which is disabled by default). If you enable Portal RBAC before configuring teams for your developers, it will prevent all developers from seeing any services in your Dev Portal. We recommend setting up your teams and permissions before enabling RBAC which will allow for a seamless transition: developers see what they're supposed to, instead of nothing at all.

### Create developer teams

First, let's create two developer teams, "Delivery Partners" with API Viewer and Consumer permissions and "New Partners" with API Consumer permissions.

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon dev-portal %} **Dev Portal**.
1. Click **Teams** in the sidebar and then click **Add team**.
1. Enter the following:
    * **Team name:** Delivery Partners
    * **Description:** Team of vetted delivery partners that can view and consume APIs
1. Click **New Team** again and enter the following:
    * **Team name:** New Partners
    * **Description:** Team of unvetted partners that can only view APIs

{% endnavtab %}
{% navtab API %}
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
1. You can verify that the teams have been created by making a GET request to the teams endpoint.
```bash
curl --request GET \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>'
```
1. Now you can assign roles to your teams. To do so, you must make a `POST` request to the team roles endpoint. The following example shows how to assign the `API Viewer` and `API Consumer` roles to the `Delivery Partners` created in the previous section for your classic pizza API product with a service ID of `5b349722-dfb4-4e78-937c-41526164fa1a`:

```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "role_name": "API Viewer, API Consumer",
  "entity_id": "5b349722-dfb4-4e78-937c-41526164fa1a",
  "entity_type_name": "Services",
  "entity_region": "us"
}'
```
1. Now assign the `API Viewer` role to the `New Partners` team for the same classic pizzas API product with a service ID of `5b349722-dfb4-4e78-937c-41526164fa1a`:

```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "role_name": "API Viewer",
  "entity_id": "5b349722-dfb4-4e78-937c-41526164fa1a",
  "entity_type_name": "Services",
  "entity_region": "us"
}'
```
1. Additionally, you've decided that since the "Delivery Partner" developers have already been vetted, it would speed up the process if you enabled auto approval for their apps. You can enable this by making the following request:
```bash
?
```
{% endnavtab %}
{% endnavtabs %}
 

### Enable Portal RBAC

Now that you've configured your two different teams and assigned permissions to those teams, you can enable Portal RBAC to let those permissions take affect.

{% navtabs %}
{% navtab Konnect UI %}

{% endnavtab %}
{% navtab API %}
RBAC is disabled by default in the {{site.konnect_short_name}} portal. To enable RBAC, you must make a `PATCH` request to the portal configuration endpoint. The following example shows how to enable RBAC in the portal. For more details on how to create your personal access token, see [Authentication](/konnect/api/#authentication). 

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

## More information
[Portal RBAC API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/)