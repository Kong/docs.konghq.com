---
title: Admin API Reference
book: workspaces

workspace_body: |
    Attribute | Description
    ---:| ---
    `name` | The Workspace name.

workspace_entities_body: |
    Attribute | Description
    ---:| ---
    `entities`| Comma-delimited list of entity identifiers

chapter: 2
---

# {{page.title}}

Kong Enterprise's Workspaces feature is configurable through Kong's
[Admin API].

## Workspace Object

The Workspace object describes the workspece entity, which has an ID
and a name.

### Add Workspace

#### Endpoint

<div class="endpoint post">/workspaces/</div>

#### Request Body

{{ page.workspace_body }}

#### Response

```
HTTP 201 Created
```

```json
{
  "name": "teamA",
  "created_at": 1528838706000,
  "id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d"
}
```

### List Workspaces

#### Endpoint

<div class="endpoint get">/workspaces/</div>

#### Response

```
HTTP 200 OK
```

```json
{
  "total": 1,
  "data": [
    {
      "created_at": 1528806517000,
      "id": "9f8008c5-722f-4637-8080-5ee96b535c33",
      "name": "default"
    }
  ]
}
```

### Update or Create a Workspace

#### Endpoint

<div class="endpoint put">/workspaces/</div>

#### Request Body

{{ page.workspace_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Workspaces), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

### Retrieve a Workspace

#### Endpoint

<div class="endpoint get">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Workspace to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
  "created_at": 1528838706000,
  "id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d",
  "name": "teamA"
}
```

### Delete a Workspace

#### Endpoint

<div class="endpoint delete">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Workspace to delete

#### Response

```
HTTP 204 No Content
```

### Update a Workspace

#### Endpoint

<div class="endpoint patch">/workspaces/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Workspace to delete

#### Request Body

{{ page.workspace_body }}

#### Response

```
HTTP 200 OK
```

```json
{
  "name": "teamB",
  "created_at": 1528838706000,
  "id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d"
}
```

### Add entities to a Workspace

Workspaces are groups of entities - including workspaces. This endpoint allows
one to add an entity, identified by its unique identifier, to a workspace.

#### Endpoint

<div class="endpoint post">/workspaces/{name or id}/entities</div>

#### Request Body

{{ page.workspace_entities_body }}

#### Response

```
HTTP 200 No Content
```

```json
{
  "host": "example.com",
  "created_at": 1528927690,
  "connect_timeout": 60000,
  "id": "ecdc96cd-39d7-4a72-b661-8481a3e14e1e",
  "protocol": "http",
  "name": null,
  "read_timeout": 60000,
  "port": 80,
  "path": "/",
  "updated_at": 1528927690,
  "retries": 5,
  "write_timeout": 60000
}
```

The response is the representation of the entity that was added to the
workspace - in this case, a Service.

### List entities that are part of a Workspace

#### Endpoint

<div class="endpoint get">/workspaces/{name or id}/entities</div>

#### Response

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "workspace_id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d",
      "entity_id": "d766d5a8-4dc8-49e8-928d-29ff5aebb927",
      "entity_type": "services",
    },
    {
      "workspace_id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d",
      "entity_id": "65b66412-df45-485d-8fa8-13cda8c892ac",
      "entity_type": "workspaces",
    }
  ],
  "total": 2
}
```

In this case, the workspace references two entities: a Service and a Workspace
(workspaces are allowed to include other workspaces).

### Delete entities from a Workspace

#### Endpoint

<div class="endpoint delete">/workspaces/{name or id}/entities</div>

#### Request Body

{{ page.workspace_entities_body }}

#### Response

```
HTTP 204 No Content
```

### Retrieve an entity from a Workspace

This endpoint allows one to retrieve an entity from a workspace - useful, say,
for checking if a given entity is part of a given workspace.

#### Endpoint

<div class="endpoint get">/workspaces/{name or id}/entities/{name or id}</div>

#### Response

```
HTTP 200 OK
```

```json
{
  "workspace_id": "5396b1b3-ff46-4cb2-8065-5a4b35be342d",
  "entity_id": "d766d5a8-4dc8-49e8-928d-29ff5aebb927",
  "entity_type": "services"
}
```

### Delete a particular entity from a workspace

#### Endpoint

<div class="endpoint delete">/workspaces/{name or id}/entities/{name or id}</div>

#### Response

```
HTTP 204 No Response
```

---

[Admin API]: /docs/{{page.kong_version}}/admin-api/
