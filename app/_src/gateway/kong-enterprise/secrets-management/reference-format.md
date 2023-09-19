---
title: Reference Format
---

We use the [URL syntax](https://en.wikipedia.org/wiki/URL) to describe references to a secret store.

```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key][/][?query]}
```

### Protocol/Scheme

```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key]}
 ^^^^^
```

The `vault` in the URL is used as an identifier for Kong. We use this to reference a vault.

### Host/Path

```text
{vault://<vault-prefix>/<secret-id>[/<secret-key]}
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

The `host` and  `path` of the URL defines the following:

#### Vault Prefix

The prefix for a vault can be either the name of the backend or the name of vault entity that you created.

Examples:

```text
{vault://env/<secret-id>[/<secret-key]}
         ^^^
```

or using a vault entity

```text
{vault://my-env-vault/<secret-id>[/<secret-key]}
         ^^^^^^^^^^^^
```

#### Secret ID

The `secret-id` is used as an identifier for a secret stored in a vault. The vault
may return either a `string` value (a single secret) or multiple related secrets
like username and password as a secret `object`.

#### Secret Key

The `secret-key` is used to identify the secret within the `secret-id` object.

{:.note}
> If secret key ends with `/`, then it is not considered as a [Secret Key](#secret-key) but as a part of [Secret Id](#secret-id).
> The difference between [Secret Key](#secret-key) and [Secret Id](#secret-id) is that only the [Secret Id](#secret-id) is sent to vault API,
> and the [Secret Key](#secret-key) is only used when processing 


### Query

Query arguments are used to denote configuration options in a `key=value` format to the [Vault Prefix](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/reference-format/#vault-prefix)
