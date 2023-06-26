## Changelog

**{{site.base_gateway}} 3.2.x**
* The plugin has been updated to use version 4.0.0 of the `lua-resty-session` library which introduced several new features such as the possibility to specify audiences.
The following configuration parameters have been affected:

Added:
  * `session_audience`
  * `session_remember`
  * `session_remember_cookie_name`
  * `session_remember_rolling_timeout`
  * `session_remember_absolute_timeout`
  * `session_absolute_timeout`
  * `session_request_headers`
  * `session_response_headers`
  * `session_store_metadata`
  * `session_enforce_same_subject`
  * `session_hash_subject`
  * `session_hash_storage_key`

Renamed:
  * `authorization_cookie_lifetime` to `authorization_rolling_timeout`
  * `authorization_cookie_samesite` to `authorization_cookie_same_site`
  * `authorization_cookie_httponly` to `authorization_cookie_http_only`
  * `session_cookie_lifetime` to `session_rolling_timeout`
  * `session_cookie_idletime` to `session_idling_timeout`
  * `session_cookie_samesite` to `session_cookie_same_site`
  * `session_cookie_httponly` to `session_cookie_http_only`
  * `session_memcache_prefix` to `session_memcached_prefix`
  * `session_memcache_socket` to `session_memcached_socket`
  * `session_memcache_host` to `session_memcached_host`
  * `session_memcache_port` to `session_memcached_port`
  * `session_redis_cluster_maxredirections` to `session_redis_cluster_max_redirections`

Removed:
  * `session_cookie_renew`
  * `session_cookie_maxsize`
  * `session_strategy`
  * `session_compressor`

**{{site.base_gateway}} 3.0.x**
* The deprecated `session_redis_auth` field has been removed from the plugin.

**{{site.base_gateway}} 2.8.x**

* Added the `session_redis_username` and `session_redis_password` configuration
parameters.

    {:.important}
    > These parameters replace the `session_redis_auth` field, which is
    now **deprecated** and planned to be removed in 3.x.x.

* Added the `resolve_distributed_claims` configuration parameter.

* The `client_id`, `client_secret`, `session_secret`, `session_redis_username`,
and `session_redis_password` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format/).

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.client_id`, `config.client_secret`, `config.session_auth`, and
 `config.session_redis_auth` parameter values will be encrypted.

  Additionally, the `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`, and `k`
  fields inside `openid_connect_jwks.previous[...].` and `openid_connect_jwks.keys[...]`
  will be marked as encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect on the nested fields in this plugin.

* The plugin now allows Redis cluster nodes to be specified by hostname through
the `session_redis_cluster_nodes` field, which is helpful if the cluster IPs are
not static.

**{{site.base_gateway}} 2.6.x**

* The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
* Added support for JWE introspection.
* Added a new parameter, `by_username_ignore_case`, which allows `consumer_by` username
values to be matched case-insensitive with identity provider (IdP) claims.
