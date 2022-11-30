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

![Vaults interface](/assets/images/docs/konnect/konnect-vaults.png)
> Figure 1: Overview page for all vaults configured for a runtime group.

Number | Item | Description
-------|------|------------
1 | **Vaults menu link** | Main link to the vaults configuration for a runtime group. Appears when you select a runtime group.
2 | **Add vault** | Click the **Add vault** button to set up any supported Konnect vault backend.
3 | **Vault entry** | Select a vault entry to open the configuration page for the particular vault. On each vault's configuration page, you can edit or delete the vault, or copy the entire configuration as JSON.
4 | **Vault ID** | The vault's UUID. 
5 | **Vault action menu** | From this menu, you can <b>view</b>, <b>edit</b>, or <b>delete</b> a vault's configuration. 

## Use cases

Vaults have several use cases: 
* Storing secrets securely
* Managing access to secrets with fine-grained policies
* Applying internal security policies
* Automating secret rotation
* Auditing secrets usage
* Encryption of secrets at rest

{{site.konnect_short_name}} **does not**:
* Store credentials to access the vault itself.
You must provide those credentials to the {{site.base_gateway}} data plane directly.
* Update or modify the secrets in 3rd party vaults.

Vaults are configurable per runtime group. You can't use the same vault across
multiple runtime groups.

## Supported vaults in {{site.konnect_short_name}}

Konnect supports the following vault backends:
* AWS Secrets Manager
* HashiCorp Vault
* GCP Secret Manager
* Environment variables

You can manage all of these vaults through the [Runtime Manager](/konnect/runtime-manager/vaults/how-to) or with [decK](/deck/latest/guides/vaults/).

## See also

Check out the example use case for [storing certificates in a vault](/konnect/runtime-manager/vaults/how-to).

For detailed vault configuration references and guides, see the {{site.base_gateway}}
documentation:
* [AWS Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm)
* [GCP Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/gcp-sm)
* [HashiCorp Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/hashicorp-vault)
* [Environment variables](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/env)
