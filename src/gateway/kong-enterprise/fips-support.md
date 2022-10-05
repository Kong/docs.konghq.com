---
title: FIPS 140-2
badge: enterprise
content_type: reference
---

{{site.base_gateway}} provides support for the Federal Information Processing Standard (FIPS 140-2). Compliance with this standard is typically required for working with U.S. federal government agencies and their contractors.

{{site.base_gateway}} offers a FIPS package. The package replaces the primary library in {{site.base_gateway}}, OpenSSL, with the [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 compliant BoringCrypto for cryptographic operations.

{{site.base_gateway}} uses BoringSSL algorithms in all core components when configured.

{:.note .no-icon}
> {{site.base_gateway}} and the {{site.base_gateway}} FIPS package are not FIPS-validated or certified.

## Install the {{site.base_gateway}} FIPS package

The only supported {{site.base_gateway}} distribution is based on Ubuntu 20.04 and can be installed with the package distinctively named `kong-enterprise-edition-fips`.

To install the {{site.base_gateway}} FIPS package use:

    apt install kong-enterprise-edition-fips

{:.note .no-icon}
> FIPS mode is only supported in Ubuntu 20.04

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
