---
title: User info authentication
nav_title: User info
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## User info authentication

The user info authentication uses OpenID Connect standard user info endpoint to verify the access token.
In most cases it is preferable to use [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
as that is meant for retrieving information from the token itself, whereas the user info endpoint is
meant for retrieving information about the user for whom the token was given. The sequence
diagram below looks almost identical to introspection authentication:

<img src="/assets/images/docs/openid-connect/userinfo-authentication.svg">

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the user info authentication, but we also enable the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) for demoing purposes.
2. We want to search the bearer token for the user info from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=userinfo                                   \
  config.auth_methods=password # only enabled for demoing purposes
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
        "auth_methods": [
            "userinfo",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

### Test the user info authentication

Request the service with a bearer token:

```bash
http -v :8000 Authorization:"$(http -a john:doe :8000 | \
    jq -r .headers.Authorization)"
```
or
```bash
http -v :8000 Authorization:"Bearer <access-token>"
```
```http
GET / HTTP/1.1
Authorization: Bearer <access-token>
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>"
    },
    "method": "GET"
}
```