---
title: RBAC API
---

## Introduction

<div class="alert alert-ee">
  Be sure to review the <a href="/enterprise/latest/setting-up-admin-api-rbac">RBAC overview</a> before exploring the RBAC API below.
</div>

## Add A User
**Endpoint**

<div class="endpoint post">/rbac/users</div>

### Request Body

| Attribute | Description
| --------- | -----------
| `name` | The RBAC user name.
| `user_token`<br>optional | The authentication token to be presented to the Admin API. If this value is not present, the token will automatically be generated.
| `enabled`<br>optional | A flag to enable or disable the user. By default, users are enabled.
| `comment`<br>optional | A string describing the RBAC user object.

**Response**

```
HTTP 201 Created
```

```json
{
 "created_at": 1501395904000, 
 "enabled": true, 
 "id": "283fccff-2d4f-49a9-8730-dc8b71ec2245", 
 "name": "bob", 
 "user_token": "9CiAvvgnqCQmarplngmT3rJImEujOw7m"
}
```
___

## Retrieve A User
**Endpoint** 

<div class="endpoint get">/rbac/users/{name_or_id}</div>

| Attribute | Description
| --------- | -----------
| `name_or_id` | The RBAC user name or UUID.

**Response**

```
HTTP 200 OK
```

```json
{
 "created_at": 1501395904000, 
 "enabled": true, 
 "id": "283fccff-2d4f-49a9-8730-dc8b71ec2245", 
 "name": "bob", 
 "user_token": "9CiAvvgnqCQmarplngmT3rJImEujOw7m"
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
   "created_at": 1501524409000, 
   "enabled": true, 
   "id": "11cbd5cf-e4e0-47b6-968b-73b062440a4e", 
   "name": "bob", 
   "user_token": "1VHzdFqU24GmoeAlsoE7V95gWn1OoPjS"
  }
 ], 
 "total": 1
}
```
___

## Update A User
**Endpoint** 

<div class="endpoint patch">/rbac/users/{name_or_id}</div>

| Attribute | Description
| --------- | -----------
| `name_or_id` | The RBAC user name or UUID.
| `user_token`<br>optional | The authentication token to be presented to the Admin API. If this value is not present, the token will automatically be generated.
| `enabled`<br>optional | A flag to enable or disable the user. By default, users are enabled.
| `comment`<br>optional | A string describing the RBAC user object.

**Response**

```
HTTP 200 OK
```

```json
{
 "created_at": 1501395904000, 
 "enabled": true, 
 "id": "283fccff-2d4f-49a9-8730-dc8b71ec2245", 
 "name": "bob", 
 "user_token": "9CiAvvgnqCQmarplngmT3rJImEujOw7m"
} 
```
___

## Delete a User
**Endpoint** 

<div class="endpoint delete">/rbac/users/{name_or_id}</div>

**Response**

```
HTTP 204 No Content
```
___

## Add a Role
**Endpoint** 

<div class="endpoint post">/rbac/roles</div>

| Attribute | Description
| --------- | -----------
| `name` | The RBAC user name.
| `comment`<br>optional | A string describing the RBAC user object.

**Response**

```
HTTP 201 Created
```

```json
{
 "created_at": 1501395904000, 
 "id": "8ddc36ee-dde0-4daa-baae-6868f4514256", 
 "name": "read-only"
} 
```
___

## Retrieve a Role
**Endpoint** 

<div class="endpoint get">/rbac/role{name_or_id}</div>

| Attribute | Description
| --------- | -----------
| `name_or_id` | The RBAC role name or UUID.

**Response**

```
HTTP 200 OK
```

```json
{
 "created_at": 1501395904000, 
 "id": "8ddc36ee-dde0-4daa-baae-6868f4514256", 
 "name": "read-only"
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
   "created_at": 1501524270000, 
   "id": "9bd49829-2a8b-41fd-b7fc-28e63c100676", 
   "name": "read-only"
  }
 ], 
 "total": 3
} 
```
___

## Update A Role
**Endpoint** 

<div class="endpoint patch">/rbac/roles/{name_or_id}</div>

