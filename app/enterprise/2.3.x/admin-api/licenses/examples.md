---
title: Licenses Examples
book: licenses
---

## **Note**: License's endpoint will not override standard license configuration

License's endpoint provides a way to configure your {{site.ee_product_name}}
without the need to create environment variables or placing a plain text file
in your system directories. The admin-api licenses endpoint also configures the
dataplane(s) in the cluster when using a hybrid configuration; thus simplifying
the configuration process of those dataplane nodes.

The standard license configuration takes precedence over the licenses endpoint
and **does not** communicate license changes if configured. In order to use
this feature correctly all standard license configurations in traditional,
control plane(s), and dataplane(s) must be removed; otherwise the licenses
endpoint will not trigger the use of licenses added or updated.

## List licenses

Submit the following request:

```bash
http GET :8001/licenses
```

### Contains licenses

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

### Does not contain any licenses

```json
{
  "data": [],
  "next": null
}
```

## List a license

Submit the following providing the id of the license:

```bash
http GET :8001/licenses/30b4edb7-0847-4f65-af90-efbed8b0161f
```

```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

## Add a license

### Auto-generated ID

```bash
http POST :8001/licenses payload="{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}"
```

```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

### Manually provided ID

```bash
http PUT :8001/licenses/e8201120-4ee3-43ca-9e92-3fed08b1a15d payload="{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}"
```

```json
{
  "created_at": 1500508800,
  "id": "e8201120-4ee3-43ca-9e92-3fed08b1a15d",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

**Note**: If provided ID exists the license will not be added, but will perform
          an update to the license for the given ID.

## Update a license

```bash
http PATCH :8001/licenses/30b4edb7-0847-4f65-af90-efbed8b0161f payload="{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-21\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb\",\"version\":\"1\"}}"
```

```json
{
  "created_at": 1500595200,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-21\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb\",\"version\":\"1\"}}",
  "updated_at": 1500595200
}
```

[services]: /enterprise/{{page.kong_version}}/admin-api/#service-object
