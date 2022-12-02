---
title: FIPS 140-2
badge: enterprise
content_type: reference
---

The Federal Information Processing Standard (FIPS) 140-2 is a federal standard defined by the National Institute of Standards and Technology. It specifies the security requirements that must be satisfied by a cryptographic module. The FIPS {{site.base_gateway}} package is FIPS 140-2 compliant. Compliance means that the software has met all of the rules of FIPS 140-2, but has not been submitted to a NIST testing lab for validation.

{{site.ee_product_name}} provides a FIPS 140-2 compliant package for **Ubuntu 20.04**. This package provides compliance for the core {{site.base_gateway}} product only. 

The package replaces the primary library in {{site.base_gateway}}, OpenSSL, with [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 validated BoringCrypto for cryptographic operations.

{:.note}
>**Note**: As of {{site.base_gateway}} 3.0, {{site.base_gateway}} plugins can't be considered FIPS-compliant. Future {{site.base_gateway}} releases aim to support plugins as well as distributions other than Ubuntu 20.04, such as RHEL. 

## Installing the {{site.base_gateway}} FIPS compliant Ubuntu package

The only supported {{site.base_gateway}} distribution is based on Ubuntu 20.04 and can be installed with the package distinctively named `kong-enterprise-edition-fips`.

To install the {{site.base_gateway}} FIPS package use:

    apt install kong-enterprise-edition-fips


### Configure FIPS

To start in FIPS mode, set the following variable to `on` in the `kong.conf` configuration file before starting {{site.base_gateway}}. 

```
fips = on # fips mode is enabled, causing incompatible ciphers to be disabled
```

You can also use an environment variable:

```bash
export KONG_FIPS=on
```

{:.important .no-icon}
> Migrating from non-FIPS to FIPS mode and backwards is not supported.
