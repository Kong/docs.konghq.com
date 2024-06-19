---
title: Demonstrating Proof-of-Possession
nav_title: Demonstrating Proof-of-Possession
minimum_version: 3.7.x
---

## Overview

Demonstrating Proof-of-Possession (DPoP) is an alternative technique to the 
[Mutual TLS certificate-bound access tokens](/hub/kong-inc/openid-connect/how-to/client-authentication/mtls/). 
Unlike its alternative, which binds the token to the mTLS client certificate, it binds the token to a JSON Web Key (JWK) provided by the client.

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant upstream as Upstream <br>(backend service,<br> e.g. httpbin)
    participant idp as Authentication Server <br>(e.g. Keycloak)
    activate client
    client->>client: generate key pair
    client->>idp: POST /oauth2/token<br>DPoP:$PROOF
    deactivate client
    activate idp
    idp-->>client: DPoP bound access token ($AT)
    activate client
    deactivate idp
    client->>kong: GET https://example.com/resource<br>Authorization: DPoP $AT<br>DPoP: $PROOF
    activate kong
    deactivate client
    kong->>kong: validate $AT and $PROOF
    kong->>upstream: proxied request <br> GET https://example.com/resource<br>Authorization: Berear $AT
    deactivate kong
    activate upstream
    upstream-->>kong: upstream response
    deactivate upstream
    activate kong
    kong-->>client: response
    deactivate kong
{% endmermaid %}
<!--vale on-->

You can use the Demonstrating Proof-of-Possession option without Mutual TLS, and even with plain HTTP, although HTTPS is recommended for enhanced security.

When verification of the DPoP proof is enabled, Kong removes the `DPoP` header and changes the token type from `dpop` to `bearer`.
This effectively downgrades the request to use a conventional bearer token.
This allows an OAuth2 upstream without DPoP support to work with the DPoP token without losing the protection of the key-binding mechanism.

It's a prerequisite that the auth server is configured to enable the DPoP for you to enable it with Kong.

If you are setting up Demonstrating Proof-of-Possession in Keycloak, refer to the [Keycloak configuration](#prerequisites) section in the prerequisites.
For other authentication servers, please consult their specific documentation to configure this functionality.

Many instructions in the other how-to guides for OpenID Connect support validation of access tokens using Demonstrating Proof-of-Possession.
Enabling the [`proof_of_possession_dpop`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_dpop) configuration option in the plugin helps to ensure that the supplied access token
is bound to the client by verifying its association with the JWT provided in the request.

DPoP is compatible with the following authentication methods:

- [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
- [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
- [Session Authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)

   Session Authentication is only compatible with DPoP when used along with one of the other supported authentication methods:

    * If multiple `openid-connect` plugins are configured with the `session` authentication method, we strongly recommend configuring different values of [`session_secret`](/hub/kong-inc/openid-connect/configuration/#config-session_secret) across plugin instances for additional security. This avoids sessions being shared across plugins and possibly bypassing the proof of possession validation.

The following example shows how to enable this feature for the JWT Access Token Authentication method. Similar steps can be followed for the other methods.

## Demo
### Prerequisites

Follow these prerequisites to set up a demo Keycloak app and a Kong service and route for testing mTLS client auth.

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

### Set up Demonstrating Proof-of-Possession with the OIDC plugin

To enable Demonstrating Proof-of-Possession, use the [`proof_of_possession_dpop`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_dpop) configuration option,
and set the service name to `openid-connect` to follow the demo:

<!-- vale off -->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8440/auth/realms/master"
  client_id: "cert_bound"
  client_secret: "cf4c655a-0622-4ce6-a0de-d3353ef0b714"
  auth_methods:
    - "bearer"
  proof_of_possession_dpop: "strict"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!-- vale on -->

If configured correctly, it returns a `200` response like this:


```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "issuer": "https://keycloak.test:8440/auth/realms/master",
        "client_id": [ "cert-bound" ],
        "client_secret": [ "cf4c655a-0622-4ce6-a0de-d3353ef0b714" ],
        "auth_methods": [ "bearer" ],
        "proof_of_possession_dpop": "strict",
    }
}
```

### Test Demonstrating Proof-of-Possession

Obtain the token from the IdP. A DPoP supporting client is required. For this demo, here is an example using [`oauth2c`](https://github.com/cloudentity/oauth2c.git):

```bash
oauth2c https://keycloak.test:8440/realms/master/.well-known/openid-configuration \
--client-id cert-bound --client-secret cf4c655a-0622-4ce6-a0de-d3353ef0b714       \
--grant-type client_credentials --scopes openid --dpop                            \
--signing-key https://path/to/the_jwks.json
```

If this is configured correctly, it returns a `200` response and something like the following:
```json
{
    "access_token": "eyJhbG...",
    "token_type":"DPoP"
}
```

The token you obtain should include a claim that consists of the hash of the client key:
```json
{
    "exp": 1622556713,
    "typ": "Bearer",
    "cnf": {
        "jkt": "hh_XBS..."
    }
}
```

Using the same client key to both obtain the token and to sign the request to access the resource.
The client should generate proper proof for possession of the key and send it via the `DPoP` header, which will be verified by Kong together with the token.
