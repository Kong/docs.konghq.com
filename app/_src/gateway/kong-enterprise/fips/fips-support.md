---
title: About FIPS 140-2 Compliance in Kong Gateway
badge: enterprise
content_type: reference
---

The Federal Information Processing Standard (FIPS) 140-2 is a federal standard defined by the National Institute of Standards and Technology. It specifies the security requirements that must be satisfied by a cryptographic module. The FIPS {{site.base_gateway}} package is FIPS 140-2 compliant. Compliance means that the software has met all of the rules of FIPS 140-2, but has not been submitted to a NIST testing lab for validation.


{{site.ee_product_name}} provides a FIPS 140-2 compliant package for **Ubuntu 20.04** {% if_version gte:3.1.x %}, **Ubuntu 22.04**, and **Red Hat Enterprise 8** {% endif_version %}. This package provides compliance for the core {{site.base_gateway}} product {% if_version gte:3.1.x %} and all out of the box plugins <!--based on the draft doc, is this accurate for 3.1.x?--> {% endif_version %}.

The package replaces the primary library in {{site.base_gateway}}, OpenSSL, with [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 validated BoringCrypto for cryptographic operations.

## Implementation details
### Password hashing

Password hashing is different from message digest, as message digest is used to verify the integrity of a message, password hashing is designed to protect the original password being reversed. So it’s a bit closer to key derivation. There’s no mention of password hashing in FIPS 140-2, and we choose key derivation functions that are approved.

| Component | Normal mode | FIPS mode | Notes |
|-----------|-------------|-----------|-------|
| core/rbac | bcrypt | PBKDF2 | PBKDF2 in BoringSSL is not FIPS validated; need OpenSSL 3.0 |
| plugins/oauth2 | Argon2 or bcrypt (when `hash_secret=true`) | Disabled (`hash_secret` can’t be set to `true`) | PBKDF2 in BoringSSL is not FIPS validated; need OpenSSL 3.0 |

* As of Kong Gateway FIPS 3.0, RBAC uses PBKDF2 as password hashing algorithm. Although PBKDF2 is an approved algorithm in FIPS 140-2, the BoringSSL implementation of PBKDF2 is not validated. This approach is future proof because once OpenSSL 3.0 gets its FIPS certification, we can move off BoringSSL, and OpenSSL 3.0’s PBKDF2 implementation is included in its FIPS validation.
* As of Kong Gateway FIPS 3.1, oauth2 plugin disables `hash_secret` feature, so the user can’t turn it on. This means password will be stored plaintext in the database; however, users can choose to use secrets management or db encryption instead.
* As of Kong Gateway FIPS 3.1, key-auth-enc uses SHA1 to speed up lookup of a key in DB. As of Kong Gateway FIPS 3.2, SHA1 support is “read-only”, meaning existing credentials in DB are still validated, but any new credentials will be hashed in SHA256.

In short:  if we aim to provide a package that there’s no confusion to break FIPS compliance in 3.2, we should disable the RBAC feature and remove the `hash_secret` feature for oauth2 plugin (it has disabled by default).

Customers who are migrating from Kong Gateway FIPS 3.1 to 3.2 and are previously using key-auth-enc plugin, should send PATCH or POST requests to all existing key-auth-enc credentials to re-hash them in SHA256.

### Non-cryptographic usage of cryptographic algorithms

FIPS only defines the approved algorithms to use for each specific purpose; using an cryptographic algorithm in a scope it’s not designed to be is not restricted in FIPS policy.

For example, use SHA256 as the message digest algorithm is approved, using MD5 is not. But that doesn’t mean MD5 can’t exist in the application at all. For example the FIPS 140-2 approved BoringSSL(https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp3678.pdf
) version allows “MD5 When used with the TLS protocol version 1.0 and 1.1”. 

Following lists such usage in Kong:

| Component | Normal mode | FIPS mode | Notes |
|-----------|-------------|-----------|-------|
| core/balancer | xxhash32 | xxhash32 | Use to generate a unique identifier. |
| core/balancer | crc32 | crc32 | Note crc32 is not message digest but also notice here to avoid confusion. |
| core/uuid | Lua random number generator | Lua random number generator | The RNG isn’t used for cryptographic purposes. |
| core/declarative_config/uuid | UUIDv5 (namespaced SHA1) | UUIDv5 (namespaced SHA1) | Used to generate a unique identifier. |
| core/declarative_config/config_hash
core/hybrid/hashes | MD5 | MD5 | Used to generate a unique identifier. |

We believe those do not impact FIPS compliance, but we would like to have confirmation from FIPS specialists.

### SSL client

FIPS 140-2 only mentioned SSL server, which is already supported in Kong Gateway FIPS 3.0. FIPS specification has not been designated for SSL clients, hence we don’t have specific handling of them in Kong.

This includes:
* Using Lua to talk in HTTPS, PostgreSQL SSL, Cassandra SSL
* Upstream that proxies in HTTPS

We are not sure how to deal with the SSL client and this required help from a FIPS consultant.
