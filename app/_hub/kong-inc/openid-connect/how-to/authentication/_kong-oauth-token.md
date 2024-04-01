---
title: Kong OAuth token authentication
nav_title: Kong OAuth token
---

## Kong OAuth token auth flow

The OpenID Connect plugin can also verify the tokens issued by [Kong OAuth 2.0 Plugin](/hub/kong-inc/oauth2/).
This is very similar to third party identity provider issued [JWT access token authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
or [introspection authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/):

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
<!--vale on-->

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Prepare Kong OAuth application

1. Create a consumer:
   ```bash
   curl -i -X PUT http://localhost:8001/consumers/jane
   ```

2. Create a {{site.base_gateway}} OAuth application for the consumer:
   ```bash
   curl -i -X PUT http://localhost:8001/consumers/jane/oauth2/client \
     --data "name=demo" \
     --data "client_secret=secret" \
     --data "hash_secret=true"
   ```

3. Create a route:
   ```bash
   curl -i -X PUT http://localhost:8001/routes/mock \
     --data "paths=/mock"
   ```

4. Apply the OAuth plugin to the route:
   ```bash
   curl -i -X POST http://localhost:8001/routes/mock/plugins \
     --data "name=oauth2" \
     --data "config.global_credentials=true" \
     --data "config.enable_client_credentials=true"
   ```

5. Test the token endpoint:
   ```bash
   curl -i -X POST --insecure https://localhost:8443/mock/oauth2/token \
    --data "client_id=client" \
    --data "client_secret=secret" \
    --data "grant_type=client_credentials"
   ```

   You should get an HTTP 200 response with the token in the `access_token` field:
   ```json
   {
       "access_token": "<access-token>",
       "expires_in": 7200,
       "token_type": "bearer"
   }
   ```

## Set up Kong OAuth token authentication

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: Kong OAuth2.
* We only want to search for the bearer token in the headers.

With all of the above in mind, let's test out Kong OAuth2 authentication with Keycloak. 
Enable the OpenID Connect plugin on the `openid-connect` service:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "kong"
  client_auth: "private_key_jwt"
  auth_methods:
    - "kong_oauth2"
  bearer_token_param_type:
    - "header"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the Kong OAuth token authentication

Request the service with a Kong OAuth token:
```bash
curl -I http:localhost:8000 \
  -H "Authorization: \
  \"Bearer $(curl -i -X POST --insecure https://localhost:8443/mock/oauth2/token \
  --data \"client_id=client\" \
  --data \"client_secret=secret" \
  --data \"grant_type=client_credentials\" | \
    jq -r .access_token)\""
```

or
```bash
curl -I http:localhost:8000 \
  -H "Authorization: Bearer <access-token>"
```

You should get an HTTP 200 response.