| Attribute | Description
| --------- | -----------
| `name` | The RBAC role name or UUID.
| `comment`<br>optional | A string describing the RBAC role object.

**Response**

```
HTTP 200 OK
```

```json
{
 "created_at": 1501395904000, 
 "enabled": true, 
 "id": "283fccff-2d4f-49a9-8730-dc8b71ec2245", 
 "name": "bob", 
 "user_token": "9CiAvvgnqCQmarplngmT3rJImEujOw7m"
} 
```
___

## Delete A Role
**Endpoint** 

<div class="endpoint delete">/rbac/role/{name_or_id}</div>

**Response**

```
HTTP 204 No Content
```
___

## Add A Permission
**Endpoint**

<div class="endpoint post">/rbac/permissions</div>

### Request Body

| Attribute | Description
| --------- | -----------
| `name` | The RBAC permisson name.
| `negative` | If true, explicitly disallow the actions associated with the permissions tied to this resource. By default this value is false.
| `resources` | One or more RBAC resource names associated with this permission.
| `actions` | One or more actions associated with this permission.
| `comment`<br>optional | A string describing the RBAC permission object.

**Response**

```
HTTP 201 Created
```
```json
{
 "actions": [
  "read", 
  "delete", 
  "create", 
  "update"
 ], 
 "created_at": 1501524737000, 
 "id": "d881bd36-00ca-404f-b428-427b2eab0184", 
 "name": "apis-all", 
 "negative": false, 
 "resources": [
  "apis"
 ]
} 
```
---

## Retrieve A Permission
**Endpoint**

<div class="endpoint get">/rbac/permissions/{name_or_id}</div>

| Attribute | Description
| --------- | -----------
| `name_or_id` | The RBAC permisson name or UUID.

**Response**

```
HTTP 200 OK
```
```json
{
 "actions": [
  "read", 
  "delete", 
  "create", 
  "update"
 ], 
 "created_at": 1501524737000, 
 "id": "d881bd36-00ca-404f-b428-427b2eab0184", 
 "name": "apis-all", 
 "negative": false, 
 "resources": [
  "apis"
 ]
} 
```
---

## List Permissions
**Endpoint**

<div class="endpoint get">/rbac/permissions/</div>

**Response**

```
HTTP 200 OK
```
```json
{
 "data": [
  {
   "actions": [
    "read", 
    "delete", 
    "create", 
    "update"
   ], 
   "created_at": 1501524737000, 
   "id": "d881bd36-00ca-404f-b428-427b2eab0184", 
   "name": "apis-all", 
   "negative": false, 
   "resources": [
    "apis"
   ]
  }, 
 ], 
 "total": 6
}
```
---

## Update a Permission
**Endpoint**

<div class="endpoint patch">/rbac/permissions/{name_or_id}</div>

### Request Body

| Attribute | Description
| --------- | -----------
| `name_or_id` | The RBAC permisson name or UUID.
| `negative` | If true, explicitly disallow the actions associated with the permissions tied to this resource. By default this value is false.
| `resources` | One or more RBAC resource names associated with this permission.
| `actions` | One or more actions associated with this permission.
| `comment`<br>optional | A string describing the RBAC permission object

**Response**

```
HTTP 200 OK
```
```json
{
 "actions": [
  "read", 
  "delete", 
  "create", 
  "update"
 ], 
 "created_at": 1501524737000, 
 "id": "d881bd36-00ca-404f-b428-427b2eab0184", 
 "name": "apis-all", 
 "negative": false, 
 "resources": [
  "apis"
 ]
}
```
---

## Delete A Permission
**Endpoint**

<div class="endpoint delete">/rbac/permissions/{name_or_id}</div>

**Response**

```
HTTP 204 No Content
```
---

## Add a User to a Role
**Endpoint**

<div class="endpoint post">/rbac/users/{name_or_id}/roles</div>

### Request Body

| Attribute | Description
| --------- | -----------
| `roles` | Comma-separated list of role names to assign to the user.

**Response**

