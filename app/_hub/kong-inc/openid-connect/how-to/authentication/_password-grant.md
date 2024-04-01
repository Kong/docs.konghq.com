---
title: Password grant
nav_title: Password grant
---

## Password grant workflow

Password grant is a **legacy** authentication grant. This is a less secure way of
authenticating end users than the authorization code flow, because, for example,
the passwords are shared with third parties. The image below illustrates the grant:

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
    kong->>kong: load <br>basic authentication<br>credentials
    activate idp
    kong->>idp: keycloak/token with<br>client credentials and<br>password grant
    deactivate kong
    idp->>idp: authenticate client and<br>verify password grant
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

## Set up password grant auth

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with the password grant.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: you only need the password grant for this flow. 
* We want to only search headers for credentials for the password grant.

With all of the above in mind, let's test out the password grant with Keycloak. 
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
    - "password"
  password_param_type: 
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

## Test the password grant

At this point you have created a service, routed traffic to the service, and 
enabled the OpenID Connect plugin on the service. You can now test the password grant.

Request the service with basic authentication credentials created in the [Keycloak configuration](#prerequisites) step:

```bash
curl --user john:doe http://localhost:8000
```

You should get an HTTP 200 response with a basic auth header:

```http
GET / HTTP/1.1
Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
```

If you make another request using the same credentials, you should see that Kong adds less
latency to the request as it has cached the token endpoint call to Keycloak.
