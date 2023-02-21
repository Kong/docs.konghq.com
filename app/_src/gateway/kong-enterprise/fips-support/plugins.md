---
title: FIPS 140-2 Compliant Plugins
badge: enterprise
content_type: reference
---

This reference lists which {{site.base_gateway}} plugins are FIPS 140-2 compliant and provides additional details about how they maintain compliance.

| Plugin  | Subcomponent Compliance (if applicable)         | FIPS Compliant    | Notes |
|-------|-------------|--------|-----|
| jwe-decrypt | N/A | Yes | Compliant via BoringSSL |

{% if_version gte: 3.2.x %}
| openid-connect | All | Yes | Compliant via BoringSSL |
| jwt-signer | All | Yes | Compliant via BoringSSL |
| key-auth-enc | N/A | Yes | Compliant via BoringSSL |
{% endif_version %}

| hmac-auth | N/A | Yes | Compliant via BoringSSL |
| ldap-auth-advanced | N/A | Yes | Compliant via BoringSSL |
| proxy-cache | N/A | Yes | Compliant via BoringSSL |
| proxy-cache-advanced | N/A | Yes | Compliant via BoringSSL |
| graphql-proxy-cache-advanced | N/A | Yes | Compliant via BoringSSL |
| mtls-auth | N/A | Yes | Compliant via BoringSSL |
| oauth2 | N/A | Yes | Compliant via BoringSSL |
| basic-auth | N/A | Yes | Compliant via BoringSSL |
| saml | N/A | Yes | Compliant via BoringSSL |
| jwt | N/A | Yes | Compliant via BoringSSL |
| All other Kong Inc. plugins | N/A | N/A | No cryptographic operations involved |