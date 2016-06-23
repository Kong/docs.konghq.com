---
id: page-plugin
title: Plugins - JWT
header_title: JWT
header_icon: /assets/images/icons/plugins/jwt.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Terminology
      - label: Configuration
  - label: Documentation
    items:
      - label: Create a Consumer
      - label: Create a JWT credential
      - label: Craft a JWT
      - label: Send a request with the JWT
      - label: (Optional) Verified claims
      - label: (Optional) Base64 encoded secret
      - label: Upstream Headers
---

Verify requests containing HS256 or RS256 signed JSON Web Tokens (as specified in [RFC 7519][rfc-jwt]). Each of your Consumers will have JWT credentials (public and secret keys) which must be used to sign their JWTs. A token can then be passed through the Authorization header or in the request's URI and Kong will either proxy the request to your upstream services if the token's signature is verified, or discard the request if not. Kong can also perform verifications on some of the registered claims of RFC 7519 (exp and nbf).

----

## Terminology

- `API`: your upstream service, for which Kong proxies requests to.
- `Plugin`: a plugin executes actions inside Kong during the request/response lifecycle.
- `Consumer`: a developer or service using the API. When using Kong, a Consumer authenticates itself with Kong which proxies every call to the upstream API.
- `Credential`: in the JWT plugin context, a pair of unique values consisting of a public key and a secret, used to sign and verify a JWT, and associated to a Consumer.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST --url http://kong:8001/apis/{api}/plugins \
    --data "name=jwt"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter            | required     | description
---                       | ---          | ---
`name`                    | *required*   | The name of the plugin to use, in this case: `jwt`
`config.uri_param_names`  | *optional*   | A list of querystring parameters that Kong will inspect to retrieve JWTs. Defaults to `jwt`.
`config.claims_to_verify` | *optional*   | A list of registered claims (according to [RFC 7519][rfc-jwt]) that Kong can verify as well. Accepted values: `exp`, `nbf`.
`config.key_claim_name`   | *optional*   | The name of the claim in which the `key` identifying the secret **must** be passed. Defaults to `iss`.
`config.secret_is_base64` | *optional*   | If true, the plugin assumes the credential's `secret` to be base64 encoded. You will need to create a base64 encoded secret for your consumer, and sign your JWT with the original secret. Defaults to `false`.

----

## Documentation

In order to use the plugin, you first need to create a Consumer and associate one or more credentials to it. The Consumer represents a developer using the final service/API, and a JWT credential holds the public and private keys used to verify a crafted token.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object. The Consumer is an entity consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
$ curl --url http://kong:8001/consumers \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created
```

form parameter | required        | description
---            | ---             | ---
`username`     | *semi-optional* | The username for this Consumer. Either this field or `custom_id` must be specified.
`custom_id`    | *semi-optional* | A custom identifier used to map the Consumer to an external database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many JWT credentials.

### Create a JWT credential

You can provision a new HS256 JWT credential by issuing the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/jwt
HTTP/1.1 201 Created

{
    "consumer_id": "7bce93e1-0a90-489c-c887-d385545f8f4b",
    "created_at": 1442426001000,
    "id": "bcbfb45d-e391-42bf-c2ed-94e32946753a",
    "key": "a36c3049b36249a3c9f8891cb127243c",
    "secret": "e71829c351aa4242c2719cbfbe671c09"
}
```

`consumer`: The `id` or `username` property of the [consumer][consumer-object] entity to associate the credentials to.

form parameter   | required        | description
---              | ---             | ---
`key`            | *optional*      | A unique string identifying the credential. If left out, it will be auto-generated. However, usage of this key is **mandatory** while crafting your token, as specified in the next section.
`algorithm`      | *optional*      | The algorithm used to verify the token's signature. Can be `HS256` or `RS256`. Defaults to `HS256`.
`rsa_public_key` | *optional*      | If `algorithm` is `RS256`, the public key (in PEM format) to use to verify the token's signature.
`secret`         | *optional*      | If `algorithm` is `HS256`, the secret used to sign JWTs for this credential. If left out, will be auto-generated.

### Craft a JWT

Now that your Consumer has a credential, and assuming we want to sign it using `HS256`, the JWT should be crafted as follows (according to [RFC 7519][rfc-jwt]):

First, the header must be:

```json
{
    "typ": "JWT",
    "alg": "HS256"
}
```

Secondly, the claims **must** contain the secret's `key` in the configured claim (from `config.key_claim_name`). That claim is `iss` (issuer field field) by default. Set its value to our previously created credential's `key`. The claims may contain other values.

```json
{
    "iss": "a36c3049b36249a3c9f8891cb127243c"
}
```

Since the `secret` associated with this `key` is `e71829c351aa4242c2719cbfbe671c09`, the final JWT is:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

### Send a request with the JWT

The JWT can now be included in a request to Kong by adding it to the `Authorization` header:

```bash
$ curl --url http://kong:8000/{api path} \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4'
```

Or as a querystring parameter, if configured in `config.uri_param_names` (which contains `jwt` by default):

```bash
$ curl http://kong:8000/{api path}?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

The request will be inspected by Kong, whose behavior depends on the validity of the JWT:

request                        | proxied to upstream API  | response status code
--------                       |--------------------------|---------------------
has no JWT                     | no                       | 401
missing or invalid `iss` claim | no                       | 401
invalid signature              | no                       | 403
valid signature                | yes                      | from the upstream service
valid signature, invalid verified claim (**option**) | no                       | 403

<div class="alert alert-warning">
  <strong>Note:</strong> When the JWT is valid and proxied to the API, Kong makes no modification to the request other than adding headers identifying the Consumer. It is the role of your service to now base64 decode the JWT claims, since it is considered valid.
</div>

### (**Optional**) Verified claims

Kong can also perform verification on registered claims, as defined in [RFC 7519][rfc-jwt]. To perform verification on a claim, add it to the `config.claims_to_verify` property:

```bash
# This adds verification for both nbf and exp claims:
$ curl -X PATCH --url http://kong:8001/apis/{api}/plugins/{jwt plugin id} \
    --data "config.claims_to_verify=exp,nbf"
```

Supported claims:

claim name | verification
-----------|-------------
`exp`      | identifies the expiration time on or after which the JWT must not be accepted for processing.
`nbf`      | identifies the time before which the JWT must not be accepted for processing.

### (**Optional**) Base64 encoded secret

If your secret contains binary data (such as secrets provided by services like Auth0), you can store them as base64 encoded in Kong. Enable this option in the plugin's configuration:

```bash
$ curl -X PATCH --url http://kong:8001/apis/{api}/plugins/{jwt plugin id} \
    --data "config.secret_is_base64=true"
```

Then, base64 encode your consumers' secrets:

```bash
# secret is: "blob data"
$ curl -X POST --url http://kong:8001/consumers/{consumer}/jwt \
  --data "secret=YmxvYiBkYXRh"
```

And sign your JWT using the original secret ("blob data").

### Upstream Headers

When a JWT is valid, a consumer has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/service, so that you can identify the consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the consumer.

[rfc-jwt]: https://tools.ietf.org/html/rfc7519
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
