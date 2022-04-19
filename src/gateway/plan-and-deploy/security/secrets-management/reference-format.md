---
title: Reference Format
beta: true
---

## Reference Format

We use the [URL syntax](https://en.wikipedia.org/wiki/URL) to describe references to a secret store.

```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key][?query]}
```

### Protocol/Scheme

```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key]}
 ^^^^^
```

The `vault` in the URL is used as an identifier for Kong. We use this to reference a vault.

### Path

```text
{vault://<vault-prefix>/<secret-id>[/<secret-key]}
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

The `path` of the URL defines the following:

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

The `secret-id` is used as an identifier in case the vault uses a nested datastructure.

#### Secret Key

The `secret-key` is used to identify the secret within the `secret-id` object.

### Query

Query arguments are used to denote configuration options in a `key=value` format to the [Vault Prefix](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/reference-format/#vault-prefix)
