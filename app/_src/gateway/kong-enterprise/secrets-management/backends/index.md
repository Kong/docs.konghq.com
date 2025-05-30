---
title: Supported Vault Backends
---

The following Vault implementations are supported:

|                                                                                                               | Tier       |
|---------------------------------------------------------------------------------------------------------------|------------|
| [AWS Secrets Manager](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/aws-sm/)      | Enterprise |

{% if_version gte:3.4.x %}
| [Azure Key Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/azure-key-vaults/) | Enterprise |
{% endif_version %}

| [GCP Secret Manager](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/gcp-sm/)      | Enterprise |
| [HashiCorp Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/hashicorp-vault/) | Enterprise |
| [CyberArk Conjur Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/cyberark-conjur-vault/) | Enterprise |


In the Free tier, secrets may be stored in [environment variables](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/env/).
