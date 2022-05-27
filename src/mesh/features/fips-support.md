---
title: Kong Mesh - FIPS Support
---

With version 1.2.0, {{site.mesh_product_name}} provides built-in support for the Federal Information Processing Standard (FIPS-2). Compliance with this standard is typically required for working with U.S. federal government agencies and their contractors.

FIPS support is provided by implementing Envoy's FIPS-compliant mode for BoringSSL. For more information about how it works, see Envoy's [FIPS 140-2 documentation](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/security/ssl#fips-140-2).

{:.important .no-icon}
> FIPS compliance is not supported on macOS.
