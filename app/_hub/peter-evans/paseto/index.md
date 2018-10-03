---
name: PASETO
publisher: peter-evans

categories:
  - authentication

type: plugin

desc: PASETO (Platform-Agnostic Security Tokens)
description: |
  Paseto (Platform-Agnostic SEcurity TOkens) is a specification and reference implementation for secure stateless tokens.

  Verify requests containing signed PASETOs (as specified in [PASETO RFC](https://paseto.io/rfc/)).
  Each of your Consumers will have PASETO credentials (public and secret keys) which must be used to sign their PASETOs.
  A token can then be passed through:

  - a query string parameter,
  - a cookie,
  - or the Authorization header.

  The plugin will either proxy the request to your upstream services if the token's signature is verified, or discard the request if not.
  The plugin can also perform verifications on registered claims and custom claims.

  **Feature Support**

  - v2.public JSON payload PASETOs
  - Registered claims validation
  - Custom claims validation

support_url: https://github.com/peter-evans/kong-plugin-paseto/issues

source_url: https://github.com/peter-evans/kong-plugin-paseto

license_type: MIT

license_url: https://github.com/peter-evans/kong-plugin-paseto/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.12.x
      - 0.13.x
      - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.32-x
      - 0.33-x
      - 0.34-x
    incompatible:

params:
  name: paseto
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true
  config:
    - name: uri_param_names
      required: false
      default: "`paseto`"
      description: A list of querystring parameters that the plugin will inspect to retrieve PASETOs.
    - name: cookie_names
      required: false
      default:
      description: A list of cookie names that the plugin will inspect to retrieve PASETOs.
    - name: claims_to_verify<br/>.{claim_name}
      required: false
      default:
      description: |
        This is a list of custom objects that you can set, with arbitrary names set in the `{claim_name}` placeholder, like `claims_to_verify.claim_1.claim=ForAudience` if your object is called "claim_1".
    - name: claims_to_verify.<br/>{claim_name}.claim
      required: semi
      default:
      description: The claim rule or name of your custom claim. See below for a description of the claim rules.
    - name: claims_to_verify.<br/>{claim_name}.value
      required: semi
      default:
      description: The value to verify against.
    - name: kid_claim_name
      required: false
      default: "`kid`"
      description: |
        The name of the claim in which the kid identifying the PASETO key pair **must** be passed. The plugin will attempt to read this claim from the PASETO footer.
    - name: anonymous
      required: false
      default:
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
    - name: run_on_preflight
      required: false
      default: "`true`"
      description: |
        A boolean value that indicates whether the plugin should run (and try to authenticate) on `OPTIONS` preflight requests, if set to `false` then `OPTIONS` requests will always be allowed.

  extra: |
    **Claim Rules**

    * `ForAudience` which compares the payload-provided `aud` claim with an expected value.
    * `IdentifiedBy` which compares the payload-provided `jti` claim with an expected value.
    * `IssuedBy` which compares the payload-provided `iss` claim with an expected value.
    * `NotExpired` which verifies that the current time is less than or equal to the DateTime stored in the `exp` claim.
    * `Subject` which compares the payload-provided `sub` claim with an expected value.
    * `ValidAt` which verifies all of the following:
      * The current time is less than or equal to the DateTime stored in the `exp` claim.
      * The current time is greater than or equal to the DateTime stored in the `iat` claim.
      * The current time is greater than or equal to the DateTime stored in the `nbf` claim.
    * `ContainsClaim` which verifies that the payload contains a claim with the specified name.
    * `{custom_claim}` which verifies that the payload contains a claim with the name set in the `{claim_name}` placeholder and with an expected value.

---

## Installation

#### Sodium Crypto Library

This plugin uses the [PASETO for Lua](https://github.com/peter-evans/paseto-lua) library, which in turn depends on the [Sodium crypto library (libsodium)](https://github.com/jedisct1/libsodium).
The following is a convenient way to install libsodium via LuaRocks.
Alternatively, see [libsodium's documentation](https://download.libsodium.org/doc/installation/) for full installation instructions.

```
luarocks install libsodium
```

Note: The Sodium Crypto Library must be installed on each node in your Kong cluster.

#### PASETO Kong Plugin
Install the plugin on each node in your Kong cluster via luarocks:

```
luarocks install kong-plugin-paseto
```

Add to the custom_plugins list in your Kong configuration (on each Kong node):

```
custom_plugins = paseto
```

## Usage

In order to use the plugin, you first need to create a Consumer and associate one or more PASETO credentials (holding the public key used to verify the token) to it. The Consumer represents a developer using the final service.

#### Create a Consumer

You need to associate a credential to an existing Consumer object. To create a Consumer, you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created
```

| Parameter |  | Default | Description |
| :---: | :---: | :---: | :---: |
| `username` | semi-optional |  | The username for this Consumer. Either this field or `custom_id` must be specified. |
| `custom_id` | semi-optional |  | A custom identifier used to map the Consumer to an external database. Either this field or `username` must be specified. |

A Consumer can have many PASETO credentials.

#### Create a PASETO credential

You can provision a new PASETO credential by issuing the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/paseto -H "Content-Type: application/x-www-form-urlencoded"
HTTP/1.1 201 Created

{
   "consumer_id": "94c058d0-f5f1-4afc-ab18-eab487492a03",
   "created_at": 1530751342000,
   "id": "f99c0041-6271-43d3-bebd-32479c2746b6",
   "kid": "ikypl5x7QEKShEoEzFxfz5axONlgjdza",
   "public_key": "8SQDqtA5yx4atQEg0uH3Rit3nLq+EAQF4A1Zkvwh5TU=",
   "secret_key": "hbJbxFK3xFL1YlrcqodKqt0FvVyZjmPXQqOIexzxsVbxJAOq0DnLHhq1ASDS4fdGK3ecur4QBAXgDVmS/CHlNQ=="
}
```

- `consumer`: The `id` or `username` property of the Consumer entity to associate the credentials to.

| Parameter |  | Default | Description |
| :---: | :---: | :---: | :---: |
| `kid` | optional |  | A unique string identifying the credential. If left out, it will be auto-generated. |
| `secret_key` | optional |  | The 64 byte secret key base64 encoded. |
| `public_key` | optional |  | The 32 byte public key base64 encoded. If left out and a `secret_key` is supplied, the `public_key` is assumed to be the last 32 bytes of the `secret_key`. |

If neither `secret_key` or `public_key` are supplied the plugin will generate a new key pair.

#### Delete a PASETO credential

You can remove a Consumer's PASETO credential by issuing the following HTTP
request:

```bash
$ curl -X DELETE http://kong:8001/consumers/{consumer}/paseto/{id}
HTTP/1.1 204 No Content
```

- `consumer`: The `id` or `username` property of the Consumer entity to associate the credentials to.
- `id`: The `id` of the PASETO credential.

#### List PASETO credentials

You can list a Consumer's PASETO credentials by issuing the following HTTP
request:

```bash
$ curl -X GET http://kong:8001/consumers/{consumer}/paseto
HTTP/1.1 200 OK
```

- `consumer`: The `id` or `username` property of the Consumer entity to list credentials for.

```json
{
    "data": [
        {
           "consumer_id": "94c058d0-f5f1-4afc-ab18-eab487492a03",
           "created_at": 1530751342000,
           "id": "f99c0041-6271-43d3-bebd-32479c2746b6",
           "kid": "ikypl5x7QEKShEoEzFxfz5axONlgjdza",
           "public_key": "8SQDqtA5yx4atQEg0uH3Rit3nLq+EAQF4A1Zkvwh5TU=",
           "secret_key": "hbJbxFK3xFL1YlrcqodKqt0FvVyZjmPXQqOIexzxsVbxJAOq0DnLHhq1ASDS4fdGK3ecur4QBAXgDVmS/CHlNQ=="
        }
    ],
    "total": 1
}
```

#### Send a request with a PASETO

PASETOs can now be included in a request to Kong by adding it to the `Authorization` header:

```bash
$ curl http://kong:8000/{route path} \
    -H 'Authorization: Bearer v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ'
```

as a querystring parameter, if configured in `config.uri_param_names` (which contains `paseto` by default):

```bash
$ curl http://kong:8000/{route path}?paseto=v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ
```

or as cookie, if the name is configured in `config.cookie_names` (which is not enabled by default):

```bash
curl --cookie paseto=v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ http://kong:8000/{route path}
```

Note: When the PASETO is valid and proxied to the upstream service, Kong makes no modification to the request other than adding headers identifying the Consumer. The PASETO will be forwarded to your upstream service, which can assume its validity. It is now the role of your service to base64 decode the PASETO claims and make use of them.
