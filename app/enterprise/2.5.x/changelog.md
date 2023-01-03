---
title: Kong Gateway Changelog
---

<!-- vale off -->

## 2.5.1.2
**Release Date:** 2021/11/18

### Fixes

#### Enterprise
- Fixed an issue with Vitals report generation. If running Vitals with InfluxDB
and attempting to generate a report containing any status codes outside of
2XX, 4XX, or 5XX, report generation would fail. With this fix, proxied traffic
outside of the expected codes will not cause errors, and instead appear as
count totals in Vitals reports.

- Fixed a latency issue in hybrid mode. Previously, applying a large number of
configuration changes to a Data Plane simultaneously caused high latency in all
upstream requests.

- Fixed accessibility issues related to non-unique IDs in the Dev Portal.

- When using OpenID Connect as the Dev Portal authentication method, updates to
Developers now correctly propagate to their associated Consumers.

## 2.5.1.1
**Release Date:** 2021/10/22

### Fixes

#### Enterprise
- This release includes a fix for an issue with the Vitals InfluxDB timestamp generation when inserting metrics.
- Kong Gateway now displays a DEBUG log message alerting users Kong Vitals is not enabled when running Kong Gateway (Enterprise) in "free" mode.
- Fixes an issue where keyring data was not being properly generated and activated
  on a Kong Gateway process start (for example, `kong start`).
- Kong Gateway now returns keyring-encrypted fields early when a decrypt attempt is made, giving you time
  to import the keys so Kong Gateway can recognize the decrypted fields. Before if there were data fields
  keyring-encrypted in the database, Kong Gateway attempted to decrypt them on the `init*` phases (`init` or `init_worker`
  phases - when the Kong process is started), and you would get errors like "no request found".
  **Keys must still be imported after the Kong process is started.**
- The [Keyring Encryption](/enterprise/2.6.x/db-encryption/) feature is no longer in an alpha quality state.
- When using Redis Cluster with a Kong Gateway plugin and the cluster nodes are configured by hostname,
  if the entire cluster is rebooted and appears on new IP addresses, now the connection will eventually self heal once DNS is updated.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  The plugin now allows Redis Cluster nodes to be specified by hostname, which is helpful if the cluster IPs are not static.

## 2.5.1.0
**Release Date** 2021/09/08

