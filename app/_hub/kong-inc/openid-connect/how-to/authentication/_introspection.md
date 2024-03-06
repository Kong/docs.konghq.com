---
title: Introspection authentication
nav_title: Introspection
---

## Introspection authentication flow

As with [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/), 
the introspection authentication relies on a bearer token that the client has already gotten from somewhere. 
The difference to stateless JWT authentication is that the plugin needs to call the introspection endpoint of 
the identity provider to find out whether the token is valid and active. 
This makes it possible to issue opaque tokens to the clients.

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

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up introspection authentication

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with introspection authentication.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: you only need introspection authentication for this flow. 
For the purposes of the demo, the example also enables the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).
* We want to only search headers for the bearer token for introspection.

With all of the above in mind, let's test out the introspection auth flow with Keycloak. 
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
    - "introspection"
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

## Test the introspection authentication

At this point you have created a service, routed traffic to the service, and 
enabled the OpenID Connect plugin on the service. You can now test the introspection auth flow.

1. Check the discovery cache: 

    ```sh
    curl -i -X GET http://localhost:8001/openid-connect/issuers
    ```

    It should contain Keycloak OpenID Connect discovery document and the keys.

2. Request the service with a bearer token:

    ```sh
    curl -I http://localhost:8000/openid-connect \
      -H "Authorization: \
      '$(curl --user <user>:<pass> http://localhost:8000/openid-connect \
      | jq -r .headers.Authorization)'"
    ```

    or:
    ```sh
    curl -I http://localhost:8000/openid-connect -H "Authorization: Bearer <access-token>"
    ```