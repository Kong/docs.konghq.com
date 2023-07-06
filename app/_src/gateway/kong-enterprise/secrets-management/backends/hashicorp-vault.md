---
title: HashiCorp Vault
badge: enterprise
---

[HashiCorp Vault](https://www.vaultproject.io/) can be configured with environment variables or with a Vault entity.

## Configuration via environment variables

Configure the following environment variables on your {{site.base_gateway}} data plane:

Static Vault token authentication:


```bash
export KONG_VAULT_HCV_PROTOCOL=<protocol(http|https)>
export KONG_VAULT_HCV_HOST=<hostname>
export KONG_VAULT_HCV_PORT=<portnumber>
export KONG_VAULT_HCV_MOUNT=<mountpoint>
export KONG_VAULT_HCV_KV=<v1|v2>
export KONG_VAULT_HCV_AUTH_METHOD=token
export KONG_VAULT_HCV_TOKEN=<tokenstring>
```

Kubernetes service account role authentication:

```bash
export KONG_VAULT_HCV_PROTOCOL=<protocol(http|https)>
export KONG_VAULT_HCV_HOST=<hostname>
export KONG_VAULT_HCV_PORT=<portnumber>
export KONG_VAULT_HCV_MOUNT=<mountpoint>
export KONG_VAULT_HCV_KV=<v1|v2>
export KONG_VAULT_HCV_AUTH_METHOD=kubernetes
export KONG_VAULT_HCV_KUBE_ROLE=<rolename>
```

You can also store this information in an entity.

## Configuration via vaults entity

{:.note}
The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-hashicorp-vault \
  --data name="hcv" \
  --data description="Storing secrets in HashiCorp Vault" \
  --data config.protocol="https" \
  --data config.host="localhost" \
  --data config.port="8200" \
  --data config.mount="secret" \
  --data config.kv="v2" \
  --data config.token="<mytoken>"
```

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
    "description": "Storing secrets in HashiCorp Vault",
    "id": "0b43d867-05db-4bed-8aed-0fccb6667837",
    "name": "hcv",
    "prefix": "my-hashicorp-vault",
    "tags": null,
    "updated_at": 1645008893
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
    host: localhost
    kv: v2
    mount: secret
    port: 8200
    protocol: https
    token: <mytoken>
  description: Storing secrets in HashiCorp Vault
  name: hcv
  prefix: my-hashicorp-vault
```

{% endnavtab %}
{% endnavtabs %}

## Examples

For example, let's say you've configured a HashiCorp Vault with a path of `secret/hello` and a key=value pair of `foo=world`:

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

Access these secrets like this:

```bash
{vault://hcv/hello/foo}
```

Or, if you configured an entity:

```bash
{vault://my-hashicorp-vault/hello/foo}
```

## Vault configuration options

Use the following configuration options to configure the vaults entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x %}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for a HashiCorp vault in {{site.base_gateway}}:

Parameter | Field name | Description
----------|------------|------------
`vaults.config.protocol` | **config-protocol** (Kong Manager) <br> **Protocol** ({{site.konnect_short_name}}) | The protocol to connect with. Accepts one of `http` or `https`.
`vaults.config.host` | **config-host** (Kong Manager) <br> **Host** ({{site.konnect_short_name}}) | The hostname of your HashiCorp vault.
`vaults.config.port` | **config-port** (Kong Manager) <br> **Port** ({{site.konnect_short_name}}) | The port number of your HashiCorp vault.
`vaults.config.mount` | **config-mount** (Kong Manager) <br> **Mount** ({{site.konnect_short_name}}) | The mount point.
`vaults.config.kv` | **config-kv** (Kong Manager) <br> **Kv** ({{site.konnect_short_name}}) | The secrets engine version. Accepts `v1` or `v2`.
`vaults.config.token` | **config-token** (Kong Manager) <br> **Token** ({{site.konnect_short_name}}) | A token string.
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the AWS vault when cached.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a AWS vault miss (no secret).
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for which stale secrets from the AWS vault should be resurrected forwhen they cannot be refreshed (e.g., the HashiCorp vault is unreachable).


{% if_version gte:3.1.x %}
| `vaults.config.namespace` | **namespace** | Namespace for the Vault. Vault Enterprise requires a namespace to successfully connect to it. |
| `vaults.config.auth_method` | **auth-method** | Defines the authentication mechanism when connecting to the Hashicorp Vault service. Accepted values are: `token`, or `kubernetes`.  |
| `vaults.config.kube_role` | **kube-role** | Defines the HashiCorp Vault role for the Kubernetes service account of the running pod. `keyring_vault_auth_method` must be set to `kubernetes` for this to activate. |
{% endif_version %}

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `hcv` for HashiCorp Vault.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-hcv-vault/<some-secret>}`.
