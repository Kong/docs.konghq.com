---
title: Financial-Grade API (FAPI)
nav_title: Financial-Grade API (FAPI)
minimum_version: 3.7.x
---

## Overview

The OpenID Connect plugin supports various features of the FAPI standard, aimed to protect APIs that expose high-value and sensitive data.

### Pushed Authorization Requests (PAR)

With PAR enabled, Kong (OAuth client) sends the payload of an authorization request to the IdP. As a result, it obtains a `request_uri` value. This value is used by the client in a call to the authorization endpoint as a reference to obtain the authorization request payload data.

For more information refer to the [Configuration reference](/hub/kong-inc/openid-connect/configuration/#config-pushed_authorization_request_endpoint)

### JWT-Secured Authorization requests (JAR)

With JAR enabled, when sending requests to the authorization endpoint, Kong provides request parameters in a JSON Web Token (JWT) instead of using a query string, which allows the request data to be signed with JSON Web Signature (JWS).

For more information refer to the [Configuration reference](/hub/kong-inc/openid-connect/configuration/#config-require_signed_request_object)

### JWT-Secured Authorization Response Mode (JARM)

With JARM enabled, Kong requests the authorization server to return the authorization response parameters encoded in a JWT, which allows the response data to be signed with JSON Web Signature (JWS).

JARM can be enabled by setting the `response_mode` configuration option to any of the following available values: `query.jwt`, `form_post.jwt`, `fragment.jwt`, `jwt`.

For more information refer to the [Configuration reference](/hub/kong-inc/openid-connect/configuration/#config-response_mode)

### Certificate-Bound Access Tokens

Certificate-bound access tokens allow binding tokens to clients. This guarantees the authenticity of the token by verifying whether the sender is authorized to use it for accessing protected resources.

For more information refer to the [dedicated section](/hub/kong-inc/openid-connect/how-to/cert-bound-access-tokens).

### Mutual TLS (mTLS) Client Authentication and Certificate-Bound Access Tokens

When mTLS client authentication is enabled, Kong establishes mTLS connections with the IdP using the configured X.509 certificate as client credentials.
If the authorization server is configured to bind the client certificate with the issued access token, Kong can validate the access token using mTLS proof of possession.

For more information refer to the dedicated sections of [mTLS Client Authentication](/hub/kong-inc/openid-connect/how-to/client-authentication/mtls) and [Certificate-Bound Access Tokens](/hub/kong-inc/openid-connect/how-to/cert-bound-access-tokens).

### Demonstrating Proof-of-Possession (DPoP)

Demonstrating Proof of Possession (DPoP) is an application-level mechanism for proving the sender's ownership of OAuth access and refresh tokens. With DPoP a client can prove the possession of a public/private key pair associated with a token, using a header. The header contains a signed JWT that includes a reference to the associated access token.

When DPoP is enabled, Kong validates the DPoP header in the request to ensure that the sender is authorized to use the access token.