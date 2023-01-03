---
title: Kong Gateway Changelog
---

<!-- vale off -->

## 2.4.1.3
**Release Date** 2021/09/02

### Fixes

#### Enterprise
- This release fixes a regression in the Kong Dev Portal templates that removed dynamic menu navigation and other improvements
from portals created in Kong Gateway v2.4.1.2.

## 2.4.1.2
**Release Date** 2021/08/18

### Fixes

#### Enterprise
- Users can now successfully delete workspaces after deleting all entities associated with that workspace.
  Previously, Kong Gateway was not correctly cleaning up parent-child relationships. For example, creating
  an Admin also creates a Consumer and RBAC user. When deleting the Admin, the Consumer and RBAC user are
  also deleted, but accessing the `/workspaces/workspace_name/meta` endpoint would show counts for Consumers
  and RBAC users, which prevented the workspace from being deleted. Now deleting entities correctly updates
  the counts, allowing an empty workspace to be deleted.
- Updates Kong Dev Portal templates' JQuery dependency to v3.6.0, improving security.
- Users with the `kong_admin` role can now log in to Kong Manager when `enforce_rbac=both` is set.
- Renames the property identifying control planes in hybrid mode when using Kong Vitals with anonymous
  reports enabled. Before, users received the error, `Cannot use this function in data plane`, on their control planes.
- Updates Nettle dependency version from `3.7.2` to `3.7.3`, fixing bugs that could cause
  RSA decryption functions to crash with invalid inputs.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  With this fix, when the OpenID Connect plugin is configured with a `config.anonymous` consumer and
  `config.scopes_required` is set, a token missing the required scopes will have the anonymous consumer
  headers set when sent to the upstream.
- Fixes a regression in the Kong Collector plugin that caused HARs to be kept in its queue indefinitely.

