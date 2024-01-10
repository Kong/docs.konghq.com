---
title: Headers
nav_title: Headers
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Headers

The OpenID Connect plugin can pass claim values, tokens, JWKs, and the session identifier to the upstream service
in request headers, and to the downstream client in response headers. By default, the plugin passes an access token
in `Authorization: Bearer <access-token>` header to the upstream service (this can be controlled with
`config.upstream_access_token_header`). The claim values can be taken from:
- an access token,
- an id token,
- an introspection response, or
- a user info response

Let's take a look for an access token payload:

```json
{
   "exp": 1622556713,
   "aud": "account",
   "typ": "Bearer",
   "scope": "openid email profile",
   "preferred_username": "john",
   "given_name": "John",
   "family_name": "Doe"
}
```

To pass the `preferred_username` claim's value `john` to the upstream with an `Authenticated-User` header,
we need to patch our plugin:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.upstream_headers_claims=preferred_username              \
  config.upstream_headers_names=authenticated_user
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "auth_methods": [ "password" ],
        "upstream_headers_claims": [ "preferred_username" ],
        "upstream_headers_names": [ "authenticated_user" ]
    }
}
```

Let's see if it had any effect:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>",
        "Authenticated-User": "john"
    },
    "method": "GET"
}
```

See the [configuration parameters](#parameters) for other options.