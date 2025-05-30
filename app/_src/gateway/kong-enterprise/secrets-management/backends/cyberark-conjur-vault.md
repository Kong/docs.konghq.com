---
title: CyberArk Conjur Vault
badge: enterprise
---

[CyberArk Conjur Vault](https://www.conjur.org/) can be configured with environment variables or with a Vault entity.

## Configuration via environment variables

Configure the following environment variables on your {{site.base_gateway}} data plane:

Workload identify api key authentication:

```bash
export KONG_VAULT_CONJUR_ENDPOINT_URL=<endpoint_url>
export KONG_VAULT_CONJUR_ACCOUNT=<account>
export KONG_VAULT_CONJUR_AUTH_METHOD="api_key"
export KONG_VAULT_CONJUR_LOGIN=<login>
export KONG_VAULT_CONJUR_API_KEY=<api_key>
```

You can also store this information in an entity.

## Configuration via vaults entity

{:.note}
The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/conjur-vault \
  --data name="conjur" \
  --data description="Storing secrets in Conjur Vault" \
  --data config.endpoint_url="http:localhost:8080" \
  --data config.account="myConjurAccount" \
  --data config.login="host/BotApp/myDemoApp" \
  --data config.api_key="<api_key>"
```

```json
{
    "config": {
        "account": "myConjurAccount",
        "api_key": "<api_key>",
        "auth_method": "api_key",
        "base64_decode": false,
        "endpoint_url": "http://localhost:8080",
        "login": "host/BotApp/myDemoApp",
        "neg_ttl": null,
        "resurrect_ttl": null,
        "ttl": 60
    },
    "created_at": 1748642425,
    "description": "Storing secrets in Conjur Vault",
    "id": "329666eb-5bed-4989-8b9c-8163be2c81e1",
    "name": "conjur",
    "prefix": "my-conjur",
    "tags": null,
    "updated_at": 1748642425
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
    endpoint_url: http://localhost:8080
    account: myConjurAccount
    login: host/BotApp/myDemoApp
    api_key: <api_key>
  description: Storing secrets in Conjur Vault
  name: conjur
  prefix: conjur-vault
```

{% endnavtab %}
{% endnavtabs %}

## Examples

For example, if you've configured a Conjur Vault with a secret of `BotApp/secretVar` using the below policy from [conjur quickstart](https://www.conjur.org/get-started/quick-start/oss-environment/):
```yaml
- !policy
  id: BotApp
  body:
  - !host myDemoApp
  - !variable secretVar
  - !permit
    role: !host myDemoApp
    privileges: [read, execute]
    resource: !variable secretVar
```

Access this secret like this:

```bash
{vault://conjur/BotApp%2FsecretVar}
```

Or, if you configured an entity:

```bash
{vault://my-conjur/BotApp%2FsecretVar}
```

If you have configured a secret value in multiple versions, for instance by [rotating the secret](https://docs.cyberark.com/conjur-enterprise/latest/en/content/operations/services/rotation-secrets.html).

Access an older version of the secret like this:

```bash
# For version 1
{vault://conjur/BotApp%2FsecretVar#1}

# For version 2
{vault://conjur/BotApp%2FsecretVar#2}

# Do not specify version number for the latest version
{vault://conjur/BotApp%2FsecretVar}
```


## How does Kong retrieve secrets from HashiCorp Vault?

Kong retrieves secrets from CybarArk Conjur Vault's REST API through a two-step process: authentication and secret retrieval.

### Step 1: Authentication
Kong authenticates to CyberArk Conjur Vault using the authentication method defined in `config.auth_method`. The only supported authentication methid is by api key.

```
POST /authn/<config.account>/<config.login>/authenticate
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: base64

"<config.api_key>"
}
```

By calling the authentication API, Kong will retrieve an access token and then use it in the next step as the value of `Authorization` header to retrieve a secret.

### Step 2: Retrieving the secret

Kong uses the access token retrieved in the [authentication step](#step-1-authentication) to call the Read Secret API and retrieve the secret value.

{% navtab Latest secrets %}

```
GET /secrets/<config.account>/variable/<secret path>
Authorization: Token token="<access token>"
```

{% endnavtab %}
{% navtab Versioned secrets %}

```
GET /secrets/<config.account>/variable/<secret path>?version=<version>
Authorization: Token token="<access token>"
```

{% endnavtab %}

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

Configuration options for a CyberArk Conjur vault in {{site.base_gateway}}:

|Parameter | Field name {:width=25%:}| Description 
|----------|------------|------------ 
|`vaults.config.endpoint_url` | **Endpoint URL** | The CyberArk Conjur backend url to connect with. Accepts one of protocols `http` or `https`. 
|`vaults.config.auth_method` | **Authentication method** | Defines the authentication mechanism when connecting to the CyberArk Conjur Vault service. Accepted value is: `api_key`.
|`vaults.config.account` | **Account** | The Conjur organization account name.
|`vaults.config.login` | **Login** | The login name of the workload identity.
|`vaults.config.api_key` | **API Key** | The API key of the workload identity.
|`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute. 
|`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs. 
|`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired (`config.ttl` is over). This is useful when a vault becomes unreachable, or when a secret is deleted from the Vault and isn't replaced immediately. On this both cases, the Gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. We recommend assigning a sufficiently high value to this configuration option to ensure a seamless transition in case there are unexpected issues with the Vault. The default value for `resurrect_ttl` is 1e8 seconds, which is about 3 years.

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, `hcv`, or `conjur`. Set `conjur` for CyberArk Conjur Vault.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://conjur-vault/<some-secret>}`.
