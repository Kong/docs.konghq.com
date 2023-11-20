## Changelog

**{{site.base_gateway}} 3.4.x**
* The Kafka Log plugin now supports the `custom_fields_by_lua` configuration for 
dynamic modification of log fields using Lua code.
* Fixed an issue where the plugin could lose connection to a broker when the broker leadership changed.

**{{site.base_gateway}} 2.8.x**

* Added support for the `SCRAM-SHA-512` authentication mechanism.

* Added the `cluster_name` configuration parameter.

* The `authentication.user` and `authentication.password` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format/).

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.authentication.user` and `config.authentication.password` parameter
 values will be encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect in this plugin.

**{{site.base_gateway}} 2.6.x**
*  The Kafka Log plugin now supports TLS, mTLS, and SASL auth.
SASL auth includes support for PLAIN, SCRAM-SHA-256, and delegation tokens.