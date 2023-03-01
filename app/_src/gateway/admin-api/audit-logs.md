---
title: Audit Logs
badge: enterprise
---

You can access request and database audit logs through the Admin API.

For usage examples, see [Audit Logging in {{site.base_gateway}}](/gateway/{{page.kong_version}}/kong-enterprise/audit-log/).

## List audit logs

### List request audit logs

**Endpoint**

<div class="endpoint get">/audit/requests</div>

**Response**

```
HTTP 200 OK
```

Example response generated for checking the `/status` endpoint without RBAC enabled:

{% if_version lte:3.1.x %}
```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": null,
            "removed_from_payload": null,
            "request_id": "OjOcUBvt6q6XJlX3dd6BSpy1uUkTyctC",
            "request_timestamp": 1676424547,
            "signature": null,
            "status": 200,
            "ttl": 2591997,
            "workspace": "1065b6d6-219f-4002-b3e9-334fc3eff46c"
        }
    ],
    "total": 1
}
```
{% endif_version %}

{% if_version gte:3.2.x %}
```json
{
    "data": [
        {
            "client_ip": "127.0.0.1",
            "method": "GET",
            "path": "/status",
            "payload": null,
            "rbac_user_id": null,
            "rbac_user_name": null,
            "removed_from_payload": null,
            "request_id": "OjOcUBvt6q6XJlX3dd6BSpy1uUkTyctC",
            "request_source": null,
            "request_timestamp": 1676424547,
            "signature": null,
            "status": 200,
            "ttl": 2591997,
            "workspace": "1065b6d6-219f-4002-b3e9-334fc3eff46c"
        }
    ],
    "total": 1
}
```
{% endif_version %}

### List database audit logs

**Endpoint**

<div class="endpoint get">/audit/objects</div>

**Response**

```
HTTP 200 OK
```

Example response for a consumer creation log entry:
```json
{
    "data": [
        {
            "dao_name": "consumers",
            "entity": "{\"created_at\":1542131418000,\"id\":\"16787ed7-d805-434a-9cec-5e5a3e5c9e4f\",\"username\":\"bob\",\"type\":0}",
            "entity_key": "16787ed7-d805-434a-9cec-5e5a3e5c9e4f",
            "expire": 1544723418009,
            "id": "7ebabee7-2b09-445d-bc1f-2092c4ddc4be",
            "operation": "create",
            "request_id": "59fpTWlpUtHJ0qnAWBzQRHRDv7i5DwK2"
        },
  ],
  "total": 1
}
```
