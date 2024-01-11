---
title: JWT access token authentication
nav_title: JWT access token
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## JWT access token authentication

For legacy reasons, the stateless `JWT Access Token` authentication is named `bearer` with the Kong
OpenID Connect plugin (see: `config.auth_methods`). Stateless authentication basically means
the signature verification using the identity provider published public keys and the standard
claims' verification (such as `exp` (or expiry)). The client may have received the token directly
from the identity provider or by other means. It is simple:

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant httpbin as Upstream <br>(backend service,<br> e.g. httpbin)
    activate client
    activate kong
    client->>kong: service with<br>access token
    deactivate client
    kong->>kong: load access token
    kong->>kong: verify signature
    kong->>kong: verify claims
    activate httpbin
    kong->>httpbin: request with<br>access token
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

1. We want to only use the bearer authentication, but we also enable the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) for demoing purposes.
2. We want to search the bearer token for the bearer authentication from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=bearer                                     \
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
            "bearer",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

The [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) is enabled so that we can get a JWT access token that we can use
to show how the JWT access token authentication works. That is: we need a token. One way to get a JWT access token
is to issue the following call (we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
http -a john:doe :8000 | jq -r .headers.Authorization
```
Output:
```
Bearer <access-token>
```

We can use the output in `Authorization` header.

### Test the JWT access token authentication

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

### Test the JWT Access Token Authentication with access token in query string 

To specify the bearer token as a query string parameter:

```bash
curl -i -X PATCH http://localhost:8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9  \
  --data "config.bearer_token_param_type=query"                 \
  --data "config.auth_methods=bearer"                           \
  --data "config.auth_methods=password" # only enabled for demoing purposes
```

Test out the token by accessing the Kong proxy:

```bash
curl http://localhost:8000?access_token=<token>
```