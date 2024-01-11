---
title: Introspection authentication
nav_title: Introspection
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Introspection authentication

As with [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)), the introspection authentication
relies on a bearer token that the client has already gotten from somewhere. The difference to stateless
JWT authentication is that the plugin needs to call the introspection endpoint of the identity provider
to find out whether the token is valid and active. This makes it possible to issue opaque tokens to
the clients.

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant idp as IDP <br>(e.g. Keycloak)
    participant httpbin as Upstream <br>(backend service,<br> e.g. httpbin)
    activate client
    activate kong
    client->>kong: service with access token
    deactivate client
    kong->>kong: load access token
    activate idp
    kong->>idp: keycloak/introspect with <br/>client credentials and access token
    deactivate kong
    idp->>idp: authenticate client <br/>and introspect access token
    activate kong
    idp->>kong: return introspection response
    deactivate idp
    kong->>kong: verify introspection response
    activate httpbin
    kong->>httpbin: request with <br/>access token
    httpbin->>kong: response
    deactivate httpbin
    activate client
    kong->>client: response
    deactivate kong
    deactivate client
{% endmermaid %}
<!--vale on-->

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the introspection authentication, but we also enable the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) for demoing purposes.
2. We want to search the bearer token for the introspection from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=introspection                              \
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
            "introspection",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

### Test the introspection authentication

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
