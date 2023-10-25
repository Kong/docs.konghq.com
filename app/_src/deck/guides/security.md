---
title: Securing sensitive data
content_type: reference
---

With decK, you can manage sensitive values such as credentials or certificates
using one of the following options:

Option | Description | Why use this method?
-------|-------------|---------------------
[decK environment variables](/deck/{{page.kong_version}}/guides/environment-variables/) | Store values as environment variables and access them directly through decK. | • You can use this option for environment-specific values. <br><br> • This method can store any configuration values used by {{site.base_gateway}} entities. <br><br> • Available for all {{site.base_gateway}} packages: open-source, Enterprise Free mode, and Enterprise licensed mode.
[Secrets in {{site.base_gateway}}](/deck/{{page.kong_version}}/guides/vaults/) | Store values as secrets in a vault, then reference the secrets with a `vault` reference. In this case, the {{site.base_gateway}} data plane manages the secrets with a `vaults` entity. <br>The environment variable vault can be used in Free mode without a license, while all other vault backends require a license. | • Is a secure way to manage sensitive information in one of the following vaults: AWS, GCP, HashiCorp Vault, or environment variables. <br><br> • You can use secrets to store many sensitive values, including parameters in Kong's configuration (`kong.conf`). See [Secrets Management in {{site.base_gateway}}](/gateway/latest/kong-enterprise/secrets-management/#what-can-be-stored-as-a-secret) for a full list. <br><br> • Secrets management is only available for {{site.ee_product_name}} packages. It is not available for open-source {{site.base_gateway}}.
