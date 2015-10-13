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
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Create a Consumer
      - label: Create a JWT credential
      - label: Craft a JWT
      - label: Send the JWT
      - label: Verified claims
      - label: Upstream Headers
---

Verify HMAC SHA-256 signed JSON Web Tokens (as specified in RFC 7519) and proxy them to your upstream services if they validate. Each of your Consumers will have a couple of public and secret keys provided by Kong and used to sign their JWTs. A token can then be passed through the Authorization header or in the request's URL and Kong will either proxy the request to your upstream services if the token's signature is verified, or discard the request if not. Kong can also perform verifications on some of the registered claims of RFC 7519 (exp and nbf).

----

## Terminology

- `api`: your upstream service placed behind Kong, for which Kong proxies requests to.
- `plugin`: a plugin executing actions inside Kong before or after a request has been proxied to the upstream API.
- `consumer`: a developer or service using the api. When using Kong, a consumer only communicates with Kong which proxies every call to the said, upstream api.
- `credential`: in the JWT plugin context, a pair of unique values consisting of a public key and a secret, used to sign and verify a JWT, and associated to a consumer.

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - jwt
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=jwt"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter               | description
---                          | ---
`name`                       | The name of the plugin to use, in this case: `jwt`
`config.uri_param_names`<br>*optional*     | Default `jwt`. A list of querystring parameters that Kong will inspect to retrieve potential JWTs.
`config.claims_to_verify`<br>*optional*    | Default `none`. A list of registered claims (according to [RFC 7519][rfc-jwt]) that Kong can verify as well. Accepted values: `exp`, `nbf`.

----

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to it. The consumer represents a developer using the final service/API.

### Create a Consumer

You need to associate a credential to an existing [consumer][consumer-object] object, that represents a user consuming the API. To create a [consumer][consumer-object] you can execute the following request:

```bash
$ curl http://kong:8001/consumers \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created
```

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [consumer][consumer-object] can have many credentials.

### Create a JWT credential

You can provision a new credential by making the following HTTP request:

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

form parameter           | description
---                      | ---
`key`<br>*optional*      | A unique string identifying the credential. If left out, will be auto-generated.
`secret`<br>*optional*   | A unique string used to sign JWTs for this consumer. If left out, will be auto-generated.

<div class="alert alert-warning">
  <strong>Note:</strong> It is recommended to let Kong auto-generate those values. Only specify them yourself if you are migrating an existing system to Kong, and must re-use your key/secret credentials to make the migration to Kong transparent to your consumers.
</div>

### Craft a JWT

Now that your consumer has a credential, his or her JWT should be crafted as follows (according to [RFC 7519][rfc-jwt]):

First, the header must be:

```json
{
    "typ": "JWT",
    "alg": "HS256"
}
```

Secondly, the claims **must** contain the `iss` (issuer) field, set to the value of our previously created credential's `key`. The claims may contain any other values.

```json
{
    "iss": "a36c3049b36249a3c9f8891cb127243c"
}
```

Since the `secret` associated with this `key` is `e71829c351aa4242c2719cbfbe671c09`, the final JWT is:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

### Send the JWT

The JWT can be sent to Kong in the `Authorization` header:

```bash
$ curl http://kong:8000/{api path} \
    -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4'
```

Or as a querystring parameter, if configured in `config.uri_param_names` (which contains `jwt` by default):

```bash
$ curl http://kong:8000/{api path}?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4
```

The request will be inspected by Kong, which will take various actions depending on the validity of the JWT:

request                        | proxied to upstream API  | response status code
--------                       |--------------------------|---------------------
has no JWT                     | no                       | 401
missing or invalid `iss` claim | no                       | 401
invalid signature              | no                       | 403
valid signature                | yes                      | from the upstream service
valid signature, invalid verified claim (**option**) | no                       | 403

<div class="alert alert-warning">
  <strong>Note:</strong> When the JWT is valid and proxied to the API, Kong makes no modification to the request other than adding headers identifying the consumer. It is the role of your service to now decode the JWT, since it is considered valid.
</div>

### (**Option**) Verified claims

Kong can also perform verification on registered claims, as defined in [RFC 7519][rfc-jwt]. To perform verification on a claim, add it to the `config.claims_to_verify` property:

```bash
# This adds verification for both nbf and exp claims:
$ curl -X PATCH http://kong:8001/apis/{api}/plugins/{jwt plugin id} \
    --data "config.claims_to_verify=exp,nbf"
```

Supported claims:

claim name | verification
-----------|-------------
`exp`      | identifies the expiration time on or after which the JWT must not be accepted for processing.
`nbf`      | identifies the time before which the JWT must not be accepted for processing.

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
