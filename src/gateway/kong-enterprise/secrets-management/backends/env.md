---
title: Environment Variables Vault
badge: free
content-type: how-to
---

## Configuration

Storing secrets in environment variables is a common way as they can be injected at build time.
There is no prior configuration needed.

## Examples

Define a secret in a environment variable:

```bash
export MY_SECRET_VALUE=EXAMPLE_VALUE
```

We can now reference this secret

```text
{vault://env/my-secret-value}
```

You can also define a `json` string if you want to store multiple secrets
in a single environment variable.

```bash
export PG_CREDS='{"username":"user", "password":"pass"}'
```

This allows you to do

```text
{vault://env/pg-creds/username}
{vault://env/pg-creds/password}
```

## Entity

{:.note}
> The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-env-vault \
  --data name=env \
  --data description="Store secrets in environment variables"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/vaults/my-env-vault \
  name="env" \
  description="Store secrets in environment variables"
```

{% endnavtab %}
{% endnavtabs %}

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