#### Hybrid Mode
- Control planes are now more lenient when checking data planes' compatibility in hybrid mode. See the
  [Version compatibility](/gateway-oss/2.4.x/hybrid-mode/#version-compatibility)
  section of the Hybrid Mode guide for more information. [#7488](https://github.com/Kong/kong/pull/7488)

## 2.4.1.1
**Release Date** 2021/05/27

### Fixes

#### Enterprise
- Kong Gateway now automatically removes trailing and leading whitespaces from RBAC
  `user_token` entries. Before, both Kong Manager and the Admin API (/rbac/users)
  allowed creating RBAC tokens with trailing whitespace. However, HTTP does not
  allow whitespace in the `Kong-Admin-Token` header value. Subsequently, a successfully
  created RBAC token was not usable. This was especially an issue when using Kong Manager
  to create tokens as it's hard to see any accidental whitespace in the text field.
- Kong Immunity used to send query parameters in plain text. With this fix,
  query parameters are now sent obfuscated.

#### Plugins
- When making a call using the [mTLS Authentication](/hub/kong-inc/mtls-auth) plugin,
  instead of a successful connection, users received an error and the call was cancelled.
  With this fix, Kong Gateway now ensures the certificate phase is set in `ngx.ctx`,
  and the mTLS Authentication plugin works as expected.

## 2.4.1.0
**Release Date** 2021/05/18

### Features

#### Core
- This Kong Gateway version introduces relaxed version checks in hybrid mode between control planes
  and data planes, allowing data planes that are missing minor updates (up to two) to
  still connect to the control plane. Also, data planes are allowed to have a superset
  of plugins in addition to the control plane plugins. See
  [Hybrid mode - limitations](/enterprise/2.4.x/deployment/hybrid-mode/#limitations) for
  more information. [6932](https://github.com/Kong/kong/pull/6932)
  <div class="alert alert-ee blue">
    Data planes are not allowed to connect to control planes if they are a different major version,
    a version newer than the control plane’s version, or missing plugins from the control plane.
  </div>
- UTF-8 characters can now be used in tags. This update expands the range of
  accepted characters in tags from a limited set of ASCII characters to almost all UTF-8 sequences.
  Exceptions:
  - `,` and `/` are reserved for filtering tags with "and" and "or", and are not allowed in tags.
  - Non-printable ASCII (for example, the space character) is not allowed.
  See [Tags](/enterprise/2.4.x/admin-api/#tags) in the Admin API documentation for more information.
- Kong Gateway now supports using an Online Certificate Status Protocol (OCSP) responder in the cluster for
  hybrid mode control planes. This new feature can be configured in the `kong.conf` file. See
  [`cluster_oscp`](/enterprise/2.4.x/property-reference/#cluster_ocsp) in the Configuration Reference for
  more information. [6887](https://github.com/Kong/kong/pull/6887)
- PostgreSQL `ssl_version` configuration now defaults to `any`. If `ssl_version` is not explicitly set,
  the `any` option ensures that `luasec` will negotiate the most secure protocol available.

#### Enterprise
When using Kong Gateway in Hybrid mode, if you’re not using features (for example, new plugin offerings)
that the data planes don’t know about (because they aren’t using a version that contains that feature),
the data planes can still read from a control plane of a more recent version. Prior to v2.4.1.0, we did
our version compatibility checks at connection initiation, which meant that incompatibilities in the data plane
were enforced even if those incompatibilities weren’t being used by the configuration at all.  We’ve now switched
the check to happen at configuration read time. See the
[Version Compatibility](/enterprise/2.4.x/deployment/hybrid-mode/#version-compatibility)
section of the Hybrid Mode Overview for more information.

#### PDK
- This release includes a new JavaScript Plugin Development Kit (PDK). This addition
  allows users to write Kong plugins in JavaScript and TypeScript. See
  [Developing JavaScript plugins](/enterprise/2.4.x/external-plugins/#developing-javascript-plugins)
  for more information.
- This release includes support for the Protobuf plugin communication protocol, which can be used in
  place of MessagePack to communicate with non-Lua plugins. [6941](https://github.com/Kong/kong/pull/6941)
- Plugin writers can now use the `ssl_certificate` phase on plugins in the
 [Stream module](/enterprise/2.4.x/plugin-development/custom-logic/#available-contexts).
  Previously plugin writers could not use the `ssl_certificate` phase on plugins in the `stream` module,
  as it was only supported with the HTTP module.
  [6873](https://github.com/Kong/kong/pull/6873)

#### Plugins
- **New plugin:** [OPA](/hub/kong-inc/opa) (`opa`)
  - The OPA plugin forwards requests to an Open Policy Agent and processes the request
    only if the authorization policy allows for it.
- **New plugin:** [Mocking](/hub/kong-inc/mocking) (`mocking`)
  - The Kong Mocking plugin leverages standards-based Open API Specifications (OAS)
    for sending out mock responses to APIs.
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The plugin now supports OT and Jaeger style `uber-trace-id` headers. See `config.header_type` in
    the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [101](https://github.com/Kong/kong-plugin-zipkin/pull/101 )
  - The plugin now allows insertion of custom tags on the Zipkin request trace. See `config.tags_header`
    in the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [102](https://github.com/Kong/kong-plugin-zipkin/pull/102)
  - The plugin now allows the creation of baggage items on child spans.
    [98](https://github.com/Kong/kong-plugin-zipkin/pull/98)
- [JWT](/hub/kong-inc/jwt) (`jwt`)
  - The plugin now supports ES384 JWTs signature validation. [6854](https://github.com/Kong/kong/pull/6854)
- Logging plugins: [File Log](/hub/kong-inc/file-log), [Loggly](/hub/kong-inc/loggly),
  [Syslog](/hub/kong-inc/syslog), [TCP Log](/hub/kong-inc/tcp-log), [UDP Log](/hub/kong-inc/udp-log),
  and [HTTP Log](/hub/kong-inc/http-log)
  - Kong administrators now have a powerful new capability to transform logs to any format that’s needed
    for capturing, indexing, and correlating logs. When formatting, developers also have the ability to
    execute custom Lua code, opening up a new range of possibilities for generating logs to whichever specification
    administrators need the most. This feature uses the new PDK method `kong.log.set_serialize_value`,
    as well as the new sandbox capability, both introduced in Kong v2.3. [6944](https://github.com/Kong/kong/pull/6944)

### Dependencies
- Bumped `opentracing-cpp` from v1.5.1 to v1.6.0
- Bumped `datadog` from v1.1.2 to v1.3.0
- Bumped `nginx-opentracing` from v0.9.0 to v0.14.0
- Bumped `jaeger` from v0.5.0 to v0.7.0
- Bumped `lua-resty-nettle` from v1.8.3 to v2.0.0
- Bumped `openresty` from v1.17.8.2 to v1.19.3.1
- Bumped `luasec` from v1.0.0 to v1.0.1
- Bumped `prometheus` from v1.2.0 to v1.2.1

### Fixes

#### Core
- Kong 2.4 ensures that all the Core entities are loaded before loading any plugins.
  This fixes an error in which plugins could not link to or modify Core entities
  because they were not loaded yet. [6880](https://github.com/Kong/kong/pull/6880)
- Schema validations now log more descriptive error messages when types are invalid.
  [6593](https://github.com/Kong/kong/pull/6593)
- Kong now ignores tags in Cassandra when filtering by multiple entities, which is the
  expected behavior and the one already existent when using PostgreSQL databases.
  See [Tags](/enterprise/2.4.x/admin-api/#tags) in the Admin API
  documentation for more information. [6931](https://github.com/Kong/kong/pull/6931)
- Users can proxy websockets through Kong when using Chrome or Firefox. `HTTP Connection`
  headers usually carry a list of headers meant for receivers (in this case a proxy) that
  are not meant to be proxied further (hop-by-hop headers). The Kong Gateway correctly
  cleans these headers, but it was a bit too aggressive and the `Upgrade` header was cleared
  from response `Connection` headers, causing the connections to fail when using Firefox
  or Chrome. [6929](https://github.com/Kong/kong/pull/6929)
- Kong now accepts fully-qualified domain names ending in dots to be compliant with
  RFC [3986](https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2) internet standard.
  [6864](https://github.com/Kong/kong/pull/6864)
- Kong has removed unnecessary load from DNS servers by resolving an issue occurring when
  using upstreams for load balancing. When caching services, Kong does not warmup upstream
  names used as service hosts entries when warming up DNS entries, as they are not real DNS
  entries. [6891](https://github.com/Kong/kong/pull/6891)
- Migrations order is now guaranteed to be always the same. Before, the order in which the
  subsystems were loaded changed randomly. Now, subsystems are sorted alphabetically, so the
  order in which migrations are executed is constant. [6901](https://github.com/Kong/kong/pull/6901)
- Buffered responses are disabled on connection upgrades. Kong cannot do buffered responses with,
  for example, websocket connection upgrades. [6902](https://github.com/Kong/kong/pull/6902)
- The host header is updated between balancer retries. Before, Kong Gateway set the `Host` header during
  the access phase only and would send the wrong header if a target failed to serve and needed
  to be retried. [6796](https://github.com/Kong/kong/pull/6796)
- Fixed an issue that occurred when using upstreams for load balancing, where Kong was attempting
  to resolve the upstream name instead of the hostname and failing with the errors `name resolution failed`
  and `dns server error: 3 name error`. The following updates correct the issue:
  - Kong does not cache empty upstream name dictionaries. [7002](https://github.com/Kong/kong/pull/7002)
  - Kong does not assume upstreams don't exist after init phases. [7010](https://github.com/Kong/kong/pull/7010)
- Balancer retries now send the upstream the correct target hostname. This fix was originally include in
  [Kong v2.1.2](https://github.com/Kong/kong/blob/master/CHANGELOG.md#212) but was reverted because of an
  issue in the Lua INGINX module. The Lua INGINX module issue has been fixed, and the original balancer
  retry fix re-applied. [1770](https://github.com/openresty/lua-nginx-module/pull/1770)
- The Developer Portal is now disabled when running without a license.
- Kong now ensures healthchecks and balancers are not created on control plane nodes.
  [7085](https://github.com/Kong/kong/pull/7085)
- This release includes the following optimizations of Kong's URL normalization code:
  - only runs regex when necessary
  - normalizes `/..`,`/.`, and `//` if necessary
  - moves anonymous callback functions to module local functions
  [7100](https://github.com/Kong/kong/pull/7100)
- Fixed an issue where control plane nodes would needlessly invalidate and send new configurations
  to data plane nodes. [7112](https://github.com/Kong/kong/pull/7112)
- Kong now ensures HTTP code `405` is handled by Kong's error page. [6933](https://github.com/Kong/kong/pull/6933)
- Kong now ensures errors in plugins `init_worker` do not break Kong's worker initialization.
  [7099](https://github.com/Kong/kong/pull/7099)
- Fixed an issue where two subsequent TLS keep-alive requests would lead to incorrect
  plugin execution. [7102](https://github.com/Kong/kong/pull/7102)
- Kong now ensures Targets upsert operation behaves similarly to other entities' upsert method.
  [7052](https://github.com/Kong/kong/pull/7052)
- Kong now ensures failed balancer retries are saved and accounted for in log data.
  [6972](https://github.com/Kong/kong/pull/6972)

#### Enterprise
- Workspaces now allow special characters in their names. Kong Manager and the Dev Portal now correctly
  display these characters. This update also fixes an issue where workspaces with special characters
  were not correctly detecting collisions in route validation.

#### CLI
Kong now ensures `kong start` and `kong stop` prioritize the CLI flag `--prefix` over
environmental variable `KONG_PREFIX`. [7080](https://github.com/Kong/kong/pull/7080)

#### Configuration
Kong now ensures the [Stream module](/enterprise/2.4.x/plugin-development/custom-logic/#available-contexts)
subsystem allows for configuration of access logs format. [7046](https://github.com/Kong/kong/pull/7046)

#### Admin API
Kong now ensures targets with a weight of 0 are displayed in the Admin API.
[7094](https://github.com/Kong/kong/pull/7094)

#### PDK
- Kong Gateway no longer leaves plugin servers alive after exiting and does not try to
  start them in the unsupported stream subsystem. [6849](https://github.com/Kong/kong/pull/6849)
- Golang does not cache `kong.log` methods. The `kong` table has some special-case logic
  for the `.log` subtable, and avoiding caching preserves this logic. [6701](https://github.com/Kong/kong/pull/6701)
- Config file style and options case are now consistent. [6981](https://github.com/Kong/kong/pull/6981)
- Added correct Protobuf MacOS path to enable external plugins in Homebrew installations. [6980](https://github.com/Kong/kong/pull/6980)
- Kong Gateway now auto-escapes upstream paths (`kong.service.request.set_path()`) to avoid proxying errors.
  [6978](https://github.com/Kong/kong/pull/6978)
- In the Golang PDK, ports are now declared as `Int`. Before they were incorrectly declared
  `Strings`. [6994](https://github.com/Kong/kong/pull/6994)
- Kong now ensures the new `response` phase is accounted for in the phase checkers.
  [7109](https://github.com/Kong/kong/pull/7109)

#### Plugins
- The [Rate Limiting](/hub/kong-inc/rate-limiting) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting)
  plugins included default options that did not work well with DB-less or hybrid deployments because the
  database is not available on data plane nodes. With this fix, the default values and validation rules are now
  compatible with DB-less or hybrid modes. [6885](https://github.com/Kong/kong/pull/6885)
- [OAuth 2.0](/hub/kong-inc/oauth2) (`oauth2`)
  - To improve user experience and limit confusion, the plugin now handles cases of client invalid
    token generation in a more predictable way. Before, the resulting error codes were confusing and
    unhelpful, often leading users to the wrong conclusions. [6594](https://github.com/Kong/kong/pull/6594)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The W3C parsing function was returning a non-used extra value that has been removed, and the plugin
    now early-exits if there is a problem with the W3C Trace Context header.
    [100](https://github.com/Kong/kong-plugin-zipkin/pull/100)
  - Fixed a bug which randomly caused requests to fail with a 400 error code during span timestamping if
    the access phase was skipped. [105](https://github.com/Kong/kong-plugin-zipkin/pull/105)
- [Kong JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
  - Cache now uses upsert instead of insert/update with databases.
  - Key rotation is now more resilient on errors. For example, previously if there were errors like an error
    connecting to an external JSON Web Key Set(JWKS) url endpoint to fetch the JWKS, the error would halt progress.
    Now, the plugin attempts to respond more resiliently, for instance by using older JWKS already downloaded.
  - Adds DB-less improvements. Before the plugin included some code paths that attempted to write data to a database.
    These code paths would cause errors with DB-less mode. Now instead of attempting to write data to a database,
    these code paths use alternative solutions such as storing data in local memory.
- [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
  - The plugin was not allowing access to any Kong modules within the sandbox except `kong.request`,
    which prevented access to other necessary modules such as `kong.log`.
- [HMAC Authentication](/hub/kong-inc/hmac-auth) (`hmac-auth`)
  - The plugin now enables Just-in-time(JIT) compilation of authorization header regex.
    [7037](https://github.com/Kong/kong/pull/7037)
- [MTLS Authentication](/hub/kong-inc/mtls-auth) (`mtls-auth`)
  - Fixed an issue where the plugin did not work in DB-less mode.
- Kong now ensures plugins written in languages other than Lua can use `kong.reponse.get_*`
  methods, for example `kong.reponse.get_status`. [7048](https://github.com/Kong/kong/pull/7048)

### Deprecated
- The BasePlugin class was deprecated in Kong v2.4.x and will be removed in v3.0.x. Plugins
  that extend `base_plugin.lua` will continue to work until v3.0.x but should be updated to the
  newer, simpler [pattern](/enterprise/2.4.x/plugin-development/custom-logic).

### Known issues
The [mTLS Authentication](/hub/kong-inc/mtls-auth) plugin is incompatible with Kong Gateway v2.4.1.0.
When making a call using the mTLS Authentication plugin, instead of a successful connection, users
receive an error and the call is aborted. This error is caused by an update to the way Kong handles
keep-alive connections. [7102](https://github.com/Kong/kong/pull/7102)

## 2.4.0.0 (beta)
**Release Date** 2021/04/13

### Features

#### Core
- This Kong Gateway version introduces relaxed version checks in hybrid mode between control planes
  and data planes, allowing data planes that are missing minor updates (up to two) to
  still connect to the control plane. Also, data planes are allowed to have a superset
  of plugins in addition to the control plane plugins. See [Managing the cluster using Control Plane
  nodes](/gateway-oss/2.4.x/hybrid-mode/#managing-the-cluster-using-control-plane-nodes) for
  more information. [6932](https://github.com/Kong/kong/pull/6932)
  <div class="alert alert-ee blue">
    Data planes are not allowed to connect to control planes if they are a different major version,
    a version newer than the control plane’s version, or missing plugins from the control plane.
  </div>
- UTF-8 characters can now be used in tags. This update expands the range of
  accepted characters in tags from a limited set of ASCII characters to almost all UTF-8 sequences.
  Exceptions:
  - `,` and `/` are reserved for filtering tags with "and" and "or", and are not allowed in tags.
  - Non-printable ASCII (for example, the space character) is not allowed.
  See [Tags](/gateway-oss/2.4.x/admin-api/#tags) in the Admin API documentation for more information.
- Kong Gateway now supports using an Online Certificate Status Protocol (OCSP) responder in the cluster for
  hybrid mode control planes. This new feature can be configured in the `kong.conf` file. See
  [`cluster_oscp`](/gateway-oss/2.4.x/configuration/#cluster_ocsp) in the Configuration Reference for
  more information. [6887](https://github.com/Kong/kong/pull/6887)
- PostgreSQL `ssl_version` configuration now defaults to `any`. If `ssl_version` is not explicitly set,
  the `any` option ensures that `luasec` will negotiate the most secure protocol available.

#### PDK
- This release includes a new JavaScript Plugin Development Kit (PDK). This addition
  allows users to write Kong plugins in JavaScript and TypeScript. See
  [Developing JavaScript plugins](/gateway-oss/2.4.x/external-plugins/#developing-javascript-plugins)
  for more information.
- This release includes support for the Protobuf plugin communication protocol, which can be used in
  place of MessagePack to communicate with non-Lua plugins. [6941](https://github.com/Kong/kong/pull/6941)
- This release enables the `ssl_certificate` phase on plugins in the `stream` module.
  [6873](https://github.com/Kong/kong/pull/6873)

#### Plugins
- **New plugin:** [OPA](/hub/kong-inc/opa) (`opa`)
  - The OPA plugin forwards requests to an Open Policy Agent and processes the request
    only if the authorization policy allows for it. **Released as BETA and should not be deployed
    in production environment.**
- **New plugin:** Mocking (`mocking`)
  - The Kong Mocking plugin leverages standards-based Open API Specifications (OAS)
    for sending out mock responses to APIs. **Released as BETA and should not be deployed
    in production environment.**
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The plugin now supports OT and Jaeger style `uber-trace-id` headers. See `config.header_type` in
    the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [101](https://github.com/Kong/kong-plugin-zipkin/pull/101 )
  - The plugin now allows insertion of custom tags on the Zipkin request trace. See `config.tags_header`
    in the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [102](https://github.com/Kong/kong-plugin-zipkin/pull/102)
  - The plugin now allows the creation of baggage items on child spans.
    [98](https://github.com/Kong/kong-plugin-zipkin/pull/98)
- [JWT](/hub/kong-inc/jwt) (`jwt`)
  - The plugin now supports ES384 JWTs signature validation. [6854](https://github.com/Kong/kong/pull/6854)
- Logging plugins: [File Log](/hub/kong-inc/file-log), [Loggly](/hub/kong-inc/loggly),
  [Syslog](/hub/kong-inc/syslog), [TCP Log](/hub/kong-inc/tcp-log), [UDP Log](/hub/kong-inc/udp-log),
  and [HTTP Log](/hub/kong-inc/http-log)
  - Kong administrators now have a powerful new capability to transform logs to any format that’s needed
    for capturing, indexing, and correlating logs. When formatting, developers also have the ability to
    execute custom Lua code, opening up a new range of possibilities for generating logs to whichever specification
    administrators need the most. This feature uses the new PDK method `kong.log.set_serialize_value`,
    as well as the new sandbox capability, both introduced in Kong v2.3. [6944](https://github.com/Kong/kong/pull/6944)
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  - `kong-openid-connect` library updated to v2.1.0
    - Treats JWE tokens as opaque, so that they can be introspected.
    - Adds support for Ed448 curve in EdDSA signing and verification and JWKS key generation.

### Dependencies
- Bumped `opentracing-cpp` from v1.5.1 to v1.6.0
- Bumped `datadog` from v1.1.2 to v1.3.0
- Bumped `nginx-opentracing` from v0.9.0 to v0.14.0
- Bumped `jaeger` from v0.5.0 to v0.7.0
- Bumped `lua-resty-nettle` from v1.8.3 to v2.0.0
- Bumped `openresty` from v1.17.8.2 to v1.19.3.1

### Fixes

#### Core
- Topological sort now prioritizes core, avoiding problems when plugin entities use core entities but
  don't explicitly depend on them. [6880](https://github.com/Kong/kong/pull/6880)
- Schema validations now log more descriptive error messages when types are invalid.
  [6593](https://github.com/Kong/kong/pull/6593)
- Kong now ignores tags in Cassandra when filtering by multiple entities, which is the
  expected behavior and the one already existent when using PostgreSQL databases.
  See [Tags](https://docs.konghq.com/enterprise/2.3.x/admin-api/#tags) in the Admin API
  documentation for more information. [6931](https://github.com/Kong/kong/pull/6931)
- Users can proxy websockets through Kong when using Chrome or Firefox. `HTTP Connection`
  headers usually carry a list of headers meant for receivers (in this case a proxy) that
  are not meant to be proxied further (hop-by-hop headers). The Kong Gateway correctly
  cleans these headers, but it was a bit too aggressive and the `Upgrade` header was cleared
  from response `Connection` headers, causing the connections to fail when using Firefox
  or Chrome. [6929](https://github.com/Kong/kong/pull/6929)
- Kong now accepts fully-qualified domain names ending in dots to be compliant with RFC internet standards.
  [6864](https://github.com/Kong/kong/pull/6864)
- Kong has removed unnecessary load from DNS servers by resolving an issue occurring when
  using upstreams for load balancing. When caching services, Kong does not warmup upstream
  names used as service hosts entries when warming up DNS entries, as they are not real DNS
  entries. [6891](https://github.com/Kong/kong/pull/6891)
- Migrations order is now guaranteed to be always the same. Before, the order in which the
  subsystems were loaded changed randomly. Now, subsystems are sorted alphabetically, so the
  order in which migrations are executed is constant. [6901](https://github.com/Kong/kong/pull/6901)
- Buffered responses are disabled on connection upgrades. Kong cannot do buffered responses with,
  for example, websocket connection upgrades. [6902](https://github.com/Kong/kong/pull/6902)
- Entity relationships are now traverse-order-independent. This fix keeps track of all copied
  records and injects the new field on each copy.
  [6843](https://github.com/Kong/kong/commit/5f2a87259e3b474ec6129490bba82dac0aeba1cf)
- The host header is updated between balancer retries. Before, Kong Gateway set the `Host` header during
  the access phase only and would send the wrong header if a target failed to serve and needed
  to be retried. [6796](https://github.com/Kong/kong/pull/6796)
- The router prioritizes the route with most matching headers when matching headers.
  [6638](https://github.com/Kong/kong/pull/6638)
- Fixed an issue involving multipart/form-data boundary checks. [6638](https://github.com/Kong/kong/pull/6638)
- Fixed an issue that occurred when using upstreams for load balancing, where Kong was attempting
  to resolve the upstream name instead of the hostname and failing with the errors `name resolution failed`
  and `dns server error: 3 name error`. The following updates correct the issue:
  - Kong does not cache empty upstream name dictionaries. [7002](https://github.com/Kong/kong/pull/7002)
  - Kong does not assume upstreams don't exist after init phases. [7010](https://github.com/Kong/kong/pull/7010)
- The Developer Portal is now disabled when running without a license.

#### PDK
- Kong Gateway no longer leaves plugin servers alive after exiting and does not try to
  start them in the unsupported stream subsystem. [6849](https://github.com/Kong/kong/pull/6849)
- Golang does not cache `kong.log` methods. The `kong` table has some special-case logic
  for the `.log` subtable, and avoiding caching preserves this logic. [6701](https://github.com/Kong/kong/pull/6701)
- The `response` phase is now included on the list of public phases. [6638](https://github.com/Kong/kong/pull/6638)
- Config file style and options case are now consistent. [6981](https://github.com/Kong/kong/pull/6981)
- Added correct Protobuf MacOS path to enable external plugins in Homebrew installations. [6980](https://github.com/Kong/kong/pull/6980)
- Kong Gateway now auto-escapes upstream paths (`kong.service.request.set_path()`) to avoid proxying errors.
  [6978](https://github.com/Kong/kong/pull/6978)
- In the Golang PDK, ports are now declared as `Int`. Before they were incorrectly declared
  `Strings`. [6994](https://github.com/Kong/kong/pull/6994)

#### Plugins
- The [Rate Limiting](/hub/kong-inc/rate-limiting) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting)
  plugins included default options that did not work well with DB-less or hybrid deployments because the
  database is not available on data plane nodes. With this fix, the default values and validation rules are now
  compatible with DB-less or hybrid modes. [6885](https://github.com/Kong/kong/pull/6885)
- [OAuth 2.0](/hub/kong-inc/oauth2) (`oauth2`)
  - To improve user experience and limit confusion, the plugin now handles cases of client invalid
    token generation in a more predictable way. Before, the resulting error codes were confusing and
    unhelpful, often leading users to the wrong conclusions. [6594](https://github.com/Kong/kong/pull/6594)
- [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
  - The W3C parsing function was returning a non-used extra value that has been removed, and the plugin
    now early-exits if there is a problem with the W3C Trace Context header.
    [100](https://github.com/Kong/kong-plugin-zipkin/pull/100)
  - Fixed a bug which randomly caused requests to fail with a 400 error code during span timestamping if
    the access phase was skipped. [105](https://github.com/Kong/kong-plugin-zipkin/pull/105)
- [Kong JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
  - Cache now uses upsert instead of insert/update with databases.
  - Key rotation is now more resilient on errors.
  - Adds DB-less improvements.
- [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
  - The plugin was not allowing access to any Kong modules within the sandbox except `kong.request`,
    which prevented access to other necessary modules such as `kong.log`.

