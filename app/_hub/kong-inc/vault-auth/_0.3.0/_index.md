## Usage

In order to use the plugin, you first need to create a Consumer to associate one or more credentials to. The Consumer represents a developer using the upstream service. Additionally, a Vault object must be created to represent the connection Kong will use to communicate with a Vault server, where access and secret tokens will be stored.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object. To create a Consumer, you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created

{
    "username":"<USERNAME>",
    "custom_id": "<CUSTOM_ID>",
    "created_at": 1472604384000,
    "id": "7f853474-7b70-439d-ad59-2481a0a9a904"
}
```

parameter                      | default | description
---                            | ---     | ---
`username`<br>*semi-optional*  |         | The username of the Consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional* |         | A custom identifier used to map the Consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

If you are also using the [ACL](/plugins/acl/) plugin and allowed lists with this
service, you must add the new consumer to an allowed group. See
[ACL: Associating Consumers][acl-associating] for details.

### Create a Vault

A Vault object represents the connection between Kong and a Vault server. It defines the connection and authentication information used to communicate with the Vault API. This allows different instances of the `vault-auth` plugin to communicate with different Vault servers, providing a flexible deployment and consumption model.

Vault objects can be created via the following HTTP request:

```bash
$ curl -X POST http://localhost:8001/vaults \
  --header 'Content-Type: multipart/form-data' \
  --form name=kong-auth \
  --form mount=kong-auth \
  --form protocol=http \
  --form host=127.0.0.1 \
  --form port=8200 \
  --form vault_token=<token>
```

```bash
HTTP/1.1 201 Created

{
  "host": "127.0.0.1",
  "created_at": 1605288799,
  "vault_token": "<token>",
  "mount": "kong-auth",
  "protocol": "http",
  "name": "kong-auth",
  "port": 8200,
  "updated_at": 1605288799,
  "id": "c22198a3-cf54-428b-bed2-59c1f3760823"
}
```

This assumes a Vault server is accessible via `127.0.0.1:8200`, and that a version 1 KV secrets engine has been enabled at `kong-auth`. Vault KV secrets engine documentation is available via the [Vault documentation](https://www.vaultproject.io/docs/secrets/kv/kv-v1.html).

### Create an Access/Secret Token Pair

`vault-auth` credentials are defined as a pair of tokens: an `access` token that identifies the owner of the credential, and a `secret` token that is used to authenticate ownership of the `access` token.

Token pairs can be managed either via the Kong Admin API, or independantly via direct access with Vault. Token pairs must be associated with an existing Kong Consumer. Creating a token pair with the Kong Admin API can be done via the following request:

```bash
$ curl -X POST http://kong:8001/vaults/{vault}/credentials/{consumer}
HTTP/1.1 201 Created

{
    "data": {
        "access_token": "v3cOV1jWglS0PFOrTcdr85bs1GP0e2yM",
        "consumer": {
            "id": "64063284-e3b5-48e7-9bca-802251c32138"
        },
        "created_at": 1550538920,
        "secret_token": "11XYyybbu3Ty0Qt4ImIshPGQ0WsvjLzl",
        "ttl": null
    }
}
```

When the `access_token` or `secret_token` values are not provided, token values will be automatically generated via a cryptographically-secure random number generator (CSPRNG).

### Integrating Vault objects with Vault-Auth plugins

Vault objects are treated as foreign references in plugin configs, creating a seamless lifecycle relationship between Vault instances and plugins with which they're associated. `vault-auth` plugins require an association with a Vault object, which can be defined with the following HTTP request during plugin creation:

```bash
$ curl -X POST http://kong:8001/plugins \
  --data name=vault-auth \
  --data config.vault.id=<uuid>
HTTP/1.1 201 Created

{
  "created_at": 1550539002,
  "config": {
    "tokens_in_body": false,
    "secret_token_name": "secret_token",
    "run_on_preflight": true,
    "vault": {
      "id": "d3da058d-0acb-49c2-b7fe-72b3e9fd4b0a"
    },
    "anonymous": null,
    "hide_credentials": false,
    "access_token_name": "access_token"
  },
  "id": "b4d0cbb7-bff2-4599-ba19-67c705c15b9a",
  "service": null,
  "enabled": true,
  "run_on": "first",
  "consumer": null,
  "route": null,
  "name": "vault-auth"
}

```

Where `<uuid>` is the `id` of an existing Vault object.

### Using Vault credentials

Simply make a request with the `access_token` and `secret_token` as querystring parameters:

```bash
$ curl http://kong:8000/{proxy path}?access_token=<access token>&secret_token=<secret token>
```

Or in a header:

```bash
$ curl http://kong:8000/{proxy path} \
    -H 'access_token: <access_token>' \
    -H 'secret_token: <secret_token>'
```

### Deleting an Access/Secret Token Pair

Existing Vault credentials can be removed from the Vault server via the following API:

```bash
$ curl -X DELETE http://kong:8001/vaults/{vault}/credentials/token/{access token}

HTTP/1.1 204 No Content
```

### Token TTL

When reading a token from Vault, Kong will search the responding KV value for the presence of a `ttl` field. When this is present, Kong will respect the advisory value of the `ttl`field and store the value of the credential in cache for only as long as the `ttl` field defines. This allows tokens created directly in Vault, outside of the Kong Admin API, to be periodically refreshed by Kong.

### Extra-Kong Token Pairs

Kong can read access/token secret pairs that have been created directly in Vault, outside of the Kong Admin API. Currently `vault-auth` supports creating and reading credentials based on the Vault v1 KV engine. Create Vault KV secret values must contain the following fields:

```
{
  access_token: <string>
  secret_token: <string>
  created_at: <integer>
  updated_at: <integer>
  ttl: <integer> (optional)
  consumer: {
    id: <uuid>
  }
}
```

Additional fields within the secret are ignored. The key must be the `access_token` value; this is the identifier by which Kong queries the Vault API to fetch the credential data. See the [Vault documentation](https://www.vaultproject.io/docs/secrets/kv/kv-v1.html) for further information on the KV v1 secrets engine.

`vault-auth` token pairs can be created with the Vault HTTP API or the `vault write` command:

```bash
$ vault write kong-auth/foo - <<EOF
{
  "access_token": "foo",
  "secret_token": "supersecretvalue",
  "consumer": {
    "id": "ce67c25e-2168-4a09-81e5-e06187a2384f"
  },
  "ttl": 86400
}
EOF
```
