---
title: Client credentials grant
nav_title: Client credentials grant
---

## Client credentials grant workflow

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

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Set up the client credential grant

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with the client credentials grant.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: client credentials grant.
* We want to search credentials for client credentials from the headers only.

With all of the above in mind, let's test out the client credentials grant with Keycloak. 
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
    - "client_credentials"
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

## Test the client credentials grant

At this point you have created a service, routed traffic to the service, and 
enabled the OpenID Connect plugin on the service. You can now test the client credentials grant.

1. Check the discovery cache: 

    ```sh
    curl -i -X GET http://localhost:8001/openid-connect/issuers
    ```

    It should contain Keycloak OpenID Connect discovery document and the keys.

2. Request the service using the client credentials created in the [Keycloak configuration](#prerequisites) step:

    ```sh
    curl http://localhost:8000/openid-connect --user service:cf4c655a-0622-4ce6-a0de-d3353ef0b714
    ```

If you make another request using the same credentials, you should see that Kong adds less
latency to the request as it has cached the token endpoint call to Keycloak.