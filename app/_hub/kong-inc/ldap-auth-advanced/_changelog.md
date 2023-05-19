## Changelog

**{{site.base_gateway}} 3.0.x**
* Added the `groups_required` parameter.
* The deprecated `X-Credential-Username` header has been removed.
* The character `.` is now allowed in group attributes.
* The character `:` is now allowed in the password field.

**{{site.base_gateway}} 2.8.x**

* The `ldap_password` and `bind_dn` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format/).

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.ldap_password` parameter value will be encrypted.

**{{site.base_gateway}} 2.3.x**

* Added the parameter `log_search_results`, which lets the plugin display all the LDAP search results received from the LDAP server.
* Added new debug log statements for authenticated groups.