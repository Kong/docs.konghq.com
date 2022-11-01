---
title: FIPS 140-2
badge: enterprise
content_type: reference
---

The Federal Information Processing Standard (FIPS) 140-2 standard is a federal standard defined by the National Institute of Standards and Technology that specifies the security requirements that must be satisfied by a cryptographic module. **The core {{site.base_gateway}} product is (FIPS) 140-2 compliant** with the FIPS package that is available for **Ubuntu 20.04**. 

For FIPS 140-2 compliance, {{site.base_gateway}} replaces the non-FIPS compliant OpenSSL with the FIPS validated library [BoringSSL](https://boringssl.googlesource.com/boringssl/) for encryption. 

{:.note}
>**Note**: As of {{site.base_gateway}} 3.0, {{site.base_gateway}} plugins can't be considered FIPS-compliant. Future {{site.base_gateway}} releases aim to support plugins as well as distributions other than Ubuntu 20.04. 

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
