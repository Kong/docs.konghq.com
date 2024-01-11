---
title: Kong OAuth token authentication
nav_title: Kong OAuth token
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Kong OAuth token authentication

The OpenID Connect plugin can also verify the tokens issued by [Kong OAuth 2.0 Plugin](/hub/kong-inc/oauth2/).
This is very similar to third party identity provider issued [JWT access token authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
or [introspection authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/):

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
    kong->>kong: verify kong<br>oauth token
    activate httpbin
    kong->>httpbin: request with<br>access token
    httpbin->>kong: response
    deactivate httpbin
    activate client
    kong->>client: response
    deactivate kong
    deactivate client
{% endmermaid %}

### Prepare Kong OAuth application

1. Create a Consumer:
   ```bash
   http -f put :8001/consumers/jane
   ```
2. Create Kong OAuth Application for the consumer:
   ```bash
   http -f put :8001/consumers/jane/oauth2/client \
     name=demo                                    \
     client_secret=secret                         \
     hash_secret=true
   ```
3. Create a Route:
   ```bash
   http -f put :8001/routes/auth paths=/auth
   ```
4. Apply OAuth plugin to the Route:
   ```bash
   http -f put :8001/plugins/7cdeaa2d-5faf-416d-8df5-533d1e4cd2c4 \
     name=oauth2                                                  \
     route.name=auth                                              \
     config.global_credentials=true                               \
     config.enable_client_credentials=true
   ```
5. Test the token endpoint:
   ```bash
   https -f --verify no post :8443/auth/oauth2/token \
     client_id=client                                \
     client_secret=secret                            \
     grant_type=client_credentials
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "access_token": "<access-token>",
       "expires_in": 7200,
       "token_type": "bearer"
   }
   ```

At this point we should be able to retrieve a new access token with:

```bash
https -f --verify no post :8443/auth/oauth2/token \
  client_id=client                                \
  client_secret=secret                            \
  grant_type=client_credentials |                 \
  jq -r .access_token
```
Output:
```
<access-token>
```

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the Kong OAuth authentication.
2. We want to search the bearer token for the Kong OAuth authentication from the headers only.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=kong_oauth2                                \
  config.bearer_token_param_type=header
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
        "auth_methods": [ "kong_oauth2" ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

### Test the Kong OAuth token authentication

Request the service with a Kong OAuth token:

```bash
http -v :8000 Authorization:"Bearer $(https -f --verify no \
    post :8443/auth/oauth2/token                             \
    client_id=client                                         \
    client_secret=secret                                     \
    grant_type=client_credentials |                          \
    jq -r .access_token)"
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
        "Authorization": "Bearer <access-token>",
        "X-Consumer-Id": "<consumer-id>",
        "X-Consumer-Username": "jane"
    },
    "method": "GET"
}
```
