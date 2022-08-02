---
title: Advanced Secrets Configuration
beta: true
---


Vault implementations offer a variety of advanced configuration options.

## Query arguments

You can configure your vault backend with query arguments.

For example, the following query uses an option called `prefix` with the value `SECURE_`:

```bash
{vault://env/my-secret-config-value?prefix=SECURE_}
```

For more information on available configuration options,
refer to respective [vault backend documentation](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends).

## Environment Variables

You can configure your vault backend with `KONG_VAULT_<vault-backend>_<config_opt>` environment variables.

For example, Kong Gateway might look for an environment variable that matches `KONG_VAULT_ENV_PREFIX`:

```bash
export KONG_VAULT_ENV_PREFIX=SECURE_
```

## Vaults entity

You can configure your vault backend using the `vaults` entity.

For the beta release of this feature, the endpoint is `/vaults-beta`.

```bash
http PUT :8001/vaults-beta/my-env-vault \
  name=env \
  description="ENV vault for secrets" \
  config.prefix=SECURE_ \
  -f
```

This lets you drop the configuration from environment variables and query arguments and use the entity name in the reference.

```bash
{vault://my-env-vault/my-secret-config-value}
```

For more information, see the section on the [Vaults entity](#vaults-entity).

## Vaults CLI

{:.warning}
> **Beta warning:** In the beta release, only the `kong vault get` command is supported.

```text
Usage: kong vault COMMAND [OPTIONS]

Vault utilities for Kong.

Example usage:
 TEST=hello kong vault get env/test

The available commands are:
  get <reference>  Retrieves a value for <reference>

Options:
 --v              verbose
 --vv             debug
```

## Vaults Entity

{:.warning}
> **Beta warning:**
> <br>
> The API endpoint is suffixed with `-beta` to avoid any possible conflicts. This will be
> changed in the future. Kong Manager has currently no supports for configuring vault entities.

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

Create a Vault entity:

{% navtabs codeblock %}
{% navtab cURL %}

```bash
$ curl -i -X PUT http://<hostname>:8001/vaults-beta/my-env-vault-1  \
        --data name=env \
        --data description='ENV vault for secrets' \
        --data config.prefix=SECRET_
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http PUT :8001/vaults-beta/my-env-vault-1 \
  name=env \
  description="ENV vault for secrets" \
  config.prefix=SECRET_  \
  -f
```

{% endnavtab %}
{% endnavtabs %}

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

Config options depend on the associated [backend](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends) used.
