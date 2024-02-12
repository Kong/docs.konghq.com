## Changelog

### {{site.base_gateway}} 3.6.x
* This plugin can now be scoped to consumer groups.
* Removed the undesired `proxy-cache-advanced/migrations/001_035_to_050.lua` file, which blocked migration from OSS to Enterprise. 
This is a breaking change only if you are upgrading from a Kong Gateway version between `0.3.5` and `0.5.0`.

### {{site.base_gateway}} 3.3.x
* Added the `ignore_uri_case` configuration parameter.
* Added wildcard and parameter match support for `config.content_type`.

### {{site.base_gateway}} 3.1.x
* Added support for integrating with redis clusters using the `config.redis.cluster_addresses` configuration parameter.

### {{site.base_gateway}} 2.8.x

* Added the `redis.sentinel_username` and `redis.sentinel_password` configuration
parameters.

* The `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be
securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `1.3-x` and `2.2.x`. They are now updated to align with the
plugin's actual versions, `0.4.x` and `0.5.x`.
