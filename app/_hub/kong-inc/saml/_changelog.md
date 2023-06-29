## Changelog

**{{site.base_gateway}} 3.2.x**
* The plugin has been updated to use version 4.0.0 of the `lua-resty-session` library. This introduced several new features, such as the possibility to specify audiences.
The following configuration parameters were affected:

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
