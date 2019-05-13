---
title: RBAC Reference
book: rbac
---

## Introduction

Kong Enterprise's RBAC feature is configurable through Kong's [Admin
API] or via the [Kong Manager].

There are 4 basic entities involving RBAC.

- **User**: The entity interacting with the system. Can be associated with
  zero, one or more roles. Example: user `bob` has token `1234`.
- **Role**: Set of permissions (`role_endpoint` and
  `role_entity`). Has a name and can be associated with zero, one or
  more permissions. Example: user bob is associated with role
  `developer`.
- **role_endpoint**: A set of enabled or disabled (see `negative`
  parameter) actions (`read`, `create`, `update`, `delete`)
  `endpoint`. Example: Role `developer` has 1 role_endpoint: `read &
  write` to endpoint `/routes`
- **role_entity**: A set of enabled or disabled (see `negative`
  parameter) actions (`read`, `create`, `update`, `delete`)
  `entity`. Example: Role `developer` has 1 role_entity: `read & write
  & delete` to entity `283fccff-2d4f-49a9-8730-dc8b71ec2245`.

## Add a User
**Endpoint**

<div class="endpoint post">/rbac/users</div>

**Request Body**

| Attribute                | Description                                                                                                                         |
| ---------                | -----------                                                                                                                         |
| `name`                   | The RBAC user name.                                                                                                                 |
| `user_token` | The authentication token to be presented to the Admin API. The value will be hashed and cannot be fetched in plaintext. |
| `enabled`<br>optional    | A flag to enable or disable the user. By default, users are enabled.                                                                |
| `comment`<br>optional    | A string describing the RBAC user object.                                                                                           |

**Response**

```
HTTP 201 Created
```

```json
{
  "comment": null,
  "created_at": 1557522650,
  "enabled": true,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "doc_knight",
  "user_token": "$2b$09$Za30VKAAAmyoB9zF2PNEF.9hgKcN2BdKkptPMCubPK/Ps08lzZjYG",
  "user_token_ident": "4d870"
}
```
___

## Retrieve a User
**Endpoint**

<div class="endpoint get">/rbac/users/{name_or_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC user name or UUID. |

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1557522650,
  "enabled": true,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "doc_lord",
  "user_token": "$2b$09$Za30VKAAAmyoB9zF2PNEF.9hgKcN2BdKkptPMCubPK/Ps08lzZjYG",
  "user_token_ident": "4d870"
}
```
___

## List Users
**Endpoint**

<div class="endpoint get">/rbac/users/</div>

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "comment": null,
      "created_at": 1557512629,
      "enabled": true,
      "id": "f035f120-a95e-4327-b2ae-8fa264601d75",
      "name": "doc_lord",
      "user_token": "$2b$09$TIMneYcTosdG9WbzRsqcweAS2zote8g6I8HqXAtbFHR1pds2ymsh6",
      "user_token_ident": "88ea3"
    },
    {
      "comment": null,
      "created_at": 1557522650,
      "enabled": true,
      "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
      "name": "doc_knight",
      "user_token": "$2b$09$Za30VKAAAmyoB9zF2PNEF.9hgKcN2BdKkptPMCubPK/Ps08lzZjYG",
      "user_token_ident": "4d870"
    }
  ],
  "next": null
}
```
___

## Update a User
**Endpoint**

