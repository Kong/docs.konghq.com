---
title: FIPS 140-2 Compliant Plugins
badge: enterprise
content_type: reference
---

This reference lists which {{site.base_gateway}} plugins are FIPS 140-2 compliant and provides additional details about how they maintain compliance.

| Plugin  | Subcomponent Compliance (if applicable)         | FIPS Compliant    | Notes |
|-------|-------------|--------|-----|
| jwe-decrypt | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |

{% if_version gte: 3.2.x %}
| openid-connect | All | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| jwt-signer | All | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| key-auth-enc | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
{% endif_version %}

| hmac-auth | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| ldap-auth-advanced | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| proxy-cache | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| proxy-cache-advanced | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| graphql-proxy-cache-advanced | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| mtls-auth | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| oauth2 | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| basic-auth | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| saml | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| jwt | N/A | Yes | Compliant via OpenSSL 3.0 FIPS provider |
| All other Kong Inc. plugins | N/A | N/A | No cryptographic operations involved |