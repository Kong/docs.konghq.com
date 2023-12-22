---
nav_title: Overview
---

The JWT plugin lets you verify requests containing HS256 or RS256 signed JSON Web Tokens, 
as specified in [RFC 7519](https://tools.ietf.org/html/rfc7519).

When you enable this plugin, it grants JWT credentials (public and secret keys) 
to each of your consumers, which must be used to sign their JWTs.
You can then pass a token through any of the following:

- A query string parameter
- A cookie
- HTTP request headers

Kong will either proxy the request to your upstream services if the token's
signature is verified, or discard the request if not. Kong can also perform
verifications on some of the registered claims of RFC 7519 (`exp` and `nbf`).
If Kong finds multiple tokens that differ - even if they are valid - the request
will be rejected to prevent JWT smuggling.

### (Optional) Verified claims

Kong can also perform verification on registered claims, as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519). To perform verification on a claim, add it to the `config.claims_to_verify` property:

You can patch an existing JWT plugin:

```bash
# This adds verification for both nbf and exp claims:
curl -X PATCH http://localhost:8001/plugins/{jwt plugin id} \
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
curl -X PATCH http://localhost:8001/routes/<route-id>/plugins/<jwt-plugin-id> \
  --data "config.secret_is_base64=true"
```

Then, base64 encode your Consumers' secrets:

```bash
# secret is: "blob data"
curl -X POST http://localhost:8001/consumers/<consumer>/jwt \
  --data "secret=YmxvYiBkYXRh"
```

And sign your JWT using the original secret ("blob data").

### Generate public/private keys

To create a brand new pair of public/private keys, run the following command:

```bash
openssl genrsa -out private.pem 2048
```

This private key must be kept secret. To generate a public key corresponding to the private key, execute:

```bash
openssl rsa -in private.pem -outform PEM -pubout -out public.pem
```

If you run the commands above, the public key is written to `public.pem`, whereas the
private key is written to `private.pem`.

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

## Get started with the JWT plugin

* [Configuration reference](/hub/kong-inc/jwt/configuration/)
* [Basic configuration example](/hub/kong-inc/jwt/how-to/basic-example/)
* [Configure the JWT plugin](/hub/kong-inc/jwt/how-to/setup/)
* [Use the JWT plugin with Auth0](/hub/kong-inc/jwt/how-to/auth0/)
* [Paginate through the JWTs](/hub/kong-inc/jwt/how-to/paginate/)
* [Retrieve the Consumer associated with a JWT](/hub/kong-inc/jwt/how-to/retrieve-consumer/)

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
