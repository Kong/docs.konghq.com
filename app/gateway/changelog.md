---
title: Kong Gateway Changelog
no_version: true
---

<!-- vale off -->
## 3.1.0.0
**Release Date** 2022/12/06

## Features

### Enterprise

- You can now specify the namespaces of HashiCorp Vaults for secrets management.

- Added support for HashiCorp Vault backends to retrieve a vault token from a
Kubernetes service account. See the following configuration parameters:
  - [`keyring_vault_auth_method`](/gateway/latest/reference/configuration/#keyring_vault_auth_method)
  - [`keyring_vault_kube_role`](/gateway/latest/reference/configuration/#keyring_vault_kube_role)
  - [`keyring_vault_kube_api_token_file`](/gateway/latest/reference/configuration/#keyring_vault_kube_api_token_file)

- FIPS 140-2 packages:
  - Kong Gateway Enterprise now provides [FIPS 140-2 compliant packages for Red Hat Enterprise 8 and Ubuntu 22.04](/gateway/latest/kong-enterprise/fips-support).
  - All out of the box Kong plugins are now supported in the Ubuntu and RHEL 8 FIPS-compliant packages.
  - Kong Gateway FIPS distributions now support TLS connections to the PostgreSQL database.

- You can now [delete consumer group configurations](/gateway/latest/kong-enterprise/consumer-groups/#delete-consumer-group-configurations)
 without deleting the group or the consumers in it.

- **Kong Manager**:
  - You can now configure the base path for Kong Manager, for example: `localhost:8445/manager`. This allows you to proxy all traffic through {{site.base_gateway}}. For example, you can proxy both API and Kong Manager traffic from one port. In addition, using the new Kong Manager base path allows you to add plugins to control access to Kong Manager. For more information, see [Enable Kong Manager](/gateway/latest/kong-manager/enable/).
  - You can now create consumer groups in Kong Manager. This allows you to define any number of rate limiting tiers and apply them to subsets of consumers instead of managing each consumer individually. For more information, see [Create Consumer Groups in Kong Manager](/gateway/latest/kong-manager/consumer-groups/).
  - You can now add `key-auth-enc` credentials to a consumer.
  - OpenID Connect plugin: More authorization variables have been added to the **Authorization** tab.
  - The Kong Manager overview tab has been optimized for performance.
  - You can now configure vaults for managing secrets through Kong Manager.
    Use the new Vaults menu to set up and manage any vaults that Kong Gateway supports.
    See the [Vault Backends references](/gateway/latest/kong-enterprise/secrets-management/backends/)
    for descriptions of all the configuration options.
  - Added support for interfacing with dynamic plugin ordering.
  - Added the ability to view details about certificates.
  - Added tooltips to plugin UI with field descriptions.
  - Added support for persisting the page size of lists across pages and provided
  more options for page sizes.

### Core
- Allow `kong.conf` SSL properties to be stored in vaults or environment
  variables. Allow such properties to be configured directly as content
  or base64 encoded content.
  [#9253](https://github.com/Kong/kong/pull/9253)
- Added support for full entity transformations in schemas.
  [#9431](https://github.com/Kong/kong/pull/9431)
- The schema `map` type field can now be marked as referenceable.
  [#9611](https://github.com/Kong/kong/pull/9611)
- Added support for dynamically changing the log level.
  [#9744](https://github.com/Kong/kong/pull/9744)
- Added support for the `keys` and `key-sets` entities. These are used for
managing asymmetric keys in various formats (JWK, PEM). For more information,
see [Key management](/gateway/latest/reference/key-management/).
[#9737](https://github.com/Kong/kong/pull/9737)

### Hybrid Mode

- Data plane node IDs will now persist across restarts.
  [#9067](https://github.com/Kong/kong/pull/9067)
- Added HTTP CONNECT forward proxy support for hybrid mode connections. New configuration
  options `cluster_use_proxy`, `proxy_server` and `proxy_server_ssl_verify` are added.
  For more information, see [CP/DP Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/).
  [#9758](https://github.com/Kong/kong/pull/9758)
  [#9773](https://github.com/Kong/kong/pull/9773)

### Performance

- Increase the default value of `lua_regex_cache_max_entries`. A warning will be thrown
  when there are too many regex routes and `router_flavor` is `traditional`.
  [#9624](https://github.com/Kong/kong/pull/9624)
- Add batch queue into the Datadog and StatsD plugins to reduce timer usage.
  [#9521](https://github.com/Kong/kong/pull/9521)

### OS support

- Kong Gateway now supports Amazon Linux 2022 with Enterprise packages.
- Kong Gateway now supports Ubuntu 22.04 with both open-source and Enterprise packages.

### PDK

- Extend `kong.client.tls.request_client_certificate` to support setting
  the Distinguished Name (DN) list hints of the accepted CA certificates.
  [#9768](https://github.com/Kong/kong/pull/9768)

### Plugins

**New plugins:**
- [**AppDynamics**](/hub/kong-inc/app-dynamics) (`app-dynamics`)
  - Integrate Kong Gateway with the AppDynamics APM Platform.
- [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt) (`jwe-decrypt`)
  - Allows you to decrypt an inbound token (JWE) in a request.
- [**OAS Validation**](/hub/kong-inc/oas-validation) (`oas-validation`)
  - Validate HTTP requests and responses based on an OpenAPI 3.0 or Swagger API Specification.
- [**SAML**](/hub/kong-inc/saml) (`saml`)
  - Provides SAML v2.0 authentication and authorization between a service provider (Kong Gateway) and an identity provider (IdP).
- [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection) (`xml-threat-protection`)
  - This new plugin allows you to reduce the risk of XML attacks by checking the structure of XML payloads. This validates maximum complexity (depth of the tree), maximum size of elements and attributes.

**Updates to existing plugins:**

- [**ACME**](/hub/kong-inc/acme/) (`acme`)
  - Added support for Redis SSL, through configuration properties
  `config.storage_config.redis.ssl`, `config.storage_config.redis.ssl_verify`,
  and `config.storage_config.redis.ssl_server_name`.
  [#9626](https://github.com/Kong/kong/pull/9626)

- [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Added `requestContext` field into `awsgateway_compatible` input data
  [#9380](https://github.com/Kong/kong/pull/9380)

- [**Authentication plugins**](/hub/#authentication):
  - The `anonymous` field can now be configured as the username of the consumer.
  This field allows you to configure a string to use as an “anonymous” consumer if authentication fails.

- [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  - Added referenceable attribute to the `headers` field
  that could be stored in vaults.
  [#9611](https://github.com/Kong/kong/pull/9611)

- [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  - `x_headers` field added. This field indicates how the plugin handles the headers
  `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Host`, and `X-Forwarded-Port`.

    The field can take one of the following options:
    - `append`: append information from this hop in the chain to those headers. This is the default setting.
    - `transparent`: leave the headers unchanged, as if the the Kong Gateway was not a proxy.
    - `delete`: remove all the headers, as if the Kong Gateway was the originating client.

    Note that all options respect the trusted IP setting, and will ignore headers from the last hop in the chain if they are not from clients with trusted IPs.

- [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  - Added the `included_status_codes` and `random_status_code` fields. These allow you to configure the HTTP status codes for the plugin.
  - The plugin now lets you auto-generate a random response based on the schema definition without defining examples.
  - You can now control behavior or obtain a specific response by sending
   behavioral headers: `X-Kong-Mocking-Delay`, `X-Kong-Mocking-Example-Id`,
   and `X-Kong-Mocking-Status-Code`.
  - This plugin now supports:
    - MIME types priority match
    - All HTTP codes
    - `$ref`

- [**mTLS Authentication**](/hub/kong-inc/mtls-auth) (`mtls-auth`)
  - Added the `config.send_ca_dn` configuration parameter to support sending CA
   DNs in the `CertificateRequest` message during SSL handshakes.
  - Added the `allow_partial_chain` configuration parameter to allow certificate verification with only an intermediate certificate.

- [**OPA**](/hub/kong-inc/opa/) (`OPA`)
  - Added the `include_uri_captures_in_opa_input` field. When this field is set to true, the [regex capture groups](/gateway/latest/reference/proxy/#using-regex-in-paths) captured on the Kong Gateway route's path field in the current request (if any) are included as input to OPA.

- [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  - Added support for integrating with Redis clusters through the `config.redis.cluster_addresses` configuration property.

- [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  - The HTTP status code and response body for rate-limited
  requests can now be customized. Thanks, [@utix](https://github.com/utix)!
  [#8930](https://github.com/Kong/kong/pull/8930)

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - Added support for deleting customer groups using the API.
  - Added `config.disable_penalty` to control whether to count `429` or not in
   sliding window mode.

- [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  - Added support for navigating nested JSON objects and arrays when transforming a JSON payload.
  - The plugin now supports vault references.

- [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  - The plugin now supports the `charset` option for the
  `config.allowed_content_types` parameter.

- [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  - Added support for Redis SSL through configuration properties
  `redis_ssl` (can be set to `true` or `false`), `ssl_verify`, and `ssl_server_name`.
   Thanks, [@dominikkukacka](https://github.com/dominikkukacka)!
   [#8595](https://github.com/Kong/kong/pull/8595)

- [**Route Transformer Advanced**](/hub/kong-inc/route-transformer-advanced/) (`route-transformer-advanced`)
  - Added the `config.escape_path` configuration parameter, which lets you
  escape the transformed path.

- [**Session**](/hub/kong-inc/session/) (`session`)
  - Added new config `cookie_persistent`, which allows the browser to persist
  cookies even if the browser is closed. This defaults to `false` which means
  cookies are not persisted across browser restarts.
  Thanks [@tschaume](https://github.com/tschaume)
  for this contribution!
  [#8187](https://github.com/Kong/kong/pull/8187)

- [**Vault Authentication**](/hub/kong-inc/vault-auth/) (`vault-auth`)
  - Added support for KV Secrets Engine v2.

- [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  - Added the `response_header_for_traceid` field in Zipkin plugin.
  The plugin sets the corresponding header in the response
  if the field is specified with a string value.
  [#9173](https://github.com/Kong/kong/pull/9173)

- WebSocket service/route support was added for logging plugins:
  - http-log
  - file-log
  - udp-log
  - tcp-log
  - loggly
  - syslog
  - kafka-log

## Known limitations

- With Dynamic log levels, if you set log-level to `alert` you will still see `info` and `error` entries in the logs. 

## Fixes

### Enterprise

- Fixed an issue where the RBAC token was not re-hashed after an update on the `user_token` field.
- Fixed an issue where `admin_gui_auth_conf` wouldn't accept
a JSON-formatted value, and was therefore unable to use vault references to
secrets.
- Fixed an issue where Admin GUI logs were not stored in the correct log file.
- Fixed an issue where Kong Gateway was unable to start in free Enterprise mode
while using vaults.
- Updated the response body for the `TRACE` method request.
- Targets with a weight of `0` are no longer included in health checks, and checking their status via the `upstreams/<upstream>/health` endpoint results in the status `HEALTHCHECK_OFF`.
Previously, the `upstreams/<upstream>/health` endpoint was incorrectly reporting targets with `weight=0` as `HEALTHY`, and the health check was reporting the same targets as `UNDEFINED`.
- Updated the Admin API response status code from `500` to `200` when the
  database is down.
- Fixed an issue when passing a license from the control plane to the data plane
  using the Admin API `/licenses` endpoint.
- In hybrid mode, fixed a license issue where entity validation would fail when
  the license entity was not processed first.
- Fixed a Websockets issue with redirects. Now, Kong Gateway redirects `ws`
requests to `wss` for `wss`-only routes for parity with HTTP/HTTPS.
- **Kong Manager**:
  - Added logging for all Kong Manager access logs.
  - Fixed an issue where the **New Workspace** button was occasionally unusable.
  - Fixed the name display of plugin configurations in Kong Manager.
  - Fixed an issue where some items were missing from the suggestion list
  when there were many items present.
  - Removed the deprecated Vitals Reports feature from Kong Manager.
  - Fixed an issue where admins with permissions to interact with scoped entities,
  such as routes and services, couldn't perform operations as expected.
  - Fixed an issue where admins with the `/admins` permission were forced to
  log out after signing in.
  - Fixed a performance issue where admins with a large number of workspace
  permissions caused Kong Manager to load slowly.

### Core

- Fixed an issue where external plugins crashing with unhandled exceptions
  would cause high CPU utilization after the automatic restart.
  [#9384](https://github.com/Kong/kong/pull/9384)
- Added `use_srv_name` options to upstream for balancer.
  [#9430](https://github.com/Kong/kong/pull/9430)
- Fixed an issue in `header_filter` instrumentation where the span was not
  correctly created.
  [#9434](https://github.com/Kong/kong/pull/9434)
- Fixed an issue in router building in `traditional_compatible` mode.
  When the field contained an empty table, the generated expression was invalid.
  [#9451](https://github.com/Kong/kong/pull/9451)
- Fixed an issue in router rebuilding where when the `paths` field is invalid,
  the router's mutex is not released properly.
  [#9480](https://github.com/Kong/kong/pull/9480)
- Fixed an issue where `kong docker-start` would fail if `KONG_PREFIX` was set to
  a relative path.
  [#9337](https://github.com/Kong/kong/pull/9337)
- Fixed an issue with error-handling and process cleanup in `kong start`.
  [#9337](https://github.com/Kong/kong/pull/9337)
- Fixed issue with prefix path normalization.
  [#9760](https://github.com/Kong/kong/pull/9760)
- Increased the maximum request argument number of the Admin API from 100 to 1000.
  The Admin API now returns a `400` error if request parameters reach the
  limitation instead of truncating any parameters over the limit.
  [#9510](https://github.com/Kong/kong/pull/9510)
- Paging size parameter is now propagated to next page if specified
  in current request.
  [#9503](https://github.com/Kong/kong/pull/9503)

### Hybrid Mode

- Fixed a race condition that could cause configuration push events to be dropped
  when the first data plane connection was established with a control plane
  worker.
  [#9616](https://github.com/Kong/kong/pull/9616)

### CLI

- Fixed slow CLI performance due to pending timer jobs.
  [#9536](https://github.com/Kong/kong/pull/9536)

### PDK

- Added support for `kong.request.get_uri_captures`
  (`kong.request.getUriCaptures`)
  [#9512](https://github.com/Kong/kong/pull/9512)
- Fixed parameter type of `kong.service.request.set_raw_body`
  (`kong.service.request.setRawBody`), return type of
  `kong.service.response.get_raw_body`(`kong.service.request.getRawBody`),
  and body parameter type of `kong.response.exit` to bytes. Note that the old
  version of the go PDK is incompatible after this change.
  [#9526](https://github.com/Kong/kong/pull/9526)

### Plugins

- Added the missing `protocols` field to various plugin schemas.
  [#9525](https://github.com/Kong/kong/pull/9525)

- [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Fixed an issue that was causing inability to
  read environment variables in ECS environment.
  [#9460](https://github.com/Kong/kong/pull/9460)
  - Specifying a null value for the `isBase64Encoded` field in lambda output
  now results in a more obvious error log entry with a `502` code.
  [#9598](https://github.com/Kong/kong/pull/9598)

* [**Azure Functions**](/hub/kong-inc/azure-functions/) (`azure-functions`)
  * Fixed an issue where calls made by this plugin would fail in the following situations:
    * The plugin was associated with a route that had no service.
    * The route's associated service had a `path` value.
    [#9177](https://github.com/Kong/kong/pull/9177)

- [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  - Fixed an issue where queue ID serialization
  did not include `queue_size` and `flush_timeout`.
  [#9789](https://github.com/Kong/kong/pull/9789)

- [**Mocking**](/hub/kong-inc/mocking) (`mocking`)
  - Fixed an issue with `accept` headers not being split and not working with wildcards. The `;q=` (q-factor weighting) of `accept` headers is now supported.

- [**OPA**](/hub/kong-inc/opa) (`opa`)
  - Removed redundant deprecated code from the plugin.

- [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  - Fixed an issue that the default propagation header
    was not configured to `w3c` correctly.
    [#9457](https://github.com/Kong/kong/pull/9457)
  - Replaced the worker-level table cache with
    `BatchQueue` to avoid data race.
    [#9504](https://github.com/Kong/kong/pull/9504)
  - Fixed an issue that the `parent_id` was not set
    on the span when propagating w3c traceparent.
    [#9628](https://github.com/Kong/kong/pull/9628)

- [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced) (`proxy-cached-advanced`)
  - The plugin now catches the error when Kong Gateway connects to Redis SSL port `6379` with `config.ssl=false`.

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  - The plugin now ensures that shared dict TTL is higher than `config.sync_rate`, otherwise Kong Gateway would lose all request counters in shared dict.

- [**Request Transformer**](/hub/kong-inc/request-transformer/) (`request-transformer`)
  - Fixed a bug when header renaming would override
   the existing header and cause unpredictable results.
  [#9442](https://github.com/Kong/kong/pull/9442)

- [**Request Termination**](/hub/kong-inc/request-termination/) (`request-termination`)
  - The plugin no longer allows setting `status_code` to `null`.
  [#9400](https://github.com/Kong/kong/pull/9400)

- [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  - Fixed the bug that the plugin would break when receiving an unexpected body.
  [#9463](https://github.com/Kong/kong/pull/9463)

- [**Zipkin**](/hub/kong-inc/zipkin) (`zipkin`)
  - Fixed an issue where Zipkin plugin couldn't parse OT baggage headers
    due to an invalid OT baggage pattern.
    [#9280](https://github.com/Kong/kong/pull/9280)

## Performance Benchmarks

The following table contains benchmark metrics comparing this release against the prior version. See the dedicated [Performance Benchmarking](/gateway/latest/reference/performance-benchmarks/) page for details on these metrics and the testing methodology utilized to obtain them.

| Metric | 3.1.0.0 | 3.0.1.0 | 
| ------ | ------- | ------- |
| RPS (higher better) | 103,173 | +6.32% |
| Min Latency (lower better) | 0.29ms | -3.34% |
| Avg Latency (lower better) | 0.90ms | -6.25% |
| Max Latency (lower better) | 53.5ms | +5.49% |
| P99 (lower better) | 3.17ms | -8.65% |


## Breaking changes

### Hybrid mode

- The legacy hybrid configuration protocol has been removed in favor of the wRPC protocol
introduced in 3.0.0.0. Rolling upgrades from 2.8.x.y to 3.1.0.0 are not supported.
Operators must upgrade to 3.0.x.x before they can perform a rolling upgrade to 3.1.0.0. For more information, see [Upgrade Kong Gateway 3.1.x](/gateway/3.1.x/upgrade).
  [#9740](https://github.com/Kong/kong/pull/9740)

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

* Kong Gateway now supports [dynamic plugin ordering](/gateway/3.0.x/kong-enterprise/plugin-ordering).
You can change a plugin's static priority by specifing the order in which plugins run.
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
    * PDK modules: [kong.websocket.client](/gateway/3.0.x/plugin-development/pdk/kong.websocket.client) and [kong.websocket.upstream](/gateway/3.0.x/plugin-development/pdk/kong.websocket.upstream)
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

    If you want to retain or add other dependencies, you can [build custom Kong Docker images](/gateway/3.0.x/install/docker/build-custom-images).

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
  * [Configure routes using expressions](/gateway/3.0.x/key-concepts/routes/expressions)
  * [Router Expressions Language reference](/gateway/3.0.x/reference/router-expressions-language)
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
  * [OpenTelemetry](/hub/kong-inc/opentelemetry) (`opentelemetry`)

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

* [ACME](/hub/kong-inc/ACME/) (`acme`)
  * Added the `allow_any_domain` field. It defaults to false and if set to true, the gateway will
  ignore the `domains` field.
  [#9047](https://github.com/Kong/kong/pull/9047)

* [AWS Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
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

* [DeGraphQL](/hub/kong-inc/degraphql) (`degraphql`)
  * The GraphQL server path is now configurable with the `graphql_server_path` configuration parameter.

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and
[Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
  * Added support for the `SCRAM-SHA-512` authentication mechanism.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)
  * This plugin now allows authorization based on group membership.
  The new configuration parameter, `groups_required`, is an array of string
  elements that indicates the groups that users must belong to for the request
  to be authorized.
  * The character `.` is now allowed in group attributes.
  * The character `:` is now allowed in the password field.

* [mTLS Authentication](/hub/kong-inc/mtls-auth) (`mtls-auth`)
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

* [StatsD](/hub/kong-inc/statsd) (`statsd`)
  * **Newly open-sourced plugin capabilities**: All capabilities of the [StatsD Advanced](/hub/kong-inc/statsd-advanced/) plugin are now bundled in the [StatsD](https://docs.konghq.com/hub/kong-inc/statsd) plugin.
    [#9046](https://github.com/Kong/kong/pull/9046)

* [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
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
  [Kong/kong-distributions #766](https://github.com/Kong/kong-distributions/pull/766)

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
    - `hmac-auth` changed from `1000` to `1030`
    - `jwt` changed from `1005` to `1450`
    - `jwt-signer` changed from `999` to `1020`.
    - `key-auth` changed from `1003` to `1250`
    - `ldap-auth` changed from `1002` to `1200`
    - `oauth2` changed from `1004` to `1400`
    - `rate-limiting` changed from `901` to `910`
    - `pre-function` changed from `+inf` to `1000000`.

* Kong plugins no longer support `CREDENTIAL_USERNAME` (`X-Credential-Username`).
  Use the constant `CREDENTIAL_IDENTIFIER` (`X-Credential-Identifier`) when
  setting the upstream headers for a credential.
  [#8815](https://github.com/Kong/kong/pull/8815)

* [ACL](/hub/kong-inc/acl/) (`acl`), [Bot Detection](/hub/kong-inc/bot-detection) (`bot-detection`), and [IP Restriction](/hub/kong-inc/ip-restriction/) (`ip-restriction`)
  * Removed the deprecated `blacklist` and `whitelist` configuration parameters.
   [#8560](https://github.com/Kong/kong/pull/8560)

* [ACME](/hub/kong-inc/ACME/) (`acme`)
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

* [Serverless Functions](/hub/kong-inc/serverless-functions/) (`post-function` or `pre-function`)
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

* [ACME](/hub/kong-inc/ACME/) (`acme`)
  * The default value of the `auth_method` configuration parameter is now set to `token`.
  [#8565](https://github.com/Kong/kong/pull/8565)
  * Added a cache for `domains_matcher`.
  [#9048](https://github.com/Kong/kong/pull/9048)

* [HTTP Log](/hub/kong-inc/http-log) (`http-log`)
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

* [LDAP Authentication](/hub/kong-inc/ldap-auth) (`ldap-auth`)
  * Refactored ASN.1 parser using OpenSSL API through FFI.
    [#8663](https://github.com/Kong/kong/pull/8663)

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)
  * Fixed an issue where Kong Manager LDAP authentication failed when `base_dn` was the domain root.

* [Mocking](/hub/kong-inc/mocking) (`mocking`)
  * Fixed an issue where `204` responses were not handled correctly and you would see the following error:
`"No examples exist in API specification for this resource"`.
  * `204` response specs now support empty content elements.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
openid-connect
  * Fixed an issue with `kong_oauth2` consumer mapping.

* [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)
    [#8968](https://github.com/Kong/kong/pull/8968)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed error handling when calling `get_window` and added more buffer on the window reserve.
  * Fixed error handling for plugin strategy configuration when in hybrid or DB-less mode and strategy is set to `cluster`.

* [Serverless Functions](/hub/kong-inc/serverless-functions/) (`serverless-functions`)
  * Fixed a problem that could cause a crash.
  [#9269](https://github.com/Kong/kong/pull/9269)

* [Syslog](/hub/kong-inc/syslog/) (`syslog`)
  * The `conf.facility` default value is now set to `user`.
    [#8564](https://github.com/Kong/kong/pull/8564)

* [Zipkin](/hub/kong-inc/zipkin) (`zipkin`)
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
* Bumped `lua-resty-mlcach`e from 2.5.0 to 2.6.0
  [#9287](https://github.com/Kong/kong/pull/9287)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

## [2.x Series Changelog](/gateway/changelog-2.x/)
