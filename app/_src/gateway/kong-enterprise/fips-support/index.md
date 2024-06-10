---
title: About FIPS 140-2 Compliance in Kong Gateway
badge: enterprise
content_type: reference
---

The Federal Information Processing Standard (FIPS) 140-2 is a federal standard defined by the National Institute of Standards and Technology. It specifies the security requirements that must be satisfied by a cryptographic module. The FIPS {{site.base_gateway}} package is FIPS 140-2 compliant. Compliance means that {{site.base_gateway}} only uses FIPS 140-2 approved algorithms while running in FIPS mode, but the product has not been submitted to a NIST testing lab for validation.


{{site.ee_product_name}} provides a FIPS 140-2 compliant package for **Ubuntu 20.04** {% if_version gte:3.1.x %}, **Ubuntu 22.04** {% if_version gte:3.4.x %}, **Red Hat Enterprise 9** {% endif_version %}, and **Red Hat Enterprise 8** {% endif_version %}. This package provides compliance for the core {{site.base_gateway}} product {% if_version gte:3.2.x %} and all out of the box plugins {% endif_version %}.

The package uses the OpenSSL FIPS 3.0 module OpenSSL to provide FIPS 140-2 validated cryptographic operations.

{:.note}
> **Note**: FIPS is not supported when running {{site.ee_product_name}} in free mode.

## FIPS implementation
### Password hashing

The following table describes how {{site.base_gateway}} uses key derivation functions:

| Component | Normal mode | FIPS mode | Notes |
|-----------|-------------|-----------|-------|
| core/rbac | bcrypt | PBKDF2 <sup>1</sup> | Compliant via OpenSSL 3.0 FIPS provider  |
| plugins/oauth2 <sup>2</sup> | Argon2 or bcrypt (when `hash_secret=true`) | Disabled (`hash_secret` can’t be set to `true`) | Compliant via OpenSSL 3.0 FIPS provider |
| plugins/key-auth-enc <sup>3</sup> | SHA1 | SHA256 | SHA1 is read-only in FIPS mode. |

{:.note .no-icon}
> **\[1\]**: As of {{site.base_gateway}} FIPS 3.0, RBAC uses PBKDF2 as password hashing algorithm.
<br><br>
> **\[2\]**: As of {{site.base_gateway}} FIPS 3.1, the oauth2 plugin disables `hash_secret` feature, so the user can’t turn it on. This means password will be stored plaintext in the database; however, users can choose to use secrets management or db encryption instead.
<br><br>
> **\[3\]**: As of {{site.base_gateway}} FIPS 3.1, key-auth-enc uses SHA1 to speed up lookup of a key in DB. As of {{site.base_gateway}} FIPS 3.2, SHA1 support is “read-only”, meaning existing credentials in DB are still validated, but any new credentials will be hashed in SHA256.

{:.important}
> **Important**: If you are migrating from {{site.base_gateway}} 3.1 to 3.2 in FIPS mode and are using the key-auth-enc plugin, you should send [PATCH or POST requests](/hub/kong-inc/key-auth-enc/#create-a-key) to all existing key-auth-enc credentials to re-hash them in SHA256.

### Non-cryptographic usage of cryptographic algorithms

FIPS only defines the approved algorithms to use for each specific purpose, so FIPS policy doesn't explicitly restrict the usage of cryptographic algorithms to only cases where they are necessary. 

For example, using SHA256 as the message digest algorithm is approved while using MD5 is not. But that doesn’t mean MD5 can’t exist in the application at all. For example, the FIPS 140-2 approved [BoringSSL](https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp3678.pdf) version allows MD5 when it's used with the TLS protocol version 1.0 and 1.1. 

The following table explains where cryptographic algorithms are used for non-cryptographic purposes in {{site.base_gateway}}:

| Component | Normal mode | FIPS mode | Notes |
|-----------|-------------|-----------|-------|
| core/balancer | xxhash32 | xxhash32 | Use to generate a unique identifier. |
| core/balancer | crc32 | crc32 | crc32 isn't message digest. |
| core/uuid | Lua random number generator | Lua random number generator | The RNG isn’t used for cryptographic purposes. |
| core/declarative_config/uuid | UUIDv5 (namespaced SHA1) | UUIDv5 (namespaced SHA1) | Used to generate a unique identifier. |
| core/declarative_config/config_hash and core/hybrid/hashes | MD5 | MD5 | Used to generate a unique identifier. |
{% if_version gte:3.5.x %}
| core/kong_request_id | rand(3) | rand(3) | The RNG isn’t used for cryptographic purposes. |
{% endif_version %}


### SSL client

FIPS 140-2 only mentioned SSL server, which is already supported in {{site.base_gateway}} FIPS 3.0. FIPS specification isn't designated for SSL clients, so there isn't specific handling of these in {{site.base_gateway}}.

This includes:
* Using Lua to talk in HTTPS and PostgreSQL SSL
{% if_version lte:3.3.x -%}
* Using Lua to talk in HTTPS, PostgreSQL SSL, and Cassandra SSL
{% endif_version -%}
* Using an upstream that proxies in HTTPS
