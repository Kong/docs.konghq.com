---
title: Password grant
nav_title: Password grant
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Password grant

Password grant is a legacy authentication grant. This is a less secure way of
authenticating end users than the authorization code flow, because, for example,
the passwords are shared with third parties. The image below illustrates the grant:

<img src="/assets/images/docs/openid-connect/password-grant.svg">

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the password grant.
2. We want to search credentials for password grant from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.password_param_type=header
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
        "password_param_type": [ "header" ]
    }
}
```

### Test the password grant

Request the service with basic authentication credentials created in the [Keycloak configuration](#prerequisites) step:

```bash
http -v -a john:doe :8000
```
```http
GET / HTTP/1.1
Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
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

If you make another request using the same credentials, you should see that Kong adds less
latency to the request as it has cached the token endpoint call to Keycloak.
