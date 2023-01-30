## Changelog

**{{site.base_gateway}} 3.1.x**
* Added support for integrating with redis clusters using the `config.redis.cluster_addresses` configuration parameter.

**{{site.base_gateway}} 2.8.x**

* Added the `redis.sentinel_username` and `redis.sentinel_password` configuration
parameters.

* The `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be
securely stored as [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format/).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `1.3-x` and `2.2.x`. They are now updated to align with the
plugin's actual versions, `0.4.x` and `0.5.x`.