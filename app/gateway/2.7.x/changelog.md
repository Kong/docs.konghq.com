---
title: Kong Gateway Changelog
---

<!-- vale off -->

## 2.7.2.0
**Release Date** 2022/04/07

### Fixes

#### Enterprise

* Fixed an issue with RBAC where `endpoint=/kong workspace=*` would not let the `/kong` endpoint be accessed from all workspaces
* Fixed an issue with RBAC where admins without a top level `endpoint=*` permission could not add any RBAC rules, even if they had `endpoint=/rbac` permissions. These admins can now add RBAC rules for their current workspace only.
* Kong Manager
  * Enable the `search_user_info` option when using OpenID Connect (OIDC)
  * Fix broken docs links on the Upstream page
  * Serverless functions can now be saved when there is a comma in the provided value
  * Custom plugins now show an Edit button when viewing the plugin configuration
* Keys are no longer rotated unexpectedly when a node restarts
* Add cache when performing RBAC token verification
* The log message "plugins iterator was changed while rebuilding it" was incorrectly logged as an `error`. This release converts it to the `info` log level.
* Fixed a 500 error when rate limiting counters are full with the Rate Limiting Advanced plugin

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`
* [Forward Proxy](/hub/kong-inc/forward-proxy) (`forward-proxy`)
  * Fix timeout issues with HTTPs requests by setting `https_proxy_host` to the same value as `http_proxy_host`
  * Use lowercase when overwriting the `host` header
  * Add support for basic authentication when using a secured proxy with HTTPS requests
* [StatsD Advanced](/hub/kong-inc/statsd-advanced) (`statsd-advanced`)
  * Added support for setting `workspace_identifier` to `workspace_name`
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Skip namespace creation if the plugin is not enabled. This prevents the error "[rate-limiting-advanced] no shared dictionary was specified" being logged.
* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced) (`proxy-cache-advanced`)
  * Large files would not be cached due to memory usage, leading to a `X-Cache-Status:Miss` response. This has now been resolved
* [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced) (`graphql-proxy-cache-advanced`)
  * Large files would not be cached due to memory usage, leading to a `X-Cache-Status:Miss` response. This has now been resolved
* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)
  * Support passwords that contain a `:` character

### Dependencies

* Bumped `openssl` from 1.1.1k to 1.1.1n to resolve CVE-2022-0778 [#8635](https://github.com/Kong/kong/pull/8635)
* Bumped `openresty` from 1.19.3.2 to 1.19.9.1 [#7727](https://github.com/Kong/kong/pull/7727)


## 2.7.1.2
**Release Date** 2022/02/17

### Fixes

#### Enterprise
* Fixed an issue with Kong Manager OIDC authentication, which caused the error
`“attempt to call method 'select_by_username_ignore_case' (a nil value)”`
and prevented login with OIDC.
* Fixed an issue where common names added to `cluster_allowed_common_names` did
not work.

## 2.7.1.1
**Release Date** 2022/02/04

### Fixes

#### Enterprise
* Fixed a performance issue with Kong Manager, which occurred when admins had
access to multiple workspaces.
* Fixed the `attempt to index local 'workspace'` error, which occurred when
accessing Routes or Services using TLS.

## 2.7.1.0
**Release Date:** 2022/01/27

### Features

#### Enterprise
* You can now configure [`cluster_max_payload`](/gateway/latest/reference/configuration/#cluster_max_payload)
for hybrid mode deployments. This configuration option sets the maximum payload
size allowed to be sent across from the control plane to the data plane. If your
environment has large configurations that generate `payload too big` errors
and don't get applied to the data planes, use this setting to adjust the limit.
* When using PKI for certificate verification in hybrid mode, you can now
configure a list of Common Names allowed to connect to a control plane with the
[`cluster_allowed_common_names`](/gateway/latest/reference/configuration/#cluster_allowed_common_names)
option. If not set, only data planes with the same parent domain as the control
plane cert are allowed.

### Fixes

#### Enterprise

* Fixed an issue where OIDC authentication into Kong Manager failed when used
with Azure AD.
* Fixed a timer leak that caused the timers to be exhausted and failed to start
any other timers used by Kong, showing the error `too many pending timers`.
* Fix an issue where, if `data_plane_config_cache_mode` was set to `off`, the
data plane received no updates from the control plane.

#### Core
* Reschedule resolve timer only when the previous one has finished.
[#8344](https://github.com/Kong/kong/pull/8344)
* Plugins, and any entities implemented with subchemas, now can use the
`transformations` and `shorthand_fields` properties, which were previously
only available for non-subschema entities.
[#8146](https://github.com/Kong/kong/pull/8146)

#### Plugins

* [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`)
  * Fixed a 500 error associated with performing arithmetic functions on a nil
  value by adding a nil value check after performing `ngx.shared.dict` operations.
  * Fixed a timer leak that caused the timers to be exhausted and failed to
  start any other timers used by Kong, showing the error `too many pending timers`.

    Before, the plugin used one timer for each namespace maintenance process,
    increasing timer usage on instances with a large number of rate limiting
    namespaces. Now, it uses a single timer for all namespace maintenance.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Fixed a 500 error that occurred when consumer groups were enforced but no
  proper configurations were provided. Now, if no specific consumer group
  configuration exists, the consumer group defaults to the original plugin
  configuration.

