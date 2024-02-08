---
title: Refresh token grant
nav_title: Refresh token grant
---

## Refresh token grant workflow

The refresh token grant can be used when the client has a refresh token available. There is a caveat
with this: identity providers in general only allow refresh token grant to be executed with the same
client that originally got the refresh token, and if there is a mismatch, it may not work. The mismatch
is likely when Kong OpenID Connect is configured to use one client, and the refresh token is retrieved
with another. The grant itself is very similar to the [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) and
the [client credentials grant](/hub/kong-inc/openid-connect/how-to/authentication/client-credentials/):

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
    client->>kong: service with<br>refresh token
    deactivate client
    kong->>kong: load refresh token
    activate idp
    kong->>idp: keycloak/token with<br>client credentials and<br>refresh token
    deactivate kong
    idp->>idp: authenticate client and<br>verify refresh token
    activate kong
    idp->>kong: return tokens
    deactivate idp
    kong->>kong: verify tokens
    activate httpbin
    kong->>httpbin: request with access token
    httpbin->>kong: response
    deactivate httpbin
    activate client
    kong->>client: response
    deactivate kong
    deactivate client
{% endmermaid %}
<!--vale on-->

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up the refresh token grant

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the refresh token grant, but we also enable 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) for demoing purposes.
2. We want to search the refresh token for the refresh token grant from the headers only.
3. We want to pass refresh token from the client in `Refresh-Token` header.
4. We want to pass refresh token to upstream in `Refresh-Token` header.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.refresh_token_param_name=refresh_token                  \
  config.refresh_token_param_type=header                         \
  config.auth_methods=refresh_token                              \
  config.auth_methods=password                                   \
  config.upstream_refresh_token_header=refresh_token
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
            "refresh_token",
            "password"
        ],
        "refresh_token_param_name": "refresh_token",
        "refresh_token_param_type": [ "header" ],
        "upstream_refresh_token_header": "refresh_token"
    }
}
```

The `config.auth_methods` and `config.upstream_refresh_token_header`
are only enabled for demoing purposes so that we can get a refresh token with:

```bash
http -a john:doe :8000 | jq -r '.headers."Refresh-Token"'
```
Output:
```
<refresh-token>
```

We can use the output in `Refresh-Token` header.

### Test the refresh token grant

Request the service with a bearer token:

```bash
http -v :8000 Refresh-Token:$(http -a john:doe :8000 | \
    jq -r '.headers."Refresh-Token"')
```
or
```bash
http -v :8000 Refresh-Token:"<refresh-token>"
```
```http
GET / HTTP/1.1
Refresh-Token: <refresh-token>
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>",
        "Refresh-Token": "<refresh-token>"
    },
    "method": "GET"
}
```
