---
title: Supported Vault Backends
---

The following Vault implementations are supported:

|                                                                                                               | Tier       |
|---------------------------------------------------------------------------------------------------------------|------------|
| [AWS Secrets Manager](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/aws-sm/)      | Enterprise |

{% if_version gte:3.5.x %}
| [Azure Key Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/azure-key-vaults/) | Enterprise |
{% endif_version %}

| [GCP Secrets Manager](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/gcp-sm/)      | Enterprise |
| [HashiCorp Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/hashicorp-vault/) | Enterprise |
| [Environment Variable](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/env/)        | Free       |
