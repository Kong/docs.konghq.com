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

Using the Keycloak and {{site.base_gateway}} configuration from the [prerequisites](#prerequisites), 
set up an instance of the OpenID Connect plugin with a refresh token grant.

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: you only need the refresh token grant for this flow. 
For the purposes of the demo, the example also enables the
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).
* We want to only search headers for the refresh token.

With all of the above in mind, let's test out the refresh token grant with Keycloak. 
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
    - "refresh_token"
    - "password"
  refresh_token_param_type:
    - "header"
  refresh_token_param_name: "refresh_token"
  upstream_refresh_token_header: "refresh_token"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the refresh token grant

### Get a refresh token

In this example, the [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) 
and the `upstream_refresh_token_header` are enabled for demoing purposes. 
One way to get a refresh token is to issue the following call 
(we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
curl --user <user>:<pass> http://localhost:8000 | jq -r '.headers."Refresh-Token"'
```

You can use the output from the `Refresh-Token` header:
```
<refresh-token>
```

### Access a service with the token

Request the service with a refresh token:

```bash
curl http://localhost:8000 \
 --header "Refresh-Token:$(curl --user <user>:<pass> http://localhost:8000 | \
 jq -r '.headers."Refresh-Token"')"
```

or
```bash
curl http://localhost:8000 \
 --header "Refresh-Token: <refresh-token>"
```

You should get an HTTP 200 response with a refresh token header:

```http
GET / HTTP/1.1
Refresh-Token: <refresh-token>
```