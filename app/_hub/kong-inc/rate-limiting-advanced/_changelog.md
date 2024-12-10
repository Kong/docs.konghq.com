## Changelog

### {{site.base_gateway}} 3.9.x
* Added the new configuration field `lock_dictionary_name` to support specifying an independent shared memory for storing locks.
* Added support for authentication from Kong Gateway to Envoy Proxy.
* Added support for combining multiple identifier items with the new configuration field `compound_identifier`.
* Fixed an issue where counters of the overriding consumer groups weren't fetched when the `window_size` was different and the workspace was non-default.
* Fixed an issue where a warn log was printed when `event_hooks` was disabled.
* Fixed an issue where, if multiple plugin instances sharing the same namespace enforced consumer groups and different `window_size`s were used in the consumer group overriding configs, then the rate limiting of some consumer groups would fall back to the `local` strategy. Now, every plugin instance sharing the same namespace can set a different `window_size`.
* Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.
* Fixed an issue where plugin-stored items with a long expiration time caused `no memory` errors.

### {{site.base_gateway}} 3.8.x
* Added the Redis `cluster_max_redirections` configuration option.
* Timer spikes no longer occur when there is network instability with the central data store.
* Fixed an issue where, if the `window_size` in the consumer group overriding config was different 
  from the `window_size` in the default config, the rate limiting of that consumer group would fall back to local strategy.
* Fixed an issue where the sync timer could stop working due to a race condition.

### {{site.base_gateway}} 3.7.x
* Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
  The original interfaces remain unchanged for backward compatibility. 

  If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
  `'local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")'`.
  The old interface will be removed in the upcoming major release.

* Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.
* Fixed an issue with `sync_rate` setting being used with the `redis` strategy. 
  If the Redis connection is interrupted while `sync_rate = 0`, the plugin now accurately falls back to the `local` strategy.
* Fixed an issue where, if `sync_rate` was changed from a value greater than `0` to `0`, the namespace was cleared unexpectedly.
* Fixed some timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
* The plugin now creates counter syncing timers during plugin execution instead of plugin creation to reduce some meaningless error logs.
* Fixed an issue where {{site.base_gateway}} produced a log of error log entries when multiple Rate Limiting Advanced plugins shared the same namespace.

### {{site.base_gateway}} 3.6.x
* Enhanced the resolution of the RLA sliding window weight.
* The plugin now checks for query errors in the Redis pipeline.
* The plugin now checks if `sync_rate` is `nil` or `null` when calling the `configure()` phase. 
If it is `nil` or `null`, the plugin skips the sync with the database or with Redis.

### {{site.base_gateway}} 3.4.x
* The `redis` strategy now catches strategy connection failures.

* The `/consumer_groups/:id/overrides` endpoint has been deprecated. While this endpoint will still function, we strongly recommend transitioning to the new and improved method for managing consumer groups, as documented in the [Enforcing rate limiting tiers with the Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/how-to/) guide. You can also find detailed information on creating consumer groups in the [API Documentation](/gateway/api/admin-ee/3.4.0.x/#/default/post-consumer_groups).

* Fixed an issue that impacted the accuracy with the `redis` policy.
  [#10559](https://github.com/Kong/kong/pull/10559)

### {{site.base_gateway}} 3.2.1
* The shared Redis connector now supports username + password authentication for cluster connections, improving on the existing single-node connection support. This automatically applies to all plugins using the shared Redis configuration.

### {{site.base_gateway}} 3.1.x
* Added the ability to customize the error code and message with
the configuration parameters `error_code` and `error_message`.

### {{site.base_gateway}} 3.0.x

* {{site.base_gateway}} now disallows enabling the plugin if the `cluster`
strategy is set with DB-less or hybrid mode.

### {{site.base_gateway}} 2.8.x

* Added the `redis.username` and `redis.sentinel_username` configuration parameters.

* The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be securely stored as
[secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

### {{site.base_gateway}} 2.7.x

* Added the `enforce_consumer_groups` and `consumer_groups` configuration parameters.

### {{site.base_gateway}} 2.5.x

* Deprecated the `timeout` field and replaces it with three precise options: `connect_timeout`, `read_timeout`, and `send_timeout`.
* Added `redis.keepalive_pool`, `redis.keepalive_pool_size`, and `redis.keepalive_backlog` configuration options.
* `ssl_verify` and `server_name` configuration options now support Redis Sentinel-based connections.

### {{site.base_gateway}} 2.2.x
* Added the `redis.ssl`, `redis.ssl_verify`, and `redis.server_name` parameters for configuring TLS connections.
