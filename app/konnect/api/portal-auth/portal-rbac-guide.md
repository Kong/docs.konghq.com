---
title: Portal Auth RBAC Setup
content-type: tutorial
---

## Getting Started

This guide walks you through the steps to enable RBAC in the {{site.konnect_short_name}} Portal. For more details on how to create your personal access token, see [Authentication](/konnect/api/#authentication). 


### Enable RBAC in portal

RBAC is disabled by default in the portal. To enable RBAC, you must make a `PATCH` request to the portal configuration endpoint. The following example shows how to enable RBAC in the portal.

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
> The `portal-id` can be found in the {{site.konnect_short_name}} within the **Developers** tab. 


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

## More information
[Portal Auth API documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/0ecb66fc-0049-414a-a1f9-f29e8a02c696)
