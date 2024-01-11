---
title: Client credentials grant
nav_title: Client credentials grant
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Client credentials grant

The client credentials grant is very similar to [the password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).
The most important difference in the Kong OpenID Connect plugin is that the plugin itself
does not try to authenticate. It just forwards the credentials passed by the client
to the identity server's token endpoint. The client credentials grant is visualized
below:

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
    client->>kong: service with<br>basic authentication
    deactivate client
    kong->>kong: load basic<br>authentication credentials
    activate idp
    kong->>idp: keycloak/token<br>with client credentials
    deactivate kong
    idp->>idp: authenticate client
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

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the client credentials grant.
2. We want to search credentials for client credentials from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=client_credentials                         \
  config.client_credentials_param_type=header
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
        "auth_methods": [ "client_credentials" ],
        "client_credentials_param_type": [ "header" ]
    }
}
```

### Test the client credentials grant

Request the service with client credentials created in the [Keycloak configuration](#prerequisites) step:

```bash
http -v -a service:cf4c655a-0622-4ce6-a0de-d3353ef0b714 :8000
```
```http
GET / HTTP/1.1
Authorization: Basic c2VydmljZTpjZjRjNjU1YS0wNjIyLTRjZTYtYTBkZS1kMzM1M2VmMGI3MTQ=
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