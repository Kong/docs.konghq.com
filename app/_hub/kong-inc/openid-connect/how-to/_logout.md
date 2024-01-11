---
title: Logout
nav_title: Logout
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Logout

The logout functionality is mostly useful together with the [session authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)
that is mostly useful with the [authorization code flow](/hub/kong-inc/openid-connect/how-to/authentication/authorization-code-flow/).

As part of the logout, the OpenID Connect plugin implements several features:

- session invalidation
- token revocation
- relying party (RP) initiated logout

Let's patch the OpenID Connect plugin to provide the logout functionality:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password                                   \
  config.logout_uri_suffix=/logout                               \
  config.logout_methods=POST                                     \
  config.logout_revoke=true
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
        "auth_methods": [ "password", "session" ],
        "logout_uri_suffix": "/logout",
        "logout_methods": [ "POST" ],
        "logout_revoke": true
    }
}
```

Login and establish a session:

```bash
http -a john:doe --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Test that session authentication works:

```bash
http --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Logout, and follow the redirect:

```bash
http --session=john --follow -a john: post :8000/logout
```
```http
HTTP/1.1 200 OK
```

We needed to pass `-a john:` as there seems to be a feature with `HTTPie`
that makes it to store the original basic authentication credentials in
a session - not just the session cookies.

At this point the client has logged out from both Kong and the identity provider (Keycloak).

Check that the session is really gone:

```bash
http --session=john :8000
```
```http
HTTP/1.1 401 Unauthorized
```