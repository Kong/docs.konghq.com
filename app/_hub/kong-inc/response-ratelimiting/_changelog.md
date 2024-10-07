## Changelog

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the DP would report that deprecated config fields were used when configuration was pushed from the CP.
   [#13069](https://github.com/Kong/kong/issues/13069)

### {{site.base_gateway}} 3.7.x
* Fixed migration of Redis configuration.

### {{site.base_gateway}} 3.6.x

* Standardized Redis configuration across plugins. The Redis configuration now follows a common schema that is shared across other plugins.

### {{site.base_gateway}} 3.5.x

* Added support for secret rotation with Redis connections. 
[#10570](https://github.com/Kong/kong/pull/10570)

### {{site.base_gateway}}  3.1.x

* Added the `redis_ssl`, `redis_ssl_verify`, and `redis_server_name` configuration parameters.

### {{site.base_gateway}} 2.8.x

* Added the `redis_username` configuration parameter.
