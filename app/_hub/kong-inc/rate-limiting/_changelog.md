## Changelog

### {{site.base_gateway}} 3.9.x
* Fixed an issue where the returned values from `get_redis_connection()` were incorrect.
[#13613](https://github.com/Kong/kong/issues/13613)
* Fixed an issue that caused an HTTP 500 error when `hide_client_headers` was set to `true` and the request exceeded the rate limit.
[#13722](https://github.com/Kong/kong/issues/13722)

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the DP would report that deprecated config fields were used when configuration was pushed from the CP.
   [#13069](https://github.com/Kong/kong/issues/13069)

### {{site.base_gateway}} 3.7.x
* Fixed migration of Redis configuration.

### {{site.base_gateway}} 3.6.x
* This plugin can now be scoped to consumer groups.
* Standardized Redis configuration across plugins. The Redis configuration now follows a common schema that is shared across other plugins.
* The plugin now provides better accuracy in counters when `sync_rate` is used with the Redis policy.
[#11859](https://github.com/Kong/kong/issues/11859)
* Fixed an issue where all counters were synced to the same database at the same rate.
[#12003](https://github.com/Kong/kong/issues/12003)

### {{site.base_gateway}} 3.1.x
* Added the ability to customize the error code and message with
the configuration parameters `error_code` and `error_message`.

### {{site.base_gateway}} 2.8.x

* Added the `redis_username` configuration parameter.

### {{site.base_gateway}}  2.7.x

* Added the `redis_ssl`, `redis_ssl_verify`, and `redis_server_name` configuration parameters.

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/api/admin-ee/latest/#/Consumers/list-consumer/
