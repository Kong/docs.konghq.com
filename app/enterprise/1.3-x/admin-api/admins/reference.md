---
title: Admins Reference
book: admins
---

## List Admins
**Endpoint**

<div class="endpoint get">/admins</div>

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [{
    "created_at": 1556638385,
    "id": "665b4070-541f-48bf-82c1-53030babaa81",
    "updated_at": 1556638385,
    "status": 4,
    "username": "test-admin",
    "email": "test@test.com",
    "rbac_token_enabled": true
  }, {
    "created_at": 1556563122,
    "id": "a93ff120-9e6c-4198-b47e-f779104c7eac",
    "updated_at": 1556563122,
    "status": 0,
    "username": "kong_admin",
    "rbac_token_enabled": false
  }],
  "next": null
}
```

## Invite an Admin
**Endpoint**

<div class="endpoint post">/admins</div>

| Attribute   | Description |
|-------------|------------------------------------------------------------|
| `email` | The **Admin**'s email address |
| `username` | The **Admin**'s username |
| `custom_id` <br>optional | The **Admin**'s custom ID |
| `rbac_token_enabled` | Allows the **Admin** to use and reset their RBAC token; `true` by default |

**Response**

```
HTTP 200 OK
```

```json
{
  "admin": {
    "created_at": 1556638641,
    "id": "8f0a742f-07f3-49e0-90d7-4fc7eea7e6a4",
    "updated_at": 1556638641,
    "status": 4,
    "username": "test-case-3",
    "email": "test3@test.com",
    "rbac_token_enabled": true
  }
}
```

## Register an Admin's Credentials
**Endpoint**

<div class="endpoint post">/admins/register</div>

| Attribute   | Description |
|-------------|---------------------------|
| `token` | The authentication token |
| `username` | The **Admin**'s username |
| `email` | The **Admin**'s email address |
| `password` | The **Admin**'s new password |

**Response**

```
HTTP 201 Created
```

## Send a Password-Reset Email to an Admin
**Endpoint**

<div class="endpoint post">/admins/password_resets</div>

| Attribute   | Description |
|-------------|------------------------------------------------------------|
| `email` | The **Admin**'s email address |

**Response**

```
HTTP 201 Created
```

## Reset an Admin's Password
**Endpoint**

<div class="endpoint patch">/admins/password_resets</div>

| Attribute   | Description |
|-------------|------------------------------------------------------------|
| `email` | The **Admin**'s email address |
| `password` | The **Admin**'s new password |
| `token` | The authentication token |

**Response**

```
HTTP 200 OK
```

## Retrieve an Admin
**Endpoint**

<div class="endpoint get">/admins/{name_or_id}</div>

| Attribute | Description |
|------------|-----------------------------------|
| `name_or_id` | The **Admin**'s username or ID |
| `generate_register_url` <br>optional | `true` returns a unique registration URL for the **Admin** |

**Notes:** 
* `generate_register_url` will only generate a URL if the **Admin**'s 
invitation status is 4 ("invited").
* `generate_register_url` will override the preåvious registration URL 
for the particular **Admin** each time it is requested.

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1556638385,
  "id": "665b4070-541f-48bf-82c1-53030babaa81",
  "updated_at": 1556638385,
  "status": 4,
  "username": "test-admin",
  "email": "test@test.com",
  "rbac_token_enabled": true
}
```

## Update an Admin
**Endpoint**

<div class="endpoint patch">/admins/{name_or_id}</div>

| Attribute | Description |
|----------------------|--------------------------------------------|
| `name_or_id` | The **Admin**'s current username or custom ID |
| `email` <br>optional | The **Admin**'s new email address |
| `username` <br>optional | The **Admin**'s new username |
| `custom_id` <br>optional | The **Admin**'s new custom ID |
| `rbac_token_enabled` | Allows the **Admin** to use and reset their RBAC token; `true` by default |

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1556638385,
  "id": "665b4070-541f-48bf-82c1-53030babaa81",
  "updated_at": 1556639017,
  "status": 4,
  "username": "test-renamed",
  "email": "test@test.com"
  "rbac_token_enabled": true
}
```

## Delete an Admin
**Endpoint**

<div class="endpoint delete">/admins/{name_or_id}</div>

| Attribute   | Description |
|--------------|-----------------------------------|
| `name_or_id` | The **Admin**'s username or ID |

**Response**

```
HTTP 204 No Content
```

## List an Admin's Roles
**Endpoint**

<div class="endpoint get">/admins/{name_or_id}/roles</div>

| Attribute   | Description |
|--------------|-----------------------------------|
| `name_or_id` | The **Admin**'s username or ID |

**Response**

```
HTTP 200 OK
```

```json
{
  "roles": [{
    "comment": "Read access to all endpoints, across all workspaces",
    "created_at": 1556563122,
    "id": "7574eb1d-c9fa-46a9-bd3a-3f1b4b196287",
    "name": "read-only",
    "is_default": false
  }, {
    "comment": "Full access to all endpoints, across all workspaces—except RBAC Admin API",
    "created_at": 1556563122,
    "id": "7fdea5c8-2bfa-4aa9-9c21-7bb9e607186d",
    "name": "admin",
    "is_default": false
  }]
}
```

## Create or Update an Admin's Roles
**Endpoint**

<div class="endpoint post">/admins/{name_or_id}/roles</div>

| Attribute   | Description |
|--------------|-----------------------------------------------------------|
| `name_or_id` | The **Admin**'s current username or ID |
| `roles` | (comma separated) string of names of Roles to create or update for an **Admin** |

**Response**

```
HTTP 201 OK
```


```json
{
  "roles": [{
    "comment": "Read access to all endpoints, across all workspaces",
    "created_at": 1556563122,
    "id": "7574eb1d-c9fa-46a9-bd3a-3f1b4b196287",
    "name": "read-only",
    "is_default": false
  }, {
    "comment": "Full access to all endpoints, across all workspaces—except RBAC Admin API",
    "created_at": 1556563122,
    "id": "7fdea5c8-2bfa-4aa9-9c21-7bb9e607186d",
    "name": "admin",
    "is_default": false
  }, {
    "comment": "Full access to all endpoints, across all workspaces",
    "created_at": 1556563122,
    "id": "99bd8d18-f5b6-410e-aefe-d75f4252f13c",
    "name": "super-admin",
    "is_default": false
  }]
}
```

## Delete an Admin's Role
**Endpoint**

<div class="endpoint delete">/admins/{name_or_id}/roles</div>

| Attribute   | Description |
|--------------|-----------------------------------------------------------|
| `name_or_id` | The **Admin**'s current username or custom ID |
| `roles` | (comma separated) string of names of Roles to remove from an **Admin** |

**Response**

```
HTTP 204 No Content
```

## List an Admin's Workspaces
**Endpoint**

<div class="endpoint get">/admins/{name_or_id}/workspaces</div>

| Attribute   | Description |
|--------------|-----------------------------------|
| `name_or_id` | The **Admin**'s username or ID |

**Response**

```
HTTP 200 OK
```

```json
[{
  "created_at": 1556563122,
  "config": {
    "portal": true,
    "portal_auto_approve": true
  },
  "id": "00000000-0000-0000-0000-000000000000",
  "name": "default",
  "meta": {}
}, {
  "created_at": 1556570807,
  "config": {
    "portal": true
  },
  "id": "57b3ce24-6d29-427f-af13-15bd60430e56",
  "name": "sdfgsdfg",
  "meta": {
    "color": "#3894f0"
  }
}]
```
