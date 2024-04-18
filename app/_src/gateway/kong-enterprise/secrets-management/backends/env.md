---
title: Environment Variables Vault
badge: free
content-type: how-to
---

Storing secrets in environment variables is a common method, as they can be injected at build time.

## Configuration via environment variables

Define a secret in a environment variable:

```bash
export MY_SECRET_VALUE=EXAMPLE_VALUE
```

You can now reference this secret:

```text
{vault://env/my-secret-value}
```

You can also define a flat `json` string if you want to store multiple secrets
in a single environment variable. Nested `json` is not supported.

```bash
export PG_CREDS='{"username":"user", "password":"pass"}'
```

This allows you to reference the secrets separately:

```text
{vault://env/pg-creds/username}
{vault://env/pg-creds/password}
```

{:.note}
> When adding an environment variable with Helm, ensure that the variable being passed has `kong-` appended to it. 

## Configuration via vaults entity

{:.note}
> The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-env-vault \
  --data name=env \
  --data description="Store secrets in environment variables"
```

Result:

```json
{
    "config": {
        "prefix": null
    },
    "created_at": 1644942689,
    "description": "Store secrets in environment variables",
    "id": "2911e119-ee1f-42af-a114-67061c3831e5",
    "name": "env",
    "prefix": "my-env-vault",
    "tags": null,
    "updated_at": 1644942689
}
```

{% endnavtab %}
{% navtab Declarative configuration %}

{:.note}
> Secrets management is supported in decK 1.16 and later.

Add the following snippet to your declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    prefix: null
  description: Store secrets in environment variables
  name: env
  prefix: my-env-vault
```

{% endnavtab %}
{% endnavtabs %}


With the entity in place you can reference secrets like this:

```bash
{vault://my-env-vault/my-secret-value}
```

## Vault configuration options

Use the following configuration options to configure the vaults entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x -%}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for an environment variable vault in {{site.base_gateway}}:

Parameter | Field name | Description
----------|---------------|------------
`vaults.config.prefix` | **config-prefix** (Kong Manager) <br> **Environment variable prefix** ({{site.konnect_short_name}}) | The prefix for the environment variable that the value will be stored in.

Common options:

Parameter | Field name | Description
----------|---------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `env` for the environment variable vault.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-env-vault/<some-secret>}`.
