---
title: Licenses Reference
badge: enterprise

licenses_attribute_id: |
    Attributes | Description
    ---:| ---
    `id` | The **license's** unique ID.

licenses_body: |
    Attribute | Description
    ---:| ---
    `payload` | The **Kong Gateway license** in JSON format.
---

The {{site.base_gateway}} Licenses feature is configurable through the
[Admin API]. This feature lets you configure a license in your
{{site.base_gateway}} cluster, in both traditional and hybrid mode deployments.
In hybrid mode deployments, the control plane sends licenses configured
through the `/licenses` endpoint to all data planes in the cluster. The data
planes use the most recent `updated_at` license.

## List licenses
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

If there are no licenses stored by {{site.base_gateway}}, the data array will
be empty.

```json
{
  "data": [],
  "next": null
}
```

## List a specific license

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

## Add a license

To create a license using an auto-generated UUID:

**Endpoint**

<div class="endpoint post">/licenses/</div>

**Request Body**

{{ page.licenses_body }}

When using `POST`, if the request payload **does**
contain a valid {{site.base_gateway}} license, the license will be added.

If the request payload **does not** contain a valid licence, a `400 BAD REQUEST`
will be returned.

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

## Update or add a license

**Endpoint**

<div class="endpoint put">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

When using `PUT`, if the request payload
**does not** contain an entity's primary key (`id` for licenses), the
license will be added and assigned the given ID.

If the request payload
**does** contain an entity's primary key (`id` for Licenses), the license
will be replaced with the given payload attribute.
If the ID is not a valid UUID, a `400 BAD REQUEST` will be returned. If the ID
is omitted, a `405 NOT ALLOWED` will be returned.

**Request Body**

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

## Update a license

**Endpoint**

<div class="endpoint patch">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

When using `PATCH`, if the request payload
**does** contain an entity's primary key (`id` for licenses), the license will
be replaced with the given payload attribute.

If the request payload **does
not** contain an entity's primary key (`id` for licenses), a `404 NOT FOUND`
will be returned or if the request payload contains a invalid licence, a `400
BAD REQUEST` will be returned.

**Request Body**

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

## Delete a license

**Endpoint**

<div class="endpoint delete">/licenses/{id}</div>

{{ page.licenses_attribute_id }}

**Response**

```
HTTP 204 No Content
```

## Generate a report

Generate a report on the Kong Gateway instance to gather monthly usage data.

<div class="endpoint get">/license/report</div>

Fields available in the report:

Field | Description
------|------------
`counters` | Counts the number of requests made in a given month. <br><br> &#8226; `bucket`: Year and month when the requests were processed. If the value in `bucket` is `UNKNOWN`, then the requests were processed before Kong Gateway 2.7.0.1. <br> &#8226; `request_count`: Number of requests processed in the given month and year.
`db_version` | The type and version of the datastore Kong Gateway is using.
`kong_version` | The version of the Kong Gateway instance.
`license_key` | An encrypted identifier for the current license key. If no license is present, the field displays as `UNLICENSED`.
`rbac_users` | The number of users registered with through RBAC.
`services_count` | The number of configured services in the Kong Gateway instance.
`system_info` | Displays information about the system running Kong Gateway. <br><br> &#8226; `cores`: Number of CPU cores on the node <br> &#8226; `hostname`: Encrypted system hostname <br> &#8226; `uname`: Operating system
`workspaces_count` | The number of workspaces configured in the Kong Gateway instance.

**Response**

```
HTTP 200 OK
```

```json
{
    "counters": [
        {
            "bucket": "2021-12",
            "request_count": 0
        }
    ],
    "db_version": "postgres 9.6.19",
    "kong_version": "2.7.0.0",
    "license_key": "ASDASDASDASDASDASDASDASDASD_ASDASDA",
    "rbac_users": 0,
    "services_count": 0,
    "system_info": {
        "cores": 4,
        "hostname": "13b867agsa008",
        "uname": "Linux x86_64"
    },
    "workspaces_count": 1
}
```

If there are no licenses stored by {{site.base_gateway}}, the report will include
`"license_key": "UNLICENSED"`:

```
HTTP 200 OK
```

```json
{
    "counters": [
        {
            "bucket": "2021-12",
            "request_count": 0
        }
    ],
    "db_version": "postgres 9.6.19",
    "kong_version": "2.7.0.0",
    "license_key": "UNLICENSED",
    "rbac_users": 0,
    "services_count": 0,
    "system_info": {
        "cores": 4,
        "hostname": "13b867agsa008",
        "uname": "Linux x86_64"
    },
    "workspaces_count": 1
}
```

[Admin API]: /gateway/{{page.kong_version}}/admin-api/
