---
title: Portal RBAC Setup
content-type: tutorial
---

## Overview

Role-based Access Control (RBAC) allows you to apply `API Viewer` and `API Consumer` roles in order to manage how developers can access services published to the dev portal. 

* API Viewer: provides read access to the documentation associated with services. 
* API Consumer: can register applications to consume services. 

You can use the API to create a team of developers, assign a role to the team, and add developers to the team. 

## Enable RBAC in portal

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
> The `portal-id` can be found in the {{site.konnect_short_name}} Portal within the **Developers** tab. 

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

To get a list of the available roles, make a GET request to the roles endpoint. The following example shows how to get a list of the available roles.

```bash
curl --request GET \
  --url https://us.api.konghq.com/v2/portal-roles \
  --header 'Authorization: Bearer <personal-access-token>'
```

To assign a role to a team, you must make a POST request to the team roles endpoint. The following example shows how to assign the developer role to the team created in the previous section.

```bash
curl --request POST \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "role_name": "API Viewer",
  "entity_id": "<service-package-id>",
  "entity_type_name": "Services",
  "entity_region": "us"
}'
```

To remove a role from a team, you must make a DELETE request to the team roles endpoint. The following example shows how to remove the developer role from the team created in the previous section.

```bash
curl --request DELETE \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles/<role-id> \
  --header 'Authorization: Bearer <personal-access-token>'
```

### Add a Developer to a Team

You can make a GET request to the developers endpoint to retrieve all the information about individual developers who have registered to the Dev Portal. The followig example shows how to make the request. 

```bash
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/developers \
  --header 'Authorization: Bearer <personal-access-token>'
```

To add a developer to a team, you must make a POST request to the team members endpoint. The following example shows how to add a developer to the team created in the previous section.
@@ -103,3 +113,9 @@ curl --request POST \
  "id": "<developer-id>"
}'
```


## More information
[Portal Auth API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/)
