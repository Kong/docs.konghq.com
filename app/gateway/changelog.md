---
title: Kong Gateway Enterprise Changelog
no_version: true
---

## 3.0.1.0
**Release Date** 2022/11/02

### Features

#### Plugins

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Values stored in `key:value` pairs in this plugin's configuration are now referenceable, which means they can be stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/) in a vault.

### Fixes

#### Enterprise

* **Kong Manager**:
  * Removed the endpoint `all_routes` from configurable RBAC endpoint permissions.
  This endpoint was erroneously appearing in the endpoints list, and didn't configure anything.
  * Fixed an issue that allowed unauthorized IDP users to log in to Kong Manager.
  These users had no access to any resources in Kong Manager, but were able to go beyond the login screen.
  * Fixed an issue where, in an environment with a valid Enterprise license, admins with no access to the `default` workspace would see a message prompting them to upgrade to Kong Enterprise.
  * Fixed pagination issues with Kong Manager tables.
  * Fixed broken `Learn more` links.
  * Fixed an issue with group to role mapping, where it didn't support group names with spaces.
  * Fixed the Cross Site Scripting (XSS) security vulnerability in the Kong Manager UI.
  * Fixed an RBAC issue where permissions applied to specific endpoints (for example, an individual service or route) were not reflected in the Kong Manager UI.
  * Removed New Relic from Kong Manager. Previously, `VUE_APP_NEW_RELIC_LICENSE_KEY` and
  `VUE_APP_SEGMENT_WRITE_KEY` were being exposed in Kong Manager with invalid values.
  * Removed the action dropdown menu on service and route pages for read-only users.
  * Fixed the **Edit Configuration** button for Dev Portal applications.
  * Fixed an RBAC issue where the roles page listed deleted roles.
  * Fixed an issue where the orphaned roles would remain after deleting a workspace and cause the **Teams** > **Admins** page to break.
  * Added the missing **Copy JSON** button for plugin configuration.
  * Fixed an issue where the **New Workspace** button on the global workspace dashboard wasn't clickable on the first page load.
  * Removed the ability to add multiple documents per service from the UI.
  Each service only supports one document, so the UI now reflects that.
  * The Upstream Timeout plugin now has an icon and is part of the Traffic Control category.
  * Fixed an error that would occur when attempting to delete ACL credentials
  from the consumer credentials list.
  This happened because the name of the plugin, `acl`, and its endpoint, `/acls`, don't match.
  * Fixed a caching issue with Dev Portal, where enabling or disabling the Dev Portal for a workspace wouldn't change the Kong Manager menu.

* Unpinned the version of `alpine` used in the `kong/kong-gateway` Docker image.
Previously, the version was pinned to 3.10, which was creating outdated `alpine` builds.

#### Core

