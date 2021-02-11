---
title: Licenses Reference
book: licenses

licenses_attribute_id: |
    Attributes | Description
    ---:| ---
    `id` | The **License's** unique ID.

licenses_body: |
    Attribute | Description
    ---:| ---
    `payload` | The **{{site.ee_product_name}} License** in JSON format.
---

## Introduction

The {{site.ee_product_name}} Licenses feature is configurable through the
[Admin API]. This feature allows the configuration a license in your
{{site.ee_product_name}} cluster; traditional and hybrid mode deployments. In
hybrid mode deployments, licenses configured via the `/licenses` endpoint will
be sent to all dataplanes in the cluster and the most recent `updated_at`
license will be used.

### List Licenses
**Endpoint**

<div class="endpoint get">/licenses/</div>

**Response**

```
HTTP 200 OK
```

```json
{
  "data": [
    {
      "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
      "created_at": 1500508800,
      "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
      "updated_at": 1500508800
    },
  ],
  "next": null,
}
```

If there are no licenses stored by {{site.ee_product_name}} the data array will
be empty.

```json
{
  "data": [],
  "next": null
}
```

### Add License

To create a license using an auto-generation UUID

**Endpoint**

<div class="endpoint post">/licenses/</div>

#### Request Body

{{ page.licenses_body }}

* The behavior of `POST` endpoint is the following: if the request payload
contains a valid {{site.ee_product_name}} license, the license will be added.
If the request payload contains a invalid licence, a `400 BAD REQUEST` will be
returned.

**Response**

```
HTTP 201 Created
```

```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

### Update or Add a License

**Endpoint**

<div class="endpoint put">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

* The behavior of `PUT` endpoint is the following: if the request payload
**does not** contain an entity's primary key (`id` for Licenses), the
license will be added and assign the id given. If the request payload
**does** contain an entity's primary key (`id` for Licenses), the license
will be replaced with the given payload attribute. If the id is not a valid
UUID, a `400 BAD REQUEST` will be returned or if the id omitted, a `405 NOT
ALLOWED` will be returned.

#### Request Body

{{ page.licenses_body }}

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1500508800,
  "id": "e8201120-4ee3-43ca-9e92-3fed08b1a15d",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

### Update a License

**Endpoint**

<div class="endpoint patch">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

* The behavior of `PATCH` endpoint is the following: if the request payload
**does** contain an entity's primary key (`id` for Licenses), the license will
be replaced with the given payload attribute. If the request payload **does
not** contain an entity's primary key (`id` for Licenses), a `404 NOT FOUND`
will be returned or if the request payload contains a invalid licence, a `400
BAD REQUEST` will be returned.

#### Request Body

{{ page.licenses_body }}

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1500595200,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-21\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb\",\"version\":\"1\"}}",
  "updated_at": 1500595200
}
```

### List a License

**Endpoint**

<div class="endpoint get">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

**Response**

```
HTTP 200 OK
```

```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-21\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

### Delete a License

**Endpoint**

<div class="endpoint delete">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

**Response**

```
HTTP 204 No Content
```

[Admin API]: /enterprise/{{page.kong_version}}/admin-api/
