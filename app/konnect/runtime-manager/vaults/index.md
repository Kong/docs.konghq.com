---
title: Secrets Management in Konnect
content_type: explanation
---

Secure your {{site.konnect_short_name}} environment with centralized secrets,
making it easier to manage and build governance.

A secret is a sensitive piece of information required for proper gateway operations.
Secrets may be part of the core gateway configuration,
or part of gateway configuration associated with APIs serviced by the gateway.
Some of the most common types of secrets include:
* Certificates
* API keys
* Personal access tokens
* Credentials for databases
* Certain plugin fields, like `session_secret` in the OIDC plugin

You can use vaults to safely store and retrieve secrets used in {{site.base_gateway}}
deployments, improving the fundamental security of your applications.
In configuration, you can then reference the secrets stored in vaults instead
of displaying the actual value of the secret.

This ensures that secrets are not stored in plaintext throughout the platform,
in places such as `kong.conf` files, in declarative configuration files, logs,
or in the {{site.konnect_short_name}} UI. This way, the {{site.konnect_short_name}}
platform never stores or sees sensitive credentials, letting you use the security controls
that you already have around sensitive information.

## Vaults interface in {{site.konnect_short_name}}

![Vaults interface](/assets/images/docs/konnect/konnect-vaults.png)
> Figure 1: Overview page for all vaults configured for a runtime group.

Number | Item | Description
-------|------|------------
1 | **Vaults menu link** | Main link to the vaults configuration for a runtime group. Appears when you select a runtime group.
2 | **Add vault** | Click the **Add vault** button to set up any supported Konnect vault backend.
3 | **Table entries for vaults** | Select a table entry to see the configuration for a particular vault. On each vault's configuration page, you can edit or delete the vault, or copy the entire configuration as JSON.
4 | **Vault ID** | The vault's UUID. You can click the copy icon to copy the ID for use in configuration.
5 | **Vault action menu** | Interact with a configured vault. From this menu, you can <b>view</b>, <b>edit</b>, or <b>delete</b> a vault's configuration. <br><br> <b>Be careful when deleting a configured vault!</b> Once deleted, a vault can't be restored, and all vault references will fail if not updated.

## Benefits

Use vaults for the following benefits:
* Storing secrets securely
* Managing access to secrets with fine grained policies
* Automation of secrets rotation
* Audits of secrets usage
* Encryption of secrets at rest

Be aware that {{site.konnect_short_name}} **does not**:
* Store credentials to access the vault itself.
You must provide those credentials to the {{site.base_gateway}} data plane directly.
* Update or modify the secrets in the 3rd party vaults.

Vaults are configurable per runtime group. You can't use the same vault across
multiple runtime groups.

## Supported vaults in {{site.konnect_short_name}}

Konnect supports the following vault backends:
* Environment variables
* AWS Secrets Manager
* HashiCorp Vault
* GCP Secret Manager

You can manage all of these vaults through the [Konnect UI](/konnect/runtime-manager/vaults/how-to) or with [decK](/deck/latest/guides/vaults/).

## See also

Check out the example use case for [storing certificates in a vault](/konnect/runtime-manager/vaults/how-to).

For detailed vault configuration references and guides, see the {{site.base_gateway}}
documentation:
* [AWS Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm)
* [GCP Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/gcp-sm)
* [HashiCorp Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/hashicorp-vault)
* [Environment variables](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/env)
