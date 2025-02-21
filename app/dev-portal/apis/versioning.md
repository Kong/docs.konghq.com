---
title: Versioning
---

The API entity allows you to set a `version` for your APIs. Each API is identified using the combination of `name+version`. If `version` is not specified, then `name` will be used as the unique identifier. 

{:.note}
> If you previously used API Products you may be wondering where the "API Product Version" concept has gone. The `version` field is now an optional field on the `API` object.

## Unversioned APIs

If you have an existing unversioned API, you can create an `API` by providing a name only:

```bash
curl -X POST -H 'Content-Type: application/json' https://us.api.konghq.com/v3/apis -d '{"name": "My Test API"}'
```

This API will be accessible as `my-test-api` in your Portal.

## Versioned APIs

To create a versioned API, specify the `version` field when creating an API:

```bash
curl -X POST -H 'Content-Type: application/json' https://us.api.konghq.com/v3/apis -d '{"name": "My Test API", "version": "v3"}'
```

This API will be accessible as `my-test-api-v3` in your list of APIs. The API will not be visible in a portal until you [publish](../portals/publishing).

The `version` field is a free text string. This allows you to follow semantic versioning (e.g. `v1`, `v2`), date based versioning (e.g. `2024-05-10`, `2024-10-22`) or any custom naming scheme (e.g. `a1b2c3-internal-xxyyzz00`)

