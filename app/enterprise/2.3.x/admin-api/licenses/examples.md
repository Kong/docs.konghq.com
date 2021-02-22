---
title: Licenses Examples
book: licenses
---
<div class="alert alert-ee">
<b>Note:</b> The <code>/licenses</code> endpoint does not override standard
license configuration.
</div>

The `/licenses` endpoint provides a way to configure your {{site.ee_gateway_name}}
without using environment variables or placing a plaintext file
in your system directories. In a hybrid mode deployment, the Admin API
`/licenses` endpoint also configures all data planes in the cluster, simplifying
the configuration process.

## Prerequisites
Remove all standard license configurations from traditional deployments, control
planes, and data planes.

If you deploy a license using environmental variables or a plaintext
file, this configuration takes precedence over the
`/licenses` endpoint and **does not** communicate any changes to the Admin API.
If you try to use the `/licenses` endpoint while having a license configured
in some other way, the new license will not apply.

## List all licenses

Submit the following request:

```bash
$ http GET :8001/licenses
```

{% navtabs codeblock %}
{% navtab Response when license exists %}
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
{% endnavtab %}
{% navtab Response if there is no license %}

```json
{
  "data": [],
  "next": null
}
```
{% endnavtab %}
{% endnavtabs %}

## List a license

Using the ID of the license, submit the following request:

```bash
$ http GET :8001/licenses/30b4edb7-0847-4f65-af90-efbed8b0161f
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

To generate an ID automatically, submit a `POST` request directly to `/licenses`:

```bash
$ http POST :8001/licenses \
  payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```

Response:
```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

### Manually provided ID

To create a license with a custom ID, submit a `PUT` request to
`/licenses/<uuid>`:

```bash
$ http PUT :8001/licenses/e8201120-4ee3-43ca-9e92-3fed08b1a15d \
  payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```

Response:
```json
{
  "created_at": 1500508800,
  "id": "e8201120-4ee3-43ca-9e92-3fed08b1a15d",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

**Note**: If the provided ID exists, the request will perform
          an update to the license for the given ID instead of creating a new
          `license` entity.

## Update a license

To update a license, submit a `PATCH` request to an existing license ID:

```bash
$ http PATCH :8001/licenses/30b4edb7-0847-4f65-af90-efbed8b0161f \
  payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-21","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb","version":"1"}}'
```

Response:
```json
{
  "created_at": 1500595200,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-21\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"24cc21223633044c15c300be19cacc26ccc5aca0dd9a12df8a7324a1970fe304bc07b8dcd7fb08d7b92e04169313377ae3b550ead653b951bc44cd2eb59f6beb\",\"version\":\"1\"}}",
  "updated_at": 1500595200
}
```

[services]: /enterprise/{{page.kong_version}}/admin-api/#service-object