* [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
  * Fix an issue where the Exit Transformer plugin
  would break the plugin iterator, causing later plugins not to run.

## 2.7.0.0
**Release Date:** 2021/12/16

### Features

#### Enterprise
* Kong Gateway now supports installations on [Debian 10 and 11](/gateway/2.7.x/install-and-run/debian/).
* This release introduces consumer groups, a new entity that lets you
manage custom rate limiting configuration for any defined subsets of consumers.
To use consumer groups for rate limiting, configure the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced)
plugin with the `enforce_consumer_groups` and `consumer_groups` parameters,
and use the `/consumer_groups` endpoint to manage the groups.

    This is useful for managing consumers with same rate limiting settings, as you
    can create a consumer group and one Rate Limiting Advanced plugin instance for
    the group to reduce proxy delay.

  * [Consumer groups reference](/gateway/2.7.x/admin-api/consumer-groups/reference)
  * [Consumer groups examples](/gateway/2.7.x/admin-api/consumer-groups/examples)

     This feature is currently not supported with declarative configuration.

* The data plane configuration cache can now be encrypted or turned off entirely.
 Two new configuration options have been added:
  * [`data_plane_config_cache_mode`](/gateway/2.7.x/reference/configuration/#data_plane_config_cache_mode):
  The cache can be `unencrypted`, `encrypted`, or `off`.
  * [`data_plane_config_cache_path`](/gateway/2.7.x/reference/configuration/#data_plane_config_cache_path):
  Use this setting to specify a custom path for the cache.
* The `/license/report` API endpoint now provides
[monthly throughput usage reports](/gateway/2.7.x/plan-and-deploy/licenses/report).

#### Dev Portal
* The Dev Portal API now supports `sort_by={attribute}` and `sort_desc`
query parameters for sorted list results.
* Improvements to Dev Portal authentication with [OpenID Connect (OIDC)](/hub/kong-inc/openid-connect):
If OIDC auth is enabled, the first time a user attempts to access the Dev Portal
using their IDP credentials, they are directed to a pre-filled registration form.
Submit the form to create a Dev Portal account, linking the account to your IDP.

   After linking, you can use your IDP credentials to directly access this Dev
   Portal account.

* Added TLSv1.3 support for the Dev Portal API and GUI.

#### Kong Manager
* When [using OpenID Connect to secure Kong Manager](/gateway/2.7.x/configure/auth/kong-manager/oidc-mapping),
you no longer need to create admins manually in Kong Manager and map their roles
to your identity provider. Instead, admins are created on first
login and their roles are assigned based on their group membership in your
IdP. This feature also partly resolves a problem with creating admins for both
Kong Manager and Dev Portal.

    {:.important}
    > **Important:** This feature introduces a **breaking change**. The
    `admin_claim` parameter replaces the `consumer_claim` parameter required by
    previous versions. You must update your OIDC config file to keep OIDC
    authentication working for Kong Manager. For more information, see
    [OIDC Authenticated Group Mapping](/gateway/2.7.x/configure/auth/kong-manager/oidc-mapping).

* Kong Manager now provides a simplified, organized form for configuring the
OpenID Connect plugin. Users can now easily identify a common set of required
parameters to configure the plugin, and add custom configurations as needed.

#### Core
* Service entities now have a required [`enabled` field](/gateway/2.7.x/admin-api/#service-object)
which defaults to `true`. When set to `false`, routes attached to the service
are not added to the proxy router. [#8113](https://github.com/Kong/kong/pull/8113)

  In hybrid mode:
  * If `enabled` is set to `false` for a service, the service and its attached
  routes and plugins are not exported to data planes.
  * If `enabled` is set to `false` for a plugin, plugins are now also not
  exported to data planes, regardless of the service setting.

* DAOs in plugins must be listed in an array, so that their loading order is
explicit. Loading them in a hash-like table is now **deprecated**.
  [#7942](https://github.com/Kong/kong/pull/7942)
* Added the ability to [route TLS traffic based on SNIs](/gateway/2.7.x/reference/proxy/#proxy-tls-passthrough-traffic)
without terminating the connection.
  [#6757](https://github.com/Kong/kong/pull/6757)

#### Performance

In this release, we continued our work on better performance:

* Improved the plugin iterator performance and JITability
  [#7912](https://github.com/Kong/kong/pull/7912)
  [#7979](https://github.com/Kong/kong/pull/7979)
* Simplified the Kong core context read and writes for better performance
  [#7919](https://github.com/Kong/kong/pull/7919)
* Reduced proxy long tail latency while reloading DB-less config
  [#8133](https://github.com/Kong/kong/pull/8133)

#### PDK

* Added two new functions for the `body_filter` phase:
[`kong.response.get_raw_body`](/gateway/2.7.x/pdk/kong.response/) and
[`kong.response.set_raw_body`](/gateway/2.7.x/pdk/kong.response/).
  [#7887](https://github.com/Kong/kong/pull/7877)

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  * Added support for JWT algorithm [RS384](https://javadoc.io/static/com.github.jwt-scala/jwt-core_3.0.0-RC3/7.1.4/api/pdi/jwt/JwtAlgorithm$$RS384$.html).
  * The plugin now allows Redis Cluster nodes to be specified by hostname
    through the `session_redis_cluster_nodes` field, which
    is helpful if the cluster IPs are not static.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Added the `enforce_consumer_groups` and `consumer_groups` parameters,
  which introduce support for consumer groups. With consumer groups, you can
  manage custom rate limiting configuration for any defined subsets of consumers.

* [Forward Proxy](/hub/kong-inc/forward-proxy) (`forward-proxy`)
  * Added two proxy authentication parameters, `auth_username` and `auth_password`.

* [Mocking](/hub/kong-inc/mocking) (`mocking`)
  * Added the `random_examples` parameter. Use this setting to randomly select
  one example from a set of mocked responses.

* [IP-Restriction](/hub/kong-inc/ip-restriction) (`ip-restriction`)
  * Response status and message can now be customized
  through configurations `status` and `message`.
  [#7728](https://github.com/Kong/kong/pull/7728)

    Thanks [timmkelley](https://github.com/timmkelley) for the patch!

* [Datadog](/hub/kong-inc/datadog) (`datadog`)
  * Added support for the `distribution` metric type.
  [#6231](https://github.com/Kong/kong/pull/6231)

    Thanks [onematchfox](https://github.com/onematchfox) for the patch!

  * Allow service, consumer, and status tags to be customized through new
  plugin configurations `service_tag`, `consumer_tag`, and `status_tag`.
  [#6230](https://github.com/Kong/kong/pull/6230)

    Thanks [onematchfox](https://github.com/onematchfox) for the patch!

* [gRPC Gateway](/hub/kong-inc/grpc-gateway) (`grpc-gateway`) and [gRPC Web](/hub/kong-inc/grpc-web) (`grpc-web`)
  * Both plugins now share the Timestamp transcoding and included `.proto`
  files features.
  [#7950(https://github.com/Kong/kong/pull/7950)

* [gRPC Gateway](/hub/kong-inc/grpc-gateway) (`grpc-gateway`)
  * This plugin now processes services and methods defined in imported
  `.proto` files.
  [#8107](https://github.com/Kong/kong/pull/8107)

* [Rate-Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`)
  Added support for Redis SSL through configuration properties
  `redis_ssl` (can be set to `true` or `false`), `redis_ssl_verify`, and
  `redis_server_name`.
  [#6737](https://github.com/Kong/kong/pull/6737)

    Thanks [gabeio](https://github.com/gabeio) for the patch!

#### Plugin encryption

* Several fields have been marked as encrypted on plugins.
If [keyring encryption](/gateway/2.7.x/plan-and-deploy/security/db-encryption/)
is enabled, these fields will be encrypted:

  * ACME: `account_email`, `eab_kid`, and `eab_hmac_kid`
  * AWS Lambda: `aws_key` and `aws_secret`
  * Azure Functions: `apikey` and `clientid`
  * Basic Auth: `basicauth_credentials.password`
  * HTTP Log: `http_endpoint`
  * LDAP Auth Advanced: `ldap_password`
  * Loggly: `key`
  * OAuth2: `config.provision_key` parameter value and the
  `oauth2_credentials.provision_key` field
  * OpenID Connect: `client_id`, `client_secret`, `session_auth`, and
  `session_redis_auth`
  * Session: `secret`
  * Vault: `vaults.vault_token` and `vault_credentials.secret_token`

  {:.note}
  > **Note**: There is a known issue with encrypting deeply nested fields in
  certain plugins. For plugins with fields that are marked as encrypted but
  currently not working, see the [Known Issues section](#known-issues).

### Fixes

#### Enterprise
* Fixed an issue with Vitals report generation. If running Vitals with InfluxDB
and attempting to generate a report containing any status codes outside of
2XX, 4XX, or 5XX, report generation would fail. With this fix, proxied traffic
outside of the expected codes will not cause errors, and instead appear as
count totals in Vitals reports.

* Fixed a latency issue in hybrid mode. Previously, applying a large number of
configuration changes to a data plane simultaneously caused high latency in all
upstream requests.

* Users can now successfully delete admins with the `super-admin` role from
any workspace, as long as they have the correct permissions, and the associated
Consumer entity will be deleted as well. This frees up the username for a new
user. Previously, deleting an admin with a `super-admin` role from a different
workspace than where it was originally created did not delete the associated
Consumer entity, and the username would remain locked. For example, if the
admin was created in workspace `dev` and deleted from workspace `QA`, this
issue would occur.

* Phone home metrics are now sent over TLS, meaning that any analytics data
on Kong Gateway usage now travels through an encrypted connection.

#### Dev Portal
* Dev Portal OpenID Connect authentication now properly redirects users based on
the values of `login_redirect_uri` and `forbidden_redirect_uri` set in `portal_auth`.
If these values are not set in `portal_auth`, redirect values are taken from the
Portal templates file, `portal.conf.yaml`.

* When using OpenID Connect as the Dev Portal authentication method, updates to
Developers now correctly propagate to their associated Consumers.

* Fixed links in Dev Portal footer.

* Improved accessibility of the Dev Portal, fixing various issues related to
labels, names, headings, and color contrast:
  * Keyboard-accessible response examples and "Try it out" sections
  * Form inputs now have labels
  * Selectable elements now all have accessible names
  * Unique IDs for active elements
  * Heading levels only increase by one, and are in the correct order
  * Improved contrast of buttons

* Fixed info tooltip crash and rendering issue when viewing the Dev Portal app
registration service list.

* Fixed the Dev Portal Application Services list to allow pagination.

* Fixed a table border styling issue in Dev Portal.

#### Kong Manager
* Fixed an issue with icon alignment in Kong Manager, where the **Delete**
(garbage can) icon overlapped with the **View** link and caused users to
accidentally click **Delete**.

#### Core

* Fixed an issue where the `pluginsocket.proto` file was missing for Go plugins.
* Balancer caches are now reset on configuration reload.
  [#7924](https://github.com/Kong/kong/pull/7924)
* Configuration reload no longer causes a new DNS-resolving timer to be started.
  [#7943](https://github.com/Kong/kong/pull/7943)
* Fixed problem when bootstrapping multi-node Cassandra clusters, where migrations could attempt
  insertions before a schema agreement occurred.
  [#7667](https://github.com/Kong/kong/pull/7667)
* Fixed an intermittent botting error which happened when a custom plugin had interdependent entity schemas
  on its custom DAO and they were loaded in an incorrect order.
  [#7911](https://github.com/Kong/kong/pull/7911)
* Fixed an issue where `encrypted=true` would apply to the main plugin object,
instead of each plugin subschema.

#### PDK

* `kong.log.inspect` log level is now `debug` instead of `warn`. It also renders
  textboxes more cleanly now.
  [#7815](https://github.com/Kong/kong/pull/7815)

#### Plugins

* [LDAP Authentication](/hub/kong-inc/ldap-auth) (`ldap-auth`)
  * Fixed issue where the basic authentication header was not parsed correctly
  when the password contained a colon (`:`).
  [#7977](https://github.com/Kong/kong/pull/7977)

    Thanks [beldahanit](https://github.com/beldahanit) for reporting the issue!

* [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  * Hid Upstream Target health metrics on the control plane, as the control plane
  doesn't initialize the balancer and doesn't have any real metrics to show.
  [#7992](https://github.com/Kong/kong/pull/7922)

* [Request Validator](/hub/kong-inc/request-validator) (`request-validator`)
  * Reverted the change in parsing multiple values, as arrays in version 1.1.3
  headers and query-args as `primitive` are now validated individually when duplicates are provided, instead of merging them as an array.
  * Whitespace around CSV values is now dropped since it is not significant according to the RFC (whitespace is optional).
  * Bumped `openapi3-deserialiser` to 2.0.0 to enable the changes.

* [Forward Proxy](/hub/kong-inc/forward-proxy) (`forward-proxy`)
  * This plugin no longer uses deprecated features of the `lua-resty-http`
  dependency, which previously added deprecation warnings to the DEBUG log.
  * This plugin no longer sets a Host header if the `upstream_host` is an empty
  string.

* [OAuth2 Introspection](/hub/kong-inc/oauth2-introspection) (`oauth2-introspection`)
  * This plugin no longer uses deprecated features of the `lua-resty-http`
  dependency, which previously added deprecation warnings to the DEBUG log.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced) (`graphql-rate-limiting-advanced`)
  * Fixed plugin initialization code causing HTTP 500 status codes after
  enabling the plugin.

* [mTLS Auth](/hub/kong-inc/mtls-auth) (`mtls-auth`)
  * Fixed an issue where CRL cache was not properly invalidated, causing all
   certificates to appear invalid.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced) (`proxy-cache-advanced`)
  * Fixed the `function cannot be called in access phase` error, which occurred
  when the plugin was called in the log phase.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Fixed the schema entity check for `config.limit` and `config.window_size` count
   when the number of configured window sizes and limits parameters are not equal.

### Dependencies

* Bumped `go-pdk` used in tests from v0.6.0 to v0.7.1
[#7964](https://github.com/Kong/kong/pull/7964)
* Bumped `grpcurl` from 1.8.2 to 1.8.5
[#7959](https://github.com/Kong/kong/pull/7959)
* Bumped `lua-pack` from 1.0.5 to 2.0.0
[#8004](https://github.com/Kong/kong/pull/8004)
* Dependency on `luaossl` is removed.
* `lua-resty-openapi3-deserializer` (library dependency)
  * Reverted the header fix in `1.1.0`. For primitive types, the values are
  returned as plain strings, not as an array. Duplicate values must now be
  offered individually for deserialization.
  * Stripped whitespace from headers since it is not significant according to
  the RFC.

### Deprecated
* Kong Immunity is deprecated, removed, and not available in Kong Gateway.
To access old Kong Immunity documentation, see the
[doc archive](https://github.com/Kong/docs.konghq.com/tree/main/archive/enterprise/immunity_2.x).
* Cassandra as a backend database for Kong Gateway
is deprecated with this release and will be removed in a future version.

  The target for Cassandra removal is the Kong Gateway 4.0 release.
  Starting with the Kong Gateway 3.0 release, some new features might
  not be supported with Cassandra. Our intent is to provide our users with ample
  time and alternatives for satisfying the use cases that they have been able to
  address with Cassandra.

* The old `BasePlugin` module is deprecated and will be removed in a future version of Kong.
  See porting tips in the [documentation](/gateway/2.7.x/plugin-development/custom-logic/#migrating-from-baseplugin-module).
* Hash syntax for plugin DAOs is deprecated. Plugin DAOs should be arrays
instead of hashes.

### Known issues
* There's a bug in Kong Gateway which prevents keyring encryption from working on
deeply nested fields in plugins, so the `encrypted=true` setting does not have any
effect on the following plugins and fields:
  * JWT Signer: the fields `d`, `p`, `q`, `dp`, `dq`, `qi`, and `k` inside
  `jwt_signer_jwks.previous[...].` and `jwt_signer_jwks.keys[...]`
  * Kafka Log: `config.authentication.user` and `config.authentication.password`
  * Kafka Upstream: `config.authentication.user` and `config.authentication.password`
  * OpenID Connect: the fields `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`, and `k`
  inside `openid_connect_jwks.previous[...].` and `openid_connect_jwks.keys[...]`

* Consumer groups are not supported in declarative configuration with
decK. If you have consumer groups in your configuration, decK will ignore them.

* If you are using SSL certificates with custom plugins, you may need to set certificate phase in `ngc.ctx`.
