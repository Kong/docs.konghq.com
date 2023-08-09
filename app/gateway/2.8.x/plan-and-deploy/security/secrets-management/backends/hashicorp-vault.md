---
title: Hashicorp Vault
badge: enterprise
---

## Configuration

[HashiCorp Vault](https://www.vaultproject.io/) can be configured with environment variables or with a Vault entity.

## Environment variables

```bash
export KONG_VAULT_HCV_PROTOCOL=<protocol(http|https)>
export KONG_VAULT_HCV_HOST=<hostname>
export KONG_VAULT_HCV_PORT=<portnumber>
export KONG_VAULT_HCV_MOUNT=<mountpoint>
export KONG_VAULT_HCV_KV=<v1|v2>
export KONG_VAULT_HCV_TOKEN=<tokenstring>
```

You can also store this information in an entity.

## Entity

{:.note}
The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{:.important}
> **API Endpoint update**
>
> If you're using 2.8.2 or below, or have not set `vaults_use_new_style_api=on` in `kong.conf` you will need to replace `/vaults/` with `/vaults-beta/` in the examples below.

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-hashicorp-vault \
  --data name="hcv" \
  --data description="Storing secrets in Hashicorp Vault" \
  --data config.protocol="https" \
  --data config.host="localhost" \
  --data config.port="8200" \
  --data config.mount="secret" \
  --data config.kv="v2" \
  --data config.token="<mytoken>"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/vaults/my-hashicorp-vault \
  name="hcv" \
  description="Storing secrets in Hashicorp Vault" \
  config.protocol="https" \
  config.host="localhost" \
  config.port="8200" \
  config.mount="secret" \
  config.kv="v2" \
  config.token="<mytoken>"
```

{% endnavtab %}
{% endnavtabs %}

Result:

```json
{
    "config": {
        "host": "localhost",
        "kv": "v2",
        "mount": "secret",
        "port": 8200,
        "protocol": "https",
        "token": "<mytoken>"
    },
    "created_at": 1645008893,
    "description": "Storing secrets in Hashicorp Vault",
    "id": "0b43d867-05db-4bed-8aed-0fccb6667837",
    "name": "hcv",
    "prefix": "my-hashicorp-vault",
    "tags": null,
    "updated_at": 1645008893
}
```

## Examples

For example, a HashiCorp Vault with a path of `secret/hello` and a key=value pair of `foo=world` created like this:

```text
vault kv put secret/hello foo=world

Key                Value
---                -----
created_time       2022-01-15T01:40:03.740833Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1
```

Would make it secrets available by:

```bash
{vault://hcv/hello/foo}
```

Or if you configured an entity

```bash
{vault://my-hashicorp-vault/hello/foo}
```
