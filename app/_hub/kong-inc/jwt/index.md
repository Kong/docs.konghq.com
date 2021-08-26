---
name: JWT
publisher: Kong Inc.
version: 2.2.x
# internal version handler 2.2.0 4/6/2021

desc: Verify and authenticate JSON Web Tokens
description: |
  Verify requests containing HS256 or RS256 signed JSON Web Tokens (as specified
  in [RFC 7519](https://tools.ietf.org/html/rfc7519)). Each of your Consumers
  will have JWT credentials (public and secret keys), which must be used to sign
  their JWTs. A token can then be passed through:

  - a query string parameter
  - a cookie
  - HTTP request headers

  Kong will either proxy the request to your Upstream services if the token's
  signature is verified, or discard the request if not. Kong can also perform
  verifications on some of the registered claims of RFC 7519 (exp and nbf).


type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x    
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
    enterprise_edition:
      compatible:
        - 2.4.x 
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: jwt
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: partially
  dbless_explanation: |
    Consumers and JWT secrets can be created with declarative configuration.

    Admin API endpoints that do POST, PUT, PATCH, or DELETE on secrets are not available on DB-less mode.
  config:
    - name: uri_param_names
      required: false
      default: "`jwt`"
      datatype: set of string elements
      description: A list of querystring parameters that Kong will inspect to retrieve JWTs.
    - name: cookie_names
      required: false
      default:
      datatype: set of string elements
      description: A list of cookie names that Kong will inspect to retrieve JWTs.
    - name: header_names
      required: false
      default: "`authorization`"
      datatype: set of string elements
      description: A list of HTTP header names that Kong will inspect to retrieve JWTs.
    - name: claims_to_verify
      required: false
      default:
      datatype: set of string elements
      description: |
        A list of registered claims (according to [RFC 7519](https://tools.ietf.org/html/rfc7519)) that Kong can verify as well. Accepted values: one of `exp` or `nbf`.
    - name: key_claim_name
      required: false
      default: "`iss`"
      datatype: string
      description: |
        The name of the claim in which the `key` identifying the secret **must** be passed. Starting with version `0.13.1`, the plugin will attempt to read this claim from the JWT payload and the header, in that order.
    - name: secret_is_base64
      required: true
      default: "`false`"
      datatype: boolean
      description: |
        If true, the plugin assumes the credential's `secret` to be base64 encoded. You will need to create a base64-encoded secret for your Consumer, and sign your JWT with the original secret.
    - name: anonymous
      required: false
      default:
      datatype: string
      description: |
        An optional string (consumer uuid) value to use as an anonymous consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. The anonymous value must refer to the Consumer `id` attribute that is internal to Kong, and **not** its `custom_id`.
    - name: run_on_preflight
      required: true
      default: "`true`"
      datatype: boolean
      description: |
        A boolean value that indicates whether the plugin should run (and try to authenticate) on `OPTIONS` preflight requests. If set to `false`, then `OPTIONS` requests will always be allowed.
    - name: maximum_expiration
      required: false
      default: 0
      datatype: number
      description: |
        A value between 0 and 31536000 (365 days) limiting the lifetime of the JWT to `maximum_expiration` seconds in the future. Any JWT that has a longer lifetime is rejected (HTTP 403). If this value is specified, `exp` must be specified as well in the `claims_to_verify` property. The default value of `0` represents an indefinite period. Potential clock skew should be considered when configuring this setting.

  extra: |
    <div class="alert alert-warning">
        <center>The option <code>config.run_on_preflight</code> is only available from version <code>0.11.1</code> and later.</center>
    </div>

---

## Documentation

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
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: user123
  custom_id: SOME_CUSTOM_ID
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
$ curl -X POST http://kong:8001/consumers/{consumer}/jwt -H "Content-Type: application/x-www-form-urlencoded"
HTTP/1.1 201 Created

{
    "consumer_id": "7bce93e1-0a90-489c-c887-d385545f8f4b",
    "created_at": 1442426001000,
    "id": "bcbfb45d-e391-42bf-c2ed-94e32946753a",
    "key": "a36c3049b36249a3c9f8891cb127243c",
    "secret": "e71829c351aa4242c2719cbfbe671c09"
}
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
You can add JWT credentials on your declarative config file on the `jwt_secrets:` yaml entry:

``` yaml
jwt_secrets:
- consumer: {consumer}
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the fields/parameters work as follows:

field/parameter                | default         | description
---                            | ---             | ---
`{consumer}`                   |                 | The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
`key`<br>*optional*            |                 | A unique string identifying the credential. If left out, it will be auto-generated.
`algorithm`<br>*optional*      | `HS256`         | The algorithm used to verify the token's signature. Can be `HS256`, `HS384`, `HS512`, `RS256`, or `ES256`.
`rsa_public_key`<br>*optional* |                 | If `algorithm` is `RS256` or `ES256`, the public key (in PEM format) to use to verify the token's signature.
`secret`<br>*optional*         |                 | If `algorithm` is `HS256` or `ES256`, the secret used to sign JWTs for this credential. If left out, will be auto-generated.

  <div class="alert alert-warning">
    <strong>Note for decK and Kong Ingress Controller users:</strong> The declarative
    configuration used in decK and the Kong Ingress Controller imposes some
    additional validation requirements that differ from the requirements listed
    above. Because they cannot rely on defaults and do not implement their own
    algorithm-specific requirements, all fields other than
    <code>rsa_public_key</code> fields are required.
    <br/>
    <br/>
    You should always fill out <code>key</code>, <code>algorithm</code>, and
    <code>secret</code>. If you use the <code>RS256</code> or
    <code>ES256</code> algorithm, use a dummy value for <code>secret</code>.
  </div>

### Delete a JWT credential

You can remove a Consumer's JWT credential by issuing the following HTTP
request:

```bash
$ curl -X DELETE http://kong:8001/consumers/{consumer}/jwt/{id}
HTTP/1.1 204 No Content
```

- `consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
- `id`: The `id` of the JWT credential.

### List JWT credentials

You can list a Consumer's JWT credentials by issuing the following HTTP
request:

```bash
$ curl -X GET http://kong:8001/consumers/{consumer}/jwt
HTTP/1.1 200 OK
```

- `consumer`: The `id` or `username` property of the
  [Consumer][consumer-object] entity to list credentials for.

```json
{
    "data": [
        {
            "rsa_public_key": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgK .... -----END PUBLIC KEY-----",
            "consumer_id": "39f52333-9741-48a7-9450-495960d91684",
            "id": "3239880d-1de5-4dbc-bccf-78f7a4280f33",
            "created_at": 1491430568000,
            "key": "c5a55906cc244f483226e02bcff2b5e",
            "algorithm": "RS256",
            "secret": "b0970f7fc9564e65xklfn48930b5d08b1"
        }
    ],
    "total": 1
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
    "iss": "a36c3049b36249a3c9f8891cb127243c"
}
```

Using the JWT debugger at https://jwt.io with the header (HS256), claims (iss, etc.),
and `secret` associated with this `key` (e71829c351aa4242c2719cbfbe671c09), you'll end up with a JWT token of:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

### Send a request with the JWT

The JWT can now be included in a request to Kong by adding it as a header, if configured in `config.header_names` (which contains `Authorization` by default):

```bash
$ curl http://kong:8000/{route path} \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4'
```

as a querystring parameter, if configured in `config.uri_param_names` (which contains `jwt` by default):

```bash
$ curl http://kong:8000/{route path}?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

or as cookie, if the name is configured in `config.cookie_names` (which is not enabled by default):

```bash
curl --cookie jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4 http://kong:8000/{route path}
```

gRPC requests can include the JWT in a header:

```bash
grpcurl -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4' ...
```

The request will be inspected by Kong, whose behavior depends on the validity of the JWT:

request                        | proxied to upstream service | response status code
--------                       |--------------------------|---------------------
has no JWT                     | no                       | 401
missing or invalid `iss` claim | no                       | 401
invalid signature              | no                       | 403
valid signature                | yes                      | from the upstream service
valid signature, invalid verified claim _optional_ | no                       | 401

<div class="alert alert-warning">
  <strong>Note:</strong> When the JWT is valid and proxied to the upstream service, Kong makes no modification to the request other than adding headers identifying the Consumer. The JWT will be forwarded to your upstream service, which can assume its validity. It is now the role of your service to base64 decode the JWT claims and make use of them.
</div>

### (Optional) Verified claims

Kong can also perform verification on registered claims, as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519). To perform verification on a claim, add it to the `config.claims_to_verify` property:

You can patch an existing JWT plugin:

```bash
# This adds verification for both nbf and exp claims:
$ curl -X PATCH http://kong:8001/plugins/{jwt plugin id} \
    --data "config.claims_to_verify=exp,nbf"
```

Supported claims:

claim name | verification
-----------|-------------
`exp`      | Identifies the expiration time on or after which the JWT must not be accepted for processing.
`nbf`      | Identifies the time before which the JWT must not be accepted for processing.

### (Optional) Base64-encoded secret

If your secret contains binary data, you can store them as base64 encoded in Kong.
Enable this option in the plugin's configuration.

You can patch an existing Route:

```bash
$ curl -X PATCH http://kong:8001/routes/{route id}/plugins/{jwt plugin id} \
    --data "config.secret_is_base64=true"
```

Then, base64 encode your Consumers' secrets:

```bash
# secret is: "blob data"
$ curl -X POST http://kong:8001/consumers/{consumer}/jwt \
  --data "secret=YmxvYiBkYXRh"
```

And sign your JWT using the original secret ("blob data").

### Craft a JWT with public/private keys (RS256 or ES256)

If you want to use RS256 or ES256 to verify your JWTs, then when creating a JWT credential,
select `RS256` or `ES256` as the `algorithm`, and explicitly upload the public key
in the `rsa_public_key` field (including for ES256 signed tokens). For example:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/jwt \
      -F "rsa_public_key=@/path/to/public_key.pem" \
HTTP/1.1 201 Created

{
    "consumer_id": "7bce93e1-0a90-489c-c887-d385545f8f4b",
    "created_at": 1442426001000,
    "id": "bcbfb45d-e391-42bf-c2ed-94e32946753a",
    "key": "a36c3049b36249a3c9f8891cb127243c",
    "rsa_public_key": "-----BEGIN PUBLIC KEY----- ..."
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
[https://jwt.io](https://jwt.io), set the right header (RS256), the claims (iss, etc.), and the
associated public key. Then, append the resulting value in the `Authorization` header, for example:

```bash
$ curl http://kong:8000/{route path} \
    -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxM2Q1ODE0NTcyZTc0YTIyYjFhOWEwMDJmMmQxN2MzNyJ9.uNPTnDZXVShFYUSiii78Q-IAfhnc2ExjarZr_WVhGrHHBLweOBJxGJlAKZQEKE4rVd7D6hCtWSkvAAOu7BU34OnlxtQqB8ArGX58xhpIqHtFUkj882JQ9QD6_v2S2Ad-EmEx5402ge71VWEJ0-jyH2WvfxZ_pD90n5AG5rAbYNAIlm2Ew78q4w4GVSivpletUhcv31-U3GROsa7dl8rYMqx6gyo9oIIDcGoMh3bu8su5kQc5SQBFp1CcA5H8sHGfYs-Et5rCU2A6yKbyXtpHrd1Y9oMrZpEfQdgpLae0AfWRf6JutA9SPhst9-5rn4o3cdUmto_TBGqHsFmVyob8VQ'
```

### Generate public/private keys

To create a brand new pair of public/private keys, run the following command:

```bash
$ openssl genrsa -out private.pem 2048
```

This private key must be kept secret. To generate a public key corresponding to the private key, execute:

```bash
$ openssl rsa -in private.pem -outform PEM -pubout -out public.pem
```

If you run the commands above, the public key is written to `public.pem`, whereas the
private key is written to `private.pem`.

### Using the JWT plugin with Auth0

[Auth0](https://auth0.com/) is a popular solution for Authorization, and relies
heavily on JWTs. Auth0 relies on RS256, does not base64 encode, and publicly
hosts the public key certificate used to sign tokens. Account name is referred
to as `{COMPANYNAME}` for the sake of the following examples.

To get started, create a Service and a Route that uses that Service.

_Note: Auth0 does not use base64-encoded secrets._

Create a Service:

```bash
$ curl -i -f -X POST http://localhost:8001/services \
    --data "name=example-service" \
    --data "url=http://httpbin.org"
```

Then create a Route:

```bash
$ curl -i -f -X POST http://localhost:8001/routes \
    --data "service.id={example-service's id}" \
    --data "paths[]=/example_path"
```

#### Add the JWT Plugin

Add the plugin to your Route:

```bash
$ curl -X POST http://localhost:8001/route/{route id}/plugins \
    --data "name=jwt"
```

Download your Auth0 account's X509 Certificate:

```bash
$ curl -o {COMPANYNAME}.pem https://{COMPANYNAME}.{REGION-ID}.auth0.com/pem
```

Extract the public key from the X509 Certificate:

```bash
$ openssl x509 -pubkey -noout -in {COMPANYNAME}.pem > pubkey.pem
```

Create a Consumer with the Auth0 public key:

```bash
$ curl -i -X POST http://kong:8001/consumers \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"

$ curl -i -X POST http://localhost:8001/consumers/{consumer}/jwt \
    -F "algorithm=RS256" \
    -F "rsa_public_key=@./pubkey.pem" \
    -F "key=https://{COMPANYNAME}.auth0.com/" # the `iss` field
```

The JWT plugin by default validates the `key_claim_name` against the `iss`
field in the token. Keys issued by Auth0 have their `iss` field set to
`http://{COMPANYNAME}.auth0.com/`. You can use [jwt.io](https://jwt.io) to
validate the `iss` field for the `key` parameter when creating the
Consumer.

Send requests through. Only tokens signed by Auth0 will work:

```bash
$ curl -i http://localhost:8000 \
    -H "Host:example.com" \
    -H "Authorization:Bearer <TOKEN>"
```

### Upstream Headers

When a JWT is valid and a Consumer has been authenticated, the plugin appends
some headers to the request before proxying it to the Upstream service
so that you can identify the Consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong.
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set).
* `X-Consumer-Username`, the `username` of the Consumer (if set).
* `X-Credential-Identifier`, the identifier of the credential (if set).
* `X-Anonymous-Consumer`, set to `true` when authentication failed, and
   the `anonymous` consumer was set instead.

You can use this information on your side to implement additional logic. You can
use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

### Paginate through the JWTs

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

You can paginate through the JWTs for all Consumers using the following
request:

```bash
$ curl -X GET http://kong:8001/jwts

{
    "total": 3,
    "data": [
        {
            "created_at": 1509593911000,
            "id": "381879e5-04a1-4c8a-9517-f85fbf90c3bc",
            "algorithm": "HS256",
            "key": "UHVwIly5ZxZH7g52E0HRlFkFC09v9yI0",
            "secret": "KMWyDsTTcZgqqyOGgRWTDgZtIyWeEtJh",
            "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
        },
        {
            "created_at": 1511389527000,
            "id": "0dfc969b-02be-42ae-9d98-e04ed1c05850",
            "algorithm": "ES256",
            "key": "vcc1NlsPfK3N6uU03YdNrDZhzmFF4S19",
            "secret": "b65Rs6wvnWPYaCEypNU7FnMOZ4lfMGM7",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        },
        {
            "created_at": 1509593912000,
            "id": "d10c6f3b-71f1-424e-b1db-366abb783460",
            "algorithm": "HS256",
            "key": "SqSNfg9ARmPnpycyJSMAc2uR6nxdmc9S",
            "secret": "CCh6ZIcwDSOIWacqkkWoJ0FWdZ5eTqrx",
            "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
        }
    ]
}
```

You can filter the list by consumer by using this other path:

```bash
$ curl -X GET http://kong:8001/consumers/{username or id}/jwt

{
    "total": 1,
    "data": [
        {
            "created_at": 1511389527000,
            "id": "0dfc969b-02be-42ae-9d98-e04ed1c05850",
            "algorithm": "ES256",
            "key": "vcc1NlsPfK3N6uU03YdNrDZhzmFF4S19",
            "secret": "b65Rs6wvnWPYaCEypNU7FnMOZ4lfMGM7",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }

        }
    ]
}
```

`username or id`: The username or id of the Consumer whose JWTs need to be listed.


### Retrieve the Consumer associated with a JWT

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

Retrieve a [Consumer][consumer-object] associated with a JWT
using the following request:

```bash
curl -X GET http://kong:8001/jwts/{key or id}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`key or id`: The `id` or `key` property of the JWT for which to get the
associated [Consumer][consumer-object].

[api-object]: /gateway-oss/latest/admin-api/#api-object
[configuration]: /gateway-oss/latest/configuration
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object

