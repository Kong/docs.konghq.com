## Changelog

**{{site.base_gateway}} 3.1.x**
* Added support for KV secrets engine v2

**{{site.base_gateway}} 2.8.1.3**

* The endpoints of Vault Auth plugin have been moved from `/vaults` to `/vault-auth`, with `vaults_use_new_style_api=on` set in `kong.conf`.

**{{site.base_gateway}} 2.8.x**

* The `vaults.vault_token` form field is now marked as
referenceable, which means it can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `2.7.x`, `2.1.x`, `1.5.x`, `1.3-x`, `0.36-x`, and `0.35-x`.
They are now updated to align with the plugin's actual versions, `0.3.0`, `0.2.2`,
`0.2.1`, `0.2.0`, `0.1.2`, and `0.1.0` respectively.

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled
and you are using Vault, the `vaults.vault_token` and `vault_credentials.secret_token` fields will be encrypted.

[consumer-object]: https://docs.konghq.com/gateway/latest/admin-api/#consumer-object
[acl-associating]: https://docs.konghq.com/hub/kong-inc/acl/#associating-consumers