<div class="endpoint patch">/rbac/users/{name_or_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC user name or UUID. |

**Request Body**

| Attribute                | Description                                                                                                                         |
| ---------                | -----------                                                                                                                         |
| `user_token`<br>optional | The authentication token to be presented to the Admin API. If this value is not present, the token will automatically be generated. |
| `enabled`<br>optional    | A flag to enable or disable the user. By default, users are enabled.                                                                |
| `comment`<br>optional    | A string describing the RBAC user object.                                                                                           |

**Response**

```
HTTP 200 OK
```

```json
{
  "comment": "this comment came from a patch request",
  "created_at": 1557522650,
  "enabled": true,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "donut_lord",
  "user_token": "$2b$09$Za30VKAAAmyoB9zF2PNEF.9hgKcN2BdKkptPMCubPK/Ps08lzZjYG",
  "user_token_ident": "4d870"
}
```
___

## Delete a User
**Endpoint**

<div class="endpoint delete">/rbac/users/{name_or_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC user name or UUID. |

**Response**

```
HTTP 204 No Content
```
___

## Add a Role
**Endpoint**

<div class="endpoint post">/rbac/roles</div>

| Attribute             | Description                               |
| ---------             | -----------                               |
| `name`                | The RBAC role name.                       |
| `comment`<br>optional | A string describing the RBAC user object. |

**Response**

```
HTTP 201 Created
```

```json
{
  "comment": null,
  "created_at": 1557532241,
  "id": "b5c5cfd4-3330-4796-9b7b-6026e91e3ad6",
  "is_default": false,
  "name": "service_reader"
}
```
___

## Retrieve a Role
Endpoint

<div class="endpoint get">/rbac/roles/{name_or_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1557532241,
  "id": "b5c5cfd4-3330-4796-9b7b-6026e91e3ad6",
  "is_default": false,
  "name": "service_reader"
}
```
___

## List Roles
**Endpoint**

<div class="endpoint get">/rbac/roles</div>

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "comment": "Full access to all endpoints, across all workspaces—except RBAC Admin API",
      "created_at": 1557506249,
      "id": "38a03d47-faae-4366-b430-f6c10aee5029",
      "name": "admin"
    },
    {
      "comment": "Read access to all endpoints, across all workspaces",
      "created_at": 1557506249,
      "id": "4141675c-8beb-41a5-aa04-6258ab2d2f7f",
      "name": "read-only"
    },
    {
      "comment": "Full access to all endpoints, across all workspaces",
      "created_at": 1557506249,
      "id": "888117e0-f2b3-404d-823b-dee595423505",
      "name": "super-admin"
    },
    {
      "comment": null,
      "created_at": 1557532241,
      "id": "b5c5cfd4-3330-4796-9b7b-6026e91e3ad6",
      "name": "doc_lord"
    }
  ],
  "next": null
}
```
___

## Update or Create a Role
**Endpoint**

<div class="endpoint put">/rbac/roles</div>

**Request Body**

| Attribute             | Description                               |
| ---------             | -----------                               |
| `name`                | The RBAC role name.                       |
| `comment`<br>optional | A string describing the RBAC user object. |

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Users), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

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
  "comment": "the best",
  "created_at": 1557532566,
  "id": "b5c5cfd4-3330-4796-9b7b-6026e91e3ad6",
  "is_default": false,
  "name": "doc_lord"
}
```

## Update a Role
**Endpoint**

<div class="endpoint patch">/rbac/roles/{name_or_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role or UUID. |

**Request Body**

| Attribute             | Description                               |
| ---------             | -----------                               |
| `comment`<br>optional | A string describing the RBAC role object. |

**Response**

```
HTTP 200 OK
```

```json
{
  "comment": "comment from patch request",
  "created_at": 1557532566,
  "id": "b5c5cfd4-3330-4796-9b7b-6026e91e3ad6",
  "is_default": false,
  "name": "service_reader"
}
```
___

## Delete a Role
**Endpoint**

<div class="endpoint delete">/rbac/role/{name_or_id}</div>

| Attribute             | Description                               |
| ---------             | -----------                               |
| `name`                | The RBAC role name.                       |

**Response**

```
HTTP 204 No Content
```
___

## Add a Role Endpoint Permission
**Endpoint**

<div class="endpoint post">/rbac/roles/{name_or_id}/endpoints</div>


| Attribute             | Description                               |
| ---------             | -----------                               |
| `name_or_id`          | The RBAC role name.                       |


**Request Body**

| Attribute             | Description                                                                                                                     |
| ---------             | -----------                                                                                                                     |
| `workspace`           | Workspace tied to the endpoint. Defaults to the default permission. Special value of "*" means **all** workspaces are affected  |
| `endpoint`            | Endpoint associated with this permission.                                                                                       |
| `negative`            | If true, explicitly disallow the actions associated with the permissions tied to this endpoint. By default this value is false. |
| `actions`             | One or more actions associated with this permission. This is a comma separated string (read,create,update,delete)               |
| `comment`<br>optional | A string describing the RBAC permission object.                                                                                 |

`endpoint` must be the path of the associated endpoint. They can be
exact matches, or contain wildcards, represented by `*`.

- Exact matches; eg:
  * /apis/
  * /apis/foo

- Wildcards; eg:
  * /apis/*
  * /apis/*/plugins

Where `*` replaces exactly one segment between slashes (or the end of
the path).

Note that wildcards can be nested (`/rbac/*`, `/rbac/*/*`,
`/rbac/*/*/*` would refer to all paths under `/rbac/`)

**Response**

```
HTTP 201 Created
```

```json
{
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "created_at": 1557764505,
  "endpoint": "/consumers",
  "negative": false,
  "role": {
    "id": "23df9f20-e7cc-4da4-bc89-d3a08f976e50"
  },
  "workspace": "default"
}
```

---

## Retrieve a Role Endpoint Permission
**Endpoint**

<div class="endpoint get">/rbac/roles/{name_or_id}/endpoints/{worspace_name_or_id}/{endpoint}</div>

| Attribute             | Description                                  |
| ---------             | -----------                                  |
| `name_or_id`          | The RBAC role name or UUID.                  |
| `worspace_name_or_id` | The worspace name or UUID.                   |
| `endpoint`            | The endpoint associated with this permisson. |

**Response**

```
HTTP 200 OK
```

```json
{
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "created_at": 1557764505,
  "endpoint": "/consumers",
  "negative": false,
  "role": {
    "id": "23df9f20-e7cc-4da4-bc89-d3a08f976e50"
  },
  "workspace": "default"
}
```

---



## List Role Endpoints Permissions
**Endpoint**

<div class="endpoint get">/rbac/roles/{role_name_or_id}/endpoints</div>

| Attribute         | Description                 |
| ---------         | -----------                 |
| `role_name_or_id` | The RBAC role name or UUID. |

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "actions": [
        "delete",
        "create",
        "update",
        "read"
      ],
      "created_at": 1557764505,
      "endpoint": "/consumers",
      "negative": false,
      "role": {
        "id": "23df9f20-e7cc-4da4-bc89-d3a08f976e50"
      },
      "workspace": "default"
    },
    {
      "actions": [
        "read"
      ],
      "created_at": 1557764438,
      "endpoint": "/services",
      "negative": false,
      "role": {
        "id": "23df9f20-e7cc-4da4-bc89-d3a08f976e50"
      },
      "workspace": "default"
    }
  ]
}
```

