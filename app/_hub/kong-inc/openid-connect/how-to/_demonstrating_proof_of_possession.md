---
title: Demonstrating Proof-of-Possession
nav_title: Demonstrating Proof-of-Possession
minimum_version: 3.7.x
---

## Overview

Demonstrating Proof-of-Possession (DPoP) is an alternative technique to the [Mutual TLS certificate-bound access tokens](/hub/kong-inc/openid-connect/how-to/client-authentication/mtls/). Instead of binding the token with the client certificate used in the mTLS, it binds the token with a JWK provided by the client.

It's possible to use Demonstrating Proof-of-Possession without mTLS, or even with plain HTTP. HTTPS is recommended for better protection.

Note that by enabling the verification of the DPoP proof, Kong removes the `DPoP` header and changes the token type from `dpop` to `bearer`, which essentially downgrades the request to use a conventional bearer token.
This allows an OAuth2 upstream without DPoP support to work with the DPoP token without losing the protection of the key-binding mechanism.

It's a prerequisite that the auth server is configured to enable the DPoP for you to enable it with Kong.

If you are configuring this in Keycloak, see the [Keycloak configuration](#prerequisites) section in the prerequisites.
For alternative auth servers, consult their documentation to configure this functionality.

Some of the instructions in the other how-to guides for OpenID Connect support validation of access tokens using mTLS proof of possession.
Enabling the [`proof_of_possession_dpop`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_dpop) configuration option in the plugin helps to ensure that the supplied access token
belongs to the client by verifying its binding with the client certificate provided in the request.

DPoP is supported by the following auth methods:

- [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
- [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
- [Session Authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)

   Session Authentication is only compatible with DPoP when used along with one of the other supported authentication methods:

    * If multiple `openid-connect` plugins are configured with the `session` auth method, we strongly recommend configuring different values of [`session_secret`](/hub/kong-inc/openid-connect/configuration/#config-session_secret) across plugin instances for additional security. This avoids sessions being shared across plugins and possibly bypassing the proof of possession validation.

The following example shows how to enable this feature for the JWT Access Token Authentication method. Similar steps can be followed for the other methods.

## Demo
### Prerequisites

Follow these prerequisites to set up a demo Keycloak app and a Kong service and route for testing mTLS client auth.

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

### Configure Demonstrating Proof-of-Possession

1. To enable Demonstrating Proof-of-Possession, use the [`proof_of_possession_dpop`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_dpop) configuration option:

    ```bash
    http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
    name=openid-connect                                          \
    service.name=openid-connect                                  \
    config.issuer=https://keycloak.test:8440/auth/realms/master  \
    config.client_id=cert-bound                                  \
    config.client_secret=cf4c655a-0622-4ce6-a0de-d3353ef0b714    \
    config.auth_methods=bearer                                   \
    config.proof_of_possession_dpop=strict
    ```
    If this is configured correctly, it returns a `200` response and something like the following:
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

1. Obtain the token from the IdP. A DPoP supporting client is required. For this demo, here is an example using [`oauth2c`](https://github.com/cloudentity/oauth2c.git):
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

    The token you obtain should include a claim that consists of the hash of the client certificate:
    ```json
    {
        "exp": 1622556713,
        "typ": "Bearer",
        "cnf": {
            "jkt": "hh_XBS..."
        }
    }
    ```

1. Access the service using the same client certificate and key used to obtain the token.
The client should generate proper proof for possession of the key and send it via the `DPoP` header, which will be verified by Kong.
