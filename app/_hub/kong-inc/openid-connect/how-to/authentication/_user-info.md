---
title: User info authentication
nav_title: User info
---

## User info auth flow

The user info authentication uses OpenID Connect standard user info endpoint to verify the access token.
In most cases it is preferable to use [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
as that is meant for retrieving information from the token itself, whereas the user info endpoint is
meant for retrieving information about the user for whom the token was given. The sequence
diagram below looks almost identical to introspection authentication:

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
    client->>kong: service with<br>access token
    deactivate client
    kong->>kong: load access token
    activate idp
    kong->>idp: keycloak/userinfo<br>with client credentials<br>and access token
    deactivate kong
    idp->>idp: authenticate client and<br>verify token
    activate kong
    idp->>kong: return user info <br>response
    deactivate idp
    kong->>kong: verify response<br>status code (200)
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

## Set up user info authentication

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with user info authentication.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: you only need user info auth for this flow. 
For the purposes of the demo, the example also enables the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).
* We want to only search the bearer token headers for the user info.

With all of the above in mind, let's test out user info authentication with Keycloak. 
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
    - "userinfo"
    - "password"
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

## Test the user info authentication

Request the service with a bearer token:

```sh
curl -I http://localhost:8000/openid-connect \
  -H "Authorization: \
  \"$(curl --user john:doe http://localhost:8000/openid-connect \
  | jq -r .headers.Authorization)\""
```

You should get an HTTP 200 response with a bearer token header:

```http
GET / HTTP/1.1
Authorization: Bearer <access-token>
```