---

## Update a Role Endpoint Permission
**Endpoint**

<div class="endpoint patch">/rbac/roles/{name_or_id}/endpoints/{worspace_name_or_id}/{endpoint}</div>

| Attribute             | Description                                  |
| ---------             | -----------                                  |
| `name_or_id`          | The RBAC role name or UUID.                  |
| `worspace_name_or_id` | The worspace name or UUID.                   |
| `endpoint`            | The endpoint associated with this permisson. |

**Request Body**

| Attribute             | Description |
| ---------             | ----------- |
| `negative`            | If true, explicitly disallow the actions associated with the permissions tied to this resource. By default this value is false. |
| `actions`             | One or more actions associated with this permission. |

**Response**

```
HTTP 200 OK
```

```json
{
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "created_at": 1557764438,
  "endpoint": "/services",
  "negative": false,
  "role": {
    "id": "23df9f20-e7cc-4da4-bc89-d3a08f976e50"
  },
  "workspace": "default"
}
```

---



## Delete a Role Endpoint Permission
**Endpoint**

<div class="endpoint delete">/rbac/roles/{name_or_id}/endpoints/{worspace_name_or_id}/{endpoint}</div>

| Attribute             | Description                                  |
| ---------             | -----------                                  |
| `name_or_id`          | The RBAC role name or UUID.                  |
| `worspace_name_or_id` | The worspace name or UUID.                   |
| `endpoint`            | The endpoint associated with this permisson. |

**Response**

```
HTTP 204 OK
```

---



## Add a Role Entity Permission
**Endpoint**
<div class="endpoint post">/rbac/roles/{name_or_id}/entities</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |

**Request Body**

| Attribute             | Description                                                                                                                     |
| ---------             | -----------                                                                                                                     |
| `negative`            | If true, explicitly disallow the actions associated with the permissions tied to this resource. By default this value is false. |
| `entity_id`           | id of the entity associated with this permission.                                                                               |
| `actions`             | One or more actions associated with this permission.                                                                            |
| `comment`<br>optional | A string describing the RBAC permission object                                                                                  |

`entity_id` must be the ID of an entity in Kong; if the ID of a
workspace is given, the permission will apply to all entities in that
workspace. Future entities belonging to that workspace will get the
same permissions. A wildcard `*` will be interpreted as **all
entities** in the system.


**Response**

```
HTTP 201 Created
```

```json
{
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "created_at": 1529005234000,
  "entity_id": "124572ea-f571-46fd-8662-8cbd3192f572",
  "entity_type": "apis",
  "negative": false,
  "role_id": "432d7b69-ab71-4567-8089-a02600cdddf6"
}

```

---

## Retrieve a Role Entity Permission
**Endpoint**
<div class="endpoint get">/rbac/roles/{name_or_id}/entities/{entity_id}</div>

| Attribute             | Description                                                                                                                     |
| ---------             | -----------                                                                                                                     |
| `name_or_id`          | The RBAC permission name or UUID.                                                                                                |
| `entity_id`           | id of the entity associated with this permission.                                                                               |

**Response**

```
HTTP 200 Ok
```

```json
{
  "actions": [
    "delete",
    "create",
    "update",
    "read"
  ],
  "created_at": 1529005234000,
  "entity_id": "124572ea-f571-46fd-8662-8cbd3192f572",
  "entity_type": "apis",
  "negative": false,
  "role_id": "432d7b69-ab71-4567-8089-a02600cdddf6"
}

```

