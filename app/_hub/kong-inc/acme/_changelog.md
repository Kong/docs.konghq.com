## Changelog

### {{site.base_gateway}} 3.5.x

* Exposed the new configuration field `scan_count` for Redis storage, 
which controls how many keys are returned in a `scan` call. 
[#11532](https://github.com/kong/kong/pull/11532)

### {{site.base_gateway}} 3.4.x

* Fixed an issue where the sanity test didn't work with `kong` storage in hybrid mode.
[#10852](https://github.com/Kong/kong/pull/10852)

### {{site.base_gateway}} 3.3.x

* Added the `account_key` configuration parameter
* Added the `config.storage_config.redis.namespace` configuration parameter.
  The namespace will be concatenated as a prefix of the key. The default is an empty string (`""`) for backward compatibility. The namespace can be any string that isn't prefixed with any of the [Kong reserved words](/konnect/reference/labels/).

### {{site.base_gateway}} 3.1.x

* Added the `config.storage_config.redis.ssl`, `config.storage_config.redis.ssl_verify`, and `config.storage_config.redis.ssl_server_name` configuration parameters.

### {{site.base_gateway}} 3.0.x
* The `storage_config.vault.auth_method` configuration parameter now defaults to `token`.
* Added the `allow_any_domain` configuration parameter. If enabled, it lets {{site.base_gateway}}
  ignore the `domains` field.

### {{site.base_gateway}} 2.8.x

* Added the `rsa_key_size` configuration parameter.
* The `consul.token`, `redis.auth`, and `vault.token` are now marked as now marked as
referenceable, which means they can be securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/) in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

### {{site.base_gateway}} 2.7.x

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `account_email`, `eab_kid`, and `eab_hmac_kid` parameter values will be
 encrypted.

### {{site.base_gateway}} 2.4.x
* Added external account binding (EAB) support with the `eab_kid` and `eab_hmac_key` configuration parameters.

### {{site.base_gateway}} 2.1.x
* Added the `fail_backoff_minutes` configuration parameter.
