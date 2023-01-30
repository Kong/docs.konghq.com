## Changelog

**{{site.base_gateway}} 2.8.x**

* Added the `redis.username` and `redis.sentinel_username` configuration parameters.

* The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `1.3-x` and `2.3.x`. They are now updated to align with the
plugin's actual versions, `0.1.x` and `0.2.x`.

**{{site.base_gateway}} 2.5.x**

* Added the `redis.keepalive_pool`, `redis.keepalive_pool_size`, and `redis.keepalive_backlog` configuration parameters.
 These options relate to [Openresty’s Lua INGINX module’s](https://github.com/openresty/lua-nginx-module/#tcpsockconnect) `tcp:connect` options.

**{{site.base_gateway}} 2.2.x**

* Added Redis TLS support with the `redis.ssl`, `redis.ssl_verify`, and `redis.server_name` configuration parameters.