### Dependencies
- Bumped `grpcurl` from 1.8.1 to 1.8.2 [#7659](https://github.com/Kong/kong/pull/7659)
- Bumped `lua-resty-openssl` from 0.7.3 to 0.7.4 [#7657](https://github.com/Kong/kong/pull/7657)
- Bumped `penlight` from 1.10.0 to 1.11.0 [#7736](https://github.com/Kong/kong/pull/7736)
- Bumped `luasec` from 1.0.1 to 1.0.2 [#7750](https://github.com/Kong/kong/pull/7750)
- Bumped `OpenSSL` from 1.1.1k to 1.1.1l [#7767](https://github.com/Kong/kong/pull/7767)

### Fixes

#### Core
- You can now successfully delete workspaces after deleting all entities associated with that workspace.
  Previously, Kong Gateway was not correctly cleaning up parent-child relationships. For example, creating
  an Admin also creates a Consumer and RBAC user. When deleting the Admin, the Consumer and RBAC user are
  also deleted, but accessing the `/workspaces/workspace_name/meta` endpoint would show counts for Consumers
  and RBAC users, which prevented the workspace from being deleted. Now deleting entities correctly updates
  the counts, allowing an empty workspace to be deleted. [#7560](https://github.com/Kong/kong/pull/7560)
- When an upstream event is received from the DAO, `handler.lua` now gets the workspace ID from the request
  and adds it to the upstream entity that will be used in the worker and cluster events. Before this change,
  when posting balancer CRUD events, the workspace ID was lost and the balancer used the default
  workspace ID as a fallback. [#7778](https://github.com/Kong/kong/pull/7778)

#### CLI
- Fixes regression that included an issue where Go plugins prevented CLI commands like `kong config parse`
  or `kong config db_import` from working as expected. [#7589](https://github.com/Kong/kong/pull/7589)

#### Admin API
- Kong Gateway now validates workspace names, preventing the use of reserved names on workspaces.
  [#7380](https://github.com/Kong/kong/pull/7380)

#### Plugins
- [Azure Functions](/hub/kong-inc/azure-functions) (`azure-functions`)
  This release updates the `lua-resty-http` dependency to v0.16.1, which means the plugin no longer
  uses the deprecated functions.


## 2.5.0.2
**Release Date** 2021/09/02

### Fixes

#### Enterprise
- This release fixes a regression in the Kong Dev Portal templates that removed dynamic menu navigation and other improvements
from portals created in Kong Gateway v2.5.0.1.

#### Plugins
- [Mocking](/hub/kong-inc/mocking) (`mocking`)
  This release fixes special character handling in path matching for the plugin. Before, if a path contained a hyphen
  the plugin failed to match the path.

## 2.5.0.1
**Release Date** 2021/08/18

### Fixes

#### Enterprise
- Updates Kong Dev Portal templates' JQuery dependency to v3.6.0, improving security.
- Now, bootstrap migrations for multi-node Apache Cassandra clusters work as expected.
  With this fix, inserts are performed after schema agreement.
- Updates Nettle dependency version from `3.7.2` to `3.7.3`, fixing bugs that could cause
  RSA decryption functions to crash with invalid inputs.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  With this fix, when the OpenID Connect plugin is configured with a `config.anonymous` consumer and
  `config.scopes_required` is set, a token missing the required scopes will have the anonymous consumer
  headers set when sent to the upstream.

## 2.5.0.0
**Release Date** 2021/08/03

### Features

#### Enterprise
- This release includes event hooks, a new entity that represents the relationship between an event (source and event) and an action (handler).
  Depending on the handler, an event hook will execute an action with the event's associated data when it is triggered. There
  are four supported handlers:
  - webhook
  - custom-webhook
  - log
  - lambda<br>
  See the event hooks [reference](/enterprise/2.5.x/admin-api/event-hooks/reference) and
  [examples](/enterprise/2.5.x/admin-api/event-hooks/examples) documentation for more information.
- For users running in free mode, Kong has updated the top banner to include information on the benefits of and a link for updating to Konnect.

#### Core
- Control planes can now send updates to new data planes even if the control planes lose connection to the database.
  [#6938](https://github.com/kong/kong/pull/6938)
- Kong now automatically adds `cluster_cert`(`cluster_mtls=shared`) or `cluster_ca_cert`(`cluster_mtls=pki`) into
  `lua_ssl_trusted_certificate` when operating in hybrid mode. Before, hybrid mode users needed to configure
  `lua_ssl_trusted_certificate` manually as a requirement for Lua to verify the control plane’s certificate.
  See [Starting Data Plane Nodes](/gateway-oss/2.5.x/hybrid-mode/#starting-data-plane-nodes)
  in the Hybrid Mode guide for more information. [#7044](https://github.com/kong/kong/pull/7044)
- New `declarative_config_string` option allows loading declarative configurations directly from a string. See the
  [Loading The Declarative Configuration File](/enterprise/2.5.x/db-less-and-declarative-config/#loading-the-declarative-configuration-file)
  section of the DB-less and Declarative Configuration guide for more information.
  [#7379](https://github.com/kong/kong/pull/7379)

#### PDK
- The Kong Gateway PDK now accepts tables in the response body for Stream subsystems, just as it does for the HTTP subsystem.
  Before, developers had to check the subsystem if they wrote code that used the `exit()` function before calling it,
  because passing the wrong argument type would break the request response.
  [#7082](https://github.com/kong/kong/pull/7082)

#### Plugins
- [HMAC Authentication](/hub/kong-inc/hmac-auth) (`hmac-auth`)
  The HMAC Authentication plugin now includes support for the `@request-target` field in the signature
  string. Before, the plugin used the `request-line` parameter, which contains the HTTP request method, request URI, and
  the HTTP version number. The inclusion of the HTTP version number in the signature caused requests to the same target
  with different request methods(such as HTTP/2) to have different signatures. The newly added `request-target` field
  only includes the lowercase request method and request URI when calculating the hash, avoiding those issues.
  See the [HMAC Authentication](/hub/kong-inc/hmac-auth) documentation for more information.
  [#7037](https://github.com/kong/kong/pull/7037)
- [Syslog](/hub/kong-inc/syslog) (`syslog`)
  The Syslog plugin now includes facility configuration options, which are a way for the plugin to group
  error messages from different sources. See the description for the facility parameter in the
  Parameters section of the [Syslog documentation](/hub/kong-inc/syslog) for more
  information. [#6081](https://github.com/kong/kong/pull/6081).
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`) The Prometheus plugin now exposes connected data planes'
  status on the  control plane. New metrics include the following:  `data_plane_last_seen`, `data_plane_config_hash`
  and `data_plane_version_compatible`. These metrics can be useful for troubleshooting when data planes have inconsistent
  configurations across the cluster. See the [Available metrics](/hub/kong-inc/prometheus/#available-metrics) section
  of the Prometheus plugin documentation for more information. [#98](https://github.com/Kong/kong-plugin-prometheus/pull/98)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  The Zipkin plugin now includes the following tags: `kong.route`,`kong.service_name`, and `kong.route_name`.
  See the [Spans](/hub/kong-inc/zipkin/#spans) section of the Zipkin plugin documentation for more information.
  [#115](https://github.com/Kong/kong-plugin-zipkin/pull/115)
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
   and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced) (`proxy-cached-advanced`)
  - This release deprecates the `timeout` field and replaces it with three precise options:
    `connect_timeout`, `read_timeout`, and `send_timeout`. Currently, if these options are not set, the
    value of `timeout` will be used for all (or its default value of 2000ms). The `connect_timeout`, `read_timeout`,
    and `send_timeout` fields are mutually required fields. The `timeout` field will be removed from the product in version 3.0.x.x.
  - This release also includes new configuration options `keepalive_pool`, `keepalive_pool_size`, and `keepalive_backlog`. These options
    relate to [Openresty’s Lua INGINX module’s](https://github.com/openresty/lua-nginx-module/#tcpsockconnect) `tcp:connect` options.
- [ACME](/hub/kong-inc/acme) (`acme`)
  The ACME plugin now waits before signaling a challenge in hybrid mode to ensure the control plane propagates any updated
  configuration data. The client certificate will now be stored in external storage in hybrid mode with a warning being
  emitted if the ACME plugin is configured to use `shm` storage. Additional checks have also been added during the sanity test
  which can be run on a Kong Gateway setup before creating any certificates.
  [#74](https://github.com/Kong/kong-plugin-acme/pull/74)


#### Hybrid Mode
- Kong Gateway now exposes an upstream health checks endpoint (using the status API) on the data plane for better
  observability. See [Readonly Status API endpoints on Data Plane](/enterprise/2.5.x/deployment/hybrid-mode/#readonly-status-api-endpoints-on-data-plane)
  in the Hybrid Mode guide for more information. [#7429](https://github.com/Kong/kong/pull/7429)
- Control planes are now more lenient when checking data planes' compatibility in hybrid mode. See the
  [Version compatibility](/enterprise/2.5.x/deployment/hybrid-mode/#version-compatibility)
  section of the Hybrid Mode guide for more information. [#7488](https://github.com/Kong/kong/pull/7488)

### Dependencies
- Bumped `openresty` from 1.19.3.1 to 1.19.3.2 [#7430](https://github.com/kong/kong/pull/7430)
- Bumped `luasec` from 1.0 to 1.0.1 [#7126](https://github.com/kong/kong/pull/7126)
- Bumped `luarocks` from 3.5.0 to 3.7.0 [#7043](https://github.com/kong/kong/pull/7043)
- Bumped `grpcurl` from 1.8.0 to 1.8.1 [#7128](https://github.com/kong/kong/pull/7128)
- Bumped `penlight` from 1.9.2 to 1.10.0 [#7127](https://github.com/Kong/kong/pull/7127)
- Bumped `lua-resty-dns-client` from 6.0.0 to 6.0.2 [#7539](https://github.com/Kong/kong/pull/7539)
- Bumped `kong-plugin-acme` from 0.2.14 to 0.2.15 [#74](https://github.com/Kong/kong-plugin-acme/pull/74)
- Bumped `kong-plugin-prometheus` from 1.2 to 1.3 [#7415](https://github.com/Kong/kong/pull/7415)
- Bumped `kong-plugin-zipkin` from 1.3 to 1.4 [#7455](https://github.com/Kong/kong/pull/7455)
- Bumped `lua-resty-openssl` from 0.7.2 to 0.7.3 [#7509](https://github.com/Kong/kong/pull/7509)
- Bumped `lua-resty-healthcheck` from 1.4.1 to 1.4.2 [#7511](https://github.com/Kong/kong/pull/7511)
- Bumped `hmac-auth` from 2.3.0 to 2.4.0 [#7522](https://github.com/Kong/kong/pull/7522)
- Pinned `lua-protobuf` to 0.3.2 (previously unpinned) [#7079](https://github.com/kong/kong/pull/7079)

### Fixes

#### Enterprise
- Renamed the property identifying control planes in hybrid mode when using Kong Vitals with
  anonymous reports enabled. Before, users received an error on their control planes about
  a function that could not be used.
- Kong Gateway now starts even when `SSL_CIPHER_SUITE` is set to `modern` when the Kong Dev Portal is enabled.
  Before, Kong Gateway would fail to start with an NGINX configuration error, "invalid number of arguments in
  'ssl_ciphers' directive".
- Updated `lua-resty-openssl` to v0.7.3, fixing an error users were encountering when trying
  to synchronize configurations from control planes to data planes. Users were seeing the following errors
  in the ingress controller logs, indicating their configurations were not successfully being pushed to the
  Kong Gateway proxy node: "failed to update kong configuration", "declarative config is invalid," and "failed to sync".
- Users can now set `enforce_rbac` to `both` and still be able to log into Kong Gateway's UI, Kong Manager.
- Updated `lua-resty-healthcheck` to v1.4.2 which fixes an error where Kong would spam ‘nothing to do’ in
  the logs multiple times per second, slowing down performance.
- Updated `lua-resty-dns-client` to v6.0.1 which fixes an issue users were encountering when
  adding more than 1000 endpoints, resulting in the error `lua_max_running_timers are not enough` throughout the logs.
- Kong Gateway now ensures proper keyspace, table, and table names are used when performing migrations on Apache Cassandra v2.2.
- This release includes an update that circumvents a potential security issue with a buffer overflow when validating the Kong Gateway license.
- Users can now successfully delete workspaces after deleting all entities associated with that workspace.
  Previously, Kong Gateway was not correctly cleaning up parent-child relationships. For example, creating
  an Admin also creates a Consumer and RBAC user. When deleting the Admin, the Consumer and RBAC user are also
  deleted, but accessing the `/workspaces/workspace_name/meta` endpoint would show counts for Consumers and RBAC
  users, which prevented the workspace from being deleted. Now deleting entities correctly updates the counts,
  allowing an empty workspace to be deleted.

#### Core
- When using DB-less mode, `select_by_cache_key` now finds entities by using the provided `field` directly
  in ` select_by_key` and does not complete unnecessary cache reads. [#7146](https://github.com/kong/kong/pull/7146)
- Kong can now finish initialization even if a plugin’s `init_worker` handler fails, improving stability.
  [#7099](https://github.com/kong/kong/pull/7099)
- TLS keepalive requests no longer share their context. Before when two calls were made to the same "server+hostname"
  but different routes and using a keepalive connection, plugins that were active in the first call were also sometimes
  (incorrectly) active in the second call. The wrong plugin was active because Kong was passing context in the SSL phase
  to the plugin iterator, creating connection-wide structures in that context, which was then shared between different
  keepalive requests. With this fix, Kong does not pass context to plugin iterators with the `certificate` phase,
  avoiding plugin mixups.[#7102](https://github.com/kong/kong/pull/7102)
- The HTTP status 405 is now handled by Kong's error handler. Before accessing Kong Gateway using the TRACE method returned
  a standard NGINX error page because the 405 wasn’t included in the error page settings of the NGINX configuration.
  [#6933](https://github.com/kong/kong/pull/6933).
- Custom `ngx.sleep` implementation in `init_worker` phase now invokes `update_time` in order to prevent time-based deadlocks
  [#7532](https://github.com/Kong/kong/pull/7532)
- `Proxy-Authorization` header is removed when it is part of the original request **or** when a plugin sets it to the
  same value as the original request
  [#7533](https://github.com/Kong/kong/pull/7533)
- `HEAD` requests don't provoke an error when a Plugin implements the `response` phase
  [#7535](https://github.com/Kong/kong/pull/7535)

#### Hybrid Mode
- Control planes no longer perform health checks on CRUD upstreams’ and targets’ events.
  [#7085](https://github.com/kong/kong/pull/7085)
- To prevent unnecessary cache flips on data planes, Kong now checks `dao:crud` events more strictly and has
  a new cluster event, `clustering:push_config` for configuration pushes. These updates allow Kong to filter
  invalidation events that do not actually require a database change. Furthermore, the clustering module does
  not subscribe to the generic `invalidations` event, which has a more broad scope than database entity invalidations.
  [#7112](https://github.com/kong/kong/pull/7112)
- Data planes ignore null fields coming from control planes when doing schema validation.
  [#7458](https://github.com/Kong/kong/pull/7458)
- Kong Gateway now includes the source in error logs produced by control planes.
  [#7494](https://github.com/Kong/kong/pull/7494)
- With this release, data plane config hash calculation and checking is more consistent.
  It is impervious to changes in table iterations. Hashes are calculated in both the control plane
  and the data plane, and data planes send pings more immediately and with the new hash.
  [#7483](https://github.com/Kong/kong/pull/7483)

#### Balancer
- All targets are returned by the Admin API now, including targets with a `weight=0`, or disabled targets.
  Before disabled targets were not included in the output when users attempted to list all targets. Then
  when users attempted to add the targets again, they received an error message telling them the targets already existed.
  [#7094](https://github.com/kong/kong/pull/7094)
- Upserting existing targets no longer fails.  Before, because of updates made to target configurations since Kong Gateway v2.2.0,
  upserting older configurations would fail. This fix allows older configurations to be imported.
  [#7052](https://github.com/kong/kong/pull/7052)
- The last balancer attempt is now correctly logged. Before balancer tries were saved when retrying, which meant the last
  retry state was not saved since there were no more retries. This update saves the failure state so it can be correctly logged.
  [#6972](https://github.com/kong/kong/pull/6972)
- Kong Gateway now ensures that the correct upstream event is removed from the queue when updating the balancer state.
  [#7103](https://github.com/kong/kong/pull/7103)

#### CLI
- The `prefix` argument in the `kong stop` command now takes precedence over environment variables,
  as it does in the `kong start` command. [#7080](https://github.com/kong/kong/pull/7080)

#### Configuration
- Declarative configurations now correctly parse custom plugin entities schemas with attributes called "plugins". Before
  when using declarative configurations, users with custom plugins that included a "plugins" field would encounter startup
  exceptions. With this fix, the declarative configuration can now distinguish between plugins schema and custom plugins fields.
  [#7412](https://github.com/kong/kong/pull/7412)
- The stream access log configuration options are now properly separated from the HTTP access log. Before when users
  used Kong Gateway with TCP, they couldn’t use a custom log format. With this fix, `proxy_stream_access_log` and `proxy_stream_error_log`
  have been added to differentiate the Stream access log from the HTTP subsystem. See
  [`proxy_stream_access_log`](/enterprise/2.5.x/property-reference/#proxy_stream_access_log)
  and [`proxy_stream_error_log`](/enterprise/2.5.x/property-reference/#proxy_stream_error_log) in the Configuration
  Property Reference for more information. [#7046](https://github.com/kong/kong/pull/7046)

#### Migrations
- Kong Gateway no longer assumes that `/?/init.lua` is in the Lua path when doing migrations. Before, when users created
  a custom plugin in a non-standard location and set `lua_package_path = /usr/local/custom/?.lua`, migrations failed.
  Migrations failed because the Kong core file is `init.lua` and it is required as part of `kong.plugins.<name>.migrations`.
  With this fix, migrations no longer expect `init.lua` to be a part of the path. [#6993](https://github.com/kong/kong/pull/6993)
- Kong Gateway no longer emits errors when doing `ALTER COLUMN` operations in Apache Cassandra 4.0.
  [#7490](https://github.com/Kong/kong/pull/7490)
  {:.important}
  > **Important:** Even with this fix, Cassandra 4.0 is not yet fully supported.

#### PDK
- With this update, `kong.response.get_XXX()` functions now work in the log phase on external plugins. Before
  `kong.response.get_XXX()` functions required data from the response object, which was not accessible in the
  post-log timer used to call log handlers in external plugins. Now these functions work by accessing the required
  data from the set saved at the start of the log phase.
  See [`kong.response`](/enterprise/2.4.x/pdk/kong.response)
  in the Plugin Development Kit for more information. [#7048](https://github.com/kong/kong/pull/7048)
- External plugins handle certain error conditions better while the Kong Gateway balancer is being refreshed. Before
  when an `instance_id` of an external plugin changed, and the plugin instance attempted to reset and retry,
  it was failing because of a typo in the comparison. [#7153](https://github.com/kong/kong/pull/7153).
- With this release, `kong.log`'s phase checker now accounts for the existence of the new `response` pseudo-phase.
  Before users may have erroneously received a safe runtime error for using a function out-of-place in the PDK.
  [#7109](https://github.com/kong/kong/pull/7109)
- Kong Gateway no longer sandboxes the `string.rep` function. Before `string.rep` was sandboxed to disallow a single operation
  from allocating too much memory. However, a single operation allocating too much memory is no longer an issue
  because in LuaJIT there are no debug hooks and it is trivial to implement a loop to allocate memory on every single iteration.
  Additionally, since the `string` table is global and obtainable by any sandboxed string, its sandboxing provoked issues on global state.
  [#7167](https://github.com/kong/kong/pull/7167)
- The `kong.pdk.node` function can now correctly iterates over all the shared dict metrics. Before this fix,
  users using the `kong.pdk.node` function could not see all shared dict metrics under the Stream subsystem.
  [#7078](https://github.com/kong/kong/pull/7078)

#### Plugins
- [LDAP Authentication](/hub/kong-inc/ldap-auth) (`ldap-auth`)
  The LDAP Authentication schema now includes a default value for the `config.ldap_port` parameter
  that matches the documentation. Before the plugin documentation
  [Parameters](/hub/kong-inc/ldap-auth/#parameters)
  section included a reference to a default value for the LDAP port; however, the default value was not included in the plugin schema.
  [#7438](https://github.com/kong/kong/pull/7438)
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  The Prometheus plugin exporter now attaches subsystem labels to memory stats. Before, the HTTP
  and Stream subsystems were not distinguished, so their metrics were interpreted as duplicate entries by Prometheus.
  [#118](https://github.com/Kong/kong-plugin-prometheus/pull/118)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The plugin now works even when `balancer_latency` is `nil`.
  - The plugin no longer shares context between several Zipkin plugins. Before the plugin was using `ngx.ctx` exclusively,
    even in a global context, which meant more than one instance of the Zipkin plugin would override each other. Now the plugin
    uses `kong.ctx.plugin` to hold the `zipkin` table, instead of `ngx.ctx`.
- [External plugins](/enterprise/2.5.x/external-plugins)
  This release includes better error messages when external plugins fail to start. With this fix, Kong Gateway detects the return code
  127 (command not found), allowing it to display an appropriate error message, "external plugin server start command exited
  with command not found". [#7523](https://github.com/Kong/kong/pull/7523)
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced) (`proxy-cached-advanced`)
  Kong now offers `ssl_verify` and `server_name` options for Redis Sentinel-based connections.
  Before these options were only offered for Cluster or plain Redis connections, causing SSL to fail in Redis Sentinel configurations.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  This release fixes an error in the plugin where counters would not sync after a `PATCH` request.


## 2.5.0.0 (beta1)
**Release Date** 2021/07/13

### Features

#### Enterprise
- For users running in free mode, Kong has updated the top banner to include information on the benefits of and a link for updating to Konnect.
- This release includes several updates to Kong Manager, the Kong Gateway UI, including the following:
  - Support for the Mocking and Response Rate Limiting plugins.
  - Updates to the Konnect Plugin page, allowing users to:
    - Create new plugin associated with `consumer` or `global`.
    - View plugin details by clicking the row.
    - Edit and delete plugins that are not associated with a `service` or `route`.
    - Click the `applied to` entity type (`service`, `route`, or `consumer`) link to view the details of that entity.
    - Sort the columns.
    - Search by ID.

#### Core
- Control Planes can now send updates to new data planes even if the control planes lose connection to the database.
  [#6938](https://github.com/kong/kong/pull/6938)
- Kong now automatically adds `cluster_cert`(`cluster_mtls=shared`) or `cluster_ca_cert`(`cluster_mtls=pki`) into
  `lua_ssl_trusted_certificate` when operating in Hybrid mode. Before, Hybrid mode users needed to configure
  `lua_ssl_trusted_certificate` manually as a requirement for Lua to verify the Control Plane’s certificate.
  See [Starting Data Plane Nodes](/gateway-oss/2.5.x/hybrid-mode/#starting-data-plane-nodes)
  in the Hybrid Mode guide for more information. [#7044](https://github.com/kong/kong/pull/7044)
- New `declarative_config_string` option allows loading a declarative config directly from a string. See the
  [Loading The Declarative Configuration File](/gateway-oss/2.5.x/db-less-and-declarative-config/#loading-the-declarative-configuration-file) section of the DB-less and Declarative Configuration guide for more information.
  [#7379](https://github.com/kong/kong/pull/7379)

#### PDK
- The Kong PDK now accepts tables in the response body for Stream subsystems, just as it does for the HTTP subsystem.
  Before developers had to check the subsystem if they wrote code that used the `exit()` function before calling it,
  because passing the wrong argument type would break the request response.
  [#7082](https://github.com/kong/kong/pull/7082)

#### Plugins
- [HMAC Authentication](/hub/kong-inc/hmac-auth) (`hmac-auth`)
  The HMAC Authentication plugin now includes support for the `@request-target` field in the signature
  string. Before, the plugin used the `request-line` parameter, which contains the HTTP request method, request URI, and
  the HTTP version number. The inclusion of the HTTP version number in the signature caused requests to the same target
  but using different request methods(such as HTTP/2) to have different signatures. The newly added request-target field
  only includes the lowercase request method and request URI when calculating the hash, avoiding those issues.
  See the [HMAC Authentication](/hub/kong-inc/hmac-auth) documentation for more information.
  [#7037](https://github.com/kong/kong/pull/7037)
- [Syslog](/hub/kong-inc/syslog) (`syslog`)
  The Syslog plugin now includes facility configuration options, which are a way for the plugin to group
  error messages from different sources. See the description for the facility parameter in the
  Parameters section of the [Syslog documentation](/hub/kong-inc/syslog) for more
  information. [#6081](https://github.com/kong/kong/pull/6081).
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`) The Prometheus plugin now exposes connected data planes'
  status on the  control plane. New metrics include the following:  `data_plane_last_seen`, `data_plane_config_hash` and `data_plane_version_compatible`. These metrics can be useful for troubleshooting when data planes have inconsistent configurations across the cluster. See the [Available metrics](/hub/kong-inc/prometheus/#available-metrics) section of the Prometheus plugin documentation for more information. [#98](https://github.com/Kong/kong-plugin-prometheus/pull/98)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  The Zipkin plugin now includes the following tags: `kong.route`,`kong.service_name` and `kong.route_name`.
  See the [Spans](/hub/kong-inc/zipkin/#spans) section of the Zipkin plugin documentation for more information.
  [#115](https://github.com/Kong/kong-plugin-zipkin/pull/115)

#### Hybrid Mode
- Kong now exposes an upstream health checks endpoint (using the status API) on the data plane for better
  observability. See [Readonly Status API endpoints on Data Plane](/gateway-oss/2.5.x/hybrid-mode/#readonly-status-api-endpoints-on-data-plane)
  in the Hybrid Mode guide for more information. [#7429](https://github.com/Kong/kong/pull/7429)
- Control Planes are now more lenient when checking Data Planes' compatibility in Hybrid mode. See the
  [Version compatibility](/gateway-oss/2.5.x/hybrid-mode/#version_compatibility)
  section of the Hybrid Mode guide for more information. [#7488](https://github.com/Kong/kong/pull/7488)

### Dependencies
- Bumped `openresty` from 1.19.3.1 to 1.19.3.2 [#7430](https://github.com/kong/kong/pull/7430)
- Bumped `luasec` from 1.0 to 1.0.1 [#7126](https://github.com/kong/kong/pull/7126)
- Bumped `luarocks` from 3.5.0 to 3.7.0 [#7043](https://github.com/kong/kong/pull/7043)
- Bumped `grpcurl` from 1.8.0 to 1.8.1 [#7128](https://github.com/kong/kong/pull/7128)
- Bumped `penlight` from 1.9.2 to 1.10.0 [#7127](https://github.com/Kong/kong/pull/7127)
- Bumped `lua-resty-dns-client` from 6.0.0 to 6.0.2 [#7539](https://github.com/Kong/kong/pull/7539)
- Bumped `kong-plugin-prometheus` from 1.2 to 1.3 [#7415](https://github.com/Kong/kong/pull/7415)
- Bumped `kong-plugin-zipkin` from 1.3 to 1.4 [#7455](https://github.com/Kong/kong/pull/7455)
- Bumped `lua-resty-openssl` from 0.7.2 to 0.7.3 [#7509](https://github.com/Kong/kong/pull/7509)
- Bumped `lua-resty-healthcheck` from 1.4.1 to 1.4.2 [#7511](https://github.com/Kong/kong/pull/7511)
- Bumped `hmac-auth` from 2.3.0 to 2.4.0 [#7522](https://github.com/Kong/kong/pull/7522)
- Pinned `lua-protobuf` to 0.3.2 (previously unpinned) [#7079](https://github.com/kong/kong/pull/7079)

### Fixes

#### Enterprise
- Renamed the property identifying control planes in hybrid mode when using Vitals with
  anonymous reports enabled. Before, users received an error on their control planes about
  a function that could not be used.
- Kong now starts even when `SSL_CIPHER_SUITE` is set to `modern` when the Kong Dev Portal is enabled.
  Before, Kong would fail to start with an NGINX configuration error, "invalid number of arguments in
  'ssl_ciphers' directive".
- Updated `lua-resty-openssl` to v0.7.3, fixing an error users were encountering when trying
  to synchronize configurations from control planes to data planes. Users were seeing the following errors
  in the ingress controller logs, indicating their configurations were not successfully being pushed to the
  Kong proxy node: "failed to update kong configuration","declarative config is invalid," and "failed to sync".
- Users can now set `enforce_rbac` to `both` and still be able to log into Kong Gateway's UI, Kong Manager.
- Updated `lua-resty-healthcheck` to v1.4.2 which fixes an error where Kong would spam ‘nothing to do’ in
  the logs multiple times per second, slowing down performance.
- Updated `lua-resty-dns-client` to v6.0.1 which fixes an issue users were encountering when
  adding more than 1000 endpoints, resulting in the error `lua_max_running_timers are not enough` throughout the logs.

#### Core
- When using DB-less mode, `select_by_cache_key` now finds entities by using the provided `field` directly
  in ` select_by_key` and does not complete unnecessary cache reads. [#7146](https://github.com/kong/kong/pull/7146)
- Kong can now finish initialization even if a plugin’s `init_worker` handler fails, improving stability.
  [#7099](https://github.com/kong/kong/pull/7099)
- TLS keepalive requests no longer share their context. Before when two calls were made to the same "server+hostname"
  but different routes and using a keepalive connection, plugins that were active in the first call were also sometimes
  (incorrectly) active in the second call. The wrong plugin was active because Kong was passing context in the SSL phase
  to the plugin iterator, creating connection-wide structures in that context, which was then shared between different
  keepalive requests. With this fix, Kong does not pass context to plugin iterators with the `certificate` phase,
  avoiding plugin mixups.[#7102](https://github.com/kong/kong/pull/7102)
- The HTTP status 405 is now handled by Kong's error handler. Before accessing Kong using the TRACE method returned
  a standard NGINX error page because the 405 wasn’t included in the error page settings of the NGINX configuration.
  [#6933](https://github.com/kong/kong/pull/6933).
- Custom `ngx.sleep` implementation in `init_worker` phase now invokes `update_time` in order to prevent time-based deadlocks
  [#7532](https://github.com/Kong/kong/pull/7532)
- `Proxy-Authorization` header is removed when it is part of the original request **or** when a plugin sets it to the
  same value as the original request
  [#7533](https://github.com/Kong/kong/pull/7533)
- `HEAD` requests don't provoke an error when a Plugin implements the `response` phase
  [#7535](https://github.com/Kong/kong/pull/7535)

#### Hybrid Mode
- Control planes no longer perform health checks on CRUD upstreams’ and targets’ events.
  [#7085](https://github.com/kong/kong/pull/7085)
- To prevent unnecessary cache flips on data planes, Kong now checks `dao:crud` events more strictly and has
  a new cluster event, `clustering:push_config` for configuration pushes. These updates allow Kong to filter
  invalidation events that do not actually require a database change. Furthermore, the clustering module does
  not subscribe to the generic `invalidations` event, which has a more broad scope than database entity invalidations.
  [#7112](https://github.com/kong/kong/pull/7112)
- Data Planes ignore null fields coming from control planes when doing schema validation.
  [#7458](https://github.com/Kong/kong/pull/7458)
- Kong now includes the source in error logs produced by control planes.
  [#7494](https://github.com/Kong/kong/pull/7494)
- With this release, data plane config hash calculation and checking is more consistent.
  It is impervious to changes in table iterations. Hashes are calculated in both the control plane
  and the data plane, and data planes send pings more immediately and with the new hash.
  [#7483](https://github.com/Kong/kong/pull/7483)


#### Balancer
- All targets are returned by the Admin API now, including targets with a `weight=0`, or disabled targets.
  Before disabled targets were not included in the output when users attempted to list all targets. Then
  when users attempted to add the targets again, they received an error message telling them the targets already existed.
  [#7094](https://github.com/kong/kong/pull/7094)
- Upserting existing targets no longer fails.  Before, because of updates made to target configurations since Kong v2.2.0,
  upserting older configurations would fail. This fix allows older configurations to be imported.
  [#7052](https://github.com/kong/kong/pull/7052)
- The last balancer attempt is now correctly logged. Before balancer tries were saved when retrying, which meant the last
  retry state was not saved since there were no more retries. This update saves the failure state so it can be correctly logged.
  [#6972](https://github.com/kong/kong/pull/6972)
- Kong now ensures that the correct upstream event is removed from the queue when updating the balancer state.
  [#7103](https://github.com/kong/kong/pull/7103)

#### CLI
- The `prefix` argument in the `kong stop` command now takes precedence over environment variables,
  as it does in the `kong   start` command. [#7080](https://github.com/kong/kong/pull/7080)

#### Configuration
- Declarative configurations now correctly parse custom plugin entities schemas with attributes called "plugins". Before
  when using declarative configurations, users with custom plugins that included a "plugins" field would encounter startup
  exceptions. With this fix, the declarative configuration can now distinguish between plugins schema and custom plugins fields.
  [#7412](https://github.com/kong/kong/pull/7412)
- The stream access log configuration options are now properly separated from the HTTP access log. Before when users
  used Kong with TCP, they couldn’t use a custom log format. With this fix, `proxy_stream_access_log` and `proxy_stream_error_log`
  have been added to differentiate the Stream access log from the HTTP subsystem. See
  [`proxy_stream_access_log`](/enterprise/2.4.x/property-reference/#proxy_stream_access_log)
  and [`proxy_stream_error_log`](/enterprise/2.4.x/property-reference/#proxy_stream_error_log) in the Configuration
  Property Reference for more information. [#7046](https://github.com/kong/kong/pull/7046)

#### Migrations
- Kong no longer assumes that `/?/init.lua` is in the Lua path when doing migrations. Before, when users created
  a custom plugin in a non-standard location and set `lua_package_path = /usr/local/custom/?.lua`, migrations failed.
  Migrations failed because the Kong core file is `init.lua` and it is required as part of `kong.plugins.<name>.migrations`.
  With this fix, migrations no longer expect `init.lua` to be a part of the path. [#6993](https://github.com/kong/kong/pull/6993)
- Kong no longer emits errors when doing `ALTER COLUMN` operations in Apache Cassandra 4.0.
  [#7490](https://github.com/Kong/kong/pull/7490)
  {:.important}
  > **Important:** Even with this fix, Cassandra 4.0 is not yet fully supported.

#### PDK
- With this update, `kong.response.get_XXX()` functions now work in the log phase on external plugins. Before
  `kong.response.get_XXX()` functions required data from the response object, which was not accessible in the
  post-log timer used to call log handlers in external plugins. Now these functions work by accessing the required
  data from the set saved at the start of the log phase.
  See [`kong.response`](/enterprise/2.4.x/pdk/kong.response)
  in the Plugin Development Kit for more information. [#7048](https://github.com/kong/kong/pull/7048)
- External plugins handle certain error conditions better while the Kong balancer is being refreshed. Before
  when an `instance_id` of an external plugin changed, and the plugin instance attempted to reset and retry,
  it was failing because of a typo in the comparison. [#7153](https://github.com/kong/kong/pull/7153).
- With this release, `kong.log`'s phase checker now accounts for the existence of the new `response` pseudo-phase.
  Before users may have erroneously received a safe runtime error for using a function out-of-place in the PDK.
  [#7109](https://github.com/kong/kong/pull/7109)
- Kong no longer sandboxes the `string.rep` function. Before `string.rep` was sandboxed to disallow a single operation
  from allocating too much memory. However, a single operation allocating too much memory is no longer an issue
  because in LuaJIT there are no debug hooks and it is trivial to implement a loop to allocate memory on every single iteration.
  Additionally, since the `string` table is global and obtainable by any sandboxed string, its sandboxing provoked issues on global state.
  [#7167](https://github.com/kong/kong/pull/7167)
- The `kong.pdk.node` function can now correctly iterates over all the shared dict metrics. Before this fix,
  users using the `kong.pdk.node` function could not see all shared dict metrics under the Stream subsystem.
  [#7078](https://github.com/kong/kong/pull/7078)

#### Plugins
- [LDAP Authentication](/hub/kong-inc/ldap-auth) (`ldap-auth`)
  The LDAP Authentication schema now includes a default value for the `config.ldap_port` parameter
  that matches the documentation. Before the plugin documentation
  [Parameters](/hub/kong-inc/ldap-auth/#parameters)
  section included a reference to a default value for the LDAP port; however, the default value was not included in the plugin schema.
  [#7438](https://github.com/kong/kong/pull/7438)
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  The Prometheus plugin exporter now attaches subsystem labels to memory stats. Before, the HTTP
  and Stream subsystems were not distinguished, so their metrics were interpreted as duplicate entries by Prometheus.
  [#118](https://github.com/Kong/kong-plugin-prometheus/pull/118)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The plugin now works even when `balancer_latency` is `nil`.
  - The plugin no longer shares context between several Zipkin plugins. Before the plugin was using `ngx.ctx` exclusively,
    even in a global context, which meant more than one instance of the Zipkin plugin would override each other. Now the plugin
    uses `kong.ctx.plugin` to hold the `zipkin` table, instead of `ngx.ctx`.
- [External plugins](/enterprise/2.4.x/external-plugins)
  This release includes better error messages when external plugins fail to start. With this fix, Kong detects the return code
  127 (command not found), allowing it to display an appropriate error message, "external plugin server start command exited
  with command not found". [#7523](https://github.com/Kong/kong/pull/7523)

