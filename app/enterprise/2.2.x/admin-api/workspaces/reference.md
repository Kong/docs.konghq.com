---
title: Workspaces Reference
book: workspaces

workspace_body: |
    Attribute | Description
    ---:| ---
    `name` | The **Workspace** name.
---

## Introduction

Kong Enterprise's Workspaces feature is configurable through Kong's
[Admin API].

## Workspace Object

The **Workspace** object describes the **Workspace** entity, which has an ID
and a name.

### Add Workspace

**Endpoint**

<div class="endpoint post">/workspaces/</div>

#### Request Body

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

### List Workspaces

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

### Update or Create a Workspace

**Endpoint**

<div class="endpoint put">/workspaces/{id}</div>

Attributes | Description
---:| ---
`id`<br>**conditional** | The **Workspace's** unique ID, if replacing it.*

* The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Workspaces), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

#### Request Body

Attribute | Description
---:| ---
`name` | The **Workspace** name.

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

### Retrieve a Workspace

**Endpoint**

<div class="endpoint get">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the **Workspace** to retrieve

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

### Retrieve Workspace Metadata

#### Endpoint

<div class="endpoint get">/workspaces/{name or id}/meta</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the **Workspace** to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
  "counts": {
    "acls": 1,
    "apis": 1,
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

### Delete a Workspace

**Endpoint**

<div class="endpoint delete">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the **Workspace** to delete

**Note:** All entities within a **Workspace** must be deleted before the
**Workspace** itself can be.

**Response**

```
HTTP 204 No Content
```

### Update a Workspace

**Endpoint**

<div class="endpoint patch">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the **Workspace** to patch

#### Request Body

Attributes | Description
---:| ---
`comment` | A string describing the **Workspace**

The behavior of `PATCH` endpoints prevents the renaming of a **Workspace**.

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
---

[Admin API]: /enterprise/{{page.kong_version}}/admin-api/
