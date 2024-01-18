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
{% if_version gte:3.6.x %}
HashiCorp Vault AppRole authentication:

```bash
export KONG_VAULT_HCV_PROTOCOL=<protocol(http|https)>
export KONG_VAULT_HCV_HOST=<hostname>
export KONG_VAULT_HCV_PORT=<portnumber>
export KONG_VAULT_HCV_MOUNT=<mountpoint>
export KONG_VAULT_HCV_KV=<v1|v2>
export KONG_VAULT_HCV_AUTH_METHOD=approle
export KONG_VAULT_HCV_APPROLE_ROLE_ID=<role_id>
export KONG_VAULT_HCV_APPROLE_SECRET_ID=<secret_id>
```
{% endif_version %}

You can also store this information in an entity.

## Configuration via vaults entity

{:.note}
The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/hashicorp-vault \
  --data name="hcv" \
  --data description="Storing secrets in HashiCorp Vault" \
  --data config.protocol="https" \
  --data config.host="localhost" \
  --data config.port="8200" \
  --data config.mount="secret" \
  --data config.kv="v2" \
  --data config.token="<token>"
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
        "token": "<token>"
    },
    "created_at": 1645008893,
    "description": "Storing secrets in HashiCorp Vault",
    "id": "0b43d867-05db-4bed-8aed-0fccb6667837",
    "name": "hcv",
    "prefix": "hashicorp-vault",
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
    token: <token>
  description: Storing secrets in HashiCorp Vault
  name: hcv
  prefix: hashicorp-vault
```

{% endnavtab %}
{% endnavtabs %}

## Examples

For example, if you've configured a HashiCorp Vault with a path of `secret/hello` and a key=value pair of `foo=world`:

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
{vault://hashicorp-vault/hello/foo}
```

If you have configured a secret value in multiple versions:

```text
# Requires kv2 engine enabled
vault kv patch secret/hello foo=world2

======= Metadata =======
Key                Value
---                -----
created_time       2022-01-16T01:40:03.740833Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2
```

Access an older version of the secret like this:

```bash
# For version 1
{vault://hcv/hello/foo#1}

# For version 2
{vault://hcv/hello/foo#2}

# Do not specify version number for the latest version
{vault://hcv/hello/foo}
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

|Parameter | Field name | Description 
|----------|------------|------------ 
|`vaults.config.protocol` | **config-protocol** (Kong Manager) <br> **Protocol** ({{site.konnect_short_name}}) | The protocol to connect with. Accepts one of `http` or `https`. 
|`vaults.config.host` | **config-host** (Kong Manager) <br> **Host** ({{site.konnect_short_name}}) | The hostname of your HashiCorp vault. 
|`vaults.config.port` | **config-port** (Kong Manager) <br> **Port** ({{site.konnect_short_name}}) | The port number of your HashiCorp vault. 
|`vaults.config.mount` | **config-mount** (Kong Manager) <br> **Mount** ({{site.konnect_short_name}}) | The mount point. 
|`vaults.config.kv` | **config-kv** (Kong Manager) <br> **Kv** ({{site.konnect_short_name}}) | The secrets engine version. Accepts `v1` or `v2`. 
|`vaults.config.token` | **config-token** (Kong Manager) <br> **Token** ({{site.konnect_short_name}}) | A token string. 
|`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute. 
|`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs. 
|`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired (`config.ttl` is over). This is useful when a vault becomes unreachable, or when a secret is deleted from the Vault and isn't replaced immediately. On this both cases, the Gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. We recommend assigning a sufficiently high value to this configuration option to ensure a seamless transition in case there are unexpected issues with the Vault. The default value for `resurrect_ttl` is 1e8 seconds, which is about 3 years. |

{% if_version gte:3.1.x %}
| `vaults.config.namespace` | **namespace** | Namespace for the Vault. Vault Enterprise requires a namespace to successfully connect to it. |
| `vaults.config.auth_method` | **auth-method** | Defines the authentication mechanism when connecting to the Hashicorp Vault service. Accepted values are: `token`, `kubernetes` or `approle`.  |
| `vaults.config.kube_role` | **kube-role** | Defines the HashiCorp Vault role for the Kubernetes service account of the running pod. `keyring_vault_auth_method` must be set to `kubernetes` for this to activate. |
| `vaults.config.kube_api_token_file` | **kube-api-token-file** | Defines the file path for the Kubernetes service account token. If not specified then a default path `/run/secrets/kubernetes.io/serviceaccount/token` will be used. |
{% endif_version %}
{% if_version gte:3.5.x %}
| `vaults.config.kube_auth_path` | **kube-auth-path** | Defines the path that enabled Kubernetes auth method. If not specified then a default path `kubernetes` will be used. If the value contains any single leading slash or single trailing slash then both of them will be trimmed. |
{% endif_version %}
{% if_version gte:3.6.x %}
| `vaults.config.approle_auth_path` | **approle_auth_path** | Defines the path that enabled Approle auth method. If not specified then a default path `approle` will be used. If the value contains any single leading slash or single trailing slash then both of them will be trimmed. |
| `vaults.config.approle_role_id` | **approle_role_id** | Defines the role id of the Approle in Hashicorp Vault. |
| `vaults.config.approle_secret_id` | **approle_secret_id** | Defines the secret id of the Approle in Hashicorp Vault. |
| `vaults.config.approle_secret_id_file` | **approle_secret_id_file** | Defines the path of the file whose content is the secret id value. |
| `vaults.config.approle_response_wrapping` | **approle_response_wrapping** | Defines whether the secret_id configured in vault entity or secret id file is actually a response wrapping token. Default to `false`. When set to true, Kong will try to unwrap the response wrapping token to get the real secret id of the Approle. Note that response wrapping token can be unwrapped only once, so make sure individual tokens are distributed for each Kong node in a typical cluster. |
{% endif_version %}

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `hcv` for HashiCorp Vault.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://hcv-vault/<some-secret>}`.
