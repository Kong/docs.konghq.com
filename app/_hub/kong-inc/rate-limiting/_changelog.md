## Changelog

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
