---
title: Security
---

decK is a CLI tool that runs on your own machine. It can be used to configure RBAC for {{ site.ee_product_name }}, but does not provide a way to secure {{ site.ce_product_name }}.

{:.important}
> decK's state file can contain sensitive data such as private keys of certificates, credentials, etc. It is up to the user to manage and store the state file in a secure fashion.

## Vulnerability disclosure

If you believe that you have found a security vulnerability in decK, submit a detailed report, along with reproducible steps to [security@konghq.com](mailto:security@konghq.com).
