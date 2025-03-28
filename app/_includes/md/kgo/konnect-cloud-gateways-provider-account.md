{% assign entity = include.entity %}

## Provider Account

In order to mange Cloud Gateway {{ entity }}s you need to have a Cloud Gateway Provider Account associated with your {{site.konnect_product_name}} account.

To create one, please contact your Kong Account Manager.

If you already have one, you can use the [{{site.konnect_short_name }}'s `/cloud-gateways/provider-accounts` API][provider_account_list_api]
to get its name (`provider` response field) and `id`.

```bash
curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer ${KONNECT_TOKEN}" -XGET https://global.api.konghq.com/v2/cloud-gateways/provider-accounts | jq
```

[provider_account_list_api]: /konnect/api/cloud-gateways/latest/#/operations/list-provider-accounts

This should return a list of provider accounts.
You can use the returned `id` and name (`provider` response field) create and managed a Cloud Gateway {{ entity }}s.

```json
{
  "data": [
    {
      "id": "11111111-1111-1111-1111-111111111111",
      "provider": "aws",
      "provider_account_id": "001111111111",
      "created_at": "2023-07-06T18:40:12.172Z",
      "updated_at": "2023-07-06T18:40:12.172Z"
    }
  ],
  "meta": {
    "page": {
      "total": 1,
      "size": 100,
      "number": 1
    }
  }
}
```
