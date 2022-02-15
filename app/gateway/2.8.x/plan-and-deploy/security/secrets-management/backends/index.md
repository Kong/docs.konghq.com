---
title: Supported Vault Backends
beta: true
---

Secrets rotation is not supported for the beta version.

The following Vault implementations are supported:

|                                                                                                                        | Rotation Support             | Get                          | Tier       |
|------------------------------------------------------------------------------------------------------------------------|------------------------------|------------------------------|------------|
| [AWS Secrets Manager](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/aws-sm)      |  <i class="fa fa-times"></i> |  <i class="fa fa-check"></i> | Enterprise |
| [Hashicorp Vault](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/hashicorp-vault) |  <i class="fa fa-times"></i> |  <i class="fa fa-check"></i> | Enterprise |
| [Environment Variable](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/env)        |  <i class="fa fa-times"></i> |  <i class="fa fa-check"></i> | Free       |
