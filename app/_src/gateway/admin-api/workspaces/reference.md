---
title: Workspaces Reference
badge: enterprise

workspace_body: |
    Attribute | Description
    ---:| ---
    `name` | The workspace name.
---


{{site.base_gateway}}'s workspaces feature is configurable through Kong's
Admin API.

The workspace object describes the workspace entity, which has an ID
and a name.

For workspace use cases and configuration examples, see [Workspace Examples](/gateway/{{page.release}}/kong-enterprise/workspaces/).

## Add workspace

**Endpoint**

<div class="endpoint post">/workspaces/</div>

**Request body**

{{ page.workspace_body }}

**Response**

```
HTTP 201 Created
```

```json
{
  "comment": null,
  "config": {
    "meta": null,
    "portal": false,
    "portal_access_request_email": null,
    "portal_approved_email": null,
    "portal_auth": null,
    "portal_auth_conf": null,
    "portal_auto_approve": null,
    "portal_cors_origins": null,
    "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
    "portal_emails_from": null,
    "portal_emails_reply_to": null,
    "portal_invite_email": null,
    "portal_reset_email": null,
    "portal_reset_success_email": null,
    "portal_token_exp": null
  },
  "created_at": 1557441226,
  "id": "c663cca5-c6f6-474a-ae44-01f62aba16a9",
  "meta": {
    "color": null,
    "thumbnail": null
  },
  "name": "green-team"
}
```

## List workspaces

**Endpoint**

<div class="endpoint get">/workspaces/</div>

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "comment": null,
      "config": {
        "meta": null,
        "portal": false,
        "portal_access_request_email": null,
        "portal_approved_email": null,
        "portal_auth": null,
        "portal_auth_conf": null,
        "portal_auto_approve": null,
        "portal_cors_origins": null,
        "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
        "portal_emails_from": null,
        "portal_emails_reply_to": null,
        "portal_invite_email": null,
        "portal_reset_email": null,
        "portal_reset_success_email": null,
        "portal_token_exp": null
      },
      "created_at": 1557419951,
      "id": "00000000-0000-0000-0000-000000000000",
      "meta": {
        "color": null,
        "thumbnail": null
      },
      "name": "default"
    },
    {
      "comment": null,
      "config": {
        "meta": null,
        "portal": false,
        "portal_access_request_email": null,
        "portal_approved_email": null,
        "portal_auth": null,
        "portal_auth_conf": null,
        "portal_auto_approve": null,
        "portal_cors_origins": null,
        "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
        "portal_emails_from": null,
        "portal_emails_reply_to": null,
        "portal_invite_email": null,
        "portal_reset_email": null,
        "portal_reset_success_email": null,
        "portal_token_exp": null
      },
      "created_at": 1557441226,
      "id": "c663cca5-c6f6-474a-ae44-01f62aba16a9",
      "meta": {
        "color": null,
        "thumbnail": null
      },
      "name": "green-team"
    }
  ],
  "next": null
}
```

## Update or create a workspace

**Endpoint**

<div class="endpoint put">/workspaces/{id}</div>

Attributes | Description
---:| ---
`id`<br>**conditional** | The **workspaces'** unique ID, if replacing it.*


* The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for workspaces), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

**Request body**

Attribute | Description
---:| ---
`name` | The workspace name.

**Response**

If creating the entity:

```
HTTP 201 Created
```

If replacing the entity:

```
HTTP 200 OK
```

```json
{
  "comment": null,
  "config": {
    "meta": null,
    "portal": false,
    "portal_access_request_email": null,
    "portal_approved_email": null,
    "portal_auth": null,
    "portal_auth_conf": null,
    "portal_auto_approve": null,
    "portal_cors_origins": null,
    "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
    "portal_emails_from": null,
    "portal_emails_reply_to": null,
    "portal_invite_email": null,
    "portal_reset_email": null,
    "portal_reset_success_email": null,
    "portal_token_exp": null
  },
  "created_at": 1557504202,
  "id": "c663cca5-c6f6-474a-ae44-01f62aba16a9",
  "meta": {
    "color": null,
    "thumbnail": null
  },
  "name": "rocket-team"
}
```

## Retrieve a workspace

**Endpoint**

<div class="endpoint get">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
  "config": {
    "portal": false,
    "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]"
  },
  "created_at": 1557504202,
    "id": "c663cca5-c6f6-474a-ae44-01f62aba16a9",
    "meta": { },
  "name": "rocket-team"
}
```

## Retrieve workspace metadata

**Endpoint**

<div class="endpoint get">/workspaces/{name or id}/meta</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
  "counts": {
    "acls": 1,
    "basicauth_credentials": 1,
    "consumers": 1234,
    "files": 41,
    "hmacauth_credentials": 1,
    "jwt_secrets": 1,
    "keyauth_credentials": 1,
    "oauth2_authorization_codes": 1,
    "oauth2_credentials": 1,
    "oauth2_tokens": 1,
    "plugins": 5,
    "rbac_roles": 3,
    "rbac_users": 12,
    "routes": 15,
    "services": 2,
    "ssl_certificates": 1,
    "ssl_servers_names": 1,
    "targets": 1,
    "upstreams": 1
  }
}
```

## Delete a workspace

**Endpoint**

<div class="endpoint delete">/workspaces/{name or id}</div>

{% if_version lte:3.3.x %}

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to delete

{:.note}
> **Note:** All entities within a workspace must be deleted before the
workspace itself can be.

{% endif_version %}

{% if_version gte:3.4.x %}
Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to delete
`cascade` | The `cascade` option lets you delete a workspace and all of its entities in one request.


**Response**

```
HTTP 204 No Content
```


Perform a cascading delete. Normally, deleting a workspace requires its entities to be deleted first. The `cascade` option lets you delete a workspace and all of its entities in one request.

```
DELETE /workspaces/{name or id}?cascade=true
```
{% endif_version %}
## Update a workspace

**Endpoint**

<div class="endpoint patch">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to patch

**Request body**

Attributes | Description
---:| ---
`comment` | A string describing the workspace

The behavior of `PATCH` endpoints prevents the renaming of a workspace.

**Response**

```
HTTP 200 OK
```

```json
{
  "comment": "this is a sample comment in the patch request",
  "config": {
    "meta": null,
    "portal": false,
    "portal_access_request_email": null,
    "portal_approved_email": null,
    "portal_auth": null,
    "portal_auth_conf": null,
    "portal_auto_approve": null,
    "portal_cors_origins": null,
    "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
    "portal_emails_from": null,
    "portal_emails_reply_to": null,
    "portal_invite_email": null,
    "portal_reset_email": null,
    "portal_reset_success_email": null,
    "portal_token_exp": null
  },
  "created_at": 1557509909,
  "id": "c543d2c8-d297-4c9c-adf5-cd64212868fd",
  "meta": {
    "color": null,
    "thumbnail": null
  },
  "name": "green-team"
}
```

## Access an endpoint within a workspace

**Endpoint**

<div class="endpoint">/{name or id}/{endpoint}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the workspace to target.

Can be used with any request method.

Target entities within a specified workspace by adding the workspace name or ID prefix before any entity endpoint.

```sh
http://localhost:8001/<WORKSPACE_NAME|WORKSPACE_ID>/<ENDPOINT>
```

For example, to target `services` in the workspace `SRE`:

```sh
http://localhost:8001/SRE/services
```

---

[Admin API]: /gateway/{{page.release}}/admin-api/
