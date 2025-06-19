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

{% if_version gte:3.4.x %}
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


## How does Kong retrieve secrets from HashiCorp Vault?

Kong retrieves secrets from HashiCorp Vault's HTTP API through a two-step process: authentication and secret retrieval.

### Step 1: Authentication
Depending on the authentication method defined in `config.auth_method`, Kong authenticates to HashiCorp Vault using one of the following methods:

- If you're using the `token` auth method, Kong uses the `config.token` as the client token.
- If you're using the `kubernetes` auth method, Kong uses the service account JWT token mounted in the pod (path defined in the `config.kube_api_token_file`) to call the login API for the Kubernetes auth path on the HashiCorp Vault server and retrieve a client token. The request looks like the following:

```
POST /v1/auth/<config.kube_auth_path>/login
Host: <config.host>:<config.port>
Content-Type: application/json
X-Vault-Namespace: <config.namespace>

{
  "jwt": "<service account JWT token>",
  "role": "<config.kube_role>"
}
```

{% if_version gte:3.4.x %}
- If you're using the `approle` auth method, Kong uses the AppRole credentials to retrieve a client token. The AppRole role ID is configured by field `config.approle_role_id`, and the secret ID is configured by field `config.approle_secret_id` or `config.approle_secret_id_file`. 
  - If you set `config.approle_response_wrapping` to `true`, then the secret ID configured by
  `config.approle_secret_id` or `config.approle_secret_id_file` will be a response wrapping token, 
  and Kong will call the unwrap API `/v1/sys/wrapping/unwrap` to unwrap the response wrapping token to fetch 
  the real secret ID. Kong will use the AppRole role ID and secret ID to call the login API for the AppRole auth path
   on the HashiCorp Vault server and retrieve a client token. The request looks like the following:

```
POST /v1/auth/<config.approle_auth_path>/login
Host: <config.host>:<config.port>
Content-Type: application/json
X-Vault-Namespace: <config.namespace>

{
  "role_id": "<config.approle_role_id>",
  "secret_id": "<secret id>"
}
```
{% endif_version %}

By calling the login API, Kong will retrieve a client token and then use it in the next step as the value of `X-Vault-Token` header to retrieve a secret.

### Step 2: Retrieving the secret

Kong uses the client token retrieved in the [authentication step](#step-1-authentication) to call the Read Secret API and retrieve the secret value. The request varies depending on the secrets engine version you're using:

{% navtabs %}
{% navtab KV v1 %}

```
GET /v1/<config.mount>/<secret path>
Host: <config.host>:<config.port>
X-Vault-Token: <client token>
X-Vault-Namespace: <config.namespace>
```

{% endnavtab %}
{% navtab KV v2 %}

```
GET /v1/<config.mount>/data/<secret path>
Host: <config.host>:<config.port>
X-Vault-Token: <client token>
X-Vault-Namespace: <config.namespace>
```

{% endnavtab %}
{% navtab KV v2 with versioned secrets %}

```
GET /v1/<config.mount>/data/<secret path>?version=<version>
Host: <config.host>:<config.port>
X-Vault-Token: <client token>
X-Vault-Namespace: <config.namespace>
```
{% endnavtab %}
{% endnavtabs %}

{:.important}
> **Warning:** Make sure you've configured the correct KV engine version in `config.kv`, otherwise Kong will fail to parse the response.

Kong will parse the response of the read secret API automatically and return the secret value.


## Vault configuration options

Use the following configuration options to configure the vaults entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x -%}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for a HashiCorp vault in {{site.base_gateway}}:

|Parameter | Field name {:width=25%:}| Description 
|----------|------------|------------ 
|`vaults.config.protocol` | `config-protocol` (Kong Manager) <br> **Protocol** ({{site.konnect_short_name}}) | The protocol to connect with. Accepts one of `http` or `https`. 
|`vaults.config.host` | `config-host` (Kong Manager) <br> **Host** ({{site.konnect_short_name}}) | The hostname of your HashiCorp vault. 
|`vaults.config.port` | `config-port` (Kong Manager) <br> **Port** ({{site.konnect_short_name}}) | The port number of your HashiCorp vault. 
|`vaults.config.mount` | `config-mount` (Kong Manager) <br> **Mount** ({{site.konnect_short_name}}) | The mount point. 
|`vaults.config.kv` | `config-kv` (Kong Manager) <br> **Kv** ({{site.konnect_short_name}}) | The secrets engine version. Accepts `v1` or `v2`. 
|`vaults.config.token` | `config-token` (Kong Manager) <br> **Token** ({{site.konnect_short_name}}) | A token string. 
|`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute. 
|`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs. 
|`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired (`config.ttl` is over). This is useful when a vault becomes unreachable, or when a secret is deleted from the Vault and isn't replaced immediately. On this both cases, the Gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. We recommend assigning a sufficiently high value to this configuration option to ensure a seamless transition in case there are unexpected issues with the Vault. The default value for `resurrect_ttl` is 1e8 seconds, which is about 3 years. |

{% if_version gte:3.1.x %}
| `vaults.config.namespace` | `namespace` | Namespace for the Vault. Vault Enterprise requires a namespace to successfully connect to it. |
| `vaults.config.auth_method` | `auth-method` | Defines the authentication mechanism when connecting to the HashiCorp Vault service. Accepted values are: `token`, `kubernetes` or `approle`.  |
| `vaults.config.kube_role` | `kube-role` | Defines the HashiCorp Vault role for the Kubernetes service account of the running pod. `keyring_vault_auth_method` must be set to `kubernetes` for this to activate. |
| `vaults.config.kube_api_token_file` | `kube-api-token-file` | Defines the file path for the Kubernetes service account token. If not specified then a default path `/run/secrets/kubernetes.io/serviceaccount/token` will be used. |
{% endif_version %}

{% if_version gte:3.4.x %}
| `vaults.config.kube_auth_path` | `kube-auth-path` | Defines the path that activates the Kubernetes authentication method. If not specified, the default path kubernetes is used. Any single leading or trailing slash in the value will be automatically trimmed. 
| `vaults.config.approle_auth_path` | `approle_auth_path` | Specifies the path that activates the AppRole authentication method. If not provided, the default path AppRole will be used. Any single leading or trailing slash in the value will be automatically trimmed. |
| `vaults.config.approle_role_id` | `approle_role_id` |  Specifies the role ID of the AppRole in HashiCorp Vault.|
| `vaults.config.approle_secret_id` | `approle_secret_id` | Defines the secret ID of the AppRole in HashiCorp Vault. |
| `vaults.config.approle_secret_id_file` | `approle_secret_id_file` | Defines the file path containing the secret ID value. |
| `vaults.config.approle_response_wrapping` | `approle_response_wrapping` | Determines whether the secret_id configured in the vault entity or secret id file is actually a response wrapping token. By default, it is set to false. When set to true, Kong will attempt to unwrap the response wrapping token to retrieve the actual secret id of the AppRole. Note: A response wrapping token can only be unwrapped once. Therefore, ensure that individual tokens are distributed to each Kong node in a typical cluster.|
{% endif_version %}


Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, `hcv`, or `conjur`. Set `hcv` for HashiCorp Vault.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://hcv-vault/<some-secret>}`.
