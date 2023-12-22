---
nav_title: Configure the JWT plugin
---

To use the plugin, you first need to create a Consumer and associate one or more
JWT credentials (holding the public and private keys used to verify the token) to it.
The Consumer represents a developer using the final service.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object.
A Consumer can have many credentials.

{% navtabs %}
{% navtab Kong Admin API %}
To create a Consumer, you can execute the following request:

```bash
curl -d "username=<user123>&custom_id=<SOME_CUSTOM_ID>" http://localhost:8001/consumers/
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: <user123>
  custom_id: <SOME_CUSTOM_ID>
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

### Create a JWT credential

{% navtabs %}
{% navtab Kong Admin API %}
You can provision a new HS256 JWT credential by issuing the following HTTP request:

```bash
curl -X POST http://localhost:8001/consumers/<consumer>/jwt -H "Content-Type: application/x-www-form-urlencoded"
```

Response:
```json
HTTP/1.1 201 Created
{
    "algorithm": "HS256",
    "consumer": {
        "id": "789955d4-7cbf-469a-bb64-8cd00bd0f0db"
    },
    "created_at": 1652208453,
    "id": "95d4ee08-c68c-4b69-aa18-e6efad3a4ff0",
    "key": "H8WBDhQlcfjoFmIiYymmkRm1y0A2c5WU",
    "rsa_public_key": null,
    "secret": "n415M6OrVnR4Dr1gyErpta0wSKQ2cMzK",
    "tags": null
}
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
You can add JWT credentials on your declarative config file on the `jwt_secrets:` yaml entry:

``` yaml
jwt_secrets:
- consumer: <consumer>
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the fields/parameters work as follows:

field/parameter                | default         | description
---                            | ---             | ---
`consumer`                   |                 | The `id` or `username` property of the [consumer][consumer-object] entity to associate the credentials to.
`key`<br>*optional*            |                 | A unique string identifying the credential. If left out, it will be auto-generated.
`algorithm`<br>*optional*      | `HS256`         | The algorithm used to verify the token's signature. Can be `HS256`, `HS384`, `HS512`, `RS256`, `RS384`, `RS512`, `ES256`, or `ES384`.
`rsa_public_key`<br>*optional* |                 | If `algorithm` is `RS256`, `RS384`, `RS512`, `ES256`, or `ES384`, the public key (in PEM format) to use to verify the token's signature.
`secret`<br>*optional*         |                 | If `algorithm` is `HS256`, `HS384`, or `HS512`, the secret used to sign JWTs for this credential. If left out, will be auto-generated.

{:.important}
> **Note for decK and {{site.kic_product_name}} users:** The declarative
configuration used in decK and the {{site.kic_product_name}} imposes some
additional validation requirements that differ from the requirements listed
above. Because they cannot rely on defaults and do not implement their own
algorithm-specific requirements, all fields other than
`rsa_public_key` fields are required.
> <br/><br/>
> You should always fill out `key`, `algorithm`, and
`secret`. If you use the `RS256` or
`ES256` algorithm, use a dummy value for `secret`.

### Delete a JWT credential

You can remove a Consumer's JWT credential by issuing the following HTTP
request:

```bash
curl -X DELETE http://localhost:8001/consumers/<consumer>/jwt/<jwt-id>
```

Response:
```
HTTP/1.1 204 No Content
```

- `consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
- `jwt-id`: The `id` of the JWT credential.

### List JWT credentials

You can list a Consumer's JWT credentials by issuing the following HTTP
request:

```bash
curl -X GET http://localhost:8001/consumers/<consumer>/jwt
```

Response:
```
HTTP/1.1 200 OK
```

- `consumer`: The `id` or `username` property of the
  [Consumer][consumer-object] entity to list credentials for.

```json
{
	"data": [
        {
            "algorithm": "HS256",
            "consumer": {
                "id": "789955d4-7cbf-469a-bb64-8cd00bd0f0db"
            },
            "created_at": 1652208453,
            "id": "95d4ee08-c68c-4b69-aa18-e6efad3a4ff0",
            "key": "H8WBDhQlcfjoFmIiYymmkRm1y0A2c5WU",
            "rsa_public_key": null,
            "secret": "n415M6OrVnR4Dr1gyErpta0wSKQ2cMzK",
            "tags": null
        }
    ],
    "next": null
}
```

### Craft a JWT with a secret (HS256)

