---
title: Advanced Secrets Configuration
---

Vault implementations offer a variety of advanced configuration options.
For specific configuration parameters for your vault backend, see the [backend reference](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/).

{% if_version lte:3.0.x %}

{:.warning}
> Kong Manager currently doesn't support configuring vault entities.

{% endif_version %}

## Query arguments

You can configure your vault backend with query arguments.

For example, the following query uses an option called `prefix` with the value `SECURE_`:

```bash
{vault://env/my-secret-config-value?prefix=SECURE_}
```

For more information on available configuration options,
refer to respective [vault backend documentation](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/).

## Environment variables

You can configure your vault backend with `KONG_VAULT_<vault-backend>_<config_opt>` environment variables.

For example, {{site.base_gateway}} might look for an environment variable that matches `KONG_VAULT_ENV_PREFIX`:

```bash
export KONG_VAULT_ENV_PREFIX=SECURE_
```

## Vaults entity

You can configure your vault backend using the `vaults` entity.

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

Create a Vault entity:

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-env-vault-1  \
  --data name=env \
  --data description='ENV vault for secrets' \
  --data config.prefix=SECRET_
```

Result:

```json
{
    "config": {
        "prefix": "SECRET_"
    },
    "created_at": 1644929952,
    "description": "ENV vault for secrets",
    "id": "684ff5ea-7f65-4377-913b-880857f39251",
    "name": "env",
    "prefix": "my-env-vault-1",
    "tags": null,
    "updated_at": 1644929952
}
```

Config options depend on the associated [backend](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/) used.

This lets you drop the configuration from environment variables and query arguments and use the entity name in the reference:

```bash
{vault://my-env-vault/my-secret-config-value}
```

## Vaults CLI

```text
Usage: kong vault COMMAND [OPTIONS]

Vault utilities for {{site.base_gateway}}.

Example usage:
 TEST=hello kong vault get env/test

The available commands are:
  get <reference>  Retrieves a value for <reference>

Options:
 -c,--conf    (optional string)  configuration file
 -p,--prefix  (optional string)  override prefix directory
 --v              verbose
 --vv             debug
```

## Declarative configuration

{:.note}
> Secrets management is supported in decK 1.16 and later.

You can configure a vault backend with decK. For example:

```yaml
vaults:
- config:
    prefix: MY_SECRET_
  description: ENV vault for secrets
  name: env
  prefix: my-env-vault
```

For more information on configuring vaults and using secret references in declarative
configuration files, see [Secret Management with decK](/deck/latest/guides/vaults/).

## Shared configuration parameters

Every vault supports the following configuration parameters:

Parameter | UI field name | Description
----------|---------------|------------
`vaults.description` *optional* | Description | An optional description for your vault.
`vaults.name` | N/A | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`.
`vaults.prefix` | Prefix | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-env-vault/<some-secret>}`.

Most of the vaults also support secret rotation by using TTLs:

Parameter | Field name | Description
----------|------------|------------
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when cached.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret).
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long previous secret values should remained in use when they cannot be refreshed (e.g., the vault is unreachable).

[Read more about secrets rotation](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/secrets-rotation/).