---

## List Entity Permissons

**Endpoint**
<div class="endpoint get">/rbac/roles/{name_or_id}/entities</div>

| Attribute             | Description                      |
| ---------             | -----------                      |
| `name_or_id`          | The RBAC permisson name or UUID. |

**Response**

```
HTTP 200 Ok
```

```json
{
  "data": [
    {
      "created_at": 1529005234000,
      "role_id": "432d7b69-ab71-4567-8089-a02600cdddf6",
      "entity_id": "124572ea-f571-46fd-8662-8cbd3192f572",
      "negative": false,
      "entity_type": "apis",
      "actions": [
        "delete",
        "create",
        "update",
        "read"
      ]
    }
  ],
  "total": 1
}
```

---
## Update an Entity Permission
**Endpoint**

<div class="endpoint patch">/rbac/roles/{name_or_id}/entities/{entity_id}</div>

| Attribute             | Description                 |
| ---------             | -----------                 |
| `name_or_id`          | The RBAC role name or UUID. |
| `entity_id`           | The entity name or UUID.    |

**Request Body**

| Attribute    | Description                 |
| ---------    | -----------                 |
| `negative` | If true, explicitly disallow the actions associated with the permissions tied to this resource. By default this value is false. |
| `actions` | One or more actions associated with this permission. |

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1529052531000,
  "role_id": "22ffce18-afef-4f19-a1b2-2071f52e2f30",
  "entity_id": "1d947f65-4879-43f0-ad93-f7cf4f05cc51",
  "negative": false,
  "entity_type": "apis",
  "actions": [
    "read"
  ]
}
```

---

## Delete an Entity Permission
**Endpoint**

<div class="endpoint delete">/rbac/roles/{name_or_id}/entities/{entity_id}</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |
| `entity_id`  | The entity name or UUID.    |

**Response**

```
HTTP 204 No Content
```

---

## List Role Permissions
**Endpoint**
<div class="endpoint get">/rbac/roles/{name_or_id}/permissions/</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |


**Response**

```
HTTP 200 OK
```
```json
{
  "entities": {
    "1d947f65-4879-43f0-ad93-f7cf4f05cc51": [
      "delete",
      "create",
      "update",
      "read"
    ]
  },
  "endpoints": {
    "default": {
      "/default/routes": [
        "read"
      ]
    }
  }
}
```

## Add a User to a Role
**Endpoint**

<div class="endpoint post">/rbac/users/{name_or_id}/roles</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |


**Request Body**

| Attribute | Description |
| --------- | ----------- |
| `roles`   | Comma-separated list of role names to assign to the user. |

**Response**

```
HTTP 201 Created
```
```json
{
 "roles": [
  {
   "created_at": 1501524270000,
   "id": "9bd49829-2a8b-41fd-b7fc-28e63c100676",
   "name": "developer"
  }
 ],
 "user": {
  "created_at": 1501524409000,
  "enabled": true,
  "id": "11cbd5cf-e4e0-47b6-968b-73b062440a4e",
  "name": "bob",
  "user_token": "1VHzdFqU24GmoeAlsoE7V95gWn1OoPjS"
 }
}
```

---
## List a User's Roles
**Endpoint**

<div class="endpoint get">/rbac/users/{name_or_id}/roles</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |


**Response**

```
HTTP 200 OK
```
```json
{
 "roles": [
  {
   "created_at": 1501524270000,
   "id": "9bd49829-2a8b-41fd-b7fc-28e63c100676",
   "name": "developer"
  }
 ],
 "user": {
  "created_at": 1501524409000,
  "enabled": true,
  "id": "11cbd5cf-e4e0-47b6-968b-73b062440a4e",
  "name": "bob",
  "user_token": "1VHzdFqU24GmoeAlsoE7V95gWn1OoPjS"
 }
}
```

---
## Delete a Role from a User
**Endpoint**

<div class="endpoint delete">/rbac/users/{name_or_id}/roles</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |


**Request Body**

| Attribute | Description                                               |
| --------- | -----------                                               |
| `roles`   | Comma-separated list of role names to assign to the user. |

**Response**

```
HTTP 204 No Content
```

---


[Admin API]: /{{page.kong_version}}/admin-api/

## List a User's Permissions
**Endpoint**

<div class="endpoint get">/rbac/users/{name_or_id}/permissions</div>

| Attribute    | Description                 |
| ---------    | -----------                 |
| `name_or_id` | The RBAC role name or UUID. |

**Response**

```
HTTP 200 OK
```
```json
{
  "entities": {
    "1d947f65-4879-43f0-ad93-f7cf4f05cc51": [
      "read"
    ]
  },
  "endpoints": {
    "default": {
      "/default/routes": [
        "read"
      ]
    }
  }
}
```
