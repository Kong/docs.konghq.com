---
title: Certificate-Bound Access Tokens
nav_title: Certificate-Bound Access Tokens
minimum_version: 3.6.x
---

## Overview

One of the main vulnerabilities of OAuth are bearer tokens. With OAuth, presenting a valid bearer token is enough proof to access a resource.
This can create problems since the client presenting the token isn't validated as the legitimate user that the token was issued to. 

Certificate-bound access tokens can solve this problem by binding tokens to clients. 
This ensures the legitimacy of the token because the it requires proof that the sender is authorized to use a particular token to access protected resources. 

To enable certificate-bound access for OpenID Connect, you must ensure that the auth server is set up to generate OAuth 2.0 Mutual TLS certificate-bound access tokens.

If you are configuring this in Keycloak, see the [Keycloak configuration](#prerequisites) section in the prerequisites.
For alternative auth servers, consult their documentation to configure this functionality.

Some of the instructions in the other how-to guides for OpenID Connect support validation of access tokens using mTLS proof of possession.
Enabling the [`proof_of_possession_mtls`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_mtls) configuration option in the plugin helps to ensure that the supplied access token
belongs to the client by verifying its binding with the client certificate provided in the request.

The certificate-bound access tokens are supported by the following auth methods:

- [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
- [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
- [Session Authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)

   Session Authentication is only compatible with certificate-bound access tokens when used along with one of the other supported authentication methods:

    * When the configuration option [`proof_of_possession_auth_methods_validation`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_auth_methods_validation) is set to `false` and other non-compatible methods are enabled, if a valid session is found, the proof of possession validation will only be performed if the session was originally created using one of the compatible methods. 
    * If multiple `openid-connect` plugins are configured with the `session` auth method, we strongly recommend configuring different values of [`session_secret`](/hub/kong-inc/openid-connect/configuration/#config-session_secret) across plugin instances for additional security. This avoids sessions being shared across plugins and possibly bypassing the proof of possession validation.

The following example shows how to enable this feature for the JWT Access Token Authentication method. Similar steps can be followed for the other methods.

## Demo
### Prerequisites

Follow these prerequisites to set up a demo Keycloak app and a Kong service and route for testing mTLS client auth.

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

### Configure certificate-bound access tokens

1. Configure {{site.base_gateway}} to use mTLS client certificate authentication. You can do this by configuring the [TLS Handshake Modifier plugin](/hub/kong-inc/tls-handshake-modifier/) or the [Mutual TLS Authentication plugin](/hub/kong-inc/mtls-auth/):

    ```bash
    http -f post :8001/plugins    \
    name=tls-handshake-modifier \
    service.name=openid-connect
    ```
    If this is configured correctly, it returns a `200` response and something like the following:
    ```json
    {
        "id": "a7f676e6-580d-4841-80de-de46e1f79eb2",
        "name": "tls-handshake-modifier",
        "service": {
            "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
        }
    }
    ```

1. To enable certificate-bound access tokens, use the [`proof_of_possession_mtls`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_mtls) configuration option:

    ```bash
    http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
    name=openid-connect                                          \
    service.name=openid-connect                                  \
    config.issuer=https://keycloak.test:8440/auth/realms/master  \
    config.client_id=cert-bound                                  \
    config.client_secret=cf4c655a-0622-4ce6-a0de-d3353ef0b714    \
    config.auth_methods=bearer                                   \
    config.proof_of_possession_mtls=strict
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
            "proof_of_possession_mtls": "strict",
        }
    }
    ```

1. Obtain the token from the IdP, making sure to modify the following command for your environment:
    ```bash
    http --cert client-cert.pem --cert-key client-key.pem                                 \
    -f post https://keycloak.test:8440/auth/realms/master/protocol/openid-connect/token \
    client_id=cert-bound                                                                \
    client_secret=cf4c655a-0622-4ce6-a0de-d3353ef0b714                                  \
    grant_type=client_credentials
    ```
    If this is configured correctly, it returns a `200` response and something like the following:
    ```json
    {
        "access_token": "eyJhbG...",
    }
    ```

    The token you obtain should include a claim that consists of the hash of the client certificate:
    ```json
    {
        "exp": 1622556713,
        "typ": "Bearer",
        "cnf": {
            "x5t#S256": "hh_XBS..."
        }
    }
    ```

1. Access the service using the same client certificate and key used to obtain the token:
    ```bash
    http --cert client-cert.pem --cert-key client-key.pem \
    -f post https://kong.test:8443                      \
    Authorization:"Bearer eyJhbGc..."
    ```
    If this is configured correctly, it returns a `200` response:
    ```http
    HTTP/1.1 200 OK
    ```