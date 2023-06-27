Validate access tokens sent by developers using a third-party OAuth 2.0
Authorization Server by leveraging its introspection endpoint
([RFC 7662](https://tools.ietf.org/html/rfc7662)). This plugin assumes that
the consumer already has an access token that will be validated against a
third-party OAuth 2.0 server.

{:.note}
> **Note**: The [OpenID Connect Plugin](/hub/kong-inc/openid-connect/) supports
OAuth 2.0 Token Introspection as well and offers functionality beyond
this plugin, such as restricting access by scope.

## Flow

![OAuth2 Introspection Flow](/assets/images/docs/oauth2/oauth2-introspection.png)

## Associate the response to a consumer

To associate the introspection response resolution to a Kong consumer, provision a Kong consumer with the same `username` returned by the Introspection Endpoint response.

## Upstream headers

When a client has been authenticated, the plugin appends the following headers to the request before proxying it to the upstream API/microservice.
Use these headers to identify the consumer in your code:

- `X-Consumer-ID`, the ID of the consumer on Kong (if matched)
- `X-Consumer-Custom-ID`, the `custom_id` of the consumer (if matched and if existing)
- `X-Consumer-Username`, the `username of` the consumer (if matched and if existing)
- `X-Anonymous-Consumer`, set to true if authentication fails, and the `anonymous` consumer is set instead.
- `X-Credential-Scope`, as returned by the Introspection response (if any)
- `X-Credential-Client-ID`, as returned by the Introspection response (if any)
- `X-Credential-Identifier`, as returned by the Introspection response (if any)
- `X-Credential-Token-Type`, as returned by the Introspection response (if any)
- `X-Credential-Exp`, as returned by the Introspection response (if any)
- `X-Credential-Iat`, as returned by the Introspection response (if any)
- `X-Credential-Nbf`, as returned by the Introspection response (if any)
- `X-Credential-Sub`, as returned by the Introspection response (if any)
- `X-Credential-Aud`, as returned by the Introspection response (if any)
- `X-Credential-Iss`, as returned by the Introspection response (if any)
- `X-Credential-Jti`, as returned by the Introspection response (if any)

Additionally, any claims specified in `config.custom_claims_forward` are also forwarded with the `X-Credential-` prefix.

{:.note}
> **Note:** If authentication fails, the plugin doesn't set any `X-Credential-*` headers.
It appends `X-Anonymous-Consumer: true` and sets the `anonymous` consumer instead.

