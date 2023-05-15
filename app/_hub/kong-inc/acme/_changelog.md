## Changelog

{% if_plugin_version gte:3.1.x %}
**{{site.base_gateway}}  3.1.x**

* Added the `config.storage_config.redis.ssl`, `config.storage_config.redis.ssl_verify`, and `config.storage_config.redis.ssl_server_name` configuration parameters.

{% endif_plugin_version %}

{% if_plugin_version gte:3.0.x %}

**{{site.base_gateway}} 3.0.x**
* The `storage_config.vault.auth_method` configuration parameter now defaults to `token`.
* Added the `allow_any_domain` configuration parameter. If enabled, it lets {{site.base_gateway}}
  ignore the `domains` field.

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}
**{{site.base_gateway}} 2.8.x**

* Added the `rsa_key_size` configuration parameter.
* The `consul.token`, `redis.auth`, and `vault.token` are now marked as now marked as
referenceable, which means they can be securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/) in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

{% endif_plugin_version %}

{% if_plugin_version gte:2.7.x %}
**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `account_email`, `eab_kid`, and `eab_hmac_kid` parameter values will be
 encrypted.

{% endif_plugin_version %}

{% if_plugin_version gte:2.4.x %}
**{{site.base_gateway}} 2.4.x**
* Added external account binding (EAB) support with the `eab_kid` and `eab_hmac_key` configuration parameters.

{% endif_plugin_version %}

**{{site.base_gateway}} 2.1.x**
* Added the `fail_backoff_minutes` configuration parameter.
