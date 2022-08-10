---
title: Environment Variables Vault
beta: true
badge: free
---

## Configuration

Storing secrets in environment variables is a common way as they can be injected at build time.
There is no prior configuration needed.

## Examples

Define a secret in a environment variable:

```bash
export MY_SECRET_VALUE=opensesame
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
The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://<hostname>:8001/vaults-beta/my-env-vault \
        --data name=env \
        --data description="Store secrets in environment variables"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http PUT :8001/vaults-beta/my-env-vault \
  name="env" \
  description="Store secrets in environment variables" \
  -f 
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

With the entity in place you can reference secrets like this:

```bash
{vault://my-env-vault/my-secret-value}
```