```
HTTP 201 Created
```
```json
{
 "roles": [
  {
   "comment": "Read-only access across all initial RBAC resources", 
   "created_at": 1501524270000, 
   "id": "9bd49829-2a8b-41fd-b7fc-28e63c100676", 
   "name": "read-only"
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

**Response**

```
HTTP 200 OK
```
```json
{
 "roles": [
  {
   "comment": "Read-only access across all initial RBAC resources", 
   "created_at": 1501524270000, 
   "id": "9bd49829-2a8b-41fd-b7fc-28e63c100676", 
   "name": "read-only"
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

## List a User's Permissions
**Endpoint**

<div class="endpoint get">/rbac/users/{name_or_id}/permissions</div>

**Response**

```
HTTP 200 OK
```
```json
{
 "apis": [
  "read"
 ], 
 "plugins": [
  "read",
  "create",
  "update",
  "delete"
 ]
}


```
---

## Delete a Role from a User
**Endpoint**

<div class="endpoint delete">/rbac/users/{name_or_id}/roles</div>

### Request Body

| Attribute | Description
| --------- | -----------
| `roles` | Comma-separated list of role names to assign to the user.

**Response**

```
HTTP 204 No Content
```
---

## Add a Permission to a Role
**Endpoint**

<div class="endpoint post">/rbac/roles/{name_or_id}/permissions</div>

### Request Body
| Attribute | Description
| --------- | -----------
| `permissions` | Comma-separated list of permission names to assign to the role.

**Response**

```
HTTP 201 Created
```
```json
{
 "permissions": [
  {
   "actions": [
    "read"
   ], 
   "comment": "Read-only permissions across all initial RBAC resources", 
   "created_at": 1501524270000, 
   "id": "6f835b92-86b1-4b9d-8a91-f9a66c1940ce", 
   "name": "read-only", 
   "negative": false, 
   "resources": [
    "default", 
    "kong", 
    "status", 
    "apis", 
    "plugins", 
    "cache", 
    "certificates", 
    "consumers", 
    "snis", 
    "upstreams", 
    "targets", 
    "rbac", 
    "key-auth", 
    "jwt", 
    "acls", 
    "basic-auth", 
    "oauth2", 
    "hmac-auth"
   ]
  }
 ], 
 "role": {
  "created_at": 1501524295000, 
  "id": "8ddc36ee-dde0-4daa-baae-6868f4514256", 
  "name": "read-only"
 }
}
```
---

## List a Role's Permissions
**Endpoint**

<div class="endpoint get">/rbac/roles/{name_or_id}/permissions</div>

**Response**

```
200 OK
```
```json
{
 "permissions": [
  {
   "actions": [
    "read"
   ], 
   "comment": "Read-only permissions across all initial RBAC resources", 
   "created_at": 1501524270000, 
   "id": "6f835b92-86b1-4b9d-8a91-f9a66c1940ce", 
   "name": "read-only", 
   "negative": false, 
   "resources": [
    "default", 
    "kong", 
    "status", 
    "apis", 
    "plugins", 
    "cache", 
    "certificates", 
    "consumers", 
    "snis", 
    "upstreams", 
    "targets", 
    "rbac", 
    "key-auth", 
    "jwt", 
    "acls", 
    "basic-auth", 
    "oauth2", 
    "hmac-auth"
   ]
  }
 ], 
 "role": {
  "created_at": 1501524295000, 
  "id": "8ddc36ee-dde0-4daa-baae-6868f4514256", 
  "name": "read-only"
 }
}
```
---

## Delete A Permission from a Role
**Endpoint**

<div class="endpoint delete">/rbac/roles/{name_or_id}/permissions</div>

### Request Body
| Attribute | Description
| --------- | -----------
| `permissions` | Comma-separated list of permission names to remove from the user.

**Response**

```
204 No Content
```
---

## List Available RBAC Resources
**Endpoint**

<div class="endpoint get">/rbac/resources</div>

**Response**

```
200 OK
```
```json
[
 "plugins", 
 "cache", 
 "targets", 
 "basic-auth", 
 "key-auth", 
 "hmac-auth", 
 "snis", 
 "certificates", 
 "kong", 
 "acls", 
 "status", 
 "jwt", 
 "rbac", 
 "apis", 
 "upstreams", 
 "consumers", 
 "oauth2"
]
```
