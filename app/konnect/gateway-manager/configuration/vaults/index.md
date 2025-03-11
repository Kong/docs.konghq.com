---
title: Secrets Management in Konnect
content_type: explanation
---

Secrets management in {{site.konnect_short_name}} allows you to store secrets in centralized vaults, making it easier to manage security and governance policies. 

Secrets can be part of the core gateway configuration,
or part of gateway configuration associated with APIs serviced by the gateway.
The most common types of secrets include:
* Certificates
* API keys
* Personal access tokens
* Credentials for databases
* Certain plugin fields, like `session_secret` in the OIDC plugin

You can use vaults to safely store and retrieve secrets used in {{site.base_gateway}}
deployments, improving the fundamental security of your applications.
In the configuration, you can reference the secrets stored in vaults as variables instead
of displaying the actual value of the secret in plaintext. This way, the {{site.konnect_short_name}}
platform never stores sensitive credentials. 


## Vaults interface in {{site.konnect_short_name}}

![Vaults interface](/assets/images/products/konnect/gateway-manager/konnect-vaults.png)
> Figure 1: Overview page for all vaults configured for a control plane.

Number | Item | Description
-------|------|------------
1 | **Vaults menu link** | Main link to the vaults configuration for a control plane. Appears when you select a control plane.
2 | **New Vault** | Click the **New Vault** button to set up any supported Konnect vault backend.
3 | **Vault entry** | Select a vault entry to open the configuration page for the particular vault. On each vault's configuration page, you can edit or delete the vault, or copy the entire configuration as JSON.
4 | **Vault action menu** | From this menu, you can <b>view</b>, <b>edit</b>, or <b>delete</b> a vault's configuration. 

## Use cases

Vaults have several use cases: 
* Storing secrets securely
* Managing access to secrets with fine-grained policies
* Applying internal security policies
* Automating secret rotation without restarting the gateway
* Auditing secrets usage
* Encryption of secrets at rest

{{site.konnect_short_name}} **does not**:

* Update or modify the secrets in 3rd party vaults.

Vaults are configurable per control plane. You can't use the same vault across
multiple control planes.

## Supported vaults in {{site.konnect_short_name}}

Konnect supports the following vault backends:
* Konnect Config Store
* AWS Secrets Manager
* HashiCorp Vault
* GCP Secret Manager
* Azure Key Vault
* Environment variables

You can manage all of these vaults through the [Gateway Manager](/konnect/gateway-manager/configuration/vaults/how-to/) or with [decK](/deck/latest/guides/vaults/).

## See also

Check out the example use case for [storing certificates in a vault](/konnect/gateway-manager/configuration/vaults/how-to/).

For detailed vault configuration references and guides, see the {{site.base_gateway}}
documentation:
* [Konnect Config Store](/konnect/gateway-manager/configuration/config-store/)
* [AWS Secrets Manager](/gateway/latest/kong-enterprise/secrets-management/backends/aws-sm/)
* [GCP Secret Manager](/gateway/latest/kong-enterprise/secrets-management/backends/gcp-sm/)
* [HashiCorp Vault](/gateway/latest/kong-enterprise/secrets-management/backends/hashicorp-vault/)
* [Azure Key Vault](/gateway/latest/kong-enterprise/secrets-management/backends/azure-key-vaults/)
* [Environment variables](/gateway/latest/kong-enterprise/secrets-management/backends/env/)