Now that your Consumer has a credential, and assuming you want to sign it using `HS256`,
the JWT should be crafted as follows (according to [RFC 7519](https://tools.ietf.org/html/rfc7519)):

First, its header must be:

```json
{
    "typ": "JWT",
    "alg": "HS256"
}
```

Secondly, the claims **must** contain the secret's `key` in the configured claim (from `config.key_claim_name`).
That claim is `iss` (issuer field) by default. Set its value to our previously created credential's `key`.
The claims may contain other values. Since Kong `0.13.1`, the claim is searched in both the JWT payload and header,
in that order.

```json
{
    "iss": "YJdmaDvVTJxtcWRCvkMikc8oELgAVNcz"
}
```

Using the JWT debugger at https://jwt.io with the header (HS256), claims (`iss`, etc.),
and `secret` associated with this `key` `C50k0bcahDhLNhLKSUBSR1OMiFGzNZ7X`, you'll end up with a JWT token of:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY
```

### Craft a JWT with public/private keys (RS256 or ES256)

If you want to use RS256 or ES256 to verify your JWTs, then when creating a JWT credential,
select `RS256` or `ES256` as the `algorithm`, and explicitly upload the public key
in the `rsa_public_key` field (including for ES256 signed tokens). For example:

```bash
curl -X POST http://localhost:8001/consumers/<consumer>/jwt \
  -F "rsa_public_key=@/path/to/public_key.pem" \
```

Response:
```json
HTTP/1.1 201 Created
{
    "created_at": 1442426001000,
    "id": "bcbfb45d-e391-42bf-c2ed-94e32946753a",
    "key": "a36c3049b36249a3c9f8891cb127243c",
    "rsa_public_key": "-----BEGIN PUBLIC KEY----- ...",
    "consumer": {
      "id": "8a21c4fa-e65e-4258-8673-540e85e67b33"
    }
}
```

When creating the signature, make sure that the header is:

```json
{
    "typ": "JWT",
    "alg": "RS256"
}
```

Secondly, the claims **must** contain the secret's `key` field (this **isn't** your private key used to generate
the token, but just an identifier for this credential) in the configured claim (from `config.key_claim_name`).
That claim is `iss` (issuer field) by default. Set its value to our previously created credential's `key`.
The claims may contain other values. Since Kong version `0.13.1`, the claim is searched in both the JWT payload and header,
in that order.

```json
{
    "iss": "a36c3049b36249a3c9f8891cb127243c"
}
```

Then, create the signature using your private keys. Using the JWT debugger at
[https://jwt.io](https://jwt.io), set the right header (RS256), the claims (`iss`, etc.), and the
associated public key. Then, append the resulting value in the `Authorization` header, for example:

```bash
curl http://localhost:8000/<route-path> \
  -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxM2Q1ODE0NTcyZTc0YTIyYjFhOWEwMDJmMmQxN2MzNyJ9.uNPTnDZXVShFYUSiii78Q-IAfhnc2ExjarZr_WVhGrHHBLweOBJxGJlAKZQEKE4rVd7D6hCtWSkvAAOu7BU34OnlxtQqB8ArGX58xhpIqHtFUkj882JQ9QD6_v2S2Ad-EmEx5402ge71VWEJ0-jyH2WvfxZ_pD90n5AG5rAbYNAIlm2Ew78q4w4GVSivpletUhcv31-U3GROsa7dl8rYMqx6gyo9oIIDcGoMh3bu8su5kQc5SQBFp1CcA5H8sHGfYs-Et5rCU2A6yKbyXtpHrd1Y9oMrZpEfQdgpLae0AfWRf6JutA9SPhst9-5rn4o3cdUmto_TBGqHsFmVyob8VQ'
```

### Send a request with the JWT

The JWT can now be included in a request to Kong by adding it as a header, if configured in `config.header_names` (which contains `Authorization` by default):

```bash
curl http://localhost:8000/<route-path> \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY'
```

as a query string parameter, if configured in `config.uri_param_names` (which contains `jwt` by default):

```bash
curl http://localhost:8000/<route-path>?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY
```

or as cookie, if the name is configured in `config.cookie_names` (which is not enabled by default):

```bash
curl --cookie jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY http://localhost:8000/<route-path>
```

gRPC requests can include the JWT in a header:

```bash
grpcurl -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY' ...
```

The request will be inspected by Kong, whose behavior depends on the validity of the JWT:

request                        | proxied to upstream service | response status code
--------                       |--------------------------|---------------------
has no JWT                     | no                       | 401
missing or invalid `iss` claim | no                       | 401
invalid signature              | no                       | 401
valid signature                | yes                      | from the upstream service
valid signature, invalid verified claim _optional_ | no                       | 401

{:.note}
> **Note:** When the JWT is valid and proxied to the upstream service, {{site.base_gateway}} makes no modification to the request other than adding headers identifying the consumer. The JWT will be forwarded to your upstream service, which can assume its validity. It is now the role of your service to base64 decode the JWT claims and make use of them.

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object