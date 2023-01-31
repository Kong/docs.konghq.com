---
title: Portal Auth RBAC Setup
content-type: tutorial
---

## Overview

This guide walks you through the steps to enable RBAC in the {{site.konnect_short_name}} Portal. You can use this API to assign `API Viewer`and `API Consumer` developers roles to manage the access to the services published to the portal. 
* `API Viewer` allows developers to read the documentation associated with services published to the portal
* `API Consumer` allows developer to register the applications to consume the services published to the portal

You can create a team, assign the roles to the team and add the developers to the team using this API. Developers within the team will be granted the role assigned. 



## Enabling RBAC in portal

RBAC is disabled by default in the portal. To enable RBAC, you must make a `PATCH` request to the portal configuration endpoint. The following example shows how to enable RBAC in the portal.

```bash
curl --request PATCH \
  --url https://cloud.konghq.com/api/portals/<portal-id> \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
    "rbac_enabled": true
  }'
```

## Explain the RBAC setup



## Create a Team

To create a team, you must make a POST request to the teams endpoint. The following example shows how to create a team.

```bash
curl --request POST \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams \
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
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams \
  --header 'Authorization: Bearer <personal-access-token>'
```

## Assigning Roles

### Available Roles

To get a list of the available roles, make a GET request to the roles endpoint. The following example shows how to get a list of the available roles.

```bash
curl --request GET \
  --url https://us.api.konghq.com/v2/portal-roles \
  --header 'Authorization: Bearer <personal-access-token>'
```

### Assigning a Role to a Team

To assign a role to a team, you must make a POST request to the team roles endpoint. The following example shows how to assign the developer role to the team created in the previous section. You can find the service package ID in Serivce Hub.  

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

### Removing a Role from a Team

To remove a role from a team, you must make a DELETE request to the team roles endpoint. The following example shows how to remove the developer role from the team created in the previous section.

```bash
curl --request DELETE \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/assigned-roles/<role-id> \
  --header 'Authorization: Bearer <personal-access-token>'
```

## List Developers 

You can make a GET request to the developers endpoint to retrieve all the information about individual developers who have registered to the Dev Portal. The followig example shows how to make the request. This will allow you to receive the developer ID in the response body, which you will need this information to add the developer to the team. 

```bash
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/developers \
  --header 'Authorization: Bearer <personal-access-token>'
```

## Add a Developer to a Team

To add a developer to a team, you must make a POST request to the team members endpoint. The following example shows how to add a developer to the team created in the previous section.

```bash
curl --request POST \
  --url https://us.api.konghq.com/v2/portals/<portal-id>/teams/<team-id>/developers \
  --header 'Authorization: Bearer <personal-access-token>' \
  --header 'Content-Type: application/json' \
  --data '{
  "id": "<developer-id>"
}'
```



## More information

* [Portal Auth API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696)
