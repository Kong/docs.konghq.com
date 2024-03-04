---
title: JWT access token authentication
nav_title: JWT access token
---

## JWT access token auth flow

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

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up JWT access token authentication

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with JWT access token authentication.

### Bearer token in headers

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: bearer authentication. 
For the purposes of the demo, the example also enables the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).
* We only want to search for the bearer token in the headers.

With all of the above in mind, let's test out JWT access token auth with Keycloak. 
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
    - "bearer"
    - "password"
  client_credentials_param_type: 
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

### Bearer token in query string 

You can also specify the bearer token as a query string parameter. 
All parameters are the same as for the 
[bearer token in headers](#bearer-token-in-headers) configuration,
except the `client_credentials_param_type`, which must be set to `query`:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "kong"
  client_auth: "private_key_jwt"
  auth_methods:
    - "bearer"
    - "password"
  client_credentials_param_type: 
    - "query"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the JWT access token authentication

At this point you have created a service, routed traffic to the service, and 
enabled the OpenID Connect plugin on the service. You can now test authentication with a JWT access token.

In this example, the [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) 
lets you obtain a JWT access token, enabling you to test how JWT access token authentication works. 
One way to get a JWT access token is to issue the following call 
(we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
curl --user user:pass http://localhost:8000/openid-connect \
    | jq -r .headers.Authorization
```

Output:
```
Bearer <access-token>
```

You can now use the token in the `Authorization` header or in a query.

### Bearer token in header
Request the service with a bearer token:

```sh
curl -I http://localhost:8000/openid-connect \
    -H "Authorization: \
    '$(curl --user user:pass http://localhost:8000/openid-connect \
    | jq -r .headers.Authorization)'"
```

or:
```sh
curl -I http://localhost:8000/openid-connect -H "Authorization: Bearer <access-token>"
```

### Bearer token in query

Test out the token by accessing the Kong proxy:

```bash
curl http://localhost:8000?access_token=<token>
```