* Fixed an issue with how Kong initializes `resty.events`. The code was
previously using `ngx.config.prefix()` to determine the listening socket
path to provide to the resty.events module. This caused breakage when
Nginx was started with a relative path prefix.
This meant that you couldn't start 3.0.x with the same default configuration as
2.8.x.

    Instead of using `ngx.config.prefix()`, Kong will now prefer the
    `kong.configuration.prefix` when available, as it is already normalized
    to an absolute path. If `kong.configuration.prefix` is not defined, the
    result of `ngx.config.prefix()` will be used after resolving it to an
    absolute path. [#9337](https://github.com/Kong/kong/pull/9337)

* Fixed an issue with secret management references for HashiCorp Vault. By default, Kong passes secrets to the Nginx using environment variables when using `kong start`. Nginx was being started directly without calling `kong start`, so the secrets were not available at initialization. [#9478](https://github.com/Kong/kong/pull/9478)

* Fixed the Amazon Linux RPM installation instructions.

## 3.0.0.0
**Release Date** 2022/09/09

{:.important}
> **Important**: Kong Gateway 3.0.0.0 is a major release and contains breaking changes.
Review the [breaking changes and deprecations](#breaking-changes-and-deprecations) and the [known limitations](#known-limitations) before attempting to [upgrade](/gateway/latest/upgrade/).

### Features

#### Enterprise

* Kong Gateway now supports [dynamic plugin ordering](/gateway/3.0.x/kong-enterprise/plugin-ordering/).
You can change a plugin's static priority by specifying the order in which plugins run.
This lets you run plugins such as `rate-limiting` before authentication plugins.

* Kong Gateway now offers a FIPS package. The package replaces the primary library, OpenSSL, with [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 compliant BoringCrypto for cryptographic operations.

  To enable FIPS mode, set [`fips`](/gateway/3.0.x/reference/configuration/#fips) to `on`.
  FIPS mode is only supported in Ubuntu 20.04.

  {:.note}
  > **Note**: The Kong Gateway FIPS package is not currently compatible with SSL
  > connections to PostgreSQL.

* Kong Gateway now includes WebSocket validation functionality. Websockets are a type of persistent connection that works on top of HTTP.

  Previously, Kong Gateway 2.x supported limited WebSocket connections, where plugins only ran during the initial connection phase instead of for each frame.
  Now, Kong Gateway provides more control over WebSocket traffic by implementing plugins that target WebSocket frames.

  This release includes:
  * [Service](/gateway/3.0.x/admin-api/#service-object) and [route](/gateway/3.0.x/admin-api/#route-object) support for `ws` and `wss` protocols
  * Two new plugins: [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) and [WebSocket Validator](/hub/kong-inc/websocket-validator/)
  * WebSocket plugin development capabilities (**Beta feature**)
    * PDK modules: [kong.websocket.client](/gateway/3.0.x/plugin-development/pdk/kong.websocket.client/) and [kong.websocket.upstream](/gateway/3.0.x/plugin-development/pdk/kong.websocket.upstream/)
    * [New plugin handlers](/gateway/3.0.x/plugin-development/custom-logic/#websocket-plugin-development)

  Learn how to develop WebSocket plugins with our [plugin development guide](/gateway/3.0.x/plugin-development/custom-logic/#websocket-plugin-development).

* In this release, Kong Manager ships a with a refactored design and improved user experience.

  Notable changes:
  * Reworked workspace dashboards, both for specific workspaces and at the multi-workspace level.
  * License metrics now appear at the top of overview pages.
  * Restructured the layout and navigation to make workspace selection a secondary concern.
  * Grayed out portal buttons when you don't have permissions.
  * Added license level to phone home metrics.
  * Added more tooltips.

* [Secrets management](/gateway/3.0.x/kong-enterprise/secrets-management/) is now generally available.
  * Added GCP integration support for the secrets manager. GCP is now available as a vault backend.
  * The `/vaults-beta` entity has been deprecated and replaced with the `/vaults` entity.
  [#8871](https://github.com/Kong/kong/pull/8871)
  [#9217](https://github.com/Kong/kong/pull/9217)

* Kong Gateway now provides slim and UBI images.
Slim images are docker containers built with a minimal set of installed packages to run Kong Gateway.
From 3.0 onward, Kong Docker images will only contain software required to run the Gateway.
This ensures that false positive vulnerabilities don't get flagged during security scanning.

    If you want to retain or add other dependencies, you can [build custom Kong Docker images](/gateway/3.0.x/install/docker/build-custom-images/).

* The base OS for our convenience docker tags (for example, `latest`, `3.0.0.0`, `3.0`) has switched from Alpine to Debian.

* Added key recovery for keyring encryption.
This exposes a new endpoint for the Admin API, [`/keyring/recover`](/gateway/3.0.x/admin-api/db-encryption/#recover-keyring-from-database), and requires [`keyring_recovery_public_key`](/gateway/3.0.x/reference/configuration/#keyring_recovery_public_key) to be set in `kong.conf`.

* You can now encrypt declarative configuration files on data planes in DB-less and hybrid modes using [AES-256-GCM](https://www.rfc-editor.org/rfc/rfc5288.html) or [chacha20-poly1305](https://www.rfc-editor.org/rfc/rfc7539.html) encryption algorithms.

    Set your desired encryption mode with the [`declarative_config_encryption_mode`](/gateway/3.0.x/reference/configuration/#declarative_config_encryption_mode) configuration parameter.

#### Core

* This release introduces a new router implementation: `atc-router`.
This router is written in Rust, a powerful routing language that can handle complex routing requirements.
The new router can be used in traditional-compatible mode, or use the new expression-based language.

  With the new router, we have:
  * Reduced router rebuild time when changing Kong’s configuration
  * Increased runtime performance when routing requests
  * Reduced P99 latency from 1.5s to 0.1s with 10,000 routes

  Learn more about the router:
  * [Configure routes using expressions](/gateway/3.0.x/key-concepts/routes/expressions/)
  * [Router Expressions Language reference](/gateway/3.0.x/reference/expressions-language/language-references/)
  * [#8938](https://github.com/Kong/kong/pull/8938)

* Implemented delayed response in stream mode.
  [#6878](https://github.com/Kong/kong/pull/6878)
* Added `cache_key` on target entity for uniqueness detection.
  [#8179](https://github.com/Kong/kong/pull/8179)
* Introduced the tracing API, which is compatible with OpenTelemetry API specs, and
  adds built-in instrumentations.

  The tracing API is intended to be used with a external exporter plugin.
  Built-in instrumentation types and sampling rate are configurable through the
  [`opentelemetry_tracing`](/gateway/3.0.x/reference/configuration/#opentelemetry_tracing) and [`opentelemetry_tracing_sampling_rate`](/gateway/3.0.x/reference/configuration/#opentelemetry_tracing_sampling_rate) options.
  [#8724](https://github.com/Kong/kong/pull/8724)
* Added `path`, `uri_capture`, and `query_arg` options to upstream `hash_on`
  for load balancing.
  [#8701](https://github.com/Kong/kong/pull/8701)
* Introduced Unix domain socket-based `lua-resty-events` to
  replace shared memory-based `lua-resty-worker-events`.
  [#8890](https://github.com/Kong/kong/pull/8890)
* Introduced the `table_name` field for entities.
  This field lets you specify a table name.
  Previously, the name was deduced by the entity `name` attribute.
  [#9182](https://github.com/Kong/kong/pull/9182)
* Added `headers` on active health checks for upstreams.
  [#8255](https://github.com/Kong/kong/pull/8255)
* Target entities using hostnames were resolved when they were not needed. Now
  when a target is removed or updated, the DNS record associated with it is
  removed from the list of hostnames to be resolved.
  [#8497](https://github.com/Kong/kong/pull/8497) [9265](https://github.com/Kong/kong/pull/9265)
* Improved error handling and debugging info in the DNS code.
  [#8902](https://github.com/Kong/kong/pull/8902)
* Kong Gateway will now attempt to recover from an unclean shutdown by detecting and
  removing dangling Unix sockets in the prefix directory.
  [#9254](https://github.com/Kong/kong/pull/9254)
* A new CLI command, `kong migrations status`, generates the migration status in a JSON file.
* Removed the warning for `AAAA` being experimental with `dns_order`.

#### Performance

- Kong Gateway does not register unnecessary event handlers on hybrid mode control plane
  nodes anymore. [#8452](https://github.com/Kong/kong/pull/8452).
- Use the new timer library to improve performance,
  except for the plugin server.
  [#8912](https://github.com/Kong/kong/pull/8912)
- Increased the use of caching for DNS queries by activating `additional_section` by default.
  [#8895](https://github.com/Kong/kong/pull/8895)
- `pdk.request.get_header` has been changed to a faster implementation.
  It doesn't fetch all headers every time it's called.
  [#8716](https://github.com/Kong/kong/pull/8716)
- Conditional rebuilding of the router, plugins iterator, and balancer on data planes.
  [#8519](https://github.com/Kong/kong/pull/8519),
  [#8671](https://github.com/Kong/kong/pull/8671)
- Made configuration loading code more cooperative by yielding.
  [#8888](https://github.com/Kong/kong/pull/8888)
- Use the LuaJIT encoder instead of JSON to serialize values faster in LMDB.
  [#8942](https://github.com/Kong/kong/pull/8942)
- Made inflating and JSON decoding non-concurrent, which avoids blocking and makes data plane reloads faster.
  [#8959](https://github.com/Kong/kong/pull/8959)
- Stopped duplication of some events.
  [#9082](https://github.com/Kong/kong/pull/9082)
- Improved performance of configuration hash calculation by using `string.buffer` and `tablepool`.
  [#9073](https://github.com/Kong/kong/pull/9073)
- Reduced cache usage in DB-less mode by not using the Kong cache for routes and services in LMDB.
  [#8972](https://github.com/Kong/kong/pull/8972)

#### Admin API

- Added a new `/timers` Admin API endpoint to get timer statistics and worker info.
  [#8912](https://github.com/Kong/kong/pull/8912)
  [#8999](https://github.com/Kong/kong/pull/8999)
- The `/` endpoint now includes plugin priority.
  [#8821](https://github.com/Kong/kong/pull/8821)

#### Hybrid Mode

- Added wRPC protocol support. Configuration synchronization now happens over wRPC.
  wRPC is an RPC protocol that encodes with ProtoBuf and transports
  with WebSocket.
  [#8357](https://github.com/Kong/kong/pull/8357)
  - To keep compatibility with earlier versions,
    added support for the control plane to fall back to the previous protocol to
    support older data planes.
    [#8834](https://github.com/Kong/kong/pull/8834)
  - Added support to negotiate services supported with wRPC protocol.
    We will support more services in the future.
    [#8926](https://github.com/Kong/kong/pull/8926)
- Declarative configuration exports now happen inside a transaction in PostgreSQL.
  [#8586](https://github.com/Kong/kong/pull/8586)

#### Plugins

* Starting with version 3.0, all bundled plugin versions are the same as the
Kong Gateway version.
[#8772](https://github.com/Kong/kong/pull/8772)

    [Plugin documentation](/hub/) now refers to the Kong Gateway version instead of
    the individual plugin version.

* **New plugins**:
  * [OpenTelemetry](/hub/kong-inc/opentelemetry/) (`opentelemetry`)

    Export tracing instrumentations to any OTLP/HTTP compatible backend.
    `opentelemetry_tracing` configuration must be enabled to collect
    the core tracing spans of Kong Gateway.
    [#8826](https://github.com/Kong/kong/pull/8826)

  * [TLS Handshake Modifier](/hub/kong-inc/tls-handshake-modifier/) (`tls-handshake-modifier`)

    Make certificates available to other plugins acting on the same request.  

  * [TLS Metadata Headers](/hub/kong-inc/tls-metadata-headers/) (`tls-metadata-headers`)

    Proxy TLS client certificate metadata to upstream services via HTTP headers.

  * [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`)

    Allows operators to specify a maximum size for incoming WebSocket messages.

  * [WebSocket Validator](/hub/kong-inc/websocket-validator/) (`websocket-validator`)

    Validate individual WebSocket messages against a user-specified schema
    before proxying them.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * Added the `allow_any_domain` field. It defaults to false and if set to true, the gateway will
  ignore the `domains` field.
  [#9047](https://github.com/Kong/kong/pull/9047)

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added support for cross-account invocation through
  the `aws_assume_role_arn` and
  `aws_role_session_name` configuration parameters.
  [#8900](https://github.com/Kong/kong/pull/8900)
  * The plugin now accepts string type `statusCode` as a valid return when
    working in proxy integration mode.
    [#8765](https://github.com/Kong/kong/pull/8765)
  * The plugin now separates AWS credential cache by the IAM role ARN.
    [#8907](https://github.com/Kong/kong/pull/8907)

* Collector (`collector`)
  * The deprecated Collector plugin has been removed.

* [DeGraphQL](/hub/kong-inc/degraphql/) (`degraphql`)
  * The GraphQL server path is now configurable with the `graphql_server_path` configuration parameter.

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and
[Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
  * Added support for the `SCRAM-SHA-512` authentication mechanism.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * This plugin now allows authorization based on group membership.
  The new configuration parameter, `groups_required`, is an array of string
  elements that indicates the groups that users must belong to for the request
  to be authorized.
  * The character `.` is now allowed in group attributes.
  * The character `:` is now allowed in the password field.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Introduced certificate revocation list (CRL) and OCSP server support with the
  following parameters: `http_proxy_host`, `http_proxy_port`, `https_proxy_host`,
  and `https_proxy_port`.

* [OPA](/hub/kong-inc/opa/) (`opa`)
  * New configuration parameter `include_body_in_opa_input`: When enabled, include the raw body as a string in the OPA input at `input.request.http.body` and the body size at `input.request.http.body_size`.

  * New configuration parameter `include_parsed_json_body_in_opa_input`: When enabled and content-type is `application/json`, the parsed JSON will be added to the OPA input at `input.request.http.parsed_body`.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * High cardinality metrics are now disabled by default.
  * Decreased performance penalty to proxy traffic when collecting metrics.
  * The following metric names were adjusted to add units to standardize where possible:
    * `http_status` to `http_requests_total`.
    * `latency` to `kong_request_latency_ms` (HTTP), `kong_upstream_latency_ms`, `kong_kong_latency_ms`, and `session_duration_ms` (stream).

        Kong latency and upstream latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.

    * `kong_bandwidth` to `kong_bandwidth_bytes`.
    * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into to `nginx_hconnections_total` (or `nginx_current_connections`?)
    *  `request_count` and `consumer_status` were merged into http_requests_total.

        If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.
  * Removed the following metric: `http_consumer_status`
  * New metrics:
    * `session_duration_ms`: monitoring stream connections.
    * `node_info`: Single gauge set to 1 that outputs the node's ID and Kong Gateway version.

  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * Updated the Grafana dashboard that comes packaged with Kong

* [StatsD](/hub/kong-inc/statsd/) (`statsd`)
  * **Newly open-sourced plugin capabilities**: All capabilities of the [StatsD Advanced](/hub/kong-inc/statsd-advanced/) plugin are now bundled in the [StatsD](https://docs.konghq.com/hub/kong-inc/statsd) plugin.
    [#9046](https://github.com/Kong/kong/pull/9046)

* [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  * Added support for including the HTTP path in the span name with the
  `http_span_name` configuration parameter.
  [#8150](https://github.com/Kong/kong/pull/8150)
  * Added support for socket connect and send/read timeouts
    through the `connect_timeout`, `send_timeout`,
    and `read_timeout` configuration parameters. This can help mitigate
    `ngx.timer` saturation when upstream collectors are unavailable or slow.
    [#8735](https://github.com/Kong/kong/pull/8735)

#### Configuration

* You can now configure `openresty_path` to allow
  developers and operators to specify the OpenResty installation to use when
  running Kong Gateway, instead of using the system-installed OpenResty.
  [#8412](https://github.com/Kong/kong/pull/8412)
* Added `ipv6only` to listen options `admin_listen`, `proxy_listen`, and `stream_listen`.
  [#9225](https://github.com/Kong/kong/pull/9225)
* Added `so_keepalive` to listen options `admin_listen`, `proxy_listen`, and `stream_listen`.
  [#9225](https://github.com/Kong/kong/pull/9225)
* Add LMDB DB-less configuration persistence and removed the JSON-based
  configuration cache for faster startup time.
  [#8670](https://github.com/Kong/kong/pull/8670)
* `nginx_events_worker_connections=auto` now has a lower bound of 1024.
  [#9276](https://github.com/Kong/kong/pull/9276)
* `nginx_main_worker_rlimit_nofile=auto` now has a lower bound of 1024.
  [#9276](https://github.com/Kong/kong/pull/9276)

#### PDK

* Added new PDK function: `kong.request.get_start_time()`.
  This function returns the request start time, in Unix epoch milliseconds.
  [#8688](https://github.com/Kong/kong/pull/8688)
* The function `kong.db.*.cache_key()` now falls back to `.id` if nothing from `cache_key` is found.
  [#8553](https://github.com/Kong/kong/pull/8553)

### Known limitations

* Kong Manager does not currently support the following features:
  * Secrets management
  * Plugin ordering
  * Expression-based routing

* Blue-green migration from 2.8.x (and below) to 3.0.x is not supported.
  * This is a known issue planned to be fixed in the next 2.8 release. If this is a requirement for upgrading,
  Kong operators should upgrade to that version before beginning a upgrade to 3.0.0.0.
  * See [Upgrade Kong Gateway](/gateway/latest/upgrade/) for more details.

* OpenTracing: There is an issue with `nginx-opentracing` in this release, so it is not
  recommended to upgrade yet if you are an OpenTracing user. This will be
  rectified in an upcoming patch/minor release.

* The Kong Gateway FIPS package is not currently compatible with SSL connections to PostgreSQL.

### Breaking changes and deprecations

#### Deployment

* Deprecated and stopped producing Amazon Linux 1 containers and packages.
Amazon Linux 1 [reached end-of-life on December 31, 2020](https://aws.amazon.com/blogs/aws/update-on-amazon-linux-ami-end-of-life).
  [Kong/docs.konghq.com #3966](https://github.com/Kong/docs.konghq.com/pull/3966)
* Deprecated and stopped producing Debian 8 (Jessie) containers and packages.
Debian 8 [reached end-of-life in June 30, 2020](https://www.debian.org/News/2020/20200709).
  [Kong/kong-build-tools #448](https://github.com/Kong/kong-build-tools/pull/448)

#### Core

* As of 3.0, Kong Gateway's schema library's `process_auto_fields` function will not make deep
  copies of data that is passed to it when the given context is `select`. This was
  done to avoid excessive deep copying of tables where we believe the data most of
  the time comes from a driver like `pgmoon` or `lmdb`.

  If a custom plugin relied on `process_auto_fields` not overriding the given table, it must make its own copy
  before passing it to the function now.
  [#8796](https://github.com/Kong/kong/pull/8796)
* The deprecated `shorthands` field in Kong plugin or DAO schemas was removed in favor
  of the typed `shorthand_fields`. If your custom schemas still use `shorthands`, you
  need to update them to use `shorthand_fields`.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The support for `legacy = true/false` attribute was removed from Kong schemas and
  Kong field schemas.
  [#8958](https://github.com/Kong/kong/pull/8958)
* The deprecated alias of `Kong.serve_admin_api` was removed. If your custom Nginx
  templates still use it, change it to `Kong.admin_content`.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The Kong singletons module `kong.singletons` was removed in favor of the PDK `kong.*`.
  [#8874](https://github.com/Kong/kong/pull/8874)
* The data plane configuration cache was removed.
  Configuration persistence is now done automatically with LMDB.
  [#8704](https://github.com/Kong/kong/pull/8704)
* `ngx.ctx.balancer_address` was removed in favor of `ngx.ctx.balancer_data`.
  [#9043](https://github.com/Kong/kong/pull/9043)
* The normalization rules for `route.path` have changed. Kong Gateway now stores the unnormalized path, but
  the regex path always pattern-matches with the normalized URI. Previously, Kong Gateway replaced percent-encoding
  in the regex path pattern to ensure different forms of URI matches.
  That is no longer supported. Except for the reserved characters defined in
  [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986#section-2.2),
  write all other characters without percent-encoding.
  [#9024](https://github.com/Kong/kong/pull/9024)
* Kong Gateway no longer uses a heuristic to guess whether a `route.path` is a regex pattern. From 3.0 onward,
  all regex paths must start with the `"~"` prefix, and all paths that don't start with `"~"` will be considered plain text.
  The migration process should automatically convert the regex paths when upgrading from 2.x to 3.0.
  [#9027](https://github.com/Kong/kong/pull/9027)
* Bumped the version number (`_format_version`) of declarative configuration to `3.0` for changes on `route.path`.
  Declarative configurations using older versions are upgraded to `3.0` during migrations.

    {:.important}
    > **Do not sync (`deck sync`) declarative configuration files from 2.8 or earlier to 3.0.**
    Old configuration files will overwrite the configuration and create compatibility issues.
    To grab the updated configuration, `deck dump` the 3.0 file after migrations are completed.

  [#9078](https://github.com/Kong/kong/pull/9078)
* Tags may now contain space characters.
  [#9143](https://github.com/Kong/kong/pull/9143)
* Support for the `nginx-opentracing` module is deprecated as of `3.0` and will
  be removed from Kong in `4.0` (see the [Known Limitations](#known-limitations) section for additional
  information).
* We removed regex [look-around](https://www.regular-expressions.info/lookaround.html) and [backreferences](https://www.regular-expressions.info/backref.html) support in the the atc-router. These are rarely used features and removing support for them improves the speed of our regex matching. If your current regexes use look-around or backreferences you will receive an error when attempting to start Kong, showing exactly what regex is incompatible. Users can either switch to the `traditional` router flavor or change the regex to remove look-around / backreferences.

#### Admin API

* The Admin API endpoint `/vitals/reports` has been removed.
* `POST` requests on `/targets` endpoints are no longer able to update
  existing entities. They are only able to create new ones.
  [#8596](https://github.com/Kong/kong/pull/8596),
  [#8798](https://github.com/Kong/kong/pull/8798). If you have scripts that use
  `POST` requests to modify `/targets`, change them to `PUT`
  requests to the appropriate endpoints before updating to {{site.base_gateway}} 3.0.
* Insert and update operations on duplicated targets return a `409` error.
  [#8179](https://github.com/Kong/kong/pull/8179),
  [#8768](https://github.com/Kong/kong/pull/8768)
* The list of reported plugins available on the server now returns a table of
  metadata per plugin instead of a boolean `true`.
  [#8810](https://github.com/Kong/kong/pull/8810)

#### PDK

* The `kong.request.get_path()` PDK function now performs path normalization
  on the string that is returned to the caller. The raw, non-normalized version
  of the request path can be fetched via `kong.request.get_raw_path()`.
  [#8823](https://github.com/Kong/kong/pull/8823)
* `pdk.response.set_header()`, `pdk.response.set_headers()`, `pdk.response.exit()` now ignore and emit warnings for manually set `Transfer-Encoding` headers.
  [#8698](https://github.com/Kong/kong/pull/8698)
* The PDK is no longer versioned.
  [#8585](https://github.com/Kong/kong/pull/8585)
* The JavaScript PDK now returns `Uint8Array` for `kong.request.getRawBody`,
  `kong.response.getRawBody`, and `kong.service.response.getRawBody`.
  The Python PDK returns `bytes` for `kong.request.get_raw_body`,
  `kong.response.get_raw_body`, and `kong.service.response.get_raw_body`.
  Previously, these functions returned strings.
  [#8623](https://github.com/Kong/kong/pull/8623)
* The `go_pluginserver_exe` and `go_plugins_dir` directives are no longer supported.
 [#8552](https://github.com/Kong/kong/pull/8552). If you are using
 [Go plugin server](https://github.com/Kong/go-pluginserver), migrate your plugins to use the
 [Go PDK](https://github.com/Kong/go-pdk) before upgrading.

#### Plugins

* DAOs in plugins must be listed in an array, so that their loading order is explicit. Loading them in a
  hash-like table is no longer supported.
  [#8988](https://github.com/Kong/kong/pull/8988)
* Plugins MUST now have a valid `PRIORITY` (integer) and `VERSION` ("x.y.z" format)
  field in their `handler.lua` file, otherwise the plugin will fail to load.
  [#8836](https://github.com/Kong/kong/pull/8836)
* The old `kong.plugins.log-serializers.basic` library was removed in favor of the PDK
  function `kong.log.serialize`. Upgrade your plugins to use the PDK.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The support for deprecated legacy plugin schemas was removed. If your custom plugins
  still use the old (`0.x era`) schemas, you are now forced to upgrade them.
  [#8815](https://github.com/Kong/kong/pull/8815)
* Updated the priority for some plugins.

    This is important for those who run custom plugins as it may affect the sequence in which your plugins are executed.
    This does not change the order of execution for plugins in a standard Kong Gateway installation.

    Old and new plugin priority values:
    - `acme` changed from `1007` to `1705`
    - `basic-auth` changed from `1001` to `1100`
    - `canary` changed from `13` to `20`
    - `degraphql` changed from `1005` to `1500`
    - `graphql-proxy-cache-advanced` changed from `100` to `99`
    - `hmac-auth` changed from `1000` to `1030`
    - `jwt` changed from `1005` to `1450`
    - `jwt-signer` changed from `999` to `1020`.
    - `key-auth` changed from `1003` to `1250`
    - `key-auth-advanced` changed from `1003` to `1250`
    - `ldap-auth` changed from `1002` to `1200`
    - `ldap-auth-advanced` changed from `1002` to `1200`
    - `mtls-auth` changed from `1006` to `1600`
    - `oauth2` changed from `1004` to `1400`
    - `openid-connect` changed from `1000` to `1050`
    - `rate-limiting` changed from `901` to `910`
    - `rate-limiting-advanced` changed from `902` to `910`
    - `route-by-header` changed from `2000` to `850`
    - `route-transformer-advanced` changed from `800` to `780`
    - `pre-function` changed from `+inf` to `1000000`
    - `vault-auth` changed from `1003` to `1350`

* Kong plugins no longer support `CREDENTIAL_USERNAME` (`X-Credential-Username`).
  Use the constant `CREDENTIAL_IDENTIFIER` (`X-Credential-Identifier`) when
  setting the upstream headers for a credential.
  [#8815](https://github.com/Kong/kong/pull/8815)

* [ACL](/hub/kong-inc/acl/) (`acl`), [Bot Detection](/hub/kong-inc/bot-detection/) (`bot-detection`), and [IP Restriction](/hub/kong-inc/ip-restriction/) (`ip-restriction`)
  * Removed the deprecated `blacklist` and `whitelist` configuration parameters.
   [#8560](https://github.com/Kong/kong/pull/8560)

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The default value of the `auth_method` configuration parameter is now `token`.

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * The AWS region is now required. You can set it through the plugin configuration with the  `aws_region` field parameter, or with environment variables.
  * The plugin now allows `host` and `aws_region` fields to be set at the same time, and always applies the SigV4 signature.
  [#8082](https://github.com/Kong/kong/pull/8082)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * The `headers` field now only takes a single string per header name,
  where it previously took an array of values.
  [#6992](https://github.com/Kong/kong/pull/6992)

* [JWT](/hub/kong-inc/jwt/) (`jwt`)
  * The authenticated JWT is no longer put into the nginx
    context (`ngx.ctx.authenticated_jwt_token`). Custom plugins which depend on that
    value being set under that name must be updated to use Kong's shared context
    instead (`kong.ctx.shared.authenticated_jwt_token`) before upgrading to 3.0.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * High cardinality metrics are now disabled by default.
  * Decreased performance penalty to proxy traffic when collecting metrics.
  * The following metric names were adjusted to add units to standardize where possible:
    * `http_status` to `http_requests_total`.
    * `latency` to `kong_request_latency_ms` (HTTP), `kong_upstream_latency_ms`, `kong_kong_latency_ms`, and `session_duration_ms` (stream).

        Kong latency and upstream latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.

    * `kong_bandwidth` to `kong_bandwidth_bytes`.
    * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into to `nginx_connections_total`.
    *  `request_count` and `consumer_status` were merged into `http_requests_total`.

        If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.
  * Removed the following metric: `http_consumer_status`
  * New metrics:
    * `session_duration_ms`: monitoring stream connections.
    * `node_info`: Single gauge set to 1 that outputs the node's ID and Kong Gateway version.

  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * Updated the Grafana dashboard that comes packaged with Kong
[#8712](https://github.com/Kong/kong/pull/8712)
  * The plugin doesn't export status codes, latencies, bandwidth and upstream
  health check metrics by default. They can still be turned on manually by setting `status_code_metrics`,
  `lantency_metrics`, `bandwidth_metrics` and `upstream_health_metrics` respectively.
  [#9028](https://github.com/Kong/kong/pull/9028)

* **[Pre-function](/hub/kong-inc/pre-function/) (`pre-function`) and [Post-function](/hub/kong-inc/post-function/)** (`post-function`)
  * Removed the deprecated `config.functions` configuration parameter from the Serverless Functions plugins' schemas.
    Use the `config.access` phase instead.
  [#8559](https://github.com/Kong/kong/pull/8559)

* [StatsD](/hub/kong-inc/statsd/) (`statsd`):
  * Any metric name that is related to a service now has a `service.` prefix: `kong.service.<service_identifier>.request.count`.
    * The metric `kong.<service_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.status.<status>`.
    * The metric `kong.<service_identifier>.user.<consumer_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.user.<consumer_identifier>.status.<status>`.
  * The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.

  [#9046](https://github.com/Kong/kong/pull/9046)

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`), [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`), and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`):
  * The default policy is now local for all deployment modes.
  [#9344](https://github.com/Kong/kong/pull/9344)

* **Deprecated**: [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`):
  * The StatsD Advanced plugin has been deprecated and will be removed in 4.0.
  All capabilities are now available in the [StatsD](/hub/kong-inc/statsd/) plugin.

* [Proxy Cache](/hub/kong-inc/proxy-cache/) (`proxy-cache`), [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`), and [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`)
  * These plugins don't store response data in `ngx.ctx.proxy_cache_hit` anymore.
    Logging plugins that need the response data must now read it from `kong.ctx.shared.proxy_cache_hit`.
    [#8607](https://github.com/Kong/kong/pull/8607)



#### Configuration

* The Kong constant `CREDENTIAL_USERNAME` with the value of `X-Credential-Username` has been
  removed.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The default value of `lua_ssl_trusted_certificate` has changed to `system`
  [#8602](https://github.com/Kong/kong/pull/8602) to automatically load the trusted CA list from the system CA store.
* It is no longer possible to use a `.lua` format to import a declarative configuration file from the `kong`
  CLI tool. Only JSON and YAML formats are supported. If your update procedure with Kong Gateway involves
  executing `kong config db_import config.lua`, convert the `config.lua` file into a `config.json` or `config.yml` file
  before upgrading.
  [#8898](https://github.com/Kong/kong/pull/8898)
* The data plane config cache mechanism and its related configuration options
(`data_plane_config_cache_mode` and `data_plane_config_cache_path`) have been removed in favor of LMDB.

#### Migrations

* The migration helper library (mostly used for Cassandra migrations) is no longer supplied with Kong Gateway.
  [#8781](https://github.com/Kong/kong/pull/8781)
* PostgreSQL migrations can now have an `up_f` part like Cassandra
  migrations, designating a function to call. The `up_f` part is
  invoked after the `up` part has been executed against the database
  for both PostgreSQL and Cassandra.

### Fixes

#### Enterprise

* Fixed an issue with keyring encryption, where the control plane would crash if any errors occurred
during the initialization of the [keyring module](/gateway/latest/kong-enterprise/db-encryption/).

* Fixed an issue where the keyring module was not decrypting keys after a soft reload.

* Fixed pagination issues:
  * Fixed a consumer pagination issue.
  * Fixed an issue that appeared when loading the second page while iterating over a foreign key field using the DAO.
    [#9255](https://github.com/Kong/kong/pull/9255)

* Fixed service route update failures that occurred after restarting a control plane.

* **Vitals**:
  * Disabled `phone_home` for `anonymous_reports` on the data plane.
  * The Kong Gateway version information is now sent in the telemetry request query parameter.

* **Kong Manager**:
  * Fixed the workspace dashboard's loading state.
    Previously, a dashboard with no request data and an existing service would still prompt users to add a service.
  * Fixed an issue where Kong Manager allowed selection of metrics not supported by the Datadog plugin.
  * Fixed the values accepted for upstream configuration in Kong Manager.
  Previously, fields that were supposed to accept decimals would only accept whole numbers.
  * Fixed an issue where you couldn't save or update `pre-function` plugin configuration when the updated value contained a comma (`,`).
  * The service name field on the Service Contracts page now correctly shows the service display name.
  Previously, it showed the service ID.
  * Fixed an issue where, after updating the CA certificate, the page wouldn't return to the certificate view.
  * Fixed an issue where the port was missing from the service URL on the service overview page.
  * Fixed an issue where switching between workspace dashboard pages would not update the Dev Portal URL.
  * Fixed issues with plugins:
    * The Exit Transformer plugin can now load Lua functions added through Kong Manager.
    * The CORS plugin now treats regexes properly for the `config.origins` field.
    * The Datadog plugin now accepts an array for the `tags` field. Previously, it was incorrectly expecting a string.

  * Fixed an `HTTP 500` error that occurred when sorting routes by the **Hosts** column, then clicking **Next** on a paginated listing.
  * Fixed an issue that prevented developer role assignments from displaying in Kong Manager.
    When viewing a role under the Permissions tab in the Dev Portal section, the list of developers wouldn't update when a new developer was added.
    Kong Manager was constructing the wrong URL when retrieving Dev Portal assignees.
  * Fixed an issue where admins couldn't switch workspaces if they didn't have an roles in the default workspace.
  * Fixed a display issue with Dev Portal settings in Kong Manager.
  * Improved the error that appeared when trying to view admin roles without permissions for the resource.
    Instead of displaying `404 workspace not found`, the error now informs the user that they don't have access to view roles.

* Fixed an issue where the data plane would reload and lose its license after an Nginx reload.
* Fixed issues in dependencies:

  * `kong-gql`: Fixed variable definitions to handle non-nullable/list-type variables correctly.
  * `lua-resty-openssl-aux-module`: Fixed an issue with getting `SSL_CTX` from a request.

#### Core

* The schema validator now correctly converts `null` from declarative
  configurations to `nil`.
  [#8483](https://github.com/Kong/kong/pull/8483)
* Kong now reschedules router and plugin iterator timers only after finishing the previous
  execution, avoiding unnecessary concurrent executions.
  [#8567](https://github.com/Kong/kong/pull/8567)
* External plugins now handle returned JSON with null member correctly.
  [#8611](https://github.com/Kong/kong/pull/8611)
* Fixed an issue where the address of an environment variable could change but the code didn't
  check that it was fixed after init.
  [#8581](https://github.com/Kong/kong/pull/8581)
* Fixed an issue where the Go plugin server instance would not be updated after
  a restart.
  [#8547](https://github.com/Kong/kong/pull/8547)
* Fixed an issue on trying to reschedule the DNS resolving timer when Kong was
  being reloaded.
  [#8702](https://github.com/Kong/kong/pull/8702)
* The private stream API has been rewritten to allow for larger message payloads.
  [#8641](https://github.com/Kong/kong/pull/8641)
* Fixed an issue that the client certificate sent to the upstream was not updated when using the `PATCH` method.
  [#8934](https://github.com/Kong/kong/pull/8934)
* Fixed an issue where the control plane and wRPC module interaction would cause Kong to crash when calling `export_deflated_reconfigure_payload` without a `pcall`.
  [#8668](https://github.com/Kong/kong/pull/8668)
* Moved all `.proto` files to `/usr/local/kong/include` and ordered by priority.
  [#8914](https://github.com/Kong/kong/pull/8914)
* Fixed an issue that caused unexpected 404 errors when creating or updating configs with invalid options.
  [#8831](https://github.com/Kong/kong/pull/8831)
* Fixed an issue that caused crashes when calling some PDK APIs.
  [#8604](https://github.com/Kong/kong/pull/8604)
* Fixed an issue that caused crashes when go PDK calls returned arrays.
  [#8891](https://github.com/Kong/kong/pull/8891)
* Plugin servers now shutdown gracefully when Kong exits.
  [#8923](https://github.com/Kong/kong/pull/8923)
* CLI now prompts with `[y/n]` instead of `[Y/n]`, as it does not take `y` as default.
  [#9114](https://github.com/Kong/kong/pull/9114)
* Improved the error message that appears when Kong can't connect to Cassandra on init.
  [#8847](https://github.com/Kong/kong/pull/8847)
* Fixed an issue where the Vault subschema wasn't loaded in the `off` strategy.
  [#9174](https://github.com/Kong/kong/pull/9174)
* The schema now runs select transformations before `process_auto_fields`.
  [#9049](https://github.com/Kong/kong/pull/9049)
* Fixed an issue where {{site.base_gateway}} would use too many timers to keep track of upstreams when `worker_consistency = eventual`.
  [#8694](https://github.com/Kong/kong/pull/8694),
  [#8858](https://github.com/Kong/kong/pull/8858)
* Fixed an issue where it wasn't possible to set target status using only a hostname for targets set only by their hostname.
  [#8797](https://github.com/Kong/kong/pull/8797)
* Fixed an issue where cache entries of some entities were not being properly invalidated after a cascade delete.
  [#9261](https://github.com/Kong/kong/pull/9261)
* Running `kong start` when {{site.base_gateway}} is already running no longer overwrites
  the existing `.kong_env` file [#9254](https://github.com/Kong/kong/pull/9254)


#### Admin API

* The Admin API now supports `HTTP/2` when requesting `/status`.
  [#8690](https://github.com/Kong/kong/pull/8690)
* Fixed an issue where the Admin API didn't display `Allow` and `Access-Control-Allow-Methods` headers with `OPTIONS` requests.

#### Plugins

* Plugins with colliding priorities have now deterministic sorting based on their name.
  [#8957](https://github.com/Kong/kong/pull/8957)

* External plugins: Kong Gateway now handles logging better when a plugin instance loses the `instances_id` in an event handler.
  [#8652](https://github.com/Kong/kong/pull/8652)

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The default value of the `auth_method` configuration parameter is now set to `token`.
  [#8565](https://github.com/Kong/kong/pull/8565)
  * Added a cache for `domains_matcher`.
  [#9048](https://github.com/Kong/kong/pull/9048)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Log output is now restricted to the workspace the plugin is running in. Previously,
  the plugin could log requests from outside of its workspace.

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Removed the deprecated `proxy_scheme` field from the plugin's schema.
    [#8566](https://github.com/Kong/kong/pull/8566)
  * Changed the path from `request_uri` to `upstream_uri` to fix an issue where the URI could not follow a rule defined by the Request Transformer plugin.
    [#9058](https://github.com/Kong/kong/pull/9058) [#9129](https://github.com/Kong/kong/pull/9129)

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed a proxy authentication error caused by incorrect base64 encoding.
  * Use lowercase when overwriting the Nginx request host header.
  * The plugin now allows multi-value response headers.

* [gRPC Gateway](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed the handling of boolean fields from URI arguments.
    [#9180](https://github.com/Kong/kong/pull/9180)

* [HMAC Authentication](/hub/kong-inc/hmac-auth/) (`hmac-auth`)
  * Removed deprecated signature format using `ngx.var.uri`.
    [#8558](https://github.com/Kong/kong/pull/8558)

* [LDAP Authentication](/hub/kong-inc/ldap-auth/) (`ldap-auth`)
  * Refactored ASN.1 parser using OpenSSL API through FFI.
    [#8663](https://github.com/Kong/kong/pull/8663)

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where Kong Manager LDAP authentication failed when `base_dn` was the domain root.

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where `204` responses were not handled correctly and you would see the following error:
`"No examples exist in API specification for this resource"`.
  * `204` response specs now support empty content elements.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
openid-connect
  * Fixed an issue with `kong_oauth2` consumer mapping.

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)
    [#8968](https://github.com/Kong/kong/pull/8968)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed error handling when calling `get_window` and added more buffer on the window reserve.
  * Fixed error handling for plugin strategy configuration when in hybrid or DB-less mode and strategy is set to `cluster`.

* **[Pre-function](/hub/kong-inc/pre-function/) (`pre-function`) and [Post-function](/hub/kong-inc/post-function/)** (`post-function`)
  * Fixed a problem that could cause a crash.
  [#9269](https://github.com/Kong/kong/pull/9269)

* [Syslog](/hub/kong-inc/syslog/) (`syslog`)
  * The `conf.facility` default value is now set to `user`.
    [#8564](https://github.com/Kong/kong/pull/8564)

* [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  * Fixed the balancer spans' duration to include the connection time
  from Nginx to the upstream.
    [#8848](https://github.com/Kong/kong/pull/8848)
  * Corrected the calculation of the header filter start time.
    [#9230](https://github.com/Kong/kong/pull/9230)
  * Made the plugin compatible with the latest [Jaeger header spec](https://www.jaegertracing.io/docs/1.29/client-libraries/#tracespan-identity), which makes `parent_id` optional.
  [#8352](https://github.com/Kong/kong/pull/8352)

#### Clustering

* The cluster listener now uses the value of `admin_error_log` for its log file
  instead of `proxy_error_log`.
  [#8583](https://github.com/Kong/kong/pull/8583)
* Fixed a typo in some business logic that checks the Kong role before setting a
  value in cache at startup. [#9060](https://github.com/Kong/kong/pull/9060)
* Fixed an issue in hybrid mode where, if a service was set to `enabled: false` and that service had a route with an enabled plugin, any new data planes would receive empty configuration.
  [#8816](https://github.com/Kong/kong/pull/8816)
* Localized `config_version` to avoid a race condition from the new yielding config loading code.
  [#8188](https://github.com/Kong/kong/pull/8818)

#### PDK

* `kong.response.get_source()` now returns an error instead of an exit when plugin throws a
  runtime exception in the access phase.
  [#8599](https://github.com/Kong/kong/pull/8599)
* `kong.tools.uri.normalize()` now escapes reserved and unreserved characters more accurately.
  [#8140](https://github.com/Kong/kong/pull/8140)


* RFC3987 validation on route paths was removed, allowing operators to create a route with an invalid path
  URI like `/something|` which can not match any incoming request. This validation will be added back in a future release.

### Dependencies

* Bumped `openresty` from 1.19.9.1 to 1.21.4.1
  [#8850](https://github.com/Kong/kong/pull/8850)
* Bumped `pgmoon` from 1.13.0 to 1.15.0
  [#8908](https://github.com/Kong/kong/pull/8908)
  [#8429](https://github.com/Kong/kong/pull/8429)
* Bumped `openssl` from 1.1.1n to 1.1.1q
  [#9074](https://github.com/Kong/kong/pull/9074)
  [#8544](https://github.com/Kong/kong/pull/8544)
  [#8752](https://github.com/Kong/kong/pull/8752)
  [#8994](https://github.com/Kong/kong/pull/8994)
* Bumped `resty.openssl` from 0.8.8 to 0.8.10
  [#8592](https://github.com/Kong/kong/pull/8592)
  [#8753](https://github.com/Kong/kong/pull/8753)
  [#9023](https://github.com/Kong/kong/pull/9023)
* Bumped `inspect` from 3.1.2 to 3.1.3
  [#8589](https://github.com/Kong/kong/pull/8589)
* Bumped `resty.acme` from 0.7.2 to 0.8.1
  [#8680](https://github.com/Kong/kong/pull/8680)
  [#9165](https://github.com/Kong/kong/pull/9165)
* Bumped `luarocks` from 3.8.0 to 3.9.1
  [#8700](https://github.com/Kong/kong/pull/8700)
  [#9204](https://github.com/Kong/kong/pull/9204)
* Bumped `luasec` from 1.0.2 to 1.2.0
  [#8754](https://github.com/Kong/kong/pull/8754)
  [#8754](https://github.com/Kong/kong/pull/9205)
* Bumped `resty.healthcheck` from 1.5.0 to 1.6.1
  [#8755](https://github.com/Kong/kong/pull/8755)
  [#9018](https://github.com/Kong/kong/pull/9018)
  [#9150](https://github.com/Kong/kong/pull/9150)
* Bumped `resty.cassandra` from 1.5.1 to 1.5.2
  [#8845](https://github.com/Kong/kong/pull/8845)
* Bumped `penlight` from 1.12.0 to 1.13.1
  [#9206](https://github.com/Kong/kong/pull/9206)
* Bumped `lua-resty-mlcache` from 2.5.0 to 2.6.0
  [#9287](https://github.com/Kong/kong/pull/9287)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21


## 2.8.4.13
**Release Date** 2024/09/20

### Breaking Changes

#### Dependencies

* Fixed RPM relocation by setting the default prefix to `/`, and added a symbolic
  link for `resty` to handle missing `/usr/local/bin` in `PATH`.

### Fixes
#### Core

* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.

#### Plugins

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where the sync timer could stop working due to a race condition.

## 2.8.4.12
**Release Date** 2024/07/29

### Breaking changes and deprecations

* Debian 10 and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 2.8.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

### Fixes

* AWS2 x86_64 is now cross-built.
* Cleaned up build code for deprecated packages.
* Made the RPM package relocatable.

## 2.8.4.11
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 2.8.4.10
**Release Date** 2024/06/18

### Known issues

* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 2.8.4.11 instead of this patch.

### Features

* Added a Docker image for RHEL 8.

### Fixes
#### Core

_Backported from 3.7.1.0_
* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.

_Backported from 3.4.3.9_
* **Vitals**: Fixed an issue where each data plane connecting to the control plane would trigger the creation of a redundant 
table rotater timer on the control plane.

#### Plugins

_Backported from 3.7.0.0_
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
    The original interfaces remain unchanged for backward compatibility. 
  
    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")`.
    The old interface will be removed in the upcoming major release.

### Dependencies

* Improved the robustness of `lua-cjson` when handling unexpected input.

## 2.8.4.9
**Release Date** 2024/04/19

### Fixes
#### Core

_Backported from 3.3.0.0_
* Fixed an issue where vault configuration stayed sticky and cached even when configurations were changed.

#### PDK

_Backported from 3.7.0.0_
* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_portand`. It now correctly returns a number.

#### Plugins

_Backported from 3.6.1.2_
* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.


## 2.8.4.8
**Release Date** 2024/03/26

### Features
#### Configuration

* TLSv1.1 and lower is now disabled by default in OpenSSL 3.x.
* **Performance:** Bumped the default values of `nginx_http_keepalive_requests` and `upstream_keepalive_max_requests` to `10000`. 
These changes are optimized to work better in systems with high throughput. 
In a low-throughput setting, these new settings may have visible effects in load balancing, where it can take more requests to start 
using all the upstreams than before.

### Fixes
#### Configuration

* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.
* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.
 
#### Core

* Updated the file permission of `kong.logrotate` to 644.
* Fixed the missing router section for the output of request debugging.
* Fixed a issue where the `/metrics` endpoint would throw an error when database was down.
* Fixed the UDP socket leak of the DNS module.

#### Plugins

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed some cache-related issues which caused `groups_required` to return unexpected codes after a non-200 response.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where, if `sync_rate` was set to `0` and the `redis` strategy was in use, the plugin did not properly revert to the `local` strategy if the Redis connection was interrupted.

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`), [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`), [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`), and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.

### Dependencies

* Bumped OpenSSL from 3.1.4 to 3.1.5
* Bumped `lua-kong-nginx-module` to 0.2.3
* Bumped `kong-lua-resty-kafka` to 0.18
* Bumped `lua-resty-luasocket` to 1.1.2 to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427)

## 2.8.4.7
**Release Date** 2024/02/08

### Fixes

#### Plugins

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers when being executed instead of at plugin creation time, which reduces meaningless error logs.
  * The plugin now returns `info` and `log` level messages when Redis connections fail. These error messages were previously missing.
  * The plugin now checks for query errors in the Redis pipeline.
  * Fixed an issue where changing `sync_rate` from a value greater than 0 to 0 would clear the namespace unexpectedly.

## 2.8.4.6
**Release Date** 2024/01/17

### Fixes

#### Core

* Respect custom `proxy_access_log`.
 [#7437](https://github.com/Kong/kong/issues/7437)
* Fixed intermittent ldoc failures caused by a LuaJIT error.
 [#7492](https://github.com/Kong/kong/issues/7492)

#### Enterprise

* Bumped the `dns_stale_ttl` default to 1 hour so that stale DNS records can be used for a longer period of time in case of resolver downtime.
* Fixed a bug where a vault with a GCP backend would hide the error message when secrets couldn't be fetched.
* Fixed an issue where a GCP vault couldn't fetch secrets due to SSL verification failure in CLI mode.
Users who use secrets management based on GCP should also ensure the `system` CA store is included in the `lua_ssl_trusted_certificate` configuration.

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Updated the time used when calculating token expiration.

### Dependencies

#### Core

* Bumped `resty-openssl` from 0.8.25 to 1.0.2.
 [#7414](https://github.com/Kong/kong/issues/7414)
* Bumped the Alpine base image from 3.16 to 3.19.
 [#7732](https://github.com/Kong/kong/issues/7732)

#### Enterprise

* Bumped `lua-resty-healthcheck` to 1.6.4 to fix a bug where the health check
  module wouldn't work correctly when multiple health check instances weren't cleared.

## 2.8.4.5
**Release Date** 2023/11/28

### Features
#### Core
* Added support for observing the time consumed by some components in the given request.
* Added a unique Request ID that is now populated in the error log, access log, error templates, log serializer, and a new `X-Kong-Request-Id` header. 
  This configuration can be customized for upstreams and downstreams using the 
  [`headers`](/gateway/2.8.x/reference/configuration/#headers) and 
  [`headers_upstream`](/gateway/2.8.x/reference/configuration/#headers_upstream) configuration options. 
  [#11663](https://github.com/Kong/kong/pull/11663)

#### Enterprise
* License management:
  * Added support for counters such as routes, plugins, licenses, and deployment information to the license report.
  * Added a checksum to the output of the license endpoint.

#### Plugins
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added the new field `unauthorized_destroy_session`. When set to `true`, it destroys the session when receiving an unauthorized request by deleting the user's session cookie.

### Fixes
#### Core
* Dismissed confusing debug log from the Redis rate limiting tool.
* Removed the asynchronous timer in `syncQuery()` to prevent hang risk.
* Updated the DNS client to follow configured timeouts in a more predictable manner.
* Ensured pluginserver protobuf includes are placed in the correct path in packages.
* Added missing support for consumer group tags.
* Fixed an issue that caused Kong Gateway to fail to start if `proxy_access_log` is `off`.
* Removed asynchronous timer in `syncQuery()` to prevent hang risk.
* Fixed an issue that called `store_connection` without passing `self`.
* Kong Gateway now uses deep copies of route, service, and consumer objects for log serialization.
* Added support for the debug request header `X-Kong-Request-Debug-Output`, 
  which lets you observe the time consumed by specific components in a given request.
  Enable it using the 
  [`request_debug`](/gateway/2.8.x/reference/configuration/#request_debug) configuration parameter.
  This header helps you diagnose the cause of any latency in Kong Gateway.
  See the [Request Debugging](/gateway/latest/production/debug-request/) guide for more information.
  [#11627](https://github.com/Kong/kong/pull/11627)
* Fixed an issue that caused a failure to broadcast keyring material when using the cluster strategy.
* Addressed a problem where an abnormal socket connection would be reused when querying the PostgreSQL database.
* Fixed a plugin server issue that triggered invalidation when the instance was reset.

#### Enterprise
* Fixed an issue with the local variable `pkey` shadowing the package `pkey`. This caused the `attempt to call field 'new' (a nil value)` error message to display when calling `pkey.new`.

#### Plugins
* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue to prevent caching network failures during revocation checks.
* [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Gradually initializes AWS library on a first use to remove startup delay caused by AWS metadata discovery.
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Now allows preserving the session when there's a `401`.
  * Fixed an issue with token revocation on logout, where the code was revoking the refresh token instead of the access token when using the discovered revocation endpoint.
* Collector (`collector`)
  * Fixed an issue where Kong Gateway couldn't start after upgrading to versions greater than or equal to 2.8.4.1 because the deprecated Collector plugin was still being used.
* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)  
  * Fixed an issue where the `allowed_content_types` configuration was unable to contain the `-` character.
* [Rate Limiting](/hub/kong-inc/rate-limiting/)(`rate-limiting`)
  * Dismissed confusing log entry from Redis regarding rate limiting.
* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Reduced upstream health iteration latency spike during scrape.

#### Admin API
* Fixed an issue where unique violation errors were reported while trying to update the `user_token` with the same value on the same RBAC user.
* Unique violations are no longer reported on `user_token` self updates.

### Dependencies
#### Core
* Bumped lua-kong-nginx-module from 0.2.0 to 0.2.2.
* Bumped lua-resty-aws from 1.3.2 to 1.3.5.
* Patched nginx-1.19.9_06-set-ssl-option-ignore-unexpected-eof

#### Enterprise
* Bumped jq to 1.7.
* Bumped OpenSSL to 3.1.4.
* The Postgres socket now closes actively when timeout happens during the query. [#11480](https://github.com/Kong/kong/pull/11480)
* Added Dynatrace testcase.
* Deprecated uses of `mockbin.com`.
* Include `.proto` files in 2.8 packages. 
* Update COPYRIGHT file for 2.8.

#### Kong Manager Enterprise
* Bumped kong_admin to v0.14.26 for GW v2.8.4.5.
* Upgraded moment.js to v2.29.4 to fix a known CVE vulnerability.

## 2.8.4.4
**Release Date** 2023/10/12

### Fixes

#### Core
* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.

## 2.8.4.3 
**Release Date** 2023/09/18

### Breaking changes and deprecations

* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 2.8.4.3, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

* Amazon Linux 2022 artifacts are renamed to Amazon Linux 2023, based on AWS's own renaming.
 
### Features
#### Plugins
* [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * The AWS Lambda plugin has been refactored by using `lua-resty-aws` as an underlying AWS library. The refactor simplifies the AWS Lambda plugin codebase and adds support for multiple IAM authenticating scenarios.

### Fixes 
#### Core
* Fixed an issue that prevented the `dbless-reconfigure` anonymous report type from respecting anonymous reports with the setting `anonymous_reports=false`.
* Fixed an issue where you couldn't create developers using the Admin API in a non-default workspace in {{site.base_gateway}} 2.8.4.2.
* Fixed an issue with Redis catching rate limiting strategy connection failures.

#### Plugins 
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue that caused the plugin to trigger rate limiting unpredictably.
  * Fixed an issue where {{site.base_gateway}} produced a log of error log entries when multiple Rate Limiting Advanced plugins shared the same namespace.
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue that caused the plugin to return logs with `invalid introspection results` when decoding a bearer token.
* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Fixed an issue that caused the response body to load when the `if_status` didn't match.

#### PDK
* Fixed a bug in the exit hook that caused customized headers to be lost.

### Performance
#### Configuration
* Bumped the default value of `upstream_keepalive_pool_size` to 512 and `upstream_keepalive_max_requests` to 1000.

### Dependencies
* Bumped `lua-protobuf` from 0.3.3 to 0.4.2
* Bumped `lua-resty-aws` from 1.0.0 to 1.3.1
* Bumped `lua-resty-gcp` from 0.0.5 to 0.0.13

## 2.8.4.2

**Release Date** 2023/07/07

### Fixes
* Fixed a bug where internal redirects, such as those produced by the `error_page` directive,
  could interfere with worker process handling the request when *buffered proxying* is
  being used.

#### Kong Manager
* Fixed an issue where the Zipkin plugin didn’t allow the addition of `static_tags` through the Kong Manager UI. 
* Fixed an issue where some of the icons were not rendering correctly.

#### Plugins
* Fixed an issue with the Oauth 2.0 Introspection plugin where a request with JSON that is not a table failed.
* Fixed an issue where the slow startup of the Go plugin server caused a deadlock.

### Dependencies
* Bumped `OpenSSL` from 1.1.1t to 3.1.1
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

## 2.8.4.1

**Release Date** 2023/05/25

### Breaking Changes
#### Plugins
* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  * The plugin now allows requests carrying a `content-type` with a parameter to match its `content-type` without a parameter.

### Features
* Redis Cluster: Added username and password authentication to Redis Cluster 6 and later versions.

### Fixes
* Fixed an issue where the RBAC token was not re-hashed after an update on the `user_token` field.
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 2.8.4 packages prior to 2.8.4.1
didn't contain the debug symbols that Dynatrace requires.

#### Plugins
* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an issue which occurred when receiving an HTTP `408` from the upstream through a forward proxy. 
  Nginx exited the process with this code, which resulted in Nginx ending the request without any contents.

* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  * The plugin now allows requests carrying a `content-type` with a parameter to match its `content-type` without a parameter.

### Dependencies
* Bumped `pgmoon` from 2.2.0.1 to 2.3.2.0.

## 2.8.4.0
**Release Date** 2023/03/28

### Features

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `aws_imds_protocol_version`, which
  lets you select the IMDS protocol version.
  This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
  [#9962](https://github.com/Kong/kong/pull/9962)
 
### Fixes
#### Enterprise

* Fixed an issue where the OpenTracing module was not included in the Amazon Linux 2 package.
* Hybrid mode: Fixed an issue where enabling encryption on a data plane would cause the data plane to stop working after a restart.
* Fixed the systemd unit file, which was incorrectly named `kong.service` in 2.8.1.x and later versions.
It has been renamed back to `kong-enterprise-edition.service` to align with previous versions.

##### Kong Manager

* Fix the character limit error `[postgres] ERROR: value too long for type character(32)` that occurred while enabling the Dev Portal. 
The character limit was shorter than the length of the autogenerated UUID.
* The `/auth` endpoint, used by Kong Manager for OIDC authentication, now correctly supports the HTTP POST method.
* Fixed an issue where users with newly registered Dev Portal accounts created through OIDC were unable to log into Dev Portal 
until the Kong Gateway container was restarted.

#### Core

* Fixed the Ubuntu ARM64 image, which was broken in 2.8.2.x and later versions.
* Router: Fixed an issue where the router used stale data when workers were respawned. 
[#9396](https://github.com/Kong/kong/pull/9396)
[#9485](https://github.com/Kong/kong/pull/9485) 
* Update the batch queues module so that queues no longer grow without bounds if
their consumers fail to process the entries. Instead, old batches are now dropped
and an error is logged.
[#10247](https://github.com/Kong/kong/pull/10247)

#### Plugins

* Added the missing `protocols` field to the following plugin schemas:
  * Azure Functions (`azure-functions`)
  * gRPC Gateway (`grpc-gateway`)
  * gRPC Web (`grpc-web`)
  * Serverless pre-function (`pre-function`)
  * Prometheus (`prometheus`)
  * Proxy Caching (`proxy-cache`)
  * Request Transformer (`request-transformer`)
  * Session (`session`)
  * Zipkin (`zipkin`)

  [#9525](https://github.com/Kong/kong/pull/9525)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Fixed an issue in this plugin's batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.
  [#10052](https://github.com/Kong/kong/pull/10052) [#10044](https://github.com/Kong/kong/pull/10044)

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where the plugin used the old route caches after routes were updated. 
 
* [Key Authentication - Encrypted](/hub/kong-inc/key-auth-enc) (`key-auth-enc`)
  * Fixed an issue where using an API key that exists in multiple workspaces caused a 401 error. 
  This occurred because of a caching issue.

## 2.8.2.4
**Release Date** 2023/01/23

### Fixes

* Kong Gateway now statically links the BoringSSL PCRE library. 
This fixes an issue introduced in 2.8.2.3, where the BoringSSL library was dynamically linked, 
causing regex compilation to fail when routing requests with some versions of the library.

## 2.8.2.3
**Release Date** 2023/01/06

### Fixes

#### Enterprise

**Kong Manager:**
* Fixed a role precedence issue with RBAC. 
RBAC rules involving deny (negative) rules now correctly take precedence over allow (non-negative) roles.
* Fixed workspace filtering pagination on the overview page.

#### Core 

* Fixed a router issue where, in an environment with more than 50,000 routes, attempting to update a route caused a `500` error response.
* Fixed a timer leak that occurred whenever the generic messaging protocol connection broke in hybrid mode.
* Fixed a `tlshandshake` method error that occurred when SSL was configured on PostgreSQL, and the Kong Gateway had `stream_listen` configured with a stream proxy. 

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Fixed the `could not update kong admin` internal error caused by empty headers.
  This error occurred when using this plugin with the Kong Ingress Controller.

* [JWT](/hub/kong-inc/jwt/) (`jwt`)
  * Fixed an issue where the JWT plugin could potentially forward an unverified token to the upstream. 

* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Fixed the error `attempt to call local 'err' (a string value)`. 

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed UUID pattern matching. 

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * Provided options to reduce the plugin's impact on performance.
  Added new `kong.conf` options to switch high cardinality metrics `on` or `off`: 
  [`prometheus_plugin_status_code_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_status_code_metrics), [`prometheus_plugin_latency_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_latency_metrics), [`prometheus_plugin_bandwidth_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_bandwidth_metrics), and [`prometheus_plugin_upstream_health_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_upstream_health_metrics).

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed a maintenance cycle lock leak in the `kong_locks` dictionary. 
  Kong Gateway now clears old namespaces from the maintenance cycle schedule when a namespace is updated.

* [Request Transformer](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

### Known limitations

* A required PCRE library is dynamically linked, where prior versions statically linked the library. Depending on the system PCRE version, this may cause regex compilation to fail when routing requests. Starting in 2.8.2.4 and later, Kong Gateway will return to statically linking the PCRE library.

## 2.8.2.2
**Release Date** 2022/12/01

### Fixes

#### Core

Timer issue fixes:
* Added batch queues for the Datadog and StatsD plugins to reduce timer usage,
fixing a `lua_max_running_timers are not enough` timer error.

    Whenever a request was processed, a new running timer was instantly
    created during the log phase. This was causing a shortage
    of timers under heavy traffic and led to unpredictable consequences, where
    internal timers were killed randomly and couldn't recover automatically.
    This would then trigger a `lua_max_running_timers are not enough` timer
    error and cause data planes to crash.

    [#9521](https://github.com/Kong/kong/pull/9521)

* Fixed a timer leak that occurred whenever the generic messaging protocol
connection would break in hybrid mode.

## 2.8.2.1
**Release Date** 2022/11/21

### Fixes

#### Enterprise

* **Kong Manager:**
  * Fixed an issue where admins needed the specific `rbac/role` permission to edit RBAC roles.
  Now, admins can edit RBAC roles with the `/admins` permission.
  * Fixed an issue where the client certificate ID didn't display properly in the upstream update form.
  * Fixed an issue in the service documents UI which allowed users to upload multiple documents. Since each service
  only supports one document, the documents would not display correctly. Uploading a new document now overrides the previous document.
  * Fixed an issue where the **New Workspace** button on the global workspace dashboard wasn't clickable on the first page load.
  * Fixed an RBAC issue where the roles page listed deleted roles.
  * Removed New Relic from Kong Manager. Previously, `VUE_APP_NEW_RELIC_LICENSE_KEY` and
  `VUE_APP_SEGMENT_WRITE_KEY` were being exposed in Kong Manager with invalid values.
  * Fixed an RBAC issue where permissions applied to specific endpoints (for example, an individual service or route) were not reflected in the Kong Manager UI.
  * Fixed an issue with group to role mapping, where it didn't support group names with spaces.
  * Fixed an issue with individual workspace dashboards, where right-clicking on **View All** and choosing "Open Link in New Tab" or "Copy Link" for services, routes, and plugins redirected to the default workspace and caused an `HTTP 404` error.

* **Dev Portal**: Fixed an issue where Dev Portal response examples weren't rendered when media type was vendor-specific.

#### Core

* Targets with a weight of `0` are no longer included in health checks, and checking their status via the `upstreams/<upstream>/health` endpoint results in the status `HEALTHCHECK_OFF`.
Previously, the `upstreams/<upstream>/health` endpoint was incorrectly reporting targets with `weight=0` as `HEALTHY`, and the health check was reporting the same targets as `UNDEFINED`.

* Fixed the default `logrotate` configuration, which lacked permissions to access logs.

#### Plugins

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  * Fixed the `Bad Gateway` error that would occur when using the Kafka Upstream plugin with the configuration `producer_async=false`.

* [Response Transformer](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Fixed an issue where the plugin couldn't process string responses.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where the plugin was causing requests to silently fail on Kong Gateway data planes.

* [Request Transformer](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

* [Azure Functions](/hub/kong-inc/azure-functions/) (`azure-functions`)
  * Fixed an issue where calls made by this plugin would fail in the following situations:
    * The plugin was associated with a route that had no service.
    * The route's associated service had a `path` value.

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where operational attributes referenced by `group_member_attribute` weren't returned in search query results.

## 2.8.2.0
**Release Date** 2022/10/12

### Fixes

#### Enterprise

* **Kong Manager**:
  * Fixed an issue where workspaces with zero roles were not correctly sorted by the number of roles.
  * Fixed the Cross Site Scripting (XSS) security vulnerability in the Kong Manager UI.
  * Fixed an issue where registering an admin without `admin_gui_auth` set resulted in a `500` error.
  * Fixed an issue that allowed unauthorized IDP users to log in to Kong Manager.
  These users had no access to any resources in Kong Manager, but were able to go beyond the login screen.

* Fixed OpenSSL vulnerabilities [CVE-2022-2097](https://nvd.nist.gov/vuln/detail/CVE-2022-2097) and [CVE-2022-2068](https://nvd.nist.gov/vuln/detail/CVE-2022-2068).
* Hybrid mode: Fixed an issue with consumer groups, where the control plane wasn't sending the correct number of consumer entries to data planes.
* Hybrid mode: Fixed an issue where sending a `PATCH` request to update a route after restarting a control plane caused a 500 error response.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Fixed an issue where the plugin couldn't read environment variables in the ECS environment, causing permission errors.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * If the `https_proxy` configuration parameter is not set, it now defaults to `http_proxy` to avoid DNS errors.

* [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`) and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed the error `function cannot be called in access phase (only in: log)`, which was preventing the plugin from working consistently.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * The plugin now returns a `500` error when using the `cluster` strategy in hybrid or DB-less modes instead of crashing.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The characters `.` and `:` are now allowed in group attributes.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed issues with OIDC role mapping where admins couldn't be added to more than one workspace, and permissions were not being updated.

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

* [Route Transformer Advanced](/hub/kong-inc/route-transformer-advanced/) (`route-transformer-advanced`)
  * Fixed an issue where URIs that included `%20` or a whitespace would return a `400 Bad Request`.


## 2.8.1.4
**Release Date** 2022/08/23

* Fixed vulnerabilities [CVE-2022-37434](https://nvd.nist.gov/vuln/detail/CVE-2022-37434) and [CVE-2022-24975](https://nvd.nist.gov/vuln/detail/CVE-2022-24975).

* When using secrets management in free mode, only the [environment variable](/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/env/) backend is available. AWS, GCP, and HashiCorp vault backends require an Enterprise license.

* Fixed an issue in Kong Manager where entity detail pages were empty and didn't list existing entities.
The following entities were affected:
  * Route lists on service pages
  * Upstreams
  * Certificates
  * SNIs
  * RBAC roles

* Fixed an issue where the browser hung when creating an upstream with the existing host and port.

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed a caching issue in hybrid mode, where the data plane node would try to retrieve a new JWK from the IdP every time.
  The data plane node now looks for a cached JWK first.

* [Proxy Caching Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed an issue that prevented users from removing the cluster addresses on an existing configuration.

### Dependencies

* Bump `lua-resty-aws` version to 0.5.4 to reduce memory usage when AWS vault is enabled. [#23](https://github.com/Kong/lua-resty-aws/pull/23)
* Bump `lua-resty-gcp` version to 0.0.5 to reduce memory usage when GCP vault is enabled. [#7](https://github.com/Kong/lua-resty-gcp/pull/7)

## 2.8.1.3
**Release Date** 2022/08/05

### Features

#### Enterprise

* Added GCP integration support for the secrets manager. GCP is now available as a vault backend.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added support for cross-account invocation through
  the `aws_assume_role_arn` and
  `aws_role_session_name` configuration parameters.
  [#8900](https://github.com/Kong/kong/pull/8900)

### Fixes

#### Enterprise
* Fixed an issue with excessive log file disk utilization on control planes.
* Fixed an issue with keyring encryption, where keyring was not decrypting keys after a soft reload.
* The router now detects static route collisions inside the current workspace, as well as with other workspaces.
* When using a custom plugin in a hybrid mode deployment, the control plane now detects compatibility issues and stops sending the plugin configuration to data planes that can't use it. The control plane continues sending the custom plugin configuration to compatible data planes.
* Optimized the Kong PDK function `kong.response.get_source()`.

#### Kong Manager
* Fixed an issue with admin creation.
Previously, when an admin was created with no roles, the admin would have access to the first workspace listed alphabetically.
* Fixed several issues with SNI listing.
Previously, the SNI list was empty after sorting by the SSL certificate ID field. In 2.8.1.1, the SSL certificate ID field in the SNI list was empty.

#### Plugins

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where the plugin didn't accept empty values in examples.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The `domains` plugin parameter can now be left empty.
  When `domains` is empty, all TLDs are allowed.
  Previously, the parameter was labelled as optional, but leaving it empty meant that the plugin retrieved no certificates at all.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Fixed an issue with nested array parsing.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue with `cluster` strategy timestamp precision in Cassandra.

## 2.8.1.2
**Release Date** 2022/07/15

### Fixes

#### Enterprise

* Fixed an issue in hybrid mode where, if a service was set to `enabled: false` and that service had a route with an enabled plugin, any new data planes would receive empty configuration.
* Fixed a timer leak that occurred when `worker_consistency` was set to `eventual` in `kong.conf`.
This issue caused timers to be exhausted and failed to start any other timers used by Kong Gateway, resulting in a `too many pending timers` error.
* Fixed memory leaks coming from `lua-resty-lock`.
* Fixed global plugins can operate out of the workspace scope

#### Kong Manager and Dev Portal

* Fixed an issue where Kong Manager did not display all Dev Portal developers in the organization.
* Fixed an issue that prevented developer role assignments from displaying in Kong Manager.
When viewing a role under the Permissions tab in the Dev Portal section, the list of developers wouldn't update when a new developer was added.
Kong Manager was constructing the wrong URL when retrieving Dev Portal assignees.
* Fixed empty string handling in Kong Manager. Previously, Kong Manager was handling empty strings as `""` instead of a null value.
* Improved Kong Manager styling by fixing an issue where content didn't fit on object detail pages.
* Fixed an issue that sometimes prevented clicking Kong Manager links and buttons in Safari.
* Fixed an issue where users were being navigated to the object detail page after clicking on the "Copy ID" button from the object list.
* Fixed an issue where the number of requests and error rate were not correctly displaying when Vitals was disabled.

#### Plugins

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Log output is now restricted to the workspace the plugin is running in. Previously,
  the plugin could log requests from outside of its workspace.

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where `204` responses were not handled correctly and you would see the following error:
`"No examples exist in API specification for this resource"`.
  * `204` response specs now support empty content elements.

### Deprecated

* **Amazon Linux 1**: Support for running Kong Gateway on Amazon Linux 1 is now deprecated, as the
[Amazon Linux (1) AMI has ended standard support as of December 31, 2020](https://aws.amazon.com/blogs/aws/update-on-amazon-linux-ami-end-of-life).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Amazon Linux 1
images or packages, and Kong will not test package installation on Amazon Linux 1.

    If you need to install Kong Gateway on Amazon Linux 1, see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/amazon-linux/).

* **Debian 8**: Support for running Kong Gateway on Debian 8 ("Jessie") is now deprecated, as
[Debian 8 ("Jessie") has reached End of Life (EOL)](https://www.debian.org/News/2020/20200709).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Debian 8
("Jessie") images or packages, and Kong will not test package installation on
Debian 8 ("Jessie").

    If you need to install Kong Gateway on Debian 8 ("Jessie"), see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/debian/).

* **Ubuntu 16.04**: Support for running Kong Gateway on Ubuntu 16.04 ("Xenial") is now deprecated,
as [Standard Support for Ubuntu 16.04 has ended as of April, 2021](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Ubuntu 16.04
images or packages, and Kong will not test package installation on Ubuntu 16.04.

    If you need to install Kong Gateway on Ubuntu 16.04, see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/ubuntu/).

## 2.8.1.1
**Release Date** 2022/05/27

### Features

#### Enterprise

* You can now enable application status and application request emails
for the Developer Portal using the following configuration parameters:
  * [`portal_application_status_email`](/gateway/latest/reference/configuration/#portal_application_status_email): Enable to send application request status update emails to developers.
  * [`portal_application_request_email`](/gateway/latest/reference/configuration/#portal_application_request_email): Enable to send service access request emails to users specified in `smtp_admin_emails`.
  * [`portal_smtp_admin_emails`](/gateway/latest/reference/configuration/#portal_smtp_admin_emails): Specify the email addresses to send portal admin emails to, overriding values set in `smtp_admin_emails`.
* Added the ability to use `email.developer_meta` fields in portal email templates. For example, `{% raw %}{{email.developer_meta.preferred_name}}{% endraw %}`.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * When working in proxy integration mode, the `statusCode` field now accepts
  string datatypes.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Introduced certificate revocation list (CRL) and OCSP server support with the
  following parameters: `http_proxy_host`, `http_proxy_port`, `https_proxy_host`,
  and `https_proxy_port`.

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)
  * Added support for the `SCRAM-SHA-512` authentication mechanism.

### Fixes

#### Enterprise

* Improved Kong Admin API and Kong Manager performance for organizations with
many entities.

* Fixed an issue with keyring encryption, where the control plane would crash if any errors occurred
during the initialization of the [keyring module](/gateway/latest/plan-and-deploy/security/db-encryption/).

* Fixed an issue where Kong Manager did not display all RBAC users and Consumers
in the organization.

* Fixed an issue where some areas in a row of a list were not clickable.

#### Plugins

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed rate limiting advanced errors that appeared when the Rate Limiting
  Advanced plugin was not in use.
  * Fixed an error where rate limiting counters were not updating response
  headers due to incorrect key expiration tracking.
  Redis key expiration is now tracked properly in `lua_shared_dict kong_rate_limiting_counters`.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an `invalid header value` error for HTTPS requests. The plugin
  now accepts multi-value response headers.
  * Fixed an error where basic authentication headers containing the `=`
  character weren't forwarded.
  * Fixed request errors that occurred when a scheme had no proxy set. The
  `https` proxy now falls back to the `http` proxy if not specified, and the
  `http` proxy falls back to `https`.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * Fixed `deserialize_parse_tree` logic when building GraphQL AST with
  non-nullable or list types.

## 2.8.1.0
**Release Date** 2022/04/07

### Fixes

#### Enterprise

* Fixed an issue with RBAC where `endpoint=/kong workspace=*` would not let the `/kong` endpoint be accessed from all workspaces
* Fixed an issue with RBAC where admins without a top level `endpoint=*` permission could not add any RBAC rules, even if they had `endpoint=/rbac` permissions. These admins can now add RBAC rules for their current workspace only.
* Kong Manager
  * Serverless functions can now be saved when there is a comma in the provided value
  * Custom plugins now show an Edit button when viewing the plugin configuration
  * Editing Dev Portal permissions no longer returns a 404 error
  * Fix an issue where admins with access to only non-default workspaces could not see any workspaces
  * Show the workspace name when an admin only has access to non-default workspaces
  * Add support for table filtering and sorting when using Cassandra
  * Support the # character in RBAC tokens on the RBAC edit page
  * Performing an action on an upstream target no longer leads to a 404 error
* Developer Portal
  * Information about the current session is now bound to an nginx worker thread. This prevents data leaks when a worker is handling multiple requests at the same time
* Keys are no longer rotated unexpectedly when a node restarts
* Add cache when performing RBAC token verification
* The log message "plugins iterator was changed while rebuilding it" was incorrectly logged as an `error`. This release converts it to the `info` log level.
* Fixed a 500 error when rate limiting counters are full with the Rate Limiting Advanced plugin
* Improved the performance of the router, plugins iterator and balancer by adding conditional rebuilding

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`
* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Use lowercase when overwriting the `host` header
* [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`)
  * Added support for setting `workspace_identifier` to `workspace_name`
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Skip namespace creation if the plugin is not enabled. This prevents the error "[rate-limiting-advanced] no shared dictionary was specified" being logged.
* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Support passwords that contain a `:` character
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Provide valid upstream headers e.g. `X-Consumer-Id`, `X-Consumer-Username`
* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Implement the `enable_hs_signatures` option to enable JWTs signed with HMAC algorithms

### Dependencies

* Bumped `openssl` from 1.1.1k to 1.1.1n to resolve CVE-2022-0778 [#8635](https://github.com/Kong/kong/pull/8635)
* Bumped `openresty` from 1.19.3.2 to 1.19.9.1 [#7727](https://github.com/Kong/kong/pull/7727)

## 2.8.0.0
**Release Date** 2022/03/02

### Features

#### Enterprise

* Improved tables in Kong Manager: (for PostgreSQL-backed instances only)
  * Click on a table row to access the entry instead of using the
  old **View** icon.
  * Search and filter tables through the **Filters** dropdown, which is located
  above the table.
  * Sort any table by clicking on a column title.
  * Tables now have pagination.

* Kong Manager with OIDC:
  * Added the configuration option
  [`admin_auto_create_rbac_token_disabled`](/gateway/latest/configure/auth/kong-manager/oidc-mapping/)
  to enable or disable RBAC tokens when automatically creating admins with OpenID
  Connect.

* If a license is present,`license_key` is now included in the `api` signal for
[`anonymous_reports`](/gateway/latest/reference/configuration/#anonymous_reports).

#### Dev Portal

* The new `/developers/export` endpoint lets you export the list of developers
and their statuses into CSV format.

#### Core

* **Beta feature**: Kong Gateway 2.8.0.0 introduces
[secrets management and vault support](/gateway/latest/kong-enterprise/secrets-management/).
You can now store confidential values such as usernames and passwords
as secrets in secure vaults. Kong Gateway can then reference these secrets,
making your environment more secure.

  The beta includes `get` support for the following vault implementations:
  * [AWS Secrets Manager](/gateway/latest/kong-enterprise/secrets-management/backends/aws-sm/)
  * [HashiCorp Vault](/gateway/latest/kong-enterprise/secrets-management/backends/hashicorp-vault/)
  * [Environment variable](/gateway/latest/kong-enterprise/secrets-management/backends/env/)

  As part of this support, some plugins have certain fields marked as
  *referenceable*. See the plugin section of the Kong Gateway 2.8 changelog for
  details.

  Test out secrets management using the
  [getting started guide](/gateway/latest/kong-enterprise/secrets-management/getting-started/),
  and check out the documentation for the Kong Admin API [`/vaults-beta` entity](/gateway/latest/admin-api/#vaults-beta-entity).

  {:.important}
  > This feature is in beta. It has limited support and implementation details
  may change. This means it is intended for testing in staging environments
  only, and **should not** be deployed in production environments.

* You can customize the transparent dynamic TLS SNI name.

  Thanks, [@Murphy-hub](https://github.com/Murphy-hub)!
  [#8196](https://github.com/Kong/kong/pull/8196)

* Routes now support matching headers with regular expressions.

  Thanks, [@vanhtuan0409](https://github.com/vanhtuan0409)!
  [#6079](https://github.com/Kong/kong/pull/6079)

* You can now configure [`cluster_max_payload`](/gateway/latest/reference/configuration/#cluster_max_payload)
  for hybrid mode deployments. This configuration option sets the maximum payload
  size allowed to be sent across from the control plane to the data plane. If your
  environment has large configurations that generate `payload too big` errors
  and don't get applied to the data planes, use this setting to adjust the limit.

  Thanks, [@andrewgkew](https://github.com/andrewgkew)!
  [#8337](https://github.com/Kong/kong/pull/8337)

#### Performance

* Improved the calculation of declarative configuration hash for big configurations.
  The new method is faster and uses less memory.
  [#8204](https://github.com/Kong/kong/pull/8204)

* Multiple improvements in the Router, including:
  * The router builds twice as fast
  * Failures are cached and discarded faster (negative caching)
  * Routes with header matching are cached

  These changes should be particularly noticeable when rebuilding in DB-less
  environments.
  [#8087](https://github.com/Kong/kong/pull/8087)
  [#8010](https://github.com/Kong/kong/pull/8010)

#### Admin API

* The current declarative configuration hash is now returned by the `status`
  endpoint when Kong node is running in DB-less or data plane mode.
  [#8214](https://github.com/Kong/kong/pull/8214)
  [#8425](https://github.com/Kong/kong/pull/8425)

#### Plugins

* [Canary](/hub/kong-inc/canary/) (`canary`)
  * Added the ability to configure `canary_by_header_name`. This parameter
  accepts a header name that, when present on a request, overrides the configured canary
  functionality.         
    * If the configured header is present with the value `always`, the request will
      always go to the canary upstream.
    * If the header is present with the value `never`, the request will never go to the
    canary upstream.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * Added three new metrics:
    * `kong_db_entities_total` (gauge): total number of entities in the database.
    * `kong_db_entity_count_errors` (counter): measures the number of errors encountered during the measurement of `kong_db_entities_total`.
    * `kong_nginx_timers` (gauge): total number of Nginx timers, in Running or Pending state. Tracks `ngx.timer.running_count()` and
      `ngx.timer.pending_count()`.
      [#8387](https://github.com/Kong/kong/pull/8387)

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)

  * Added Redis ACL support (Redis v6.0.0+) for storing and retrieving a session.
    Use the `session_redis_username` and `session_redis_password` configuration
    parameters to configure it.

    {:.important}
    > These parameters replace the `session_redis_auth` field, which is
    now **deprecated** and planned to be removed in 3.x.x.

  * Added support for distributed claims. Set the `resolve_distributed_claims`
   configuration parameter to `true` to tell OIDC to explicitly resolve
   distributed claims.

      Distributed claims are represented by the `_claim_names` and `_claim_sources`
      members of the JSON object containing the claims.

  * **Beta feature:** The `client_id`, `client_secret`, `session_secret`, `session_redis_username`,
  and `session_redis_password` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Forward Proxy Advanced](/hub/kong-inc/forward-proxy/) (`forward-proxy`)

  * Added `http_proxy_host`, `http_proxy_port`, `https_proxy_host`, and
  `https_proxy_port` configuration parameters for mTLS support.

      {:.important}
      > These parameters replace the `proxy_port` and `proxy_host` fields, which
      are now **deprecated** and planned to be removed in 3.x.x.

  * The `auth_password` and `auth_username` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)

  * Added the ability to identify a Kafka cluster using the `cluster_name` configuration parameter.
   By default, this field generates a random string. You can also set your own custom cluster identifier.

  * **Beta feature:** The `authentication.user` and `authentication.password` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)

  * **Beta feature:** The `ldap_password` and `bind_dn` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Vault Authentication](/hub/kong-inc/vault-auth/) (`vault-auth`)

  * **Beta feature:** The `vaults.vault_token` form field is now marked as
  referenceable, which means it can be securely stored as a
  [secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)

  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).
  * Added the `redis_username` configuration parameter.

    Thanks, [@27ascii](https://github.com/27ascii) for the original contribution!
    [#8213](https://github.com/Kong/kong/pull/8213)

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Use response buffering from the PDK.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.sentinel_username` and `redis.sentinel_password` configuration
  parameters.

  * **Beta feature:**  The `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be
  securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [jq](/hub/kong-inc/jq/) (`jq`)
  * Use response buffering from the PDK.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * Added the `rsa_key_size` configuration parameter.

    Thanks, [lodrantl](https://github.com/lodrantl)!
    [#8114](https://github.com/Kong/kong/pull/8114)

### Fixes

#### Enterprise

* Fixed a timer leak that caused the timers to be exhausted and failed to start
any other timers used by Kong, showing the error `too many pending timers`.

* Fixed an issue where, if `data_plane_config_cache_mode` was set to `off`, the
data plane received no updates from the control plane.

* Fixed `attempt to index local 'workspace'` error, which occurred when
accessing Routes or Services using TLS.

* Fixed an issue where [`cluster_telemetry_server_name`](/gateway/latest/reference/configuration/#cluster_telemetry_server_name)
was not automatically generated and registered if it was not explicitly set.

* Fixed the [`cluster_allowed_common_names`](/gateway/latest/reference/configuration/#cluster_allowed_common_names)
setting. When using PKI for certificate verification in hybrid mode, you can now
configure a list of Common Names allowed to connect to a control plane with the
option. If not set, only data planes with the same parent domain as the control
plane cert are allowed.

#### Kong Manager

* Fixed an issue where OIDC authentication into Kong Manager failed when used
with Azure AD.

* Fixed a performance issue with the Teams page in Kong Manager.

* Fixed an issue with checkboxes in Kong Manager, where the checkbox for
the OAuth2 plugin's `hash_secret` value was labelled as *Required* and users
were not able to uncheck it.

* Fixed an issue where Kong Manager was not updating plugin configuration
 when attempting to clear the `service.id` from a plugin.

* Fixes an issue with Route creation in Kong Manager, where a new route would
default to `http` as the supported protocol. Now, creating a Route picks up
the correct default value, which is `http,https`.

* Kong Manager now accurately lists `udp` as a protocol option for Route and
Service objects on their configuration pages.

* Fixed an issue with Kong Manager OIDC authentication, which caused the error
`“attempt to call method 'select_by_username_ignore_case' (a nil value)”`
and prevented login with OIDC.

* Fixed a latency issue with OAuth2 token creation. These tokens
 are no longer tracked by the workspace entity counter, as the count is not
 needed by the Kong Manager UI.

* Fixed an issue where the plugin list table couldn't be sorted by the
**Applied To** column.

#### Dev Portal

* When the SMTP configuration was broken or unresponsive, the API would respond
with an error message that was a JavaScript Object (`[Object object]`) instead
of a string. This happened when a user was registering on any given portal with
broken SMTP. Now, if there is an error, the API responds with the string
`Error sending email`.

* The `/document_objects` and `/services/:id/document_objects` endpoints no
longer accept multiple documents per service. This was an issue, as each service
can only have one document. Instead, posting a document to one of these endpoints
now overrides the previous document.

#### Core

* When the Router encounters an SNI FQDN with a trailing dot (`.`),
  the dot will be ignored, since according to
  [RFC-3546](https://datatracker.ietf.org/doc/html/rfc3546#section-3.1)
  the dot is not part of the hostname.
  [#8269](https://github.com/Kong/kong/pull/8269)

* Fixed a bug in the Router that would not prioritize the routes with
  both a wildcard and a port (`route.*:80`) over wildcard-only routes (`route.*`),
  which have less specificity.
  [#8233](https://github.com/Kong/kong/pull/8233)

* The internal DNS client isn't confused by the single-dot (`.`) domain,
  which can appear in `/etc/resolv.conf` in special cases like `search .`
  [#8307](https://github.com/Kong/kong/pull/8307)

* The Cassandra connector now records migration consistency level.

  Thanks, [@mpenick](https://github.com/mpenick)!
  [#8226](https://github.com/Kong/kong/pull/8226)

#### Balancer

* Targets now keep their health status when upstreams are updated.
  [#8394](https://github.com/Kong/kong/pull/8394)

* One debug message which was erroneously using the `error` log level
  has been downgraded to the appropriate `debug` log level.
  [#8410](https://github.com/Kong/kong/pull/8410)

#### Clustering

* Replaced a cryptic error message with a more useful one when
  there is a failure on SSL when connecting with the control plane.
  [#8260](https://github.com/Kong/kong/pull/8260)

#### Admin API

* Fixed an incorrect `next` field that appeared when paginating Upstreams.
  [#8249](https://github.com/Kong/kong/pull/8249)

#### PDK

* Phase names are now correctly selected when performing phase checks.
  [#8208](https://github.com/Kong/kong/pull/8208)
* Fixed a bug in the go-PDK where, if `kong.request.getrawbody` was
  big enough to be buffered into a temporary file, it would return an
  an empty string.
  [#8390](https://github.com/Kong/kong/pull/8390)

#### Plugins

* **External Plugins**:
  * Fixed incorrect handling of the Headers Protobuf Structure
    and representation of null values, which provoked an error on init with the go-pdk.
    [#8267](https://github.com/Kong/kong/pull/8267)

  * Unwrap `ConsumerSpec` and `AuthenticateArgs`.

    Thanks, [@raptium](https://github.com/raptium)!
    [#8280](https://github.com/Kong/kong/pull/8280)

  * Fixed a problem in the stream subsystem, where it would attempt to load
    HTTP headers.
    [#8414](https://github.com/Kong/kong/pull/8414)

* [CORS](/hub/kong-inc/cors/) (`cors`)
  * The CORS plugin does not send the `Vary: Origin` header anymore when
    the header `Access-Control-Allow-Origin` is set to `*`.

    Thanks, [@jkla-dr](https://github.com/jkla-dr)!
    [#8401](https://github.com/Kong/kong/pull/8401)

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Fixed incorrect behavior when configured to use an HTTP proxy
  and deprecated the `proxy_scheme` config attribute for removal in 3.0.
  [#8406](https://github.com/Kong/kong/pull/8406)

* [OAuth2](/hub/kong-inc/oauth2/) (`oauth2`)
  * The plugin clears the `X-Authenticated-UserId` and
  `X-Authenticated-Scope` headers when it is configured in logical OR and
  is used in conjunction with another authentication plugin.
  [#8422](https://github.com/Kong/kong/pull/8422)

* [Datadog](/hub/kong-inc/datadog/) (`datadog`)
  * The plugin schema now lists the default values
  for configuration options in a single place instead of in two
  separate places.
  [#8315](https://github.com/Kong/kong/pull/8315)

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed a 500 error associated with performing arithmetic functions on a nil
  value by adding a nil value check after performing `ngx.shared.dict` operations.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed a 500 error that occurred when consumer groups were enforced but no
  proper configurations were provided. Now, if no specific consumer group
  configuration exists, the consumer group defaults to the original plugin
  configuration.

  * Fixed a timer leak that caused the timers to be exhausted and failed to
  start any other timers used by Kong, showing the error `too many pending timers`.

    Before, the plugin used one timer for each namespace maintenance process,
    increasing timer usage on instances with a large number of rate limiting
    namespaces. Now, it uses a single timer for all namespace maintenance.

  * Fixed an issue where the `local` strategy was not working with DB-less
  and hybrid deployments. We now allow `sync_rate = null` and `sync_rate = -1`
  when a `local` strategy is defined.

* [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  * Fixed an issue where the Exit Transformer plugin
  would break the plugin iterator, causing later plugins not to run.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)

  * Fixed `attempt to index local 'workspace'` error, which occurred when
  accessing Routes or Services using TLS.

* [OAuth2 Introspection](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)

  * Fixed issues with TLS connections when the IDP is behind a reverse proxy.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)

  * Fixed a `X-Cache-Status:Miss` error that occurred when caching large files.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)

  * Fixed a `X-Cache-Status:Miss` error that occurred when caching large files.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)

  * In the `body_filter` phase, the plugin now sets the body to an empty string
  instead of `nil`.

* [jq](/hub/kong-inc/jq/) (`jq`)

  * If plugin has no output, it will now return the raw body instead of attempting
  to restore the original response body.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)

  * Fixed negative caching, which was loading wrong a configuration value.

* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)

  * Fixed an issue where the `enable_hs_signatures` configuration
  parameter did not work. The plugin now defines expiry earlier to avoid
  arithmetic on a nil value.

### Dependencies
* Bumped OpenSSL from 1.1.1l to 1.1.1m
[#8191](https://github.com/Kong/kong/pull/8191)
* Bumped `resty.session` from 3.8 to 3.10
[#8294](https://github.com/Kong/kong/pull/8294)
* Bumped `lua-resty-openssl` to 0.8.5
[#8368](https://github.com/Kong/kong/pull/8368)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

### Deprecated

* The external `go-pluginserver` project is considered deprecated in favor of
  the [embedded server approach](/gateway/latest/reference/external-plugins/).

* Starting with Kong Gateway 2.8.0.0, Kong is not building new open-source
CentOS images. Support for running open-source Kong Gateway on CentOS on is now
deprecated, as [CentOS has reached End of Life (OEL)](https://www.centos.org/centos-linux-eol/).

    Running Kong Gateway Enterprise on CentOS is currently supported, but CentOS
    is planned to be fully deprecated in Kong Gateway 3.x.x.

* OpenID Connect plugin: The `session_redis_auth` field is
  now deprecated and planned to be removed in 3.x.x. Use
  `session_redis_username` and `session_redis_password` instead.

* Forward Proxy Advanced plugin: The `proxy_port` and `proxy_host` fields are
now deprecated and planned to be removed in 3.x.x. Use
`http_proxy_host` and `http_proxy_port`, or `https_proxy_host` and
`https_proxy_port` instead.

* AWS Lambda plugin: The `proxy_scheme` field is now deprecated and planned to
be removed in 3.x.x.

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

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`
* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fix timeout issues with HTTPs requests by setting `https_proxy_host` to the same value as `http_proxy_host`
  * Use lowercase when overwriting the `host` header
  * Add support for basic authentication when using a secured proxy with HTTPS requests
* [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`)
  * Added support for setting `workspace_identifier` to `workspace_name`
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Skip namespace creation if the plugin is not enabled. This prevents the error "[rate-limiting-advanced] no shared dictionary was specified" being logged.
* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Large files would not be cached due to memory usage, leading to a `X-Cache-Status:Miss` response. This has now been resolved
* [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`)
  * Large files would not be cached due to memory usage, leading to a `X-Cache-Status:Miss` response. This has now been resolved
* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
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

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed a 500 error associated with performing arithmetic functions on a nil
  value by adding a nil value check after performing `ngx.shared.dict` operations.
  * Fixed a timer leak that caused the timers to be exhausted and failed to
  start any other timers used by Kong, showing the error `too many pending timers`.

    Before, the plugin used one timer for each namespace maintenance process,
    increasing timer usage on instances with a large number of rate limiting
    namespaces. Now, it uses a single timer for all namespace maintenance.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed a 500 error that occurred when consumer groups were enforced but no
  proper configurations were provided. Now, if no specific consumer group
  configuration exists, the consumer group defaults to the original plugin
  configuration.

* [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  * Fix an issue where the Exit Transformer plugin
  would break the plugin iterator, causing later plugins not to run.

## 2.7.0.0
**Release Date:** 2021/12/16

### Features

#### Enterprise
* Kong Gateway now supports installations on [Debian 10 and 11](/gateway/2.7.x/install-and-run/debian/).
* This release introduces consumer groups, a new entity that lets you
manage custom rate limiting configuration for any defined subsets of consumers.
To use consumer groups for rate limiting, configure the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
plugin with the `enforce_consumer_groups` and `consumer_groups` parameters,
and use the `/consumer_groups` endpoint to manage the groups.

    This is useful for managing consumers with same rate limiting settings, as you
    can create a consumer group and one Rate Limiting Advanced plugin instance for
    the group to reduce proxy delay.

  * [Consumer groups reference](/gateway/2.7.x/admin-api/consumer-groups/reference/)
  * [Consumer groups examples](/gateway/2.7.x/admin-api/consumer-groups/examples/)

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
* Improvements to Dev Portal authentication with [OpenID Connect (OIDC)](/hub/kong-inc/openid-connect/):
If OIDC auth is enabled, the first time a user attempts to access the Dev Portal
using their IDP credentials, they are directed to a pre-filled registration form.
Submit the form to create a Dev Portal account, linking the account to your IDP.

   After linking, you can use your IDP credentials to directly access this Dev
   Portal account.

* Added TLSv1.3 support for the Dev Portal API and GUI.

#### Kong Manager
* When [using OpenID Connect to secure Kong Manager](/gateway/2.7.x/configure/auth/kong-manager/oidc-mapping/),
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
    [OIDC Authenticated Group Mapping](/gateway/2.7.x/configure/auth/kong-manager/oidc-mapping/).

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

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added support for JWT algorithm RS384.
  * The plugin now allows Redis Cluster nodes to be specified by hostname
    through the `session_redis_cluster_nodes` field, which
    is helpful if the cluster IPs are not static.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added the `enforce_consumer_groups` and `consumer_groups` parameters,
  which introduce support for consumer groups. With consumer groups, you can
  manage custom rate limiting configuration for any defined subsets of consumers.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Added two proxy authentication parameters, `auth_username` and `auth_password`.

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Added the `random_examples` parameter. Use this setting to randomly select
  one example from a set of mocked responses.

* [IP-Restriction](/hub/kong-inc/ip-restriction/) (`ip-restriction`)
  * Response status and message can now be customized
  through configurations `status` and `message`.
  [#7728](https://github.com/Kong/kong/pull/7728)

    Thanks [timmkelley](https://github.com/timmkelley) for the patch!

* [Datadog](/hub/kong-inc/datadog/) (`datadog`)
  * Added support for the `distribution` metric type.
  [#6231](https://github.com/Kong/kong/pull/6231)

    Thanks [onematchfox](https://github.com/onematchfox) for the patch!

  * Allow service, consumer, and status tags to be customized through new
  plugin configurations `service_tag`, `consumer_tag`, and `status_tag`.
  [#6230](https://github.com/Kong/kong/pull/6230)

    Thanks [onematchfox](https://github.com/onematchfox) for the patch!

* [gRPC Gateway](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`) and [gRPC Web](/hub/kong-inc/grpc-web/) (`grpc-web`)
  * Both plugins now share the Timestamp transcoding and included `.proto`
  files features.
  [#7950(https://github.com/Kong/kong/pull/7950)

* [gRPC Gateway](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * This plugin now processes services and methods defined in imported
  `.proto` files.
  [#8107](https://github.com/Kong/kong/pull/8107)

* [Rate-Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
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

* [LDAP Authentication](/hub/kong-inc/ldap-auth/) (`ldap-auth`)
  * Fixed issue where the basic authentication header was not parsed correctly
  when the password contained a colon (`:`).
  [#7977](https://github.com/Kong/kong/pull/7977)

    Thanks [beldahanit](https://github.com/beldahanit) for reporting the issue!

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * Hid Upstream Target health metrics on the control plane, as the control plane
  doesn't initialize the balancer and doesn't have any real metrics to show.
  [#7992](https://github.com/Kong/kong/pull/7922)

* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  * Reverted the change in parsing multiple values, as arrays in version 1.1.3
  headers and query-args as `primitive` are now validated individually when duplicates are provided, instead of merging them as an array.
  * Whitespace around CSV values is now dropped since it is not significant according to the RFC (whitespace is optional).
  * Bumped `openapi3-deserialiser` to 2.0.0 to enable the changes.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * This plugin no longer uses deprecated features of the `lua-resty-http`
  dependency, which previously added deprecation warnings to the DEBUG log.
  * This plugin no longer sets a Host header if the `upstream_host` is an empty
  string.

* [OAuth2 Introspection](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * This plugin no longer uses deprecated features of the `lua-resty-http`
  dependency, which previously added deprecation warnings to the DEBUG log.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * Fixed plugin initialization code causing HTTP 500 status codes after
  enabling the plugin.

* [mTLS Auth](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where CRL cache was not properly invalidated, causing all
   certificates to appear invalid.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed the `function cannot be called in access phase` error, which occurred
  when the plugin was called in the log phase.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
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

* Cassandra as a backend database for Kong Gateway
is deprecated with this release and will be removed in a future version.

  The target for Cassandra removal is the Kong Gateway 3.4 release.
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

## 2.6.1.0
**Release Date** 2022/04/07

### Fixes

#### Enterprise

* Fixed an issue with RBAC where `endpoint=/kong workspace=*` would not let the `/kong` endpoint be accessed from all workspaces
* Fixed an issue with RBAC where admins without a top level `endpoint=*` permission could not add any RBAC rules, even if they had `endpoint=/rbac` permissions. These admins can now add RBAC rules for their current workspace only.

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`

### Dependencies

* Bumped `openssl` from 1.1.1k to 1.1.1n to resolve CVE-2022-0778 [#8635](https://github.com/Kong/kong/pull/8635)
* Bumped `luarocks` from 3.7.1 to 3.8.0 [#8630](https://github.com/Kong/kong/pull/8630)
* Bumped `openresty` from 1.19.3.2 to 1.19.9.1 [#7727](https://github.com/Kong/kong/pull/7727)

## 2.6.0.4
**Release Date** 2022/02/10

### Fixes

#### Enterprise
* Fixed an issue with Kong Manager OIDC authentication, which caused the error
`“attempt to call method 'select_by_username_ignore_case' (a nil value)”`
and prevented login with OIDC.



## 2.6.0.3
**Release Date:** 2022/01/27

### Features

#### Enterprise
* You can now configure [`cluster_max_payload`](/gateway/latest/reference/configuration/#cluster_max_payload)
for hybrid mode deployments. This configuration option sets the maximum payload
size allowed to be sent across from the control plane to the data plane. If your
environment has large configurations that generate `payload too big` errors
and don't get applied to the data planes, use this setting to adjust the limit.

### Fixes

#### Enterprise

* Phone home metrics are now sent over TLS, meaning that any analytics data
on Kong Gateway usage now travels through an encrypted connection.
* Fixed an issue where OIDC authentication into Kong Manager failed when used
with Azure AD.
* Fixed a timer leak that caused the timers to be exhausted and failed to start
any other timers used by Kong, showing the error `too many pending timers`.
* Fixed an issue with icon alignment in Kong Manager, where the **Delete**
(garbage can) icon overlapped with the **View** link and caused users to
accidentally click **Delete**.

#### Dev Portal
* Fixed the Dev Portal Application Services list to allow pagination.
* Fixed a table border styling issue.
* Fixed issues with modal accessibility.

#### Plugins

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`) and
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Fixed a timer leak that caused the timers to be exhausted and failed to
  start any other timers used by Kong, showing the error `too many pending timers`.

    Before, the plugin used one timer for each namespace maintenance process,
    increasing timer usage on instances with a large number of rate limiting
    namespaces. Now, it uses a single timer for all namespace maintenance.

## 2.6.0.2
**Release Date:** 2021/12/03

### Fixes

#### Dev Portal

* Fixed links in Dev Portal footer.

* Improved accessibility of the Dev Portal, fixing various issues related to
labels, names, headings, and color contrast:
    * Keyboard-accessible response examples and "Try it out" sections
    * Form inputs now have labels
    * Selectable elements now all have accessible names
    * Unique IDs for active elements
    * Heading levels only increase by one, and are in the correct order
    * Improved contrast of buttons

* Fixed the Dev Portal API `/applications` endpoint to only accept allowed
fields in a PATCH request.

* Fixed info tooltip crash and rendering issue when viewing the Dev Portal app
registration service list.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - The plugin now allows Redis Cluster nodes to be specified by hostname
    through the `session_redis_cluster_nodes` field, which
    is helpful if the cluster IPs are not static.

## 2.6.0.1
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

- Users can now successfully delete admins with the `super-admin` role from
any workspace, as long as they have the correct permissions, and the associated
Consumer entity will be deleted as well. This frees up the username for a new
user. Previously, deleting an admin with a `super-admin` role from a different
workspace than where it was originally created did not delete the associated
Consumer entity, and the username would remain locked. For example, if the
admin was created in workspace `dev` and deleted from workspace `QA`, this
issue would occur.

### Dependencies
* Bumped kong-redis-cluster from `1.1-0` to `1.2.0`.
  - With this update, if the entire cluster is restarted and starts up using
  new IP addresses, the cluster client can recover automatically.

## 2.6.0.0
**Release date:** 2021/10/14

### Features

#### Enterprise

#### Core
This release includes the addition of a new schema entity validator: `mutually_exclusive`. Before, the
`only_one_of` validator required at least one of the fields included be configured. This new entity validator allows
only one or neither of the fields be configured.
[#7765](https://github.com/Kong/kong/pull/7765)

#### Configuration
- Enable IPV6 on `dns_order` as unsupported experimental feature.
  [#7819](https://github.com/Kong/kong/pull/7819).
- The template renderer can now use `os.getenv`.
  [#6872](https://github.com/Kong/kong/pull/6872).

#### Hybrid Mode
- Data plane is able to eliminate some unknown fields when Control Plane is using a more modern version.
  [#7827](https://github.com/Kong/kong/pull/7827).

#### Admin API
- Added support for the HTTP HEAD method for all Admin API endpoints.
  [#7796](https://github.com/Kong/kong/pull/7796)
- Added better support for OPTIONS requests. Previously, the Admin API replied the same on all OPTIONS requests,
  where as now OPTIONS request will only reply to routes that our Admin API has. Non-existing routes will have a
  404 returned. Additionally, the Allow header was added to responses. Both Allow and Access-Control-Allow-Methods
  now contain only the methods that the specific API supports.
  [#7830](https://github.com/Kong/kong/pull/7830)

#### Plugins
- **New plugin:** [jq](/hub/kong-inc/jq/) (`jq`)
  The jq plugin enables arbitrary jq transformations on JSON objects included in API requests or responses.
- [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)
  The Kafka Log plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  The Kafka Upstream plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - The Rate Limiting Advanced plugin now has a new identifier type, `path`, which allows rate limiting by
    matching request paths.
  - The plugin now has a `local` strategy in the schema. The local strategy automatically sets `config.sync_rate` to -1.
  - The highest sync-rate configurable was a 1 second interval. This sync-rate has been increased by reducing
    the minimum allowed interval from 1 to 0.020 second (20ms).
- [OPA](/hub/kong-inc/opa/) (`opa`)
  The OPA plugin now has a request path parameter, which makes setting policies on a path easier for administrators.
- [Canary](/hub/kong-inc/canary/) (`canary`)
  The Canary plugin now has the option to hash on the header (falls back on IP, and then random).
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  Upgrade to v2.1.0 to maintain version compatibility with older data planes.
  - Features from v2.0.x include the following:
    - The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
    - The plugin now supports JWE Introspection.
  - Feature from to v2.1.x includes the following:
    - The plugin now has a new param, `by_username_ignore_case`, which allows `consumer_by` username values to be
      matched case-insensitive with Identity Provider claims.
- [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  - This release includes a fix for the URL encode transformed path. The plugin now uses PDK functions to set upstream URI
    by replacing `ngx.var.upstream_uri` so the urlencode is taken care of.
- [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  The plugin will now try to detect the AWS region by using `AWS_REGION` and
  `AWS_DEFAULT_REGION` environment variables (when not specified with the plugin configuration).
  This allows users to specify a 'region' on a per Kong node basis, adding the ability to invoke the
  Lambda function in the same region where Kong is located.
  [#7765](https://github.com/Kong/kong/pull/7765)
- [Datadog](/hub/kong-inc/datadog/) (`datadog`)
  The Datadog plugin now allows `host` and `port` config options be configured from environment variables,
  `KONG_DATADOG_AGENT_HOST` and `KONG_DATADOG_AGENT_PORT`. This update enables users to set
   different destinations on a per Kong node basis, which makes multi-DC setups easier and in Kubernetes helps
   with the ability to run the Datadog agents as a daemon-set.
  [#7463](https://github.com/Kong/kong/pull/7463)
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  The Prometheus plugin now includes a new metric, `data_plane_cluster_cert_expiry_timestamp`, to expose the Data Plane's `cluster_cert`
   expiry timestamp for improved monitoring in Hybrid Mode.
  [#7800](https://github.com/Kong/kong/pull/7800).
- [GRPC-Gateway](/hub/kong-inc/grpc-gateway/) (grpc-gateway)
  - Fields of type `.google.protobuf.Timestamp` on the gRPC side are now
    transcoded to and from ISO8601 strings in the REST side.
    [#7538](https://github.com/Kong/kong/pull/7538)
  - URI arguments like `..?foo.bar=x&foo.baz=y` are interpreted as structured
    fields, equivalent to `{"foo": {"bar": "x", "baz": "y"}}`.
    [#7564](https://github.com/Kong/kong/pull/7564)
- [Request Termination](/hub/kong-inc/request-termination/) (`request-termination`)
  - The Request Termination plugin now includes a new `trigger` config option, which makes the plugin
    only activate for any requests with a header or query parameter named like the trigger. This config option
    can be a great debugging aid, without impacting actual traffic being processed.
    [#6744](https://github.com/Kong/kong/pull/6744).
  - The `request-echo` config option was added. If set, the plugin responds with a copy of the incoming request.
    This config option eases troubleshooting when Kong Gateway is behind one or more other proxies or LB's,
    especially when combined with the new `trigger` option.
    [#6744](https://github.com/Kong/kong/pull/6744).

### Dependencies
* Bumped `openresty` from 1.19.3.2 to [1.19.9.1](https://openresty.org/en/changelog-1019009.html)
  [#7430](https://github.com/Kong/kong/pull/7727)
* Bumped `openssl` from `1.1.1k` to `1.1.1l`
  [7767](https://github.com/Kong/kong/pull/7767)
* Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
* Bumped `Penlight` to 1.11.0
  [#7736](https://github.com/Kong/kong/pull/7736)
* Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
* Bumped `lua-protobuf` from 0.3.2 to 0.3.3
  [#7656](https://github.com/Kong/kong/pull/7656)
* Bumped `lua-resty-openssl` from 0.7.3 to 0.7.4
  [#7657](https://github.com/Kong/kong/pull/7657)
* Bumped `lua-resty-acme` from 0.6 to 0.7.1
  [#7658](https://github.com/Kong/kong/pull/7658)
* Bumped `grpcurl` from 1.8.1 to 1.8.2
  [#7659](https://github.com/Kong/kong/pull/7659)
* Bumped `luasec` from 1.0.1 to 1.0.2
  [#7750](https://github.com/Kong/kong/pull/7750)
* Bumped `lua-resty-ipmatcher` to 0.6.1
  [#7703](https://github.com/Kong/kong/pull/7703)

### Fixes

#### Enterprise
- This release includes a fix for an issue with the Vitals InfluxDB timestamp generation when inserting metrics.
- Kong Gateway (Enterprise) no longer exports `consumer_reset_secrets`.
- Fixes an issue where keyring data was not being properly generated and activated
  on a Kong process start (for example, kong start).
- Kong Gateway now returns keyring-encrypted fields early when a decrypt attempt is made, giving you time
  to import the keys so Kong Gateway can recognize the decrypted fields. Before if there were data fields
  keyring-encrypted in the database, Kong Gateway attempted to decrypt them on the `init*` phases (`init` or `init_worker`
  phases - when the Kong process is started), and you would get errors like "no request found". **Keys must still be imported after the Kong process is started.**
- The [Keyring Encryption](/gateway/latest/kong-enterprise/db-encryption/) feature is no longer in an alpha quality state.
- This release includes a fix to the CentOS Docker image builds, ensuring CentOS 7 images are properly generated.

#### Core
- Balancer retries now correctly set the `:authority` pseudo-header on balancer retries.
  [#7725](https://github.com/Kong/kong/pull/7725).
- Healthchecks are now stopped while the Balancer is being recreated.
  [#7549](https://github.com/Kong/kong/pull/7549).
- Fixed an issue in which a malformed `Accept` header could cause unexpected HTTP 500.
  [#7757](https://github.com/Kong/kong/pull/7757).
- Kong no longer removes `Proxy-Authentication` request header and `Proxy-Authenticate` response header.
  [#7724](https://github.com/Kong/kong/pull/7724).
- Fixed an issue where Kong would not sort correctly Routes with both regex and prefix paths.
  [#7695](https://github.com/Kong/kong/pull/7695)

#### Hybrid Mode
- Ensure data plane config thread is terminated gracefully, preventing a semi-deadlocked state.
  [#7568](https://github.com/Kong/kong/pull/7568)

##### CLI
- `kong config parse` no longer crashes when there's a Go plugin server enabled.
  [#7589](https://github.com/Kong/kong/pull/7589).

##### Configuration
- Declarative Configuration parser now prints more correct errors when printing unknown foreign references.
  [#7756](https://github.com/Kong/kong/pull/7756).
- YAML anchors in Declarative Configuration are properly processed.
  [#7748](https://github.com/Kong/kong/pull/7748).

##### Admin API
- `GET /upstreams/:upstreams/targets/:target` no longer returns 404 when target weight is 0.
  [#7758](https://github.com/Kong/kong/pull/7758).

##### PDK
- `kong.response.exit` now uses customized "Content-Length" header when found.
  [#7828](https://github.com/Kong/kong/pull/7828).

##### Plugins
- [ACME](/hub/kong-inc/acme/) (`acme`)
  Dots in wildcard domains are escaped.
  [#7839](https://github.com/Kong/kong/pull/7839).
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  Upstream's health info now includes previously missing `subsystem` field.
  [#7802](https://github.com/Kong/kong/pull/7802).
- [Proxy-Cache](/hub/kong-inc/proxy-cache/) (`proxy-cache`)
  Fixed an issue where the plugin would sometimes fetch data from the cache but not return it.
  [#7775](https://github.com/Kong/kong/pull/7775)

## 2.6.0.0 (beta1)
**Release date:** 2021/10/04

### Features

#### Enterprise

#### Core
This release includes the addition of a new schema entity validator: `mutually_exclusive`. Before, the
`only_one_of` validator required at least one of the fields included be configured. This new entity validator allows
only one or neither of the fields be configured.
[#7765](https://github.com/Kong/kong/pull/7765)

#### Configuration
- Enable IPV6 on `dns_order` as unsupported experimental feature.
  [#7819](https://github.com/Kong/kong/pull/7819).
- The template renderer can now use `os.getenv`.
  [#6872](https://github.com/Kong/kong/pull/6872).

#### Hybrid Mode
- Data plane is able to eliminate some unknown fields when Control Plane is using a more modern version.
  [#7827](https://github.com/Kong/kong/pull/7827).

#### Admin API
- Added support for the HTTP HEAD method for all Admin API endpoints.
  [#7796](https://github.com/Kong/kong/pull/7796)
- Added better support for OPTIONS requests. Previously, the Admin API replied the same on all OPTIONS requests,
  where as now OPTIONS request will only reply to routes that our Admin API has. Non-existing routes will have a
  404 returned. Additionally, the Allow header was added to responses. Both Allow and Access-Control-Allow-Methods
  now contain only the methods that the specific API supports.
  [#7830](https://github.com/Kong/kong/pull/7830)

#### Plugins
- **New plugin:** [jq](/hub/kong-inc/jq/) (`jq`)
  The jq plugin enables arbitrary jq transformations on JSON objects included in API requests or responses.
- [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)
  The Kafka Log plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  The Kafka Upstream plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - The Rate Limiting Advanced plugin now has a new identifier type, `path`, which allows rate limiting by
    matching request paths.
  - The plugin now has a `local` strategy in the schema. The local strategy automatically sets `config.sync_rate` to -1.
  - The highest sync-rate configurable was a 1 second interval. This sync-rate has been increased by reducing
    the minimum allowed interval from 1 to 0.020 second (20ms).
- [OPA](/hub/kong-inc/opa/) (`opa`)
  The OPA plugin now has a request path parameter, which makes setting policies on a path easier for administrators.
- [Canary](/hub/kong-inc/canary/) (`canary`)
  The Canary plugin now has the option to hash on the header (falls back on IP, and then random).
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  Upgrade to v2.1.0 to maintain version compatibility with older data planes.
  - Features from v2.0.x include the following:
    - The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
    - The plugin now supports JWE Introspection.
  - Feature from to v2.1.x includes the following:
    - The plugin now has a new param, `by_username_ignore_case`, which allows `consumer_by` username values to be
      matched case-insensitive with Identity Provider claims.
- [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  The plugin will now try to detect the AWS region by using `AWS_REGION` and
  `AWS_DEFAULT_REGION` environment variables (when not specified with the plugin configuration).
  This allows users to specify a 'region' on a per Kong node basis, adding the ability to invoke the
  Lambda function in the same region where Kong is located.
  [#7765](https://github.com/Kong/kong/pull/7765)
- [Datadog](/hub/kong-inc/datadog/) (`datadog`)
  The Datadog plugin now allows `host` and `port` config options be configured from environment variables,
  `KONG_DATADOG_AGENT_HOST` and `KONG_DATADOG_AGENT_PORT`. This update enables users to set
   different destinations on a per Kong node basis, which makes multi-DC setups easier and in Kubernetes helps
   with the ability to run the Datadog agents as a daemon-set.
  [#7463](https://github.com/Kong/kong/pull/7463)
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  The Prometheus plugin now includes a new metric, `data_plane_cluster_cert_expiry_timestamp`, to expose the Data Plane's `cluster_cert`
   expiry timestamp for improved monitoring in Hybrid Mode.
  [#7800](https://github.com/Kong/kong/pull/7800).
- [GRPC-Gateway](/hub/kong-inc/grpc-gateway/) (grpc-gateway)
  - Fields of type `.google.protobuf.Timestamp` on the gRPC side are now
    transcoded to and from ISO8601 strings in the REST side.
    [#7538](https://github.com/Kong/kong/pull/7538)
  - URI arguments like `..?foo.bar=x&foo.baz=y` are interpreted as structured
    fields, equivalent to `{"foo": {"bar": "x", "baz": "y"}}`.
    [#7564](https://github.com/Kong/kong/pull/7564)
- [Request Termination](/hub/kong-inc/request-termination/) (`request-termination`)
  - The Request Termination plugin now includes a new `trigger` config option, which makes the plugin
    only activate for any requests with a header or query parameter named like the trigger. This config option
    can be a great debugging aid, without impacting actual traffic being processed.
    [#6744](https://github.com/Kong/kong/pull/6744).
  - The `request-echo` config option was added. If set, the plugin responds with a copy of the incoming request.
    This config option eases troubleshooting when Kong Gateway is behind one or more other proxies or LB's,
    especially when combined with the new `trigger` option.
    [#6744](https://github.com/Kong/kong/pull/6744).

### Dependencies
* Bumped `openresty` from 1.19.3.2 to [1.19.9.1](https://openresty.org/en/changelog-1019009.html)
  [#7430](https://github.com/Kong/kong/pull/7727)
* Bumped `openssl` from `1.1.1k` to `1.1.1l`
  [7767](https://github.com/Kong/kong/pull/7767)
* Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
* Bumped `Penlight` to 1.11.0
  [#7736](https://github.com/Kong/kong/pull/7736)
* Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
* Bumped `lua-protobuf` from 0.3.2 to 0.3.3
  [#7656](https://github.com/Kong/kong/pull/7656)
* Bumped `lua-resty-openssl` from 0.7.3 to 0.7.4
  [#7657](https://github.com/Kong/kong/pull/7657)
* Bumped `lua-resty-acme` from 0.6 to 0.7.1
  [#7658](https://github.com/Kong/kong/pull/7658)
* Bumped `grpcurl` from 1.8.1 to 1.8.2
  [#7659](https://github.com/Kong/kong/pull/7659)
* Bumped `luasec` from 1.0.1 to 1.0.2
  [#7750](https://github.com/Kong/kong/pull/7750)
* Bumped `lua-resty-ipmatcher` to 0.6.1
  [#7703](https://github.com/Kong/kong/pull/7703)

### Fixes

#### Enterprise
- This release includes a fix for an issue with the Vitals InfluxDB timestamp generation when inserting metrics.
- Kong Gateway (Enterprise) no longer exports `consumer_reset_secrets`.
- Fixes an issue where keyring data was not being properly generated and activated
  on a Kong process start (for example, kong start).
- Kong Gateway now returns keyring-encrypted fields early when a decrypt attempt is made, giving you time
  to import the keys so Kong Gateway can recognize the decrypted fields. Before if there were data fields
  keyring-encrypted in the database, Kong Gateway attempted to decrypt them on the `init*` phases (`init` or `init_worker`
  phases - when the Kong process is started), and you would get errors like "no request found". **Keys must still be imported after the Kong process is started.**
- The [Keyring Encryption](/gateway/latest/kong-enterprise/db-encryption/) feature is no longer in an alpha quality state.

#### Core
- Balancer retries now correctly set the `:authority` pseudo-header on balancer retries.
  [#7725](https://github.com/Kong/kong/pull/7725).
- Healthchecks are now stopped while the Balancer is being recreated.
  [#7549](https://github.com/Kong/kong/pull/7549).
- Fixed an issue in which a malformed `Accept` header could cause unexpected HTTP 500.
  [#7757](https://github.com/Kong/kong/pull/7757).
- Kong no longer removes `Proxy-Authentication` request header and `Proxy-Authenticate` response header.
  [#7724](https://github.com/Kong/kong/pull/7724).
- Fixed an issue where Kong would not sort correctly Routes with both regex and prefix paths.
  [#7695](https://github.com/Kong/kong/pull/7695)

#### Hybrid Mode
- Ensure data plane config thread is terminated gracefully, preventing a semi-deadlocked state.
  [#7568](https://github.com/Kong/kong/pull/7568)

##### CLI
- `kong config parse` no longer crashes when there's a Go plugin server enabled.
  [#7589](https://github.com/Kong/kong/pull/7589).

##### Configuration
- Declarative Configuration parser now prints more correct errors when printing unknown foreign references.
  [#7756](https://github.com/Kong/kong/pull/7756).
- YAML anchors in Declarative Configuration are properly processed.
  [#7748](https://github.com/Kong/kong/pull/7748).

##### Admin API
- `GET /upstreams/:upstreams/targets/:target` no longer returns 404 when target weight is 0.
  [#7758](https://github.com/Kong/kong/pull/7758).

##### PDK
- `kong.response.exit` now uses customized "Content-Length" header when found.
  [#7828](https://github.com/Kong/kong/pull/7828).

##### Plugins
- [ACME](/hub/kong-inc/acme/) (`acme`)
  Dots in wildcard domains are escaped.
  [#7839](https://github.com/Kong/kong/pull/7839).
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  Upstream's health info now includes previously missing `subsystem` field.
  [#7802](https://github.com/Kong/kong/pull/7802).
- [Proxy-Cache](/hub/kong-inc/proxy-cache/) (`proxy-cache`)
  Fixed an issue where the plugin would sometimes fetch data from the cache but not return it.
  [#7775](https://github.com/Kong/kong/pull/7775)
