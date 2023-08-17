---
title: Portal RBAC Setup
content-type: tutorial
---

## Overview

A common scenario for a Dev Portal is to restrict developers' ability to view or request access to specific services based on their permissions.

{{site.konnect_short_name}} Portal enables administrators with the ability to define Role-Based Access Control (RBAC) for teams of developers through the Konnect API.

Portal RBAC supports two different roles for Services that can be applied to a Team of developers:

* API Viewer: provides read access to the documentation associated with a Service.
* API Consumer: can register applications to consume versions of a Service.

You can use the API to create a team, assign a role to the team, and finally, add developers to the team.

## Enable RBAC in portal

Portal RBAC is deny-by-default which means that if you haven't configured teams & roles for your developers, then enabling the capability will prevent them from seeing any services in the Portal.

We recommend setting up your teams and permissions before enabling RBAC which will allow for a seamless transition: developers see what they're supposed to, instead of nothing at all.

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

## Setup RBAC

### Create a Team

To create a team, you must make a POST request to the teams endpoint. The following example shows how to create a team.

```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
    "name": "IDM - Developers Team",
    "description": "The Identity Management (IDM) team."
  }'
```

You can verify that the team has been created by making a GET request to the teams endpoint.

```bash
curl --request GET \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>'
```

### Assign a Role to a Team

Once you have defined a Team, the next step is to assign one or more roles to the team.

To get a list of the available roles, make a GET request to the roles endpoint. The following example shows how to get a list of the available roles.

```bash
curl --request GET \
  --url https://<region>.api.konghq.com/v2/portal-roles \
  --header 'Authorization: Bearer <personal-access-token>'
```

Available roles are limited to managing access to Services. In the future, we may expand the types of access that can be managed. The current list of available Service roles are:

* "API Consumer"
* "API Viewer"

Assigning a role to a team requires a few pieces of information:

* The Entity type (e.g. `Services`)
* The Role to be applied (e.g. `API Consumer` or `API Viewer`)
* The Entity id (e.g. `5b349722-dfb4-4e78-937c-41526164fa1a`)
* The Region the Entity is in (e.g. `us` or `eu`)

To assign a role to a team, you must make a POST request to the team roles endpoint. The following example shows how to assign the `API Viewer` role to the team created in the previous section for a particular Service with id of `5b349722-dfb4-4e78-937c-41526164fa1a`.

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

Each role mapping created has a unique ID that can be used later for removing that role permission.

```json
{
  "id": "8a368199-258e-4e55-81e7-346bbf9c182a",
  "role_name": "API Viewer",
  "entity_region": "us",
  "entity_type_name": "Services",
  "entity_id": "a2df2d4d-127e-4625-b26d-92cbd4a3b930"
}
```

To remove a role from a team, you must make a DELETE request to the team roles endpoint. The following example shows how to remove the RBAC role from the team created in the previous section.

```bash
curl --request DELETE \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles/<role-id> \
  --header 'Authorization: Bearer <personal-access-token>'
```

### Add a Developer to a Team

Once a Team has been created with one or more RBAC roles, you need to add developers to the team.

Every developer in your portal has a unique ID that can be used for management operations.

You can make a GET request to the developers endpoint to retrieve all the information about individual developers who have registered to the Dev Portal. The following example shows how to make the request.

```bash
curl --request GET \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/developers \
  --header 'Authorization: Bearer <personal-access-token>'
```

To add a developer to a team, you make a POST request to the team members endpoint with the unique ID of the developer you want to add. The following example shows how to add a developer to a team.

```bash
curl --request POST \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/developers \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "id": "<developer-id>"
}'
```

### Remove a Developer from a Team

To remove a developer from a team, you make a DELETE request to the team members endpoint with the unique ID of the developer you want to remove. The following example shows how to add a developer to a team.

```bash
curl --request DELETE \
  --url https://<region>.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/developers/<developer-id> \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json'
```

## More information
[Portal RBAC API documentation](/konnect/api/portal-rbac/v2/)
