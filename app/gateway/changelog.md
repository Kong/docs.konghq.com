---
title: Kong Gateway Changelog
no_version: true
---

<!-- vale off -->


## 3.3.0.0
**Release Date** 2023/05/19

### Breaking changes and deprecations

#### Core

* The `traditional_compat` router mode has been made more compatible with the
  behavior of `traditional` mode by splitting routes with multiple paths into
  multiple `atc` routes with separate priorities. Since the introduction of the new
  router in Kong Gateway 3.0, `traditional_compat` mode assigned only one priority
  to each route, even if different prefix path lengths and regular expressions
  were mixed in a route. This was not how multiple paths were handled in the
  `traditional` router and the behavior has now been changed so that a separate
  priority value is assigned to each path in a route.
  [#10615](https://github.com/Kong/kong/pull/10615)

* **Tracing**: `tracing_sampling_rate` now defaults to 0.01 (trace one of every 100 requests) 
instead of the previous 1 (trace all requests). 
  Tracing all requests causes unnecessary resource drain for most production systems.
  [#10774](https://github.com/Kong/kong/pull/10774)

#### Plugins

* Plugin batch queuing:
  * [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`), [**StatsD**](/hub/kong-inc/statsd/) (`statsd`), 
[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**Datadog**](/hub/kong-inc/datadog/) (`datadog`)

      The queuing system has been reworked, causing some plugin 
      parameters to not function as expected anymore. 
      If you use queues in these plugins, new parameters must be configured.
      See each plugin's documentation for details.

  * The module `kong.tools.batch_queue` has been renamed to `kong.tools.batch` and 
  the API was changed.  If your custom plugin uses queues, it must 
  be updated to use the new API.
  [#10172](https://github.com/Kong/kong/pull/10172)

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * The plugin version has been updated to match Kong Gateway's version.

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * If the log server responds with a 3xx HTTP status code, the
  plugin now considers it to be an error and retries according to the retry
  configuration. Previously, 3xx status codes would be interpreted as a success,
  causing the log entries to be dropped.
  [#10172](https://github.com/Kong/kong/pull/10172)

* [**Serverless Functions**](/hub/kong-inc/serverless-functions/) (`post-function` or `pre-function`)
  * `kong.cache` now points to a cache instance that is dedicated to the
  Serverless Functions plugins. It does not provide access to the global Kong Gateway cache. 
  Access to certain fields in `kong.conf` has also been restricted.
  [#10417](https://github.com/Kong/kong/pull/10417)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  This plugin now uses queues for internal buffering. 
  The standard queue parameter set is available to control queuing behavior.
  [#10753](https://github.com/Kong/kong/pull/10753)

#### Reminders 

* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. 
These images and packages are still available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

* **Cassandra deprecation and removal reminder:** Using Cassandra as a backend database for Kong Gateway is deprecated. 
It is planned for removal with {{site.base_gateway}} 3.4.

### Features

#### Enterprise

* When using the [data plane resilience feature](/gateway/latest/kong-enterprise/cp-outage-handling-faq/), the server-side certificate of the backend Amazon S3 or GCP Cloud Storage service will now be validated if it goes through HTTPS.
* When [managing secrets](/gateway/latest/kong-enterprise/secrets-management/) with an AWS or GCP backend, the backend server's certificate is now validated if it goes through HTTPS.
* Kong Enterprise now supports [using AWS IAM database authentication to connect to the Amazon RDS](/gateway/latest/kong-enterprise/aws-iam-auth-to-rds-database/) (PostgreSQL) database.
* Kong Manager:
  * Kong Manager and Konnect now share the same UI for the navbar, sidebar, and all entity lists. 
  * Improved display for the routes list when the expressions router is enabled. 
  * **CA Certificates** and **TLS Verify** are now supported in the Kong Gateway service form. 
  * Added a GitHub star in the free mode navbar. 
  * Upgraded the Konnect CTA in free mode.
* SBOM files in SPDX and CycloneDX are now generated for Kong Gateway's Docker images.

#### Kong Gateway with Konnect

* You can now configure [labels for data planes](/konnect/runtime-manager/runtime-instances/custom-dp-labels/)
  to provide metadata information for Konnect.
  [#10471](https://github.com/Kong/kong/pull/10471)
* Sending analytics to Konnect from Kong Gateway DB-less mode is now supported.

#### Core

* `runloop` and `init` error response content types are now compliant with the `Accept` header value.
  [#10366](https://github.com/Kong/kong/pull/10366)
* You can now configure custom error templates.
  [#10374](https://github.com/Kong/kong/pull/10374)
* The maximum number of request headers, response headers, URI arguments, and POST arguments that are
  parsed by default can now be configured with the following new configuration parameters:
  [`lua_max_req_headers`](/gateway/latest/reference/configuration/#lua_max_req_headers), [`lua_max_resp_headers`](/gateway/latest/reference/configuration/#lua_max_resp_headers), [`lua_max_uri_args`](/gateway/latest/reference/configuration/#lua_max_uri_args), and [`lua_max_post_args`](/gateway/latest/reference/configuration/#lua_max_post_args).
  [#10443](https://github.com/Kong/kong/pull/10443)
* Added PostgreSQL triggers on the core entites and entities in bundled plugins to delete
  expired rows in an efficient and timely manner.
  [#10389](https://github.com/Kong/kong/pull/10389)
* Added support for configurable node IDs.
  [#10385](https://github.com/Kong/kong/pull/10385)
* Request and response buffering options are now enabled for incoming HTTP 2.0 requests.
  
    Thanks [@PidgeyBE](https://github.com/PidgeyBE) for contributing this change.
    [#10204](https://github.com/Kong/kong/pull/10204) [#10595](https://github.com/Kong/kong/pull/10595)

* Added `KONG_UPSTREAM_DNS_TIME` to `kong.ctx` to record the time it takes for DNS
  resolution when Kong proxies to an upstream.
  [#10355](https://github.com/Kong/kong/pull/10355)
* Dynamic log levels now have a default timeout of 60 seconds.
  [#10288](https://github.com/Kong/kong/pull/10288)

#### Admin API

* Added a new `updated_at` field for the following entities: `ca_certificates`, `certificates`, `consumers`, `targets`, `upstreams`, `plugins`, `workspaces`, `clustering_data_planes`, `consumer_group_consumers`, `consumer_group_plugins`, `consumer_groups`, `credentials`, `document_objects`, `event_hooks`, `files`, `group_rbac_roles`, `groups`, `keyring_meta`, `legacy_files`, `login_attempts`, `parameters`, `rbac_role_endpoints`, `rbac_role_entities`, `rbac_roles`, `rbac_users`, and `snis`.
[#10400](https://github.com/Kong/kong/pull/10400)
* The `/upstreams/<upstream>/health?balancer_health=1` endpoint always shows the balancer health
through a new attribute: `balancer_health`. This always returns `HEALTHY` or `UNHEALTHY`, reporting
the true state of the balancer, even if the overall upstream health status is `HEALTHCHECKS_OFF`.
This is useful for debugging.
[#5885](https://github.com/Kong/kong/pull/5885)
* **Beta**: OpenAPI specs are now available for the Kong Gateway Admin API:
  * [Kong Gateway Admin API - OSS spec](https://developer.konghq.com/spec/680541e5-de6e-46e5-b43d-0bd1b2369453/e2a0ef29-573d-4fc4-86df-216c417f4aa9)
  * [Kong Gateway Admin API - Enterprise spec](https://developer.konghq.com/spec/937dcdd7-4485-47dc-af5f-b805d562552f/be79b812-46d5-4cc1-b757-b5270bf4fa60)

#### Status API

* The `status_listen` server has been enhanced with the addition of the
`/status/ready` API for monitoring Kong Gateway's health.
This endpoint provides a `200` response upon receiving a `GET` request,
but only if a valid, non-empty configuration is loaded and Kong Gateway is
prepared to process user requests.

    Load balancers frequently utilize this functionality to ascertain
    Kong Gateway's availability to distribute incoming requests.
    [#10610](https://github.com/Kong/kong/pull/10610)
    [#10787](https://github.com/Kong/kong/pull/10787)
* **Beta**: An OpenAPI spec is now available for the 
[Kong Gateway Status API](https://developer.konghq.com/spec/9542436a-58d1-4522-a00b-32125b5940f0/5feb007a-348b-486d-8d06-92f615471d22).


#### PDK

* The PDK now supports getting a plugin's ID with `kong.plugin.get_id`.
  [#9903](https://github.com/Kong/kong/pull/9903)
* Tracing module: Renamed spans to simplify filtering on tracing backends.
  See [`kong.tracing`](/gateway/latest/plugin-development/pdk/kong.tracing/) for details. 
  [#10577](https://github.com/Kong/kong/pull/10577)

#### Plugins

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
  * This plugin now supports configuring an `account_key` in `keys` and `key_sets`.
    [#9746](https://github.com/Kong/kong/pull/9746)
  * This plugin now supports configuring a `namespace` for Redis storage,
  which defaults to an empty string for backwards compatibility.
    [#10562](https://github.com/Kong/kong/pull/10562)

* [**Proxy Cache**](/hub/kong-inc/proxy-cache/) (`proxy-cache`)
  * Added the configuration parameter `ignore_uri_case` to allow handling the cache key URI as lowercase.
  [#10453](https://github.com/Kong/kong/pull/10453)

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Added wildcard and parameter match support for `content_type`.
  * Added the configuration parameter `ignore_uri_case` to allow handling the cache key URI as lowercase.
    [#10453](https://github.com/Kong/kong/pull/10453)

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * Added the `application/json; charset=utf-8` option for the `Content-Type` header
  to support log collectors that require that character set declaration.
  [#10533](https://github.com/Kong/kong/pull/10533)

* [**Datadog**](/hub/kong-inc/datadog/) (`datadog`)
  * The `host` configuration parameter is now referenceable.
    [#10484](https://github.com/Kong/kong/pull/10484)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`) and [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * These plugins now convert `traceid` in HTTP response headers to hex format.
  [#10534](https://github.com/Kong/kong/pull/10534)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Spans are now correctly correlated in downstream Datadog traces.
  [10531](https://github.com/Kong/kong/pull/10531)
  * Added the `header_type` field. Previously, the `header_type` was hardcoded to `preserve`.
   Now it can be set to one of the following values: `preserve`, `ignore`, `b3`, `b3-single`,
  `w3c`, `jaeger`, or `ot`.
  [#10620](https://github.com/Kong/kong/pull/10620)
  * Added the new span attribute `http.client_ip` to capture the client IP when behind a proxy.
  [#10723](https://github.com/Kong/kong/pull/10723)
  * Added the `http_response_header_for_traceid` configuration parameter.
  Setting a string value in this field sets a corresponding header in the response.
  [#10379](https://github.com/Kong/kong/pull/10379)

* [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `disable_https` to support scheme configuration on the lambda service API endpoint.
  [#9799](https://github.com/Kong/kong/pull/9799)

* [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * The plugin now honors the following Kong Gateway configuration parameters: [`untrusted_lua`](/gateway/latest/reference/configuration/#untrusted_lua), [`untrusted_lua_sandbox_requires`](/gateway/latest/reference/configuration/#untrusted_lua_sandbox_requires), [`untrusted_lua_sandbox_environment`](/gateway/latest/reference/configuration/#untrusted_lua_sandbox_environment). These parameters apply to advanced templates (Lua expressions).

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Errors are now logged for validation failures.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Added the configuration field `add_claims`, which lets you add extra claims to JWT. 

### Fixes

#### Enterprise

* The Kong Enterprise systemd unit was incorrectly renamed to `kong.service` in 3.2.x.x versions. 
It has now been reverted back to `kong-enterprise-edition.service` to keep consistent with previous releases.
* Fixed an issue where Kong Gateway failed to generate a keyring when RBAC was enabled.
* Fixed `lua_ssl_verify_depth` in FIPS mode to match the same depth of normal mode.
* Removed the email field from the developer registration response.
* Websocket requests now generate balancer spans when tracing is enabled.
* Fixed an issue where management of licenses via the `/licenses/` endpoint would fail if the current license is not valid.
* Resolved an issue with the plugin iterator where sorting would become mixed up when dynamic reordering was applied. 
  This fix ensures proper sorting behavior in all scenarios.
* Kong Manager:
  * Fixed an issue where changing the vault name in Kong Manager would throw an error.
  * Fixed an issue with tabs, where vertical tab content became blank when selecting a tab that is currently active. 
  * Fixed an issue where the `/register` route occasionally jumped to `/login` instead.
  * Removed the **Custom Identifier** field from the StatsD plugin.
  This field appeared in Kong Manager under Metrics, but the field doesn't exist in the plugin's schema.

#### Kong Gateway with Konnect

* The standard expired license notification no longer appears in logs for data planes running in Konnect mode (`konnect_mode=on`), as it does not apply to them.
* New license alert behavior for data planes running in Konnect mode:
  * If there are at least 16 days left before expiration, no alerts are issued. 
  * If the license expires within 16 days, a warning level alert is issued every day. 
  * If the license is expired, a critical level alert is issued every day.

#### Core

* Fixed an issue where the upstream keepalive pool had a CRC32 collision.
  [#9856](https://github.com/Kong/kong/pull/9856)
* Hybrid mode:
  * Fixed an issue where the control plane didn't downgrade configuration for the AWS Lambda and Zipkin plugins for older versions of data planes.
    [#10346](https://github.com/Kong/kong/pull/10346)
  * Fixed an issue where the control plane didn't rename fields correctly for the Session plugin for older versions of data planes.
  [#10352](https://github.com/Kong/kong/pull/10352)
* Fixed an issue where validation of regex routes was occasionally skipped when the old-fashioned config style was used for DB-less Kong Gateway.
  [#10348](https://github.com/Kong/kong/pull/10348)
* Fixed an issue where tracing could cause unexpected behavior.
  [#10364](https://github.com/Kong/kong/pull/10364)
*  Fixed an issue where balancer passive healthchecks would use the wrong status code when Kong Gateway changed the status code from the upstream in the `header_filter` phase.
  [#10325](https://github.com/Kong/kong/pull/10325)
  [#10592](https://github.com/Kong/kong/pull/10592)
* Fixed an issue where schema validations failing in a nested record did not propagate the error correctly.
  [#10449](https://github.com/Kong/kong/pull/10449) 
* Fixed an issue where dangling Unix sockets would prevent Kong Gateway from restarting in
  Docker containers if it was not cleanly stopped.
  [#10468](https://github.com/Kong/kong/pull/10468)
* Fixed an issue where the sorting function for traditional router sources or destinations led to 
`invalid order function for sorting` errors.
  [#10514](https://github.com/Kong/kong/pull/10514)
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)
* Fixed a typo in the mlcache option `shm_set_tries`.
  [#10712](https://github.com/Kong/kong/pull/10712)
* Fixed an issue where a slow startup of the Go plugin server caused a deadlock.
  [#10561](https://github.com/Kong/kong/pull/10561)
* Tracing: 
  * Fixed an issue that caused the `sampled` flag of incoming propagation
  headers to be handled incorrectly and only affect some spans.
  [#10655](https://github.com/Kong/kong/pull/10655)
  * Fixed an issue that was preventing `http_client` spans from being created for OpenResty HTTP client requests.
  [#10680](https://github.com/Kong/kong/pull/10680)
  * Fixed an approximation issue that resulted in reduced precision of the balancer span start and end times.
  [#10681](https://github.com/Kong/kong/pull/10681)
  * `tracing_sampling_rate` now defaults to 0.01 (trace one of every 100 requests) 
  instead of the previous 1 (trace all requests). 
  Tracing all requests causes unnecessary resource drain for most production systems.
  [#10774](https://github.com/Kong/kong/pull/10774)
* Fixed an issue with vault references, which caused Kong Gateway to error out when trying to stop.
  [#10775](https://github.com/Kong/kong/pull/10775)
* Fixed an issue where vault configuration stayed sticky and cached even when configurations were changed.
  [#10776](https://github.com/Kong/kong/pull/10776)
* Fixed the following PostgreSQL TTL clean-up timer issues: 
  * Timers will now only run on traditional and control plane nodes that have enabled the Admin API.
  [#10405](https://github.com/Kong/kong/pull/10405)
  * Kong Gateway now runs a batch delete loop on each TTL-enabled table with a number of `50.000` rows per batch.
  [#10407](https://github.com/Kong/kong/pull/10407)
  * The cleanup job now runs every 5 minutes instead of every 60 seconds.
  [#10389](https://github.com/Kong/kong/pull/10389)
  * Kong Gateway now deletes expired rows based on the database server-side timestamp to avoid potential
  problems caused by the differences in clock time between Kong Gateway and the database server.
  [#10389](https://github.com/Kong/kong/pull/10389)
* Fixed an issue where an empty value for the URI argument `custom_id` crashed the `/consumer` API.
  [#10475](https://github.com/Kong/kong/pull/10475)

#### PDK

* `request.get_uri_captures` now returns the unnamed part tagged as an array for jsonification.
  [#10390](https://github.com/Kong/kong/pull/10390)
* Fixed an issue for tracing PDK where the sampling rate didn't work.
  [#10485](https://github.com/Kong/kong/pull/10485)

#### Plugins

* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`), [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), and [**Vault Authentication**](/hub/kong-inc/vault-auth/) (`vault-auth`)
  * Added the missing schema field `protocols` for `jwe-decrypt`, `oas-validation`, and `vault-auth`.
  [KAG-754](https://konghq.atlassian.net/browse/KAG-754)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) 
  * The `redis` rate limiting strategy now returns an error when Redis Cluster is down.
  * Fixed an issue where the rate limiting `cluster_events` broadcast the wrong data in traditional cluster mode.
  * The control plane no longer creates namespace or syncs.

* [**StatsD Advanced**](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`)
  * Changed the plugin's name to `statsd-advanced` instead of `statsd`. 

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The plugin now performs authentication before authorization, and returns a 403 HTTP code when a user isn't in the authorized groups.
  * The plugin now supports setting the groups to an empty array when groups are not empty. 

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an issue where reconfiguring the plugin didn't take effect.
  * Fixed an issue that caused spans to be propagated incorrectly
  resulting in the wrong hierarchy being rendered on tracing backends.
    [#10663](https://github.com/Kong/kong/pull/10663)

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where the validation function for the  `allowed_content_types` parameter was too strict, making it impossible to use media types that contained a `-` character.

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an issue which caused the wrong `latencies.proxy` to be used in the logging plugins. 
  This plugin now evaluates `ctx.WAITING_TIME` in the forward proxy instead of doing it in the subsequent phase. 

* [**Request Termination**](/hub/kong-inc/request-termination/) (`request-termination`)
  * Fixed an issue with the `echo` option, which caused the plugin to not return the `uri-captures`.
  [#10390](https://github.com/Kong/kong/pull/10390)

* [**Request Transformer**](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where requests would intermittently
  be proxied with incorrect query parameters.
  [10539](https://github.com/Kong/kong/pull/10539)
  * The plugin now honors the value of the `untrusted_lua` configuration parameter.
  [#10327](https://github.com/Kong/kong/pull/10327)

* [**OAuth2**](/hub/kong-inc/oauth2/) (`oauth2`)
  * Fixed an issue where the OAuth2 token was being cached as `nil` if the wrong service was accessed first.
  [#10522](https://github.com/Kong/kong/pull/10522)
  * This plugin now prevents an authorization code created by one plugin instance from being exchanged for an access token created by a different plugin instance.
  [#10011](https://github.com/Kong/kong/pull/10011)

* [**gRPC Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed an issue where having a `null` value in the JSON payload caused an uncaught exception to be 
  thrown during `pb.encode`.
  [#10687](https://github.com/Kong/kong/pull/10687)
  * Fixed an issue where empty arrays in JSON were incorrectly encoded as `"{}"`. They are
   now encoded as `"[]"` to comply with standards.
  [#10790](https://github.com/Kong/kong/pull/10790)

### Dependencies

* Updated the datafile library dependency to fix the following issues:
  * Kong Gateway didn't work when installed on a read-only file system.
  * Kong Gateway didn't work when started from systemd.
* Bumped `lua-resty-session` from 4.0.2 to 4.0.3
  [#10338](https://github.com/Kong/kong/pull/10338)
* Bumped `lua-protobuf` from 0.3.3 to 0.5.0
  [#10137](https://github.com/Kong/kong/pull/10413)
  [#10790](https://github.com/Kong/kong/pull/10790)
* Bumped `lua-resty-timer-ng` from 0.2.3 to 0.2.5
  [#10419](https://github.com/Kong/kong/pull/10419)
  [#10664](https://github.com/Kong/kong/pull/10664)
* Bumped `lua-resty-openssl` from 0.8.17 to 0.8.20
  [#10463](https://github.com/Kong/kong/pull/10463)
  [#10476](https://github.com/Kong/kong/pull/10476)
* Bumped `lua-resty-http` from 0.17.0.beta.1 to 0.17.1
  [#10547](https://github.com/Kong/kong/pull/10547)
* Bumped `lua-resty-aws` from 1.1.2 to 1.2.2
* Bumped `lua-resty-gcp` from 0.0.11 to 0.0.12
* Bumped `LuaSec` from 1.2.0 to 1.3.1
  [#10528](https://github.com/Kong/kong/pull/10528)
* Bumped `lua-resty-acme` from 0.10.1 to 0.11.0
  [#10562](https://github.com/Kong/kong/pull/10562)
* Bumped `lua-resty-events` from 0.1.3 to 0.1.4
  [#10634](https://github.com/Kong/kong/pull/10634)
* Bumped `lua-kong-nginx-module` from 0.5.1 to 0.6.0
  [#10288](https://github.com/Kong/kong/pull/10288)
* Bumped `lua-resty-lmdb` from 1.0.0 to 1.1.0
  [#10766](https://github.com/Kong/kong/pull/10766)
* Bumped `kong-openid-connect` from 2.5.4 to 2.5.5

## 3.2.2.2
**Release Date** 2023/05/19

### Fixes

#### Core 
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  lead to the corruption of chunk-encoded response data.
  [#10816](https://github.com/Kong/kong/pull/10816)
  [#10824](https://github.com/Kong/kong/pull/10824)
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)

#### Plugins
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
    * Fixed the log flooding issue caused by low `sync_rate` settings.

## 3.2.2.1
**Release Date** 2023/04/03

### Fixes
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 3.2.x packages prior to 3.2.2.1 didn't contain the debug symbols that Dynatrace requires.

### Deprecations
* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.


## 3.2.2.0
**Release Date** 2023/03/22

### Fixes 
#### Enterprise
* In Kong 3.2.1.0 and 3.2.1.1, `alpine` and `ubuntu` ARM64 artifacts incorrectly handled HTTP/2 requests, causing the protocol to fail. These artifacts have been removed. 
* Added the default logrotate file `/etc/logrotate.d/kong-enterprise-edition`. This file was missing in all 3.x versions of Kong Gateway prior to this release.

#### Plugins
* [**SAML**](/hub/kong-inc/saml/) (`saml`)
    * The SAML plugin now works on read-only file systems.
    * The SAML plugin can now handle the field `session_auth_ttl` (removed since 3.2.0.0).

* Datadog Tracing plugin: We found some late-breaking issues with the Datadog Tracing plugin and elected to remove it from the 3.2 release. We plan to add the plugin back with the issues fixed in a later release. 

### Known issues
* Due to changes in GPG keys, using yum to install this release triggers a `Public key for kong-enterprise-edition-3.2.1.0.rhel7.amd64.rpm is not installed` error. The package *is* signed, however, it's signed with a different (rotated) key from the metadata service, which triggers the error in yum. To avoid this error, manually download the package from [download.konghq.com](https://download.konghq.com/) and install it. 

## 3.2.1.0
**Release Date** 2023/02/28

### Deprecations

* Deprecated Alpine Linux images and packages. 
    
    Kong is announcing our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

### Breaking changes

* The default PostgreSQL SSL version has been bumped to TLS 1.2. In `kong.conf`:
   
    * The default [`pg_ssl_version`](/gateway/latest/reference/configuration/#postgres-settings)
    is now `tlsv1_2`.
    * Constrained the valid values of this configuration option to only accept the following: `tlsv1_1`, `tlsv1_2`, `tlsv1_3` or `any`.

    This mirrors the setting `ssl_min_protocol_version` in PostgreSQL 12.x and onward. 
    See the [PostgreSQL documentation](https://postgresqlco.nf/doc/en/param/ssl_min_protocol_version/)
    for more information about that parameter.

    To use the default setting in `kong.conf`, verify that your Postgres server supports TLS 1.2 or higher versions, or set the TLS version yourself. 
    TLS versions lower than `tlsv1_2` are already deprecated and considered insecure from PostgreSQL 12.x onward.
  
* Added the [`allow_debug_header`](/gateway/latest/reference/configuration/#allow_debug_header) 
configuration property to `kong.conf` to constrain the `Kong-Debug` header for debugging. This option defaults to `off`.

    If you were previously relying on the `Kong-Debug` header to provide debugging information, set `allow_debug_header: on` to continue doing so.

* [**JWT plugin**](/hub/kong-inc/jwt/) (`jwt`)
    
    * The JWT plugin now denies any request that has different tokens in the JWT token search locations.
      [#9946](https://github.com/Kong/kong/pull/9946)

* Sessions library upgrade [#10199](https://github.com/Kong/kong/pull/10199):
    * The [`lua-resty-session`](https://github.com/bungle/lua-resty-session) library has been upgraded to v4.0.0. This version includes a full rewrite of the session library, and is not backwards compatible.
      
      This library is used by the following plugins: [**Session**](/hub/kong-inc/session/), [**OpenID Connect**](/hub/kong-inc/openid-connect/), and [**SAML**](/hub/kong-inc/saml/). This also affects any session configuration that uses the Session or OpenID Connect plugin in the background, including sessions for Kong Manager and Dev Portal.

      All existing sessions are invalidated when upgrading to this version.
      For sessions to work as expected in this version, all nodes must run Kong Gateway 3.2.x or later.
      For that reason, we recommend that during upgrades, proxy nodes with mixed versions run for
      as little time as possible. During that time, the invalid sessions could cause failures and partial downtime.
    
   * Parameters:
      * The new parameter `idling_timeout`, which replaces `cookie_lifetime`, now has a default value of 900. Unless configured differently, sessions expire after 900 seconds (15 minutes) of idling. 
      * The new parameter `absolute_timeout` has a default value of 86400. Unless configured differently, sessions expire after 86400 seconds (24 hours).
      * Many session parameters have been renamed or removed. Although your configuration will continue to work as previously configured, we recommend adjusting your configuration to avoid future unexpected behavior. Refer to the [upgrade guide for 3.2](/gateway/latest/upgrade/#session-library-upgrade) for all session configuration changes and guidance on how to convert your existing session configuration.
      
      
### Features

#### Core

* When `router_flavor` is set to`traditional_compatible`, Kong Gateway verifies routes created 
  using the expression router instead of the traditional router to ensure created routes
  are compatible.
  [#9987](https://github.com/Kong/kong/pull/9987)
* In DB-less mode, the `/config` API endpoint can now flatten all schema validation
  errors into a single array using the optional `flatten_errors` query parameter.
  [#10161](https://github.com/Kong/kong/pull/10161)
* The upstream entity now has a new load balancing algorithm option: [`latency`](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms).
  This algorithm chooses a target based on the response latency of each target
  from prior requests.
  [#9787](https://github.com/Kong/kong/pull/9787)
* The Nginx `charset` directive can now be configured with Nginx directive injections.
    Set it in Kong Gateway's configuration with [`nginx_http_charset`](/gateway/latest/reference/configuration/#nginx_http_charset)
    [#10111](https://github.com/Kong/kong/pull/10111)
* The services upstream TLS configuration is now extended to the stream subsystem.
  [#9947](https://github.com/Kong/kong/pull/9947)
* Added the new configuration parameter [`ssl_session_cache_size`](/gateway/latest/reference/configuration/#ssl_session_cache_size), 
which lets you set the Nginx directive `ssl_session_cache`.
  This configuration parameter defaults to `10m`.
  Thanks [Michael Kotten](https://github.com/michbeck100) for contributing this change.
  [#10021](https://github.com/Kong/kong/pull/10021)
* [`status_listen`](/gateway/latest/reference/configuration/#status_listen) now supports HTTP2. [#9919](https://github.com/Kong/kong/pull/9919)
* The shared Redis connector now supports username + password authentication for cluster connections, improving on the existing single-node connection support. This automatically applies to all plugins using the shared Redis configuration.


#### Enterprise

* **FIPS Support**:
  * The OpenID Connect, Key Authentication - Encrypted, and JWT Signer plugins are now [FIPS 140-2 compliant](/gateway/latest/kong-enterprise/fips-support/). 

    If you are migrating from {{site.base_gateway}} 3.1 to 3.2 in FIPS mode and are using the `key-auth-enc` plugin, you should send [PATCH or POST requests](/hub/kong-inc/key-auth-enc/#create-a-key) to all existing `key-auth-enc` credentials to re-hash them in SHA256.
  * FIPS-compliant Kong Gateway packages now support PostgreSQL SSL connections. 

##### Kong Manager

* Improved the editor for expression fields. Any fields using the expression router now have syntax highlighting, autocomplete, and route validation.
* Improved audit logs by adding `rbac_user_name` and `request_source`. 
By combining the data in the new `request_source` field with the `path` field, you can now determine login and logout events from the logs. 
See the documentation for more detail on [interpreting audit logs](/gateway/latest/kong-enterprise/audit-log/#kong-manager-authentication).
* License information can now be copied or downloaded into a file from Kong Manager. 
* Kong Manager now supports the `POST` method for OIDC-based authentication.
* Keys and key sets can now be configured in Kong Manager.
* Optimized the color scheme for `http` method badges.

#### Plugins

* **Plugin entity**: Added an optional `instance_name` field, which identifies a
  particular plugin entity.
  [#10077](https://github.com/Kong/kong/pull/10077)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Added support for setting the durations of Kong phases as span tags
  through the configuration property `phase_duration_flavor`.
  [#9891](https://github.com/Kong/kong/pull/9891)

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * The `headers` configuration parameter is now referenceable, which means it can be securely stored in a vault.
  [#9948](https://github.com/Kong/kong/pull/9948)

* [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `aws_imds_protocol_version`, which
  lets you select the IMDS protocol version.
  This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
  [#9962](https://github.com/Kong/kong/pull/9962)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * This plugin can now be scoped to individual services, routes, and consumers.
  [#10096](https://github.com/Kong/kong/pull/10096)

* [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  * Added the `tag_style` configuration parameter, which allows the plugin 
  to send metrics with [tags](https://github.com/prometheus/statsd_exporter#tagging-extensions).
  The parameter defaults to `nil`, which means that no tags are added to the metrics.
  [#10118](https://github.com/Kong/kong/pull/10118)
  
* [**Session**](/hub/kong-inc/session/) (`session`), [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`), and [**SAML**](/hub/kong-inc/saml/) (`saml`)

  * These plugins now use `lua-resty-session` v4.0.0. 

    This update includes new session functionalities such as configuring audiences to manage multiple 
    sessions in a single cookie, global timeout, and persistent cookies.
  
    Due to this update, there are also a number of deprecated and removed parameters in these plugins. 
    See the invidividual plugin documentation for the full list of changed parameters in each plugin.
    * [Session changelog](/hub/kong-inc/session/#changelog)
    * [OpenID Connect changelog](/hub/kong-inc/openid-connect/#changelog)
    * [SAML changelog](/hub/kong-inc/saml/#changelog)

* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`) and [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
    * In hybrid and DB-less modes, these plugins now support `sync_rate = -1` with any strategy, including the default `cluster` strategy.

* [**OPA**](/hub/kong-inc/opa/) (`opa`)
    * This plugin can now handle custom messages from the OPA server.

* [**Canary**](/hub/kong-inc/canary/) (`canary`)
    * Added a default value for the `start` field in the canary plugin. 
    If not set, the start time defaults to the current timestamp.
    
* **Improved Plugin Documentation**
    * Split the plugin compatibility table into a [technical compatibility page](/hub/plugins/compatibility/) and a [license tiers](hub/plugins/license-tiers) page. 
    * Updated the plugin compatibility information for more clarity on [supported network protocols](/hub/plugins/compatibility/#protocols) and on [entity scopes](/hub/plugins/compatibility/#scopes). 
    * Revised docs for the following plugins to include examples:
      * [CORS](/hub/kong-inc/cors/)
      * [File Log](/hub/kong-inc/file-log/)
      * [HTTP Log](/hub/kong-inc/http-log/)
      * [JWT Signer](/hub/kong-inc/jwt-signer/)
      * [Key Auth](/hub/kong-inc/key-auth/)
      * [OpenID Connect](/hub/kong-inc/openid-connect/)
      * [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
      * [SAML](/hub/kong-inc/saml/)
      * [StatsD](/hub/kong-inc/statsd/)
  

### Fixes

#### Core 

* Added back PostgreSQL `FLOOR` function when calculating `ttl`, so `ttl` is always returned as a whole integer.
  [#9960](https://github.com/Kong/kong/pull/9960)
* Exposed PostreSQL connection pool configuration.
  [#9603](https://github.com/Kong/kong/pull/9603)
* **Nginx template**: The default charset is no longer added to the `Content-Type` response header when the upstream response doesn't contain it.
  [#9905](https://github.com/Kong/kong/pull/9905)
* Fixed an issue where, after a valid declarative configuration was loaded,
  the configuration hash was incorrectly set to the value `00000000000000000000000000000000`.
  [#9911](https://github.com/Kong/kong/pull/9911)
* Updated the batch queues module so that queues no longer grow without bounds if
  their consumers fail to process the entries. Instead, old batches are now dropped
  and an error is logged.
  [#10247](https://github.com/Kong/kong/pull/10247)
* Fixed an issue where `X-Kong-Upstream-Status` couldn't be emitted when a response was buffered.
  [#10056](https://github.com/Kong/kong/pull/10056)
* Improved the error message for invalid JWK entries.
  [#9904](https://github.com/Kong/kong/pull/9904)
* Fixed an issue where the `#` character wasn't parsed correctly from environment variables and vault references.
  [10132](https://github.com/Kong/kong/pull/10132)
* Fixed an issue where control plane didn't downgrade configuration for the AWS Lambda and Zipkin plugins for older versions of data planes.
  [#10346](https://github.com/Kong/kong/pull/10346)
* Fixed an issue in DB-less mode, where validation of regex routes could be skipped when using a configuration format older than `3.0`.
  [#10348](https://github.com/Kong/kong/pull/10348)

#### Enterprise

* Fixed an issue where the forward proxy between the data plane and the control plane didn't support telemetry port 8006.
* Fix the PostgreSQL mTLS error `bad client cert type`. 
* Fixed issues with the Admin API's `/licenses` endpoint:
    * The Enterprise license wasn't being picked up by other nodes in a cluster.
    * Vitals routes weren't accessible.
    * Vitals wasn't showing up in hybrid mode.
* Fixed RBAC issues:
  * Fixed an issue where workspace admins couldn't add rate limiting policies to consumer groups.
  * Fixed an issue where workspace admins in one workspace would have admin rights in other workspaces. 
    Workspace admins are now correctly restricted to their own workspaces.
  * Fixed a role precedence issue with RBAC. RBAC rules involving deny (negative) rules now correctly take precedence over allow (non-negative) roles.

##### Vitals

* Fixed an issue where Vitals wasn't tracking the status codes of service-less routes.
* Fixed the Admin API error `/vitals/reports/:entity_type is not available`.

##### Kong Manager

* Fixed an issue where `404 Not Found` errors were triggered while updating the service, route, or consumer bound to a scoped plugin.
* Moved the `tags` field out of the advanced fields section for certificate, route, and upstream configuration pages. 
The tags field is now visible without needing to expand to see all fields.
* Improved the user interface for Keys and Key Sets entities. 
* You can now add tags for consumer groups in Kong Manager.
* Fixed an issue where the plugin **Copy JSON** button didn't copy the full configuration.
* Fixed an issue where the password reset form didn't check for matching passwords and allowed mismatched passwords to be submitted.
* Added a link to the upgrade prompt for Konnect or Enterprise. 
* Fixed an issue where any IdP user could log into Kong Manager, regardless of their role or group membership. 
These users could see the Workspaces Overview dashboard with the default workspace, but they couldn't do anything else.
Now, if IdP users with no groups or roles attempt to log into Kong Manager, they will be denied access.

#### Plugins

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Fixed an issue where the global plugin's sample ratio overrode the route-specific ratio.
  [#9877](https://github.com/Kong/kong/pull/9877)
  * Fixed an issue where `trace-id` and `parent-id` strings with decimals were not processed correctly.

* [**JWT**](/hub/kong-inc/jwt/) (`jwt`)
  * This plugin now denies requests that have different tokens in the JWT token search locations. 
  
    Thanks Jackson 'Che-Chun' Kuo from Latacora for reporting this issue.
    [#9946](https://github.com/Kong/kong/pull/9946)

* [**Datadog**](/hub/kong-inc/datadog/) (`datadog`),[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  * Fixed an issue in these plugins' batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.
  [#10052](https://github.com/Kong/kong/pull/10052) [#10044](https://github.com/Kong/kong/pull/10044)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  *  Fixed non-compliances to specification:
     * For `http.uri` in spans, the field is now the full HTTP URI.
      [#10036](https://github.com/Kong/kong/pull/10036)
     * `http.status_code` is now present on spans for requests that have a status code.
      [#10160](https://github.com/Kong/kong/pull/10160)
     * `http.flavor` is now a string value, not a double.
      [#10160](https://github.com/Kong/kong/pull/10160)
  * Fixed an issue with getting the traces of other formats, where the trace ID reported and propagated could be of incorrect length.
    This caused traces originating from Kong Gateway to incorrectly connect with the target service, causing Kong Gateway and the target service to submit separate traces.
    [#10332](https://github.com/Kong/kong/pull/10332)
  
* [**OAuth2**](/hub/kong-inc/oauth2/) (`oauth2`)
  * `refresh_token_ttl` is now limited to a range between `0` and `100000000` by the schema validator. 
  Previously, numbers that were too large caused requests to fail.
  [#10068](https://github.com/Kong/kong/pull/10068)

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where it was not possible to specify an anonymous consumer by name.
  * Fixed an issue where the `authorization_cookie_httponly` and `session_cookie_httponly` parameters would always be set to `true`, even if they were configured as `false`.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Matched the plugin's behavior to the Rate Limiting plugin.
    When an `HTTP 429` status code was returned, rate limiting related headers were missed from the PDK module `kong.response.exit()`. 
    This made the plugin incompatible with other Kong components like the Exit Transformer plugin.

* [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Fixed an issue where the `allow.json` configuration parameter couldn't use nested JSON object and array syntax.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed UUID pattern matching. 

* [**SAML**](/hub/kong-inc/saml/) (`saml`)
  * Fixed an issue where the `session_cookie_httponly` parameter would always be set to `true`, even if it was configured as `false`.

* [**Key Authentication Encrypted**](/hub/kong-inc/key-auth-enc/) (`key-auth-enc`)
  * Fixed the `ttl` parameter. You can now set `ttl` for an encrypted key.
  * Fixed an issue where this plugin didn't accept tags.

### Dependencies

* Bumped`lua-resty-openssl` from 0.8.15 to 0.8.17
* Bumped `libexpat` from 2.4.9 to 2.5.0
* Bumped `kong-openid-connect` from v2.5.0 to v2.5.2
* Bumped `openssl` from 1.1.1q to 1.1.1t
* `libyaml` is no longer built with Kong Gateway. System `libyaml` is used instead.
* Bumped `luarocks` from 3.9.1 to 3.9.2
  [#9942](https://github.com/Kong/kong/pull/9942)
* Bumped `atc-router` from 1.0.1 to 1.0.5
  [#9925](https://github.com/Kong/kong/pull/9925)
  [#10143](https://github.com/Kong/kong/pull/10143)
  [#10208](https://github.com/Kong/kong/pull/10208)
* Bumped `lua-resty-openssl` from 0.8.15 to 0.8.17
  [#9583](https://github.com/Kong/kong/pull/9583)
  [#10144](https://github.com/Kong/kong/pull/10144)
* Bumped `lua-kong-nginx-module` from 0.5.0 to 0.5.1
  [#10181](https://github.com/Kong/kong/pull/10181)
* Bumped `lua-resty-session` from 3.10 to 4.0.0
  [#10199](https://github.com/Kong/kong/pull/10199)
  [#10230](https://github.com/Kong/kong/pull/10230)
* Bumped `libxml` from 2.10.2 to 2.10.3 to resolve [CVE-2022-40303](https://nvd.nist.gov/vuln/detail/cve-2022-40303) and [CVE-2022-40304](https://nvd.nist.gov/vuln/detail/cve-2022-40304)


## 3.1.1.4
**Release Date** 2023/05/16

### Features

* Kong Manager with OIDC:
  * Added the configuration option
  [`admin_auto_create`](/gateway/latest/kong-manager/auth/oidc/mapping/) to enable or disable automatic admin creation.
  This option is `true` by default.

### Fixes 

#### Core 
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)
* Hybrid mode: Fixed an issue where Vitals/Analytics couldn't communicate through the cluster telemetry endpoint.
* Fixed an issue where `alpine` and `ubuntu` ARM64 artifacts incorrectly handled HTTP/2 requests, causing the protocol to fail.
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  lead to the corruption of chunk-encoded response data.
  [#10816](https://github.com/Kong/kong/pull/10816)
  [#10824](https://github.com/Kong/kong/pull/10824)
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 3.1.x packages prior to 3.1.1.4 
didn't contain the debug symbols that Dynatrace requires.

#### Enterprise

**Kong Manager**:
* Fixed configuration fields for the StatsD plugin:
  * Added missing metric fields: `consumer_identifier`, `service_identifier`, and `workspace_identifier`. 
  * Removed the non-existent `custom_identifier` field.
* Fixed an issue where the `Copy JSON` for a plugin didn't copy the full plugin configuration.
* Fixed an issue where the Zipkin plugin didn't allow the addition of `static_tags` through the Kong Manager UI.
* Added missing default values to the Vault configuration page.
* Fixed the broken Konnect link in free mode banners.

* OIDC authentication issues:
  * The `/auth` endpoint, used by Kong Manager for OIDC authentication, now correctly supports the HTTP POST method.
  * Fixed an issue with OIDC authentication in Kong Manager, where the default roles 
(`workspace-super-admin`, `workspace-read-only`, `workspace-portal-admin`, and `workspace-admin`) were missing from any 
newly created workspace.
  * Fixed an issue where users with newly registered Dev Portal accounts created through OIDC were unable to log into 
  Dev Portal until the Kong Gateway container was restarted. 
  This happened when `by_username_ignore_case` was set to `true`, which incorrectly caused consumers to always load from cache.

#### Plugins

* [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Fixed an issue that was causing some requests to be proxied with the wrong query parameters.

## 3.1.1.3
**Release Date** 2023/01/30

### Fixes

#### Enterprise

* Fixed the accidental removal of the `ca-certificates` dependency from packages and images. 
This prevented SSL connections from using common root certificate authorities.

### Upgrades
You can now directly upgrade to {{site.base_gateway}} 3.1.1.3 from 2.8.x.x. Previously, you had to upgrade to 3.0.x first, then upgrade to the latest 3.x version.


## 3.1.1.2
**Release Date** 2023/01/24

### Features

#### Enterprise

- **Dev Portal**:
  - The Dev Portal API now supports an optional `fields` query parameter on the `/files` endpoint.
  This parameter lets you specify which file object fields should be included in the response.

#### Core 

- When `router_flavor` is `traditional_compatible`, verify routes created using the
  Expression router instead of the traditional router to ensure created routes
  are actually compatible.
  [#10088](https://github.com/Kong/kong/pull/10088)
  
- `kong migrations up` now reports routes that are incompatible with the 3.0 router
  and stops the migration progress so that admins have a chance to adjust them.

  [#10092](https://github.com/Kong/kong/pull/10092)
  [#10101](https://github.com/Kong/kong/pull/10101)

### Fixes

#### Enterprise

- **Kong Manager**:
  - Fixed issues with the plugin list:
      - Added missing icons and categories for the TLS Handshake Modifier and TLS Metadata Headers plugins.
      - Removed entries for the following deprecated plugins: Kubernetes Sidecar Injector, Collector, and Upstream TLS.
      - Removed Apache OpenWhisk plugin from Kong Manager. This plugin must be [installed manually via LuaRocks](/hub/kong-inc/openwhisk/).
      - Removed the internal-only Konnect Application Auth plugin. 
  - Fixed an issue where Kong Manager would occasionally log out while redirecting to other pages or refreshing 
    the page when OpenID Connect was used as the authentication method. 
  - Fixed an issue where `404 Not Found` errors were triggered while updating the service, route, or consumer bound to a scoped plugin.
  - Fixed an issue where admins with the permission `['create'] /services/*/plugins` couldn't create plugins under a service.
  - Fixed an issue where viewing a consumer group in any workspace other than `default` would cause a `404 Not Found` error. 

#### Core

* Fixed an issue where regexes generated in inso would not work in Kong Gateway. 
* Bumped `atc-router` to `1.0.2` to address the potential worker crash issue.
  [#9927](https://github.com/Kong/kong/pull/9927)

#### Hybrid mode

- Fixed an issue where Vitals data was not showing up after a license was deployed using the `/licenses` endpoint.
Kong Gateway now triggers an event that allows the Vitals subsystem to be reinitialized during license preload.
- Fixed an issue where the forward proxy between data planes and the control plane didn't support the telemetry port `8006`.
- Reverted the removal of WebSocket protocol support for configuration sync.
  Backwards compatibility with 2.8.x.x data planes has been restored. 
  [#10067](https://github.com/Kong/kong/pull/10067) 

#### Plugins

- [**Datadog**](/hub/kong-inc/datadog/) (`datadog`),[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  - Fixed an issue in these plugins' batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - Fixed an issue with the `local` strategy, which was not working correctly when `window_size` was set to `fixed`, 
    and the cache would expire while the window was still valid.
  
- [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  - Added the OAS Validation plugin back into the bundled plugins list. The plugin is now available by default
  with no extra configuration necessary through `kong.conf`.
  - Fixed an issue where the plugin returned the wrong error message when failing to get the path schema spec. 
  - Fixed a `500` error that occurred when the response body schema had no content field.

- [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Fixed an issue where the plugin used the old route caches after routes were updated. 

### Deprecations

- Support for the `/vitals/reports/:entity_type` endpoint is deprecated. Use one of the following endpoints from the Vitals API instead:
  - For `/vitals/reports/consumer`, use `/{workspace_name}/vitals/status_codes/by_consumer` instead
  - For `/vitals/reports/service`, use `/{workspace_name}/vitals/status_codes/by_service` instead
  - For `/vitals/reports/hostname`, use `/{workspace_name}/vitals/nodes` instead

  See the [Vitals documentation](/gateway/latest/kong-enterprise/analytics/#vitals-api) for more detail.
 
### Known issues
* The `ca-certificates` dependency is missing from packages and images. 
This prevents SSL connections from using common root certificate authorities. 

    Upgrade to 3.1.1.3 to resolve.

## 3.1.0.0
**Release Date** 2022/12/06

### Features

#### Enterprise

- You can now specify the namespaces of HashiCorp Vaults for secrets management.

- Added support for HashiCorp Vault backends to retrieve a vault token from a
Kubernetes service account. See the following configuration parameters:
  - [`keyring_vault_auth_method`](/gateway/latest/reference/configuration/#keyring_vault_auth_method)
  - [`keyring_vault_kube_role`](/gateway/latest/reference/configuration/#keyring_vault_kube_role)
  - [`keyring_vault_kube_api_token_file`](/gateway/latest/reference/configuration/#keyring_vault_kube_api_token_file)

- FIPS 140-2 packages:
  - Kong Gateway Enterprise now provides [FIPS 140-2 compliant packages for Red Hat Enterprise 8 and Ubuntu 22.04](/gateway/latest/kong-enterprise/fips-support/).
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

#### Core
- Allow `kong.conf` SSL properties to be stored in vaults or environment
  variables. Allow such properties to be configured directly as content
  or base64 encoded content.
  [#9253](https://github.com/Kong/kong/pull/9253)
- Added support for full entity transformations in schemas.
  [#9431](https://github.com/Kong/kong/pull/9431)
- The schema `map` type field can now be marked as referenceable.
  [#9611](https://github.com/Kong/kong/pull/9611)
- Added support for [dynamically changing the log level](/gateway/latest/production/logging/update-log-level-dynamically/).
  [#9744](https://github.com/Kong/kong/pull/9744)
- Added support for the `keys` and `key-sets` entities. These are used for
managing asymmetric keys in various formats (JWK, PEM). For more information,
see [Key management](/gateway/latest/reference/key-management/).
[#9737](https://github.com/Kong/kong/pull/9737)

#### Hybrid Mode

- Data plane node IDs will now persist across restarts.
  [#9067](https://github.com/Kong/kong/pull/9067)
- Added HTTP CONNECT forward proxy support for hybrid mode connections. New configuration
  options `cluster_use_proxy`, `proxy_server` and `proxy_server_ssl_verify` are added.
  For more information, see [CP/DP Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/).
  [#9758](https://github.com/Kong/kong/pull/9758)
  [#9773](https://github.com/Kong/kong/pull/9773)

#### Performance

- Increase the default value of `lua_regex_cache_max_entries`. A warning will be thrown
  when there are too many regex routes and `router_flavor` is `traditional`.
  [#9624](https://github.com/Kong/kong/pull/9624)
- Add batch queue into the Datadog and StatsD plugins to reduce timer usage.
  [#9521](https://github.com/Kong/kong/pull/9521)

#### OS support

- Kong Gateway now supports Amazon Linux 2022 with Enterprise packages.
- Kong Gateway now supports Ubuntu 22.04 with both open-source and Enterprise packages.

#### PDK

- Extend `kong.client.tls.request_client_certificate` to support setting
  the Distinguished Name (DN) list hints of the accepted CA certificates.
  [#9768](https://github.com/Kong/kong/pull/9768)

#### Plugins

**New plugins:**
- [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  - Integrate Kong Gateway with the AppDynamics APM Platform.
- [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`)
  - Allows you to decrypt an inbound token (JWE) in a request.
- [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  - Validate HTTP requests and responses based on an OpenAPI 3.0 or Swagger API Specification.
- [**SAML**](/hub/kong-inc/saml/) (`saml`)
  - Provides SAML v2.0 authentication and authorization between a service provider (Kong Gateway) and an identity provider (IdP).
- [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
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

- [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
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

### Known limitations

- With Dynamic log levels, if you set log-level to `alert` you will still see `info` and `error` entries in the logs. 

### Fixes

#### Enterprise

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

#### Core

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

#### Hybrid Mode

- Fixed a race condition that could cause configuration push events to be dropped
  when the first data plane connection was established with a control plane
  worker.
  [#9616](https://github.com/Kong/kong/pull/9616)

#### CLI

- Fixed slow CLI performance due to pending timer jobs.
  [#9536](https://github.com/Kong/kong/pull/9536)

#### PDK

- Added support for `kong.request.get_uri_captures`
  (`kong.request.getUriCaptures`)
  [#9512](https://github.com/Kong/kong/pull/9512)
- Fixed parameter type of `kong.service.request.set_raw_body`
  (`kong.service.request.setRawBody`), return type of
  `kong.service.response.get_raw_body`(`kong.service.request.getRawBody`),
  and body parameter type of `kong.response.exit` to bytes. Note that the old
  version of the go PDK is incompatible after this change.
  [#9526](https://github.com/Kong/kong/pull/9526)

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

- [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  - Fixed an issue with `accept` headers not being split and not working with wildcards. The `;q=` (q-factor weighting) of `accept` headers is now supported.

- [**OPA**](/hub/kong-inc/opa/) (`opa`)
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

- [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cached-advanced`)
  - The plugin now catches the error when Kong Gateway connects to Redis SSL port `6379` with `config.ssl=false`.

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
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

- [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  - Fixed an issue where Zipkin plugin couldn't parse OT baggage headers
    due to an invalid OT baggage pattern.
    [#9280](https://github.com/Kong/kong/pull/9280)

### Breaking changes

#### Hybrid mode

- The legacy hybrid configuration protocol has been removed in favor of the wRPC protocol
introduced in 3.0.0.0. Rolling upgrades from 2.8.x.y to 3.1.0.0 are not supported.
Operators must upgrade to 3.0.x.x before they can perform a rolling upgrade to 3.1.0.0. For more information, see [Upgrade Kong Gateway 3.1.x](/gateway/3.1.x/upgrade/).
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

* Kong Gateway now supports [dynamic plugin ordering](/gateway/3.0.x/kong-enterprise/plugin-ordering/).
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
  * [Router Expressions Language reference](/gateway/3.0.x/reference/router-expressions-language/)
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

* [ACME](/hub/kong-inc/ACME/) (`acme`)
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

* [Serverless Functions](/hub/kong-inc/serverless-functions/) (`serverless-functions`)
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
* Bumped `lua-resty-mlcach`e from 2.5.0 to 2.6.0
  [#9287](https://github.com/Kong/kong/pull/9287)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

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

* Fix the character limit error `[postgres] ERROR: value too long for type character(32)` that occured while enabling the Dev Portal. 
The character limit was shorter than the length of the autogenerated UUID.
* Fixed an issue where the Zipkin plugin didn't allow the addition of `static_tags` through the Kong Manager UI.
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
  This error occurred when using this plugin with the Kubernetes Ingress Controller.

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
   * Added support for cross-account lambda function invocation based on AWS roles.

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

* [ACME](/hub/kong-inc/ACME/) (`acme`)
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
- Bumped kong-redis-cluster from `1.1-0` to `1.2.0`.
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
- Bumped `openresty` from 1.19.3.2 to [1.19.9.1](https://openresty.org/en/changelog-1019009.html)
  [#7430](https://github.com/Kong/kong/pull/7727)
- Bumped `openssl` from `1.1.1k` to `1.1.1l`
  [7767](https://github.com/Kong/kong/pull/7767)
- Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
- Bumped `Penlight` to 1.11.0
  [#7736](https://github.com/Kong/kong/pull/7736)
- Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
- Bumped `lua-protobuf` from 0.3.2 to 0.3.3
  [#7656](https://github.com/Kong/kong/pull/7656)
- Bumped `lua-resty-openssl` from 0.7.3 to 0.7.4
  [#7657](https://github.com/Kong/kong/pull/7657)
- Bumped `lua-resty-acme` from 0.6 to 0.7.1
  [#7658](https://github.com/Kong/kong/pull/7658)
- Bumped `grpcurl` from 1.8.1 to 1.8.2
  [#7659](https://github.com/Kong/kong/pull/7659)
- Bumped `luasec` from 1.0.1 to 1.0.2
  [#7750](https://github.com/Kong/kong/pull/7750)
- Bumped `lua-resty-ipmatcher` to 0.6.1
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
- Bumped `openresty` from 1.19.3.2 to [1.19.9.1](https://openresty.org/en/changelog-1019009.html)
  [#7430](https://github.com/Kong/kong/pull/7727)
- Bumped `openssl` from `1.1.1k` to `1.1.1l`
  [7767](https://github.com/Kong/kong/pull/7767)
- Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
- Bumped `Penlight` to 1.11.0
  [#7736](https://github.com/Kong/kong/pull/7736)
- Bumped `lua-resty-http` from 0.15 to 0.16.1
  [#7797](https://github.com/kong/kong/pull/7797)
- Bumped `lua-protobuf` from 0.3.2 to 0.3.3
  [#7656](https://github.com/Kong/kong/pull/7656)
- Bumped `lua-resty-openssl` from 0.7.3 to 0.7.4
  [#7657](https://github.com/Kong/kong/pull/7657)
- Bumped `lua-resty-acme` from 0.6 to 0.7.1
  [#7658](https://github.com/Kong/kong/pull/7658)
- Bumped `grpcurl` from 1.8.1 to 1.8.2
  [#7659](https://github.com/Kong/kong/pull/7659)
- Bumped `luasec` from 1.0.1 to 1.0.2
  [#7750](https://github.com/Kong/kong/pull/7750)
- Bumped `lua-resty-ipmatcher` to 0.6.1
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
- The [Keyring Encryption](/gateway/latest/kong-enterprise/db-encryption/) feature is no longer in an alpha quality state.
- When using Redis Cluster with a Kong Gateway plugin and the cluster nodes are configured by hostname,
  if the entire cluster is rebooted and appears on new IP addresses, now the connection will eventually self heal once DNS is updated.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
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
- [Azure Functions](/hub/kong-inc/azure-functions/) (`azure-functions`)
  This release updates the `lua-resty-http` dependency to v0.16.1, which means the plugin no longer
  uses the deprecated functions.


## 2.5.0.2
**Release Date** 2021/09/02

### Fixes

#### Enterprise
- This release fixes a regression in the Kong Dev Portal templates that removed dynamic menu navigation and other improvements
from portals created in Kong Gateway v2.5.0.1.

#### Plugins
- [Mocking](/hub/kong-inc/mocking/) (`mocking`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
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
  See the event hooks [reference](/enterprise/2.5.x/admin-api/event-hooks/reference/) and
  [examples](/enterprise/2.5.x/admin-api/event-hooks/examples/) documentation for more information.
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
- [HMAC Authentication](/hub/kong-inc/hmac-auth/) (`hmac-auth`)
  The HMAC Authentication plugin now includes support for the `@request-target` field in the signature
  string. Before, the plugin used the `request-line` parameter, which contains the HTTP request method, request URI, and
  the HTTP version number. The inclusion of the HTTP version number in the signature caused requests to the same target
  with different request methods(such as HTTP/2) to have different signatures. The newly added `request-target` field
  only includes the lowercase request method and request URI when calculating the hash, avoiding those issues.
  See the [HMAC Authentication](/hub/kong-inc/hmac-auth/) documentation for more information.
  [#7037](https://github.com/kong/kong/pull/7037)
- [Syslog](/hub/kong-inc/syslog/) (`syslog`)
  The Syslog plugin now includes facility configuration options, which are a way for the plugin to group
  error messages from different sources. See the description for the facility parameter in the
  Parameters section of the [Syslog documentation](/hub/kong-inc/syslog/) for more
  information. [#6081](https://github.com/kong/kong/pull/6081).
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`) The Prometheus plugin now exposes connected data planes'
  status on the  control plane. New metrics include the following:  `data_plane_last_seen`, `data_plane_config_hash`
  and `data_plane_version_compatible`. These metrics can be useful for troubleshooting when data planes have inconsistent
  configurations across the cluster. See the [Available metrics](/hub/kong-inc/prometheus/#available-metrics) section
  of the Prometheus plugin documentation for more information. [#98](https://github.com/Kong/kong-plugin-prometheus/pull/98)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  The Zipkin plugin now includes the following tags: `kong.route`,`kong.service_name`, and `kong.route_name`.
  See the [Spans](/hub/kong-inc/zipkin/#spans) section of the Zipkin plugin documentation for more information.
  [#115](https://github.com/Kong/kong-plugin-zipkin/pull/115)
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
   and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cached-advanced`)
  - This release deprecates the `timeout` field and replaces it with three precise options:
    `connect_timeout`, `read_timeout`, and `send_timeout`. Currently, if these options are not set, the
    value of `timeout` will be used for all (or its default value of 2000ms). The `connect_timeout`, `read_timeout`,
    and `send_timeout` fields are mutually required fields. The `timeout` field will be removed from the product in version 3.0.x.x.
  - This release also includes new configuration options `keepalive_pool`, `keepalive_pool_size`, and `keepalive_backlog`. These options
    relate to [Openresty’s Lua INGINX module’s](https://github.com/openresty/lua-nginx-module/#tcpsockconnect) `tcp:connect` options.
- [ACME](/hub/kong-inc/acme/) (`acme`)
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
  See [`kong.response`](/enterprise/2.4.x/pdk/kong.response/)
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
- [LDAP Authentication](/hub/kong-inc/ldap-auth/) (`ldap-auth`)
  The LDAP Authentication schema now includes a default value for the `config.ldap_port` parameter
  that matches the documentation. Before the plugin documentation
  [Parameters](/hub/kong-inc/ldap-auth/#parameters)
  section included a reference to a default value for the LDAP port; however, the default value was not included in the plugin schema.
  [#7438](https://github.com/kong/kong/pull/7438)
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  The Prometheus plugin exporter now attaches subsystem labels to memory stats. Before, the HTTP
  and Stream subsystems were not distinguished, so their metrics were interpreted as duplicate entries by Prometheus.
  [#118](https://github.com/Kong/kong-plugin-prometheus/pull/118)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The plugin now works even when `balancer_latency` is `nil`.
  - The plugin no longer shares context between several Zipkin plugins. Before the plugin was using `ngx.ctx` exclusively,
    even in a global context, which meant more than one instance of the Zipkin plugin would override each other. Now the plugin
    uses `kong.ctx.plugin` to hold the `zipkin` table, instead of `ngx.ctx`.
- [External plugins](/enterprise/2.5.x/external-plugins/)
  This release includes better error messages when external plugins fail to start. With this fix, Kong Gateway detects the return code
  127 (command not found), allowing it to display an appropriate error message, "external plugin server start command exited
  with command not found". [#7523](https://github.com/Kong/kong/pull/7523)
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cached-advanced`)
  Kong now offers `ssl_verify` and `server_name` options for Redis Sentinel-based connections.
  Before these options were only offered for Cluster or plain Redis connections, causing SSL to fail in Redis Sentinel configurations.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
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
- [HMAC Authentication](/hub/kong-inc/hmac-auth/) (`hmac-auth`)
  The HMAC Authentication plugin now includes support for the `@request-target` field in the signature
  string. Before, the plugin used the `request-line` parameter, which contains the HTTP request method, request URI, and
  the HTTP version number. The inclusion of the HTTP version number in the signature caused requests to the same target
  but using different request methods(such as HTTP/2) to have different signatures. The newly added request-target field
  only includes the lowercase request method and request URI when calculating the hash, avoiding those issues.
  See the [HMAC Authentication](/hub/kong-inc/hmac-auth/) documentation for more information.
  [#7037](https://github.com/kong/kong/pull/7037)
- [Syslog](/hub/kong-inc/syslog/) (`syslog`)
  The Syslog plugin now includes facility configuration options, which are a way for the plugin to group
  error messages from different sources. See the description for the facility parameter in the
  Parameters section of the [Syslog documentation](/hub/kong-inc/syslog/) for more
  information. [#6081](https://github.com/kong/kong/pull/6081).
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`) The Prometheus plugin now exposes connected data planes'
  status on the  control plane. New metrics include the following:  `data_plane_last_seen`, `data_plane_config_hash` and `data_plane_version_compatible`. These metrics can be useful for troubleshooting when data planes have inconsistent configurations across the cluster. See the [Available metrics](/hub/kong-inc/prometheus/#available-metrics) section of the Prometheus plugin documentation for more information. [#98](https://github.com/Kong/kong-plugin-prometheus/pull/98)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
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
  See [`kong.response`](/enterprise/2.4.x/pdk/kong.response/)
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
- [LDAP Authentication](/hub/kong-inc/ldap-auth/) (`ldap-auth`)
  The LDAP Authentication schema now includes a default value for the `config.ldap_port` parameter
  that matches the documentation. Before the plugin documentation
  [Parameters](/hub/kong-inc/ldap-auth/#parameters)
  section included a reference to a default value for the LDAP port; however, the default value was not included in the plugin schema.
  [#7438](https://github.com/kong/kong/pull/7438)
- [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  The Prometheus plugin exporter now attaches subsystem labels to memory stats. Before, the HTTP
  and Stream subsystems were not distinguished, so their metrics were interpreted as duplicate entries by Prometheus.
  [#118](https://github.com/Kong/kong-plugin-prometheus/pull/118)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The plugin now works even when `balancer_latency` is `nil`.
  - The plugin no longer shares context between several Zipkin plugins. Before the plugin was using `ngx.ctx` exclusively,
    even in a global context, which meant more than one instance of the Zipkin plugin would override each other. Now the plugin
    uses `kong.ctx.plugin` to hold the `zipkin` table, instead of `ngx.ctx`.
- [External plugins](/enterprise/2.4.x/external-plugins/)
  This release includes better error messages when external plugins fail to start. With this fix, Kong detects the return code
  127 (command not found), allowing it to display an appropriate error message, "external plugin server start command exited
  with command not found". [#7523](https://github.com/Kong/kong/pull/7523)


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
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
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
- When making a call using the [mTLS Authentication](/hub/kong-inc/mtls-auth/) plugin,
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
- **New plugin:** [OPA](/hub/kong-inc/opa/) (`opa`)
  - The OPA plugin forwards requests to an Open Policy Agent and processes the request
    only if the authorization policy allows for it.
- **New plugin:** [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  - The Kong Mocking plugin leverages standards-based Open API Specifications (OAS)
    for sending out mock responses to APIs.
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The plugin now supports OT and Jaeger style `uber-trace-id` headers. See `config.header_type` in
    the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [101](https://github.com/Kong/kong-plugin-zipkin/pull/101 )
  - The plugin now allows insertion of custom tags on the Zipkin request trace. See `config.tags_header`
    in the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [102](https://github.com/Kong/kong-plugin-zipkin/pull/102)
  - The plugin now allows the creation of baggage items on child spans.
    [98](https://github.com/Kong/kong-plugin-zipkin/pull/98)
- [JWT](/hub/kong-inc/jwt/) (`jwt`)
  - The plugin now supports ES384 JWTs signature validation. [6854](https://github.com/Kong/kong/pull/6854)
- Logging plugins: [File Log](/hub/kong-inc/file-log/), [Loggly](/hub/kong-inc/loggly/),
  [Syslog](/hub/kong-inc/syslog), [TCP Log](/hub/kong-inc/tcp-log/), [UDP Log](/hub/kong-inc/udp-log/),
  and [HTTP Log](/hub/kong-inc/http-log/)
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
- The [Rate Limiting](/hub/kong-inc/rate-limiting/) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/)
  plugins included default options that did not work well with DB-less or hybrid deployments because the
  database is not available on data plane nodes. With this fix, the default values and validation rules are now
  compatible with DB-less or hybrid modes. [6885](https://github.com/Kong/kong/pull/6885)
- [OAuth 2.0](/hub/kong-inc/oauth2/) (`oauth2`)
  - To improve user experience and limit confusion, the plugin now handles cases of client invalid
    token generation in a more predictable way. Before, the resulting error codes were confusing and
    unhelpful, often leading users to the wrong conclusions. [6594](https://github.com/Kong/kong/pull/6594)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The W3C parsing function was returning a non-used extra value that has been removed, and the plugin
    now early-exits if there is a problem with the W3C Trace Context header.
    [100](https://github.com/Kong/kong-plugin-zipkin/pull/100)
  - Fixed a bug which randomly caused requests to fail with a 400 error code during span timestamping if
    the access phase was skipped. [105](https://github.com/Kong/kong-plugin-zipkin/pull/105)
- [Kong JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  - Cache now uses upsert instead of insert/update with databases.
  - Key rotation is now more resilient on errors. For example, previously if there were errors like an error
    connecting to an external JSON Web Key Set(JWKS) url endpoint to fetch the JWKS, the error would halt progress.
    Now, the plugin attempts to respond more resiliently, for instance by using older JWKS already downloaded.
  - Adds DB-less improvements. Before the plugin included some code paths that attempted to write data to a database.
    These code paths would cause errors with DB-less mode. Now instead of attempting to write data to a database,
    these code paths use alternative solutions such as storing data in local memory.
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - The plugin was not allowing access to any Kong modules within the sandbox except `kong.request`,
    which prevented access to other necessary modules such as `kong.log`.
- [HMAC Authentication](/hub/kong-inc/hmac-auth/) (`hmac-auth`)
  - The plugin now enables Just-in-time(JIT) compilation of authorization header regex.
    [7037](https://github.com/Kong/kong/pull/7037)
- [MTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Fixed an issue where the plugin did not work in DB-less mode.
- Kong now ensures plugins written in languages other than Lua can use `kong.reponse.get_*`
  methods, for example `kong.reponse.get_status`. [7048](https://github.com/Kong/kong/pull/7048)

### Deprecated
- The BasePlugin class was deprecated in Kong v2.4.x and will be removed in v3.0.x. Plugins
  that extend `base_plugin.lua` will continue to work until v3.0.x but should be updated to the
  newer, simpler [pattern](/enterprise/2.4.x/plugin-development/custom-logic/).

### Known issues
The [mTLS Authentication](/hub/kong-inc/mtls-auth/) plugin is incompatible with Kong Gateway v2.4.1.0.
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
- **New plugin:** [OPA](/hub/kong-inc/opa/) (`opa`)
  - The OPA plugin forwards requests to an Open Policy Agent and processes the request
    only if the authorization policy allows for it. **Released as BETA and should not be deployed
    in production environment.**
- **New plugin:** Mocking (`mocking`)
  - The Kong Mocking plugin leverages standards-based Open API Specifications (OAS)
    for sending out mock responses to APIs. **Released as BETA and should not be deployed
    in production environment.**
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The plugin now supports OT and Jaeger style `uber-trace-id` headers. See `config.header_type` in
    the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [101](https://github.com/Kong/kong-plugin-zipkin/pull/101 )
  - The plugin now allows insertion of custom tags on the Zipkin request trace. See `config.tags_header`
    in the [Parameters](/hub/kong-inc/zipkin/#parameters) section of the Zipkin
    plugin documentation for more information. [102](https://github.com/Kong/kong-plugin-zipkin/pull/102)
  - The plugin now allows the creation of baggage items on child spans.
    [98](https://github.com/Kong/kong-plugin-zipkin/pull/98)
- [JWT](/hub/kong-inc/jwt/) (`jwt`)
  - The plugin now supports ES384 JWTs signature validation. [6854](https://github.com/Kong/kong/pull/6854)
- Logging plugins: [File Log](/hub/kong-inc/file-log/), [Loggly](/hub/kong-inc/loggly/),
  [Syslog](/hub/kong-inc/syslog), [TCP Log](/hub/kong-inc/tcp-log/), [UDP Log](/hub/kong-inc/udp-log/),
  and [HTTP Log](/hub/kong-inc/http-log/)
  - Kong administrators now have a powerful new capability to transform logs to any format that’s needed
    for capturing, indexing, and correlating logs. When formatting, developers also have the ability to
    execute custom Lua code, opening up a new range of possibilities for generating logs to whichever specification
    administrators need the most. This feature uses the new PDK method `kong.log.set_serialize_value`,
    as well as the new sandbox capability, both introduced in Kong v2.3. [6944](https://github.com/Kong/kong/pull/6944)
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
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
- The [Rate Limiting](/hub/kong-inc/rate-limiting/) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/)
  plugins included default options that did not work well with DB-less or hybrid deployments because the
  database is not available on data plane nodes. With this fix, the default values and validation rules are now
  compatible with DB-less or hybrid modes. [6885](https://github.com/Kong/kong/pull/6885)
- [OAuth 2.0](/hub/kong-inc/oauth2/) (`oauth2`)
  - To improve user experience and limit confusion, the plugin now handles cases of client invalid
    token generation in a more predictable way. Before, the resulting error codes were confusing and
    unhelpful, often leading users to the wrong conclusions. [6594](https://github.com/Kong/kong/pull/6594)
- [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  - The W3C parsing function was returning a non-used extra value that has been removed, and the plugin
    now early-exits if there is a problem with the W3C Trace Context header.
    [100](https://github.com/Kong/kong-plugin-zipkin/pull/100)
  - Fixed a bug which randomly caused requests to fail with a 400 error code during span timestamping if
    the access phase was skipped. [105](https://github.com/Kong/kong-plugin-zipkin/pull/105)
- [Kong JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  - Cache now uses upsert instead of insert/update with databases.
  - Key rotation is now more resilient on errors.
  - Adds DB-less improvements.
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - The plugin was not allowing access to any Kong modules within the sandbox except `kong.request`,
    which prevented access to other necessary modules such as `kong.log`.


## 2.3.3.4
**Release Date** 2021/09/02

### Fixes

#### Enterprise
- This release fixes a regression in the Kong Dev Portal templates that removed dynamic menu navigation and other improvements
from portals created in Kong Gateway v2.3.3.3.

## 2.3.3.3
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
- Users can now include special characters ".", "-", "_", "~" in workspace names. Before when users created
  workspaces using the UI, the workspace name was validated; however, when using the Admin API to add users,
  the workspace name was not validated. Because the name was not validated in the Admin Api, users could create workspace names with special characters that would then break the environment.
- Kong Gateway now escapes "-" and "." special characters in workspace names when building the compiled pattern
  for collision detection.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  With this fix, when the OpenID Connect plugin is configured with a `config.anonymous` consumer and
  `config.scopes_required` is set, a token missing the required scopes will have the anonymous consumer
  headers set when sent to the upstream.

#### Hybrid Mode
- Control planes are now more lenient when checking data planes' compatibility in hybrid mode. See the
  [Version compatibility](/enterprise/2.3.x/deployment/hybrid-mode/#version-compatibility)
  section of the Hybrid Mode guide for more information. [#7488](https://github.com/Kong/kong/pull/7488)

## 2.3.3.2
**Release Date** 2021/04/21

### Fixes

#### Enterprise
- When using Kong Gateway in hybrid mode, schema, minor, and major version changes lead to
  a broken connection between the control planes and data planes. With this fix, the
  [OAuth 2.0 Authentication](/hub/kong-inc/oauth2/) plugin is upgraded to v2.2.0 and the
  [OpenID Connect](/hub/kong-inc/openid-connect/) plugin is downgraded from v1.9.0 to v1.8.4.

- When using the [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/) plugin with a service
  that was configured for mutual TLS, the Kong Gateway was not sending the client certificate
  to the upstream. With this fix, Kong Gateway now avoids patching a plugin's handler if it is
  not defined and supports client certificates in `buffered_proxying` mode.

## 2.3.3.1
**Release Date** 2021/04/14

### Features

#### Enterprise
- Users can now set a custom login message and classification banner (top and bottom) on the Kong Manager login page.
  This classification banner persists beyond the login page and can be configured in the `kong.conf` file.

  The following new configuration options are now available:
  * `admin_gui_header_txt`
  * `admin_gui_header_bg_color`
  * `admin_gui_header_txt_color`
  * `admin_gui_footer_txt`
  * `admin_gui_footer_bg_color`
  * `admin_gui_footer_txt_color`
  * `admin_gui_login_banner_title`
  * `admin_gui_login_banner_body`

  See the [Kong Manager section](/enterprise/2.3.x/property-reference/#kong-manager-section) of the
  Configuration Property Reference for more information.

### Fixes

#### Core
- Fixed an issue that occurred when using upstreams for load balancing, where Kong was attempting to resolve
the upstream name instead of the hostname and failing with the errors `name resolution failed` and
`dns server error: 3 name error`. The following updates correct the issue:
  - Kong does not cache empty upstream name dictionaries. [7002](https://github.com/Kong/kong/pull/7002)
  - Kong does not assume upstreams don't exist after init phases. [7010](https://github.com/Kong/kong/pull/7010)

#### Enterprise
- Fixed an issue with upgrades of Kong Gateway (Enterprise) from v1.5.x to v2.1.x. Before the fix, when admin
  consumers were shared across multiple workspaces, it was possible for the migration to fail. The upgrade would
  fail because plugin entities that depend on consumer entities must live in the same workspace as the consumer entity.
  This fix migrates these plugin entities to the same workspace as the consumer entities. Customers affected by this
  issue will need to upgrade their v2.1 install to at least v2.1.4.5 before attempting to migrate from v1.5 to v2.1.
- Fixed an issue where customers could not add roles to new admin users via Kong Manager. With this fix, role selection
  now properly displays available roles to assign.

#### Plugins
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - Fixed an issue where the plugin was running the exit hook twice. It now correctly runs the exit hook once.

## 2.3.3.0
**Release Date** 2021/03/26

### Features

#### Plugins
- [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  - Content-type failures are now reported as such when `verbose_response` is enabled.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
  - Disallows decimal values between 0,1 in `sync_rate`.

### Fixes
- Adjusted the `systemd reload` command to do a `kong prepare`.
- Removed output messages from non-strict failure builds on license validation module.
- Fixed an FFI table overflow issue when syncing DB-less declarative config.
- Kong now accepts values for Subject Alternate Name (SAN) in a certificate as per RFC 5280.
The [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/) plugin is now processing presented Alternate Names.
- Fixed a Websocket issue where connection upgrades would fail with a 502 after upgrading to v2.3.2.0.
- Upgrade header is not cleared anymore when response Connection header contains Upgrade.
- Avoided potential race conditions that could result in HTTP 500 errors when using the
least-connection algorithm in the case where an upstream target becomes inaccessible.
- Kong does not try to warm up upstream names when warming up DNS entries.
- Migrations order is now guaranteed to be always the same.
- Buffered responses are disabled on connection upgrades.
- Schema validations now log more descriptive error messages when types are invalid.
- Kong now ignores tags in Cassandra when filtering by multiple entities, which is the expected
behavior and the one already existent when using PostgreSQL databases
- Kong accepts fully-qualified domain names ending in dots.
- Now Kong does not leave plugin servers alive after exiting and does not try to start
them in the unsupported stream subsystem.
- Changed default values and validation rules for plugins that were not well-adjusted
for DB-less or hybrid modes.
- Topological sort now prioritizes core, avoiding problems when plugin entities use
core entities but don't explicitly depend on them.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - Add `config.disable_session` to be able to disable session creation with
    specified authentication methods.
  - Changed `Cache-Control="no-store"` instead of `Cache-Control="no-cache, no-store"`,
    and only set `Pragma="no-cache"` with HTTP 1.0 (and below).
  - Fixed `/openid-connect/jwks` to not expose private keys (this bug was introduced
    in v1.6.0 (Kong Enterprise v2.1.3.1) and affects all versions up to v1.8.3 (Kong Enterprise v2.3.2)).
  - Token introspection now checks the status code properly.
  - More consistent response body checks on HTTP requests.
  - Fixed an issue where enabling zlib compressor did not affect the size of the session cookie.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - Now the plugin does not pre-create namespaces on `init-worker`. As a side effect to this patch
    the plugin will create namespaces on the fly. This may result in a slightly (10-20%) increased
    response time on the first request.
- [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  - Now the plugin correctly decodes and normalizes arrays when there are multiple headers with
    the same field-name.
- [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Remove CA existence check on plugin creation - the check was not compatible with DB-less mode.
  - Correctly fetch certificates from the end of the proof chain when consumer credentials are used.
- [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - The plugin now respects `skip_large_bodies` config setting when using AWS API Gateway compatibility.
- [ACME](/hub/kong-inc/acme/) (`acme`)
  - Bump `lua-resty-acme` to v0.6.x; this fixes several issues with Pebble test server.
- [OAuth 2.0 Authentication](/hub/kong-inc/oauth2/) (`oauth2`)
  - The plugin now has better handling for multiple cases of client invalid token generation.

## 2.3.2.0
**Release Date** 2021/02/11

### **Kong Gateway (Enterprise)**
The following sections list {{site.ee_product_name}}-exclusive updates,
features, and fixes for the **2.3.2.0** version.

Kong Enterprise is renamed to Kong Gateway or Kong Gateway (Enterprise) going forward. For a more detailed explanation, including information about Kong Gateway (OSS), see [Kong Gateway (Enterprise) 2.3.x Release Notes](https://docs.konghq.com/enterprise/2.3.x/release-notes/).

### Features

#### Enterprise
- Kong Gateway can now run in free mode, without a license, which gives users access to
Kong Manager and an easy upgrade path to Enterprise.
- A (non-OSS) Kong Gateway running in its default free Mode can be upgraded to add
Enterprise functionality modules and features including **Kong Vitals**, **RBAC**,
**Workspaces**, and **Enterprise Plugins** simply by applying a new Kong license.
Contact your Kong sales representative for more information.
- A new Admin API endpoint allows application of a license to Kong Gateway.
- In hybrid mode, the control plane now propagates its license to the connected data planes in the cluster. Data planes do not require individual licenses.
- The Kong Gateway installation packages now reside under https://bintray.com/kong/ and do not require a login. Search for “gateway” to list all available packages.
- Added details to the error message of the entity type and number of entities that are preventing a Workspace from being deleted if the Workspace is not empty.
- mTLS connections to PostgreSQL are now supported.
- PostgreSQL connection using scram-sha256 authentication are now supported.

#### Core
- Kong checks version compatibility between the control plane and any data planes to ensure
the data planes and any plugins have compatibility with the control plane in hybrid mode.
The sync is stopped if the major/minor version differ or if the installed plugin versions
differ between control plane and data plane nodes. For more information, see
[Version and Compatibility Checks](/2.3.x/hybrid-mode/#version-and-compatibility-checks).
- {{site.base_gateway}} now accepts UTF-8 characters in route and service names. Entities with a `name` field
now support UTF-8 characters.
- Certificates now have `cert_alt` and `key_alt` fields to specify an alternative certificate
and key pair.
- The Go pluginserver `stderr` and `stdout` are now written into {{site.base_gateway}}’s logs, allowing Golang’s
native `log.Printf()`.
  - Introduced support for multiple pluginservers. This feature is backward-compatible with
  the existing single Go pluginserver.

#### Plugin Development Kit (PDK)
- Introduced a `kong.node.get_hostname` method that returns current node's host name.
- Introduced a `kong.cluster.get_id` method that returns a unique ID
  for the current {{site.base_gateway}} cluster. If the gateway is running in DB-less mode
  without a cluster ID explicitly defined, this method returns nil.
  For Hybrid mode, all Control Planes and Data Planes belonging to the
  same cluster returns the same cluster ID. For traditional database
  type deployments, all {{site.base_gateway}} nodes pointing to the same database will
  also return the same cluster ID.
- Introduced a `kong.log.set_serialize_value`, which allows customizing
  the output of `kong.log.serialize`.

#### Plugins
- The [HTTP Log](https://docs.konghq.com/hub/kong-inc/http-log/) (`http-log`) plugin
now lets you add a table of headers to the HTTP request using the
`headers` configuration parameter, which will help you integrate with many observability systems.
- The [Key Authentication](https://docs.konghq.com/hub/kong-inc/key-auth/) (`key-auth`)
plugin has two new configuration parameters: `key_in_header` and `key_in_query`. Both
are booleans and tell {{site.base_gateway}} whether to accept (true) or reject (false) passed in either
the header or the query string. Both default to “true.”
- The [Request Size Limiting](https://docs.konghq.com/hub/kong-inc/request-size-limiting/)
(`request-size-limiting`) plugin has a new configuration `require_content_length` that
causes the plugin to ensure a valid Content-Length header exists before reading the request body.
- The [Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/)
(`serverless-functions`) plugin introduces a sandboxing capability, is *enabled* by default,
and where only Kong PDK, OpenResty `ngx` APIs, and Lua standard libraries are allowed.
- The [LDAP Authentication Advanced](https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`) plugin has two new features:
  - added config `log_search_results` that allows displaying all of the LDAP search results received from the LDAP server.
  - additional debug log statements added for authenticated groups.
- [Rate Limiting Advanced](https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`) plugin has added a jitter (random delay) for the Retry-After header.
- [Mutual TLS Authentication](https://docs.konghq.com/hub/kong-inc/mtls-auth/)(`mtls-auth`) plugin has added support for tags in the DAO and now ensures the existence of any provided CAs when creating the plugin entry.
- [Response Transformer Advanced](https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`) has json paths for nested elements and arrays and transform gzipped content.
- Collector (`collector`, used for Immunity) plugin supports hybrid mode and has removed the `log_bodies` configuration option.
- OpenID Connect Library
  - Token introspection now checks the status code properly.
  - More consistent response body checks on HTTP requests.

#### Configuration
- `client_max_body_size` and `client_body_buffer_size`, that previously
  hardcoded to 10m, are now configurable through
  [nginx_admin_client_max_body_size](/gateway-oss/2.3.x/configuration/#nginx_http_client_max_body_size)
  and [nginx_admin_client_body_buffer_size](/gateway-oss/2.3.x/configuration/#nginx_admin_client_body_buffer_size).
- Kong-generated SSL private keys now have `600` file system permission.
- Properties `ssl_cert`, `ssl_cert_key`, `admin_ssl_cert`,
  `admin_ssl_cert_key`, `status_ssl_cert`, and `status_ssl_cert_key`
  is now an array: previously, only an RSA certificate was generated
  by default; with this change, an ECDSA is also generated. On
  intermediate and modern cipher suites, the ECDSA certificate is set
  as the default fallback certificate; on old cipher suite, the RSA
  certificate remains as the default. On custom certificates, the first
  certificate specified in the array is used.
- {{site.base_gateway}} now runs as a `kong` user if it exists; if user does not exist
  in the system, the `nobody` user is used, as before.

### Dependencies
- Bumped `kong-plugin-serverless-functions` from 1.0 to 2.1.
- Bumped `lua-resty-dns-client` from 5.1.0 to 5.2.0.
- Bumped `lua-resty-healthcheck` from 1.3.0 to 1.4.0.
- Bumped `OpenSSL` from 1.1.1h to 1.1.1i.
- Bumped `kong-plugin-zipkin` from 1.1 to 1.2.
- Bumped `kong-plugin-request-transformer` from 1.2 to 1.3.

### Fixes

#### Core
- Fixed an issue where certain incoming URI may make it possible to bypass security rules applied
on Route objects. This fix make such attacks more difficult by always normalizing the incoming
request's URI before matching against the Router.
- Fixed issue where a Go plugin would fail to read `kong.ctx.shared` values set by Lua plugins.
- Properly trigger `dao:delete_by:post` hook.
- Fixed issue where a route that supports both http and https (and has a hosts and SNIs
match criteria) would fail to proxy http requests, as it does not contain an SNI.
- Fixed issue where a `nil` request context would lead to errors `attempt to index local 'ctx'`
being shown in the logs.
- Reduced the number of needed timers to active health check upstreams and to resolve hosts.
- Schemas for full-schema validations are correctly cached now, avoiding memory
  leaks when reloading declarative configurations.
- The schema for the upstream entities now limits the highest configurable
  number of successes and failures to 255, respecting the limits imposed by
  `lua-resty-healthcheck`.
- Certificates for database connections now are loaded in the right order
  avoiding failures to connect to PostgreSQL databases.
- Fixed Lua `validate_function` in sandbox module.
- Mark boolean fields with default values as required.

#### Enterprise
- Fixed an issue that incorrectly enforced plugins when they exist in the default and a named workspace.
   The plugin configuration in the default workspace was incorrectly overriding the disabled plugin
   configuration in the named workspace.
- Fixed an issue for vitals when proxy-cached-advanced or forward-proxy plugins (possibly others)
are in use.
- Requests that received a cache hit using the plugins were not showing up under
   service/route vitals, but were visible under workspace vitals.

#### CLI
- Fixed issue where `kong reload -c <config>` would fail.
- Fixed issue where the {{site.base_gateway}} configuration cache would get corrupted.
- Kong migrations now accepts a `-p/--prefix` flag.

#### Developer Portal
- Fixed issue when applying permissions to developers using the Application Registration feature.

#### Plugin Development Kit (PDK)
- Ensure the log serializer encodes the `tries` field as an array when
  empty, rather than an object.

#### Plugins
- The [JWT](https://docs.konghq.com/hub/kong-inc/jwt/) (`jwt`) plugin disallows on consumers.
- The [Request Transformer](https://docs.konghq.com/hub/kong-inc/request-transformer/) (`request-transformer`)
plugin does not allow `null` in config anymore as they can lead to runtime errors.
- [OpenID Connect](https://docs.konghq.com/hub/kong-inc/openid-connect/) (`openid-connect`)
 - Fixed issue causing a 500 auth error when falling back to an anonymous user.
 - Fixed consumer and discovery invalidation events that were returning when the operation was create. This could leave some cache entries in cache that need to be invalidated.
 - Fixed a circular dependency issue with redirect function.
 - Fixed init worker on clients could take a long time.
- The [Rate Limiting](https://docs.konghq.com/hub/kong-inc/rate-limiting/) (`rate-limiting`) has improved counter accuracy.

### Deprecated

#### Kong Studio
- Kong Studio is deprecated.

#### Distributions
- Support for CentOS-6 is removed and entered end-of-life on Nov 30, 2020.


## 2.3.0.0 (beta)
**Release Date** 2021/01/20

### **Kong Enterprise**
The following sections list {{site.ee_product_name}}-exclusive updates,
features, and fixes for the **2.3.0.0 beta** version.

### Features

#### Enterprise
A (non-OSS) Kong Gateway running in its default Free Mode can be upgraded to add
Enterprise functionality modules and features including **Kong Vitals**, **RBAC**,
**Workspaces**, and **Kong Enterprise Plugins** simply by applying a new Kong license.
Contact your Kong sales representative for more information.

#### Core
- Kong checks version compatibility between the control plane and any data planes to ensure
the data planes and any plugins have compatibility with the control plane in hybrid mode.
The sync is stopped if the major/minor version differ or if the installed plugin versions
differ between control plane and data plane nodes. For more information, see
[Version and Compatibility Checks](/2.3.x/hybrid-mode/#version-and-compatibility-checks).
- Kong now accepts UTF-8 characters in route and service names. Entities with a `name` field
now support UTF-8 characters.
- Certificates now have `cert_alt` and `key_alt` fields to specify an alternative certificate
and key pair.
- The Go pluginserver `stderr` and `stdout` are now written into Kong’s logs, allowing Golang’s
native `log.Printf()`.
  - Introduced support for multiple pluginservers. This feature is backward-compatible with
  the existing single Go pluginserver.

#### Plugin Development Kit (PDK)
- Introduced a `kong.node.get_hostname` method that returns current node's host name.
- Introduced a `kong.cluster.get_id` method that returns a unique ID
  for the current Kong cluster. If Kong is running in DB-less mode
  without a cluster ID explicitly defined, this method returns nil.
  For Hybrid mode, all Control Planes and Data Planes belonging to the
  same cluster returns the same cluster ID. For traditional database
  type deployments, all Kong nodes pointing to the same database will
  also return the same cluster ID.
- Introduced a `kong.log.set_serialize_value`, which allows customizing
  the output of `kong.log.serialize`.

#### Plugins
- The [HTTP Log](https://docs.konghq.com/hub/kong-inc/http-log/) (`http-log`) plugin
has been improved to allow you to add a table of headers to the HTTP request using the
`headers` configuration parameter, which will help you integrate with many observability systems.
- The [Key Authentication](https://docs.konghq.com/hub/kong-inc/key-auth/) (`key-auth`)
plugin has two new configuration parameters: `key_in_header` and `key_in_query`. Both
are booleans and tell Kong whether to accept (true) or reject (false) passed in either
the header or the query string. Both default to “true.”
- The [Request Size Limiting](https://docs.konghq.com/hub/kong-inc/request-size-limiting/)
(`request-size-limiting`) plugin has a new configuration `require_content_length` that
causes the plugin to ensure a valid Content-Length header exists before reading the request body.
- The [Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/)
(`serverless-functions`) plugin introduces a sandboxing capability, is *enabled* by default,
and where only Kong PDK, OpenResty `ngx` APIs, and Lua standard libraries are allowed.

#### Configuration
- `client_max_body_size` and `client_body_buffer_size`, that previously
  hardcoded to 10m, are now configurable through
  [nginx_admin_client_max_body_size](/2.3.x/configuration/#nginx_http_client_max_body_size)
  and [nginx_admin_client_body_buffer_size](/2.3.x/configuration/#nginx_admin_client_body_buffer_size).
- Kong-generated SSL private keys now have `600` file system permission.
- Properties `ssl_cert`, `ssl_cert_key`, `admin_ssl_cert`,
  `admin_ssl_cert_key`, `status_ssl_cert`, and `status_ssl_cert_key`
  is now an array: previously, only an RSA certificate was generated
  by default; with this change, an ECDSA is also generated. On
  intermediate and modern cipher suites, the ECDSA certificate is set
  as the default fallback certificate; on old cipher suite, the RSA
  certificate remains as the default. On custom certificates, the first
  certificate specified in the array is used.
- Kong now runs as a `kong` user if it exists; if user does not exist
  in the system, the `nobody` user is used, as before.

### Dependencies
- Bumped `kong-plugin-serverless-functions` from 1.0 to 2.1.
- Bumped `lua-resty-dns-client` from 5.1.0 to 5.2.0.
- Bumped `lua-resty-healthcheck` from 1.3.0 to 1.4.0.
- Bumped `OpenSSL` from 1.1.1h to 1.1.1i.
- Bumped `kong-plugin-zipkin` from 1.1 to 1.2.
- Bumped `kong-plugin-request-transformer` from 1.2 to 1.3.

### Fixes

#### Core
- Fixed issue where a Go plugin would fail to read `kong.ctx.shared` values set by Lua plugins.
- Properly trigger `dao:delete_by:post` hook.
- Fixed issue where a route that supports both http and https (and has a hosts and SNIs
match criteria) would fail to proxy http requests, as it does not contain an SNI.
- Fixed issue where a `nil` request context would lead to errors `attempt to index local 'ctx'`
being shown in the logs.
- Reduced the number of needed timers to active health check upstreams and to resolve hosts.
- Schemas for full-schema validations are correctly cached now, avoiding memory
  leaks when reloading declarative configurations.
- The schema for the upstream entities now limits the highest configurable
  number of successes and failures to 255, respecting the limits imposed by
  `lua-resty-healthcheck`.
- Certificates for database connections now are loaded in the right order
  avoiding failures to connect to PostgreSQL databases.

#### CLI
- Fixed issue where `kong reload -c <config>` would fail.
- Fixed issue where the Kong configuration cache would get corrupted.

#### Developer Portal
- Fixed issue when applying permissions to developers using the Application Registration feature.

#### Plugin Development Kit (PDK)
- Ensure the log serializer encodes the `tries` field as an array when
  empty, rather than an object.

#### Plugins
- The [Request Transformer](https://docs.konghq.com/hub/kong-inc/request-transformer/) (`request-transformer`)
plugin does not allow `null` in config anymore as they can lead to runtime errors.
- [OpenID Connect](https://docs.konghq.com/hub/kong-inc/openid-connect/) (`openid-connect`) issue
fixed causing a 500 auth error when falling back to an anonymous user.

### Deprecated
#### Distributions
- Support for CentOS-6 is removed and entered end-of-life on Nov 30, 2020.

## 2.2.1.5
**Release Date** 2021/09/02

### Fixes

#### Enterprise
- This release fixes a regression in the Kong Dev Portal templates that removed dynamic menu navigation and other improvements
from portals created in Kong Gateway v2.2.1.4.

## 2.2.1.4
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

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  With this fix, when the OpenID Connect plugin is configured with a `config.anonymous` consumer and
  `config.scopes_required` is set, a token missing the required scopes will have the anonymous consumer
  headers set when sent to the upstream.

## 2.2.1.3
**Release Date** 2021/04/22

This release includes internal updates that do not affect product functionality.

## 2.2.1.2
**Release Date** 2021/04/14

### Fixes

#### Enterprise
- Fixed an issue with upgrades of Kong Gateway (Enterprise) from v1.5.x to v2.1.x. Before the fix, when admin consumers were shared across multiple workspaces, it was possible for the migration to fail. The upgrade would fail because plugin entities that depend on consumer entities must live in the same workspace as the consumer entity. This fix migrates these plugin entities to the same workspace as the consumer entities. Customers affected by this issue will need to upgrade their v2.1 install to at least v2.1.4.5 before attempting to migrate from v1.5 to v2.1.
- Fixed an issue where customers could not add roles to new admin users via the Kong Cloud Manager. With this fix, role selection now properly displays available roles to assign.

#### Plugins
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - Fixed an issue where the plugin was running the exit hook twice. It now correctly runs the exit hook once.

## 2.2.1.1
**Release Date** 2021/03/26

### Fixes

#### Core
- Fixed an issue where certain incoming URI may make it possible to bypass security rules applied
on Route objects. This fix make such attacks more difficult by always normalizing the incoming
request's URI before matching against the Router.
- Sanitize sanitize path postfix for additional security.

#### Enterprise
- Kong now display errors to better identify the issue when `validate_key` fails.
- Kong now uses the correct workspace ID when selecting SNI in DB-less/hybrid mode.
- Fixed verification when using combined certificates.
- Corrected healthchecker thresholds.

#### DevPortal
- Before, when enabling application registration with key authentication, developers who created
applications were able to see all Services for which the application registration plugin was enabled,
regardless of the permissions granted to their role. With this fix, developers who create applications
will only see Services if the role they are assigned to has been granted permissions to the relevant
specs.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - Fixed init workers that were prolonging Kong startup time.
  - Fixed consumer and discovery invalidation events that were returning when the operation
  was `create`. This could leave some cache entries in cache that need to be invalidated.
  - Fixed a circular dependency issue with `redirect` function.
  - Added `config.disable_session` to be able to disable session creation with specified
    authentication methods.
  - Changed `Cache-Control="no-store"` instead of `Cache-Control="no-cache, no-store"`,
    and only set `Pragma="no-cache"` with HTTP 1.0 (and below).
  - Fixed `/openid-connect/jwks` to not expose private keys (this bug was introduced
    in v1.6.0 (Kong Enterprise v2.1.3.1) and affects all versions up to v1.8.3 (Kong Enterprise v2.3.2)).
  - Token introspection now checks the status code properly.
  - More consistent response body checks on HTTP requests.
  - Fixed an issue where enabling zlib compressor the size of the session cookie was not
    changing in value.
- [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - The plugin now respects `skip_large_bodies` config setting when using AWS API Gateway compatibility.
- [ACME](/hub/kong-inc/acme/) (`acme`)
  - Bump `lua-resty-acme` to v0.6.x; this fixes several issues with Pebble test server.
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - The plugin now allows access to Kong modules within the sandbox, not only to `kong.request`.

#### Plugin Dependencies
- OpenID Connect Library
  - Token introspection now checks the status code properly.
  - Added more consistent response body checks on `HTTP` requests.


## 2.2.1.0
**Release Date** 2020/12/31

### Features

#### Developer Portal
- Added `key-auth` support to Portal Application Registration.

### Fixes

#### Core
- OpenSSL version bumped to 1.1.1i.
  The OpenSSL version bump is related to CVE-2020-1971. We have performed an extensive review of OpenSSL usage in Kong and have found the following:
  - The core product is not vulnerable to the high severity CVE-2020-1971.
  - The `mtls-auth` plugin had a potential exploit associated with with CVE-2020-1971, but it would require an attacker to control a trusted CA or have admin port access, which [we recommend you block from attackers](https://docs.konghq.com/latest/secure-admin-api/) for numerous reasons. The updated OpenSSL version in this release additionally protects the `mtls-auth` plugin.
  - As a precautionary measure, we have bumped the OpenSSL dependency version to OpenSSL 1.1.1i.

#### Enterprise
- Fixed an issue where `/tmp` directories will not be deleted when running Kong or Kong CLI.
- Fixed an issue that prevented the use of keyring encryption of Kong database fields.
- RCE (Remote Code Execution) Plugin Mitigations:
  Several Kong plugins allow arbitrary code execution by design, including the `serverless` plugin (also known as `pre-function` and `post-function` capabilities) and the `exit-transformer` plugin (for example, allows an administrator to configure a Lua-based response transformation). Changes include:
  - A new change locks down these plugins so that they have limited functions available in a sandbox, providing significant additional security for a user with an exposed admin port.
  - Functions such as "require" are no longer available to scripts that run in these plugins for security purposes, because allowing "require" allows embedded additional arbitrary code execution.
  - **Important**: This change causes a **breaking change** in this patch release and it cannot be avoided. Our recommendation is that [users lock down their admin ports](https://docs.konghq.com/latest/secure-admin-api/) to avoid attackers trying to exploit any API gateway, like Kong, to gain access to internal networks. If you need the previous release behavior, including the ability to arbitrarily "require" libraries or if you want to lock things down further, we have introduced three new settings you can use:
    - `KONG_UNTRUSTED_LUA = off | sandbox | on` Sets whether any custom Lua code can be used outside of Kong's distributed code. Defaults to "sandbox".
    - `KONG_UNTRUSTED_LUA_SANDBOX_REQUIRES = foo,bar` Which libraries, if any, you want to require in the sandbox. Defaults to an empty list.
    - `KONG_UNTRUSTED_LUA_SANDBOX_ENVIRONMENT = kong.request` Any additional objects you want to pass through to the sandbox environments.  Defaults to an empty list.

    For detailed information about these new properties, see the [property reference documentation](https://docs.konghq.com/enterprise/2.3.x/property-reference/#untrusted_lua).

#### Developer Portal
- In the Developer Portal Edit Application dialog, the Edit button is renamed to Save.

#### Plugins
- Collector (`collector`, used for Immunity)
  - Use `kong.request.get_body()`
- [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Fixed (log) updating auth errors to handle fallthrough scenarios.
  - Fixed (route, ws) ensuring workspace options are used for cache lookups.
- [Forward Proxy Advanced](/hub/kong-inc/forward-proxy/)(`forward-proxy`/)
  - Fixed an issue where PDK logging phase check causes an error.
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - Bumped `lua-resty-session` dependency to 3.8 to allow passing connection options to redis cluster client.
- [Session](/hub/kong-inc/session/) (`session`)
  - Added endpoint key to Admin API.
  - Bumped `lua-resty-session` dependency to 3.8.

#### Configuration

- Kong now runs as a `kong` user if it exists; if user does not exist
  in the system, the `nobody` user is used, as before.

#### Breaking Changes
- See *RCE (Remote Code Execution) Plugin Mitigations* in the Kong Enterprise section.


## 2.2.0.0
**Release Date** 2020/11/17

<div class="alert alert-warning">
<i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
<b>Important:</b> Kong Enterprise 2.2.0.0 includes 2.2.0.0 (beta)
features, fixes, known issues, and workarounds. The changelog for 2.2.0.0 version includes only the diff between 2.2.0.0 and 2.2.0.0 (beta). See the <a href="#2200-beta">2.2.0.0 (beta) changelog</a> for more information.
</div>

### Features
**Note: Feature updates for Kong Enterprise 2.2.0.0 version include [2.2.0.0 (beta)](/gateway/changelog/#beta-features-2200) features.**

#### **Kong Manager**
- No new features.
- Kong Brain and Service Map are removed.

#### **Plugins**
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - Added `config.enable_hs_signatures` (`false` is the default).
  - Added `config.session_compressor`.
- [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  - Added `config.enable_hs_signatures` (`false` is the default).
- [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Added support for `isBase64Encoded` flag in Lambda function responses.
- [gRPC-Web](/hub/kong-inc/grpc-web/) (`grpc-web`)
  - New configuration `pass_stripped_path`, which, if set to true, causes the
  plugin to pass the stripped request path (see the
  [`strip_path`](/enterprise/latest/admin-api/#route-object) Route attribute)
  to the upstream gRPC service.

### Fixes
**Note: Fixes for Kong Enterprise 2.2.0.0 version include [2.2.0.0 (beta)](/gateway/changelog/#beta-fixes-2200) fixes.**

#### **OpenID Connect Library**
  - Changed to disable HS-signature verification by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Fixes vulnerability in the OpenID Connect and JWT Signer Plugins. Login to the [Kong Enterprise Support Portal](https://support.konghq.com/support/s/) for [OIDC advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-OIDC-Plugin) and [JWT advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-JWT-Signer-Plugin) details.

#### **Plugins**
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - HS-signature verification is now disabled by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Updated `lua-resty-session` dependency to 3.7.
- [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  - HS-signature verification is now disabled by default.


## 2.2.0.0 (beta)
**Release Date** 2020/10/27

### **Kong Enterprise**
The following sections list {{site.ee_product_name}}-exclusive updates,
features, and fixes for the **2.2.0.0 beta** version.

### Dependencies
- Bumped the required lua-resty-openssl version to
[0.6.8](https://github.com/fffonion/lua-resty-openssl/blob/master/CHANGELOG.md#068---2020-10-15).

### Features {#beta-features-2200}

#### Core
- Added support for TLS Redis connections when using the Kong Redis library.
- Added support for running Kong as the non-root user `kong` on distributed
systems.

#### Plugins
- OpenID Connect (`openid-connect`)
  - Added the `issuers_allowed` configuration parameter, which introduces the
  ability to specify valid issuers for access token ISS claim.
  - Added the ability to pass `urn:ietf:params:oauth:grant-type:jwt-bearer`
  assertions with the `client_credentials` authentication method.
  - Added the `userinfo_endpoint` configuration parameter, which allows
  manual definition of a user info endpoint.
  - Added the ability to find nested claims using array indices. Array indices
  start at 1, same as in Lua.
  - Added issuer cache warmup on node start.
- **Encryption support:** The Redis strategy now supports TLS connections.
  Introduced the `redis.ssl`, `redis.ssl_verify`, and `redis.server_name`
  parameters for configuring TLS connections. Applies to the following plugins:
  - Rate Limiting Advanced (`rate-limiting-advanced`)
  - Proxy Caching Advanced (`proxy-cache-advanced`)

### Fixes {#beta-fixes-2200}

#### Core
- **Hybrid mode**:
  - Fixed an issue where, in a cluster with multiple Control
  Planes, configuration changes made by one Control Plane would not be picked up
  by other Control Planes, and therefore would not be pushed to all Data Planes.
  - Fixed an issue with custom certificates. When using a workspace other than
  `default`, Kong Gateway did not present the configured certificate when the
  correct SNI was sent.

#### Plugins
- OpenID Connect (`openid-connect`)
  - Fixed a bug in issuer normalization.
  - Improved discovery and rediscovery to be more resilient.
  - When refreshing tokens, the old `id_token` is now preserved if a new one is
  not given.
  - Fixed an issue where token decoding also re-verified claims. Changed it
  to skip claim verification when decoding tokens.
  - Fixed issue of sharing the cache key using the same credentials but with
    different endpoint arguments. Added a new parameter: `cache_tokens_salt`.
    The value for this parameter is auto-generated by default, which means that
    the token endpoint cache is not automatically shared between different
    plugin instances.
  - Fixed issue that caused the `unexpected_redirect_uri` setting to be
  ignored.
  - Fixed redirects to use `kong.response.exit`, which implements the proper
  short-circuiting semantics in Kong.
- OAuth Introspection (`oauth2-introspection`)
  - Fixed an issue where the cache would not be properly invalidated
  when a Consumer username was updated.
- Proxy Caching Advanced (`proxy-cache-advanced`)
  - Fixed a 500 error that would appear when the URL contained empty query
  string parameters.
- Exit Transformer (`exit-transformer`)
  - Fixed some cases where an `unknown` exit would not be handled.
- AWS Lambda (`aws-lambda`)
  - Respect the `skip_large_bodies` config setting even when not using AWS API
    Gateway compatibility.
- ACME (`acme`)
  - Changed the cache to use non-nil TTL in Hybrid mode. This fixes a bug for
    renewals not updating the certificate after Kong Gateway 2.0.5.
  - Fixed a bug in database mode where the renewal configuration was not
    properly stored.
- Prometheus (`prometheus`)
  - Switched to using the `Kong.pdk.serializer` instead of the deprecated basic
    serializer.
- Collector (`collector`, used for Immunity)
  - Removed the `/service_maps` passthrough.


### **Kong Gateway (OSS)**

**Kong Enterprise 2.2.0.0 beta** inherits the following changes from the
open-source **Kong Gateway 2.2.0.0**:

### Dependencies

- For Kong Gateway 2.2, the required OpenResty version has been bumped to
  [1.17.8.2](http://openresty.org/en/changelog-1017008.html), and the
  the set of patches included has changed, including the latest release of
  [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module).
  If you are installing Kong from one of our distribution
  packages, you are not affected by this change.
- Bumped OpenSSL version from `1.1.1g` to `1.1.1h`.
  [#6382](https://github.com/Kong/kong/pull/6382)

    <div class="alert alert-ee blue">
    <strong>Note:</strong> If you are not using one of our distribution packages and compiling
    OpenResty from source, you must still apply Kong's <a href="https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/patches">
    OpenResty patches</a>
    (and, as highlighted above, compile OpenResty with the new
    <code>lua-kong-nginx-module</code>). Our <a href="https://github.com/Kong/kong-build-tools">kong-build-tools</a>
    repository allows you to do both easily.
    </div>

- Cassandra 2.x support is now deprecated. If you are still
  using Cassandra 2.x with Kong, we recommend you to upgrade, since this
  series of Cassandra is about to be EOL with the upcoming release of
  Cassandra 4.0.

### Additions

#### Core

-  **UDP support**: Kong now features support for UDP proxying
  in its stream subsystem. The `"udp"` protocol is now accepted in the `protocols`
  attribute of Routes and the `protocol` attribute of Services.
  Load balancing and logging plugins support UDP as well.
  [#6215](https://github.com/Kong/kong/pull/6215)
- **Configurable Request and Response Buffering**: The buffering of requests
  or responses can now be enabled or disabled on a per-route basis, through
  setting attributes `Route.request_buffering` or `Route.response_buffering`
  to `true` or `false`. The default behavior remains the same: buffering is
  enabled by default for requests and responses.
  [#6057](https://github.com/Kong/kong/pull/6057)
- **Option to Automatically Load OS Certificates**: The configuration
  attribute `lua_ssl_trusted_certificate` was extended to accept a
  comma-separated list of certificate paths, as well as a special `system`
  value, which expands to the system default certificates file installed
  by the operating system. This follows a very simple heuristic to try to
  use the most common certificate file in the most popular distros.
  [#6342](https://github.com/Kong/kong/pull/6342)
- **The consistent-hashing load balancing algorithm** does not need to use the
  entire target history to build the same proxying destinations table on all
  Kong nodes anymore. Now, deleted targets are removed from the database and the
  target entities can be manipulated by the Admin API the same way as any other
  entity.
  [#6336](https://github.com/Kong/kong/pull/6336)
- **Added `X-Forwarded-Path` header:** If a trusted source provides an
  `X-Forwarded-Path` header, it is proxied as is. Otherwise, Kong sets
  the content of said header to the request's path.
  [#6251](https://github.com/Kong/kong/pull/6251)
- **Hybrid Mode:**
  - The table of Data Plane nodes at the Control Plane is now
    cleaned up automatically, according to a delay value configurable using
    the `cluster_data_plane_purge_delay` attribute, set to 14 days by default.
    [#6376](https://github.com/Kong/kong/pull/6376)
  - Data Plane nodes now apply only the last config when receiving
    several updates in sequence, improving the performance when large configs
    are in use. [#6299](https://github.com/Kong/kong/pull/6299)
  - Synchronization performance improvements: Kong now uses a
    new internal synchronization method to push changes from the Control Plane
    to the Data Plane, drastically reducing the amount of communication between
    nodes during bulk updates.
    [#6293](https://github.com/Kong/kong/pull/6293)
- **The `Upstream.client_certificate` attribute** can now be used for proxying.
  This allows the `client_certificate` setting used for mTLS handshaking with
  the `Upstream` server to be shared easily among different Services.
  However, `Service.client_certificate` will take precedence over
  `Upstream.client_certificate` if both are set simultaneously.
  In previous releases, `Upstream.client_certificate` was only used for
  mTLS in active health checks.
  [#6348](https://github.com/Kong/kong/pull/6348)
- **New `shorthand_fields` top-level attribute** in schema definitions, which
  deprecates `shorthands` and includes type definitions in addition to the
  shorthand callback.
  [#6364](https://github.com/Kong/kong/pull/6364)

#### Admin API

- **Hybrid Mode:** Introduced the new endpoint `/clustering/data-planes`, which
  returns complete information about all Data Plane nodes that are connected to
  the Control Plane cluster, regardless of the Control Plane node to which they
  are connected.
  [#6308](https://github.com/Kong/kong/pull/6308)
- Admin API responses now honor the `headers` configuration setting for
  including or removing the `Server` header.
  [#6371](https://github.com/Kong/kong/pull/6371)

#### PDK

- New function `kong.request.get_forwarded_prefix`: Returns the prefix path
  component of the request's URL that Kong stripped before proxying to upstream,
  respecting the value of `X-Forwarded-Prefix` when it comes from a trusted
  source.
  [#6251](https://github.com/Kong/kong/pull/6251)
- The `kong.response.exit` now honors the `headers` configuration setting for
  including or removing the `Server` header.
  [#6371](https://github.com/Kong/kong/pull/6371)
- The `kong.log.serialize` function now can be called using the stream subsystem,
  allowing various logging plugins to work under TCP and TLS proxy modes.
  [#6036](https://github.com/Kong/kong/pull/6036)
- Requests with `multipart/form-data` MIME type now can use the same part name
  multiple times. [#6054](https://github.com/Kong/kong/pull/6054)

#### Plugins

- **New Response Phase for custom plugins**: Both Go and Lua custom plugins now
  support a new plugin phase called `response` in Lua plugins and `Response` in
  Go. Using it automatically enables response buffering, which allows you to
  manipulate both the response headers and the response body in the same phase.
  This enables support for response handling in Go, where header and body
  filter phases are not available, allowing you to use PDK functions such
  as `kong.Response.GetBody()`, and provides an equivalent simplified
  feature for handling buffered responses from Lua plugins as well.
  [#5991](https://github.com/Kong/kong/pull/5991)
- [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Bumped to version 3.5.0.
  [#6379](https://github.com/Kong/kong/pull/6379)
  - Added support for the `isBase64Encoded` flag in Lambda function responses.
- [gRPC Web](/hub/kong-inc/grpc-web/) (`grpc-web`)
  - Introduced the configuration parameter `pass_stripped_path`, which, if set
  to true, causes the plugin to pass the stripped request path (see the
  [`strip_path`](/enterprise/latest/admin-api/#route-object) Route attribute)
  to the upstream gRPC service.
- [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  - Added support for rate limiting by path using the `limit_by = "path"`
  configuration attribute. Thanks [KongGuide](https://github.com/KongGuide) for
  the patch!
  [#6286](https://github.com/Kong/kong/pull/6286)
- [Correlation ID](/hub/kong-inc/correlation-id/) (`correlation-id`)
  - The plugin now generates a `correlation-id` value by default
  if the correlation ID header arrives but is empty.
  [#6358](https://github.com/Kong/kong/pull/6358)

### Deprecated Features

- **Hybrid mode:**  The `/clustering/status` endpoint is now deprecated, since it
  returned only information about Data Plane nodes directly connected to the
  Control Plane node to which the Admin API request was made. It is
  superseded by the new `/clustering/data-planes` endpoint.
- The `shorthands` attribute in schema definitions is deprecated in favor of
  the new `shorthand_fields` top-level attribute.

## 2.1.4.7
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

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  With this fix, when the OpenID Connect plugin is configured with a `config.anonymous` consumer and
  `config.scopes_required` is set, a token missing the required scopes will have the anonymous consumer
  headers set when sent to the upstream.

## 2.1.4.6
**Release Date** 2021/04/21

This release includes internal updates that do not affect product functionality.

### Fixes

#### Enterprise
- Fixed an issue encountered when users were deleting a Kong Dev Portal collection and
  the collection was not defined in `portal.conf.yaml` or `portal.conf.yaml`
  did not exist. Instead of deleting the content, users received an error.
  This issue also occurred when users were using the Kong Dev Portal CLI to wipe or deploy
  templates. With this fix, deleting content from the Kong Dev Portal works as
  expected.
- In Kong Manager, users could receive an empty set of roles from an API request,
  even when valid RBAC roles existed in the database because of a filtering issue
  with portal and default roles on a paginated set. With this fix, if valid RBAC
  roles exist in the database, an API request returns with those valid roles.

## 2.1.4.5
**Release Date** 2021/03/31

### Fixes

#### Enterprise
Fixed an issue with upgrades of Kong Gateway (Enterprise) from v1.5.x to v2.1.x. Before the fix, when admin consumers were shared across multiple workspaces, it was possible for the migration to fail. The upgrade would fail because plugin entities that depend on consumer entities must live in the same workspace as the consumer entity. This fix migrates these plugin entities to the same workspace as the consumer entities. Customers affected by this issue will need to upgrade their v2.1 install to at least v2.1.4.5 before attempting to migrate from v1.5 to v2.1.

## 2.1.4.4
**Release Date** 2021/03/26

### Fixes

#### Core
- Fixed an issue where certain incoming URI may make it possible to bypass security rules applied
on Route objects. This fix make such attacks more difficult by always normalizing the incoming
request's URI before matching against the Router.
- Sanitize sanitize path postfix for additional security.

#### Enterprise
- If a trusted source provides an `X-Forwarded-Path` header, it's proxied as-is; otherwise,
Kong will set the content of the header to the request's URI.
- Fixed a migration issue where workspaces IDs (`ws_id`) were not being appended to more than
  1000 entities, resulting in `ws_id` being `null` after migrations have been successfully
  completed with `kong migrations finish`.

#### DevPortal
- Before, when enabling application registration with key authentication, developers who created
applications were able to see all Services for which the application registration plugin was enabled,
regardless of the permissions granted to their role. With this fix, developers who create applications
will only see Services if the role they are assigned to has been granted permissions to the relevant
specs.

#### Plugins
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - Fixed init workers that were prolonging Kong startup time.
  - Fixed consumer and discovery invalidation events that were returning when the operation
  was `create`. This could leave some cache entries in cache that need to be invalidated.
  - Fixed a circular dependency issue with the redirect function.
  - Added `config.disable_session` to be able to disable session creation with
    specified authentication methods.
  - Changed `Cache-Control="no-store"` instead of `Cache-Control="no-cache, no-store"`,
    and only set `Pragma="no-cache"` with HTTP 1.0 (and below).
  - Fixed `/openid-connect/jwks` to not expose private keys (this bug was introduced
    in v1.6.0 (Kong Enterprise v2.1.3.1) and affects all versions up to v1.8.3 (Kong Enterprise v2.3.2)).
  - Token introspection now checks the status code properly.
  - More consistent response body checks on HTTP requests.
  - Fixed an issue where enabling zlib compressor did not affect the size of the session cookie.
- [ACME](/hub/kong-inc/acme/) (`acme`) (updated to v0.2.14)
  - Bump `lua-resty-acme` to v0.6.x; this fixes several issues with Pebble test server.
- [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  - The plugin now allows access to Kong modules within the sandbox, not only to `kong.request`.

#### Plugin Dependencies
- OpenID Connect Library
  - Token introspection now checks the status code properly.
  - Added more consistent response body checks on `HTTP` requests.

## 2.1.4.3
**Release Date** 2020/12/31

### Fixes

#### Core
- OpenSSL version bumped to 1.1.1i.
  The OpenSSL version bump is related to CVE-2020-1971. We have performed an extensive review of OpenSSL usage in Kong and have found the following:
  - The core product is not vulnerable to the high severity CVE-2020-1971.
  - The `mtls-auth` plugin had a potential exploit associated with with CVE-2020-1971, but it would require an attacker to control a trusted CA or have admin port access, which [we recommend you block from attackers](https://docs.konghq.com/latest/secure-admin-api/) for numerous reasons. The updated OpenSSL version in this release additionally protects the `mtls-auth` plugin.
  - As a precautionary measure, we have bumped the OpenSSL dependency version to OpenSSL 1.1.1i.

#### Kong Enterprise
- RCE (Remote Code Execution) Plugin Mitigations:
  Several Kong plugins allow arbitrary code execution by design, including the `serverless` plugin (also known as `pre-function` and `post-function` capabilities) and the `exit-transformer` plugin (for example, allows an administrator to configure a Lua-based response transformation). Changes include:
  - A new change in this release locks down these plugins so that they have limited functions available in a sandbox, providing significant additional security for a user with an exposed admin port.
  - Functions such as "require" are no longer available to scripts that run in these plugins for security purposes, because allowing "require" allows embedded additional arbitrary code execution.
  - **Important**: This change causes a **breaking change** in this patch release and it cannot be avoided. Our recommendation is that [users lock down their admin ports](https://docs.konghq.com/latest/secure-admin-api/) to avoid attackers trying to exploit any API gateway, like Kong, to gain access to internal networks. If you need the previous release behavior, including the ability to arbitrarily "require" libraries or if you want to lock things down further, we have introduced three new settings you can use:
    - `KONG_UNTRUSTED_LUA = off | sandbox | on` Sets whether any custom Lua code can be used outside of Kong's distributed code. Defaults to "sandbox".
    - `KONG_UNTRUSTED_LUA_SANDBOX_REQUIRES = foo,bar` Which libraries, if any, you want to require in the sandbox. Defaults to an empty list.
    - `KONG_UNTRUSTED_LUA_SANDBOX_ENVIRONMENT = kong.request` Any additional objects you want to pass through to the sandbox environments.  Defaults to an empty list.

    For detailed information about these new properties, see the [property reference documentation](https://docs.konghq.com/enterprise/2.3.x/property-reference/#untrusted_lua).

- Backport Admins Migration Fix: When upgrading from 1.5.x.y to versions prior to 2.2.0.0, there was a known migration issue that prevented the upgrade from continuing and also generated log errors. This issue was caused by a bug in the handling of which workspaces consumers were assigned to. Release 2.1.4.3 resolves this issue the same way it does for 2.2.0.0. It is recommended that if you are upgrading to 2.1.x.y, that you use 2.1.4.3 to avoid migration errors.

#### Kong Manager
- Fixed an issue causing the Developer registration link to not work.

#### Plugins
- Mutual TLS Authentication (`mtls-auth`)
  - Fixed (log) updating auth errors to handle fallthrough scenarios.
  - Fixed (route, ws) ensuring workspace options are used for cache lookups.

#### Breaking Changes
- See *RCE (Remote Code Execution) Plugin Mitigations* in the Kong Enterprise section.


## 2.1.4.2
**Release Date** 2020/11/17

### Fixes

#### Core
- Fixed an issue causing workspace entity count meta information to get out of sync when deleting entities by name.

#### Kong Manager
- Added Service path to information at the top of Service specific page.

#### Kong Developer Portal
- Fixed Application Save button label, changing from Edit to Save.

#### **OpenID Connect Library**
  - Changed to disable HS-signature verification by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Fixes vulnerability in the OpenID Connect and JWT Signer Plugins. Login to the [Kong Enterprise Support Portal](https://support.konghq.com/support/s/) for [OIDC advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-OIDC-Plugin) and [JWT advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-JWT-Signer-Plugin) details.

#### Plugins
- Mutual TLS Authentication (`mtls-auth`)
  - Fixed an issue when client certificate is not requested for plugins applied in non-default workspace.
- Proxy Cache Advanced (`proxy-cache-advanced`)
  - Fixed cache usage when URL includes empty query string param.
- [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  - HS-signature verification is now disabled by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Updated `lua-resty-session` dependency to 3.7.
- [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  - HS-signature verification is now disabled by default.


## 2.1.4.1
**Release Date** 2020/10/30

### Fixes

#### Core

* Fix unique violation error for workspaces when using PUT.
* Fix cluster telemetry server name default.
* Allow certificates to be applied from workspaces.
* Fix time waiting calculation for 499 errors.
* Migration optimizations and fixes:
  * Remove extra connections in PostgreSQL.
  * Ensure that multiple workspaces are not created for Cassandra.
* Database optimizations and fixes:
  * Correct wait for schema agreement timeout with Cassandra.
  * Remove rate limiting metrics on database export.
* Fix cluster level invalidation for hybrid control plane nodes.
* Optimize workspace ID retrieval.

#### Plugins

* [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  * Fix error getting route.
* [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Ensure that the basic serializer generates the `request.tls.client_verify`
  field based on this module's validation result.
* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  - Update the `lua-resty-ljsonschema` library dependency.
  See library [changelog](https://github.com/Tieske/lua-resty-ljsonschema#111-28-oct-2020).


## 2.1.4.0
**Release Date** 2020/10/01

### Fixes

#### Kong Gateway

* Fixed upsert for RBAC users using Admin API.
* Allow PostgreSQL keepalive time to be configurable.

#### Kong Manager

* Added path to service on display page.

#### Kong Developer Portal

* Fixed app ``Save`` button to display as ``Save`` instead of ``Edit``.
* Added `plugin.service` check in `app_reg` helper.
* Fixed application registration issue rendered unusable with certain plugin configurations.
* Fixed sidebar links with "."

### Deprecated Features

* Kong Brain is deprecated and not available for use in Kong Enterprise.

## 2.1.3.1
**Release Date** 2020/08/31

### Fixes

#### Kong Gateway

* Fixed issues to properly migrate workspaces associated with ACL groups.
* Improved the amount of logging in the migrations framework.

#### Kong Manager

* Fixed docs link and messaging on the Dev Portals page.

## 2.1.3.0
**Release Date** 2020/08/25

Kong Enterprise 2.1.3.0 version includes 2.1.0.0 (beta) features, fixes, known issues, and workarounds. See the [2.1.0.0 (beta)](/gateway/changelog/#2100-beta/) changelog for more details.

### Features

**Note: Feature updates for Kong Enterprise 2.1.3.0 version includes [2.1.0.0 (beta)](/gateway/changelog/#features) features.**

#### Kong Gateway
* Inherited changes from OSS Kong in releases 2.0.x, 2.1.0, 2.1.1, 2.1.2, and 2.1.3.
* Workspaces code has been refactored for performance. The feature should work the same for most users.
* TLS version may be specified when using TLS to connect to a PostgreSQL database.

#### Kong Manager
* Open ID Connect (`openid-connect`) can now be used with [Mapping Service Directory Groups to Kong Roles](/enterprise/latest/kong-manager/service-directory-mapping/) using `config.authenticated_groups_claim`.
* Can now see the `created_at` timestamp for consumer credentials.
* Provide a warning when a user's session is about to expire.
* Generate an RBAC token for an administrator rather than letting them set one.
* Plugin forms now have docs links to the [Plugins Hub](/hub/).

#### Kong Developer Portal
* Application Registration can now be configured to use a third-party OAuth provider.

#### Plugins
* [Open ID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added `X-Authenticated-Groups` request header when doing authenticated groups.
  * Added `config.groups_required` and `config.groups_claim`.
  * Added `config.roles_required` and `config.roles_claim`.
  * Added `DELETE :8001/openid-connect/issuers` endpoint (for cache clearing).
  * Added `DELETE :8001/openid-connect/jwks` endpoint (for rotating the jwks).
  * Added Admin API for DB-less (it is a single node only).
  * Added support for `x5t` key lookups.
  * Added support for same `x5t` but different `alg` lookups.
  * Changed that `config.authenticated_groups_claim` is considered even on successful consumer mapping so that it enables dynamic groups, while using consumer mapping. This feature is used with [Mapping Service Directory Groups to Kong Roles](/enterprise/latest/kong-manager/service-directory-mapping/).
  * Changed code to be more resilient on rediscovery errors.
  * Changed `config.rediscovery_lifetime` to default to 30 seconds instead of 300 seconds (5 minutes).
  * Changed plugin to do rediscovery on configuration changes (while still respecting `config.rediscovery_lifetime`).

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Added support to specify JSON types for configuration values. For example, by doing `config.add.json.json_types`: ["number"], the plugin will convert "-1" added JSON values into -1.
  * Improved performance by not inheriting from the BasePlugin class.
  * The plugin is now defensive against possible errors and nil header values.

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Standardize on `allow` instead of `whitelist` to specify the parameter names that should be allowed in request JSON body. Previous `whitelist` nomenclature is deprecated and support will be removed in Kong 3.0.

#### Documentation Updates
  * Plugin examples now include declarative configuration (YAML) information.
  * Upgrade and Migration instructions are updated for migrating from Kong Enterprise 1.5.x to 2.1.x, Kong Community Gateway 1.5 to Kong Enterprise 1.5, and Developer Portal templates.

### Fixes

**Note: Fixes for Kong Enterprise 2.1.3.0 version includes the [2.1.0.0 (beta)](/gateway/changelog/#fixes) fixes.**

#### Kong Manager
* Auto-generated role `workspace-portal-admin` does not display link to Dev Portal Editor.
* Routes form did not expose `path_handling` attribute for adding/editing.
* When Kong Manager is secured with OIDC, new workspaces do not include the auto-generated roles.
* Able to enumerate usernames via the `/admins` endpoint.
* Unable to install Kong Manager outside the root directory.

#### Kong Developer Portal
* The `/developers/:developer/applications` endpoint allowed applications to be created for a developer other than the one in the path.
* The change password endpoint for developers did not require the original password.
* User was not redirected to Login after a session timeout.
* Unable to configure `Accept Http If Already Terminated` for Application Registration plugin. Instead, add both Application Registration and OAuth 2.0 Authentication, and set the config on the Oauth2 Authentication plugin.

#### Plugins

* Collector (`collector`, for Brain and Immunity)
  * Fixed a bug that would make the plugin try to parse request/response body regardless of the content-type.

* [GraphQL Rate Limiting Advance](/hub/kong-inc/graphql-rate-limiting-advanced/)d (`gql-rate-limiting-advanced`)
  * Fixed configuration using transformation that breaks in hybrid mode.

* [gRPC Gateway](/hub/kong-inc/grpc-gateway/) documentation is improved.

* [Kong JWT Signer](/hub/kong-inc/jwt-signer/)
  * Changed PostgreSQL column type for keys in `jwt_signer_jwks` table from JSONB to JSONB[] for a better hybrid compatibility.
  * Changed PostgreSQL column type for previous in `jwt_signer_jwks` table from JSONB to JSONB[] for a better hybrid compatibility.
  * Changed JWKS URIs to return application/jwk-set+json instead of application/json.
  * Remove `run_on` field for 2.1.0.0 compatibility.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Return a 500 when there's an error.
  * Respond with a 401 instead of 403.
  * Case-sensitive groups.
  * Accept AD group names containing spaces.

* [Open ID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed DB-less to reload private key JWTS on each request.
  * Fixed runtime error on two log statements when validating required claims.
  * Changed arguments parser to use Kong PDK for building dynamic redirect URI. Works with Kong `port_maps` configuration.
  * OpenID Connect Library
    * Fixed a small typo in error message.
    * Removed azp claims verification on other tokens than the ID token.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed per service rate limiting.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Improved performance by not inheriting from the `BasePlugin` class.
  * Empty arrays are correctly preserved.
  * Prevent the plugin from throwing an error when its access handler did not get a chance to run (e.g., on short-circuited, unauthorized requests).
  * Standardized on `allow` instead of `whitelist` to specify the parameter names that should be allowed in response JSON body.
  * The plugin is now defensive against possible errors and nil header values.
  * Fixed an issue where the plugin was validating the value in `config.replace.body` against the content type as defined in the Content-Type response header.

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Template errors are properly thrown.

* Updated version compatibility for plugins bundled with Kong Enterprise to 2.1.x.

### Known Issues and Workarounds

**Note: Known issues and workarounds for Kong Enterprise includes [2.1.0.0 (beta)](/gateway/changelog/#known-issues-and-workarounds) known issues and workarounds.**

* The LDAP Authentication and LDAP Authentication Advanced plugins require a workaround to support CLI access with RBAC tokens: [Using Service Directory Mapping on the CLI](/enterprise/2.1.x/kong-manager/authentication/ldap/#using-service-directory-mapping-on-the-cli).

* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin does not support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

* For the [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) plugin, standardize on `allow` instead of `whitelist` to specify the parameter names that should be allowed in request JSON body. Previous `whitelist` nomenclature is deprecated and support will be removed in Kong 3.0.

* Breaking changes

  * When performing upgrade and migration to 2.1.x, custom entities and plugins have breaking changes. See [https://docs.konghq.com/enterprise/2.1.x/deployment/upgrades/custom-changes/](https://docs.konghq.com/enterprise/2.1.x/deployment/upgrades/custom-changes/).

  * `run_on` is removed from plugins, as it has not been used for a long time but compatibility was kept in 1.x. Any plugin with `run_on` will now break because the schema no longer contains that entry. If testing custom plugins against this beta release, update the plugin's schema.lua file and remove the `run_on` field.

  * The [Correlation ID](/hub/kong-inc/correlation-id/) (`correlation-id`) plugin has a higher priority than in CE. This is an incompatible change with CE in case `correlation-id` is configured against a Consumer.

  * The ability to share an entity between Workspaces is no longer supported. The new method requires a copy of the entity to be created in the other Workspaces.


## 2.1.0.0 (beta)
**Release Date** 2020/07/16

### Features

#### Kong Gateway
* Inherited changes from OSS Kong in releases 2.0.x and 2.1.0.
* Workspaces code has been refactored for performance. The feature should work the same for most users.
* TLS version may be specified when using TLS to connect to a PostgreSQL database.

#### Kong Manager
* Open ID Connect (`openid-connect`) can now be used with [Mapping Service Directory Groups to Kong Roles](/enterprise/latest/kong-manager/service-directory-mapping/) using `config.authenticated_groups_claim`.
* Can now see the `created_at` timestamp for consumer credentials.
* Provide a warning when a user's session is about to expire.
* Generate an RBAC token for an administrator rather than letting them set one.
* Plugin forms now have docs links to the [Plugins Hub](/hub/).

#### Kong Developer Portal
* Application Registration can now be configured to use a third-party OAuth provider.

#### Plugins

* Open ID Connect (`openid-connect`)
  * Added `X-Authenticated-Groups` request header when doing authenticated groups.
  * Added `config.groups_required` and `config.groups_claim`.
  * Added `config.roles_required` and `config.roles_claim`.
  * Added `DELETE :8001/openid-connect/issuers` endpoint (for cache clearing).
  * Added `DELETE :8001/openid-connect/jwks` endpoint (for rotating the jwks).
  * Added Admin API for DB-less (it is a single node only).
  * Added support for `x5t` key lookups.
  * Added support for same `x5t` but different `alg` lookups.
  * Changed that `config.authenticated_groups_claim` is considered even on successful consumer mapping so that it enables dynamic groups, while using consumer mapping. This feature is used with [Mapping Service Directory Groups to Kong Roles](/enterprise/latest/kong-manager/service-directory-mapping/).
  * Changed code to be more resilient on rediscovery errors.
  * Changed `config.rediscovery_lifetime` to default to 30 seconds instead of 300 seconds (5 minutes).
  * Changed plugin to do rediscovery on configuration changes (while still respecting `config.rediscovery_lifetime`).

* Response Transformer Advanced (`response-transformer-advanced`)
  * Added support to specify JSON types for configuration values. For example, by doing `config.add.json.json_types`: ["number"], the plugin will convert "-1" added JSON values into -1.
  * Improved performance by not inheriting from the BasePlugin class.
  * The plugin is now defensive against possible errors and nil header values.

### Fixes

#### Kong Manager
* Auto-generated role `workspace-portal-admin` does not display link to Dev Portal Editor.
* Routes form did not expose `path_handling` attribute for adding/editing.
* When Kong Manager is secured with OIDC, new workspaces do not include the auto-generated roles.
* Able to enumerate usernames via the `/admins` endpoint.
* Unable to install Kong Manager outside the root directory.

#### Kong Developer Portal
* The `/developers/:developer/applications` endpoint allowed applications to be created for a developer other than the one in the path.
* The change password endpoint for developers did not require the original password.
* User was not redirected to Login after a session timeout.
* Unable to configure `Accept Http If Already Terminated` for Application Registration plugin. Instead, add both Application Registration and OAuth 2.0 Authentication, and set the config on the Oauth2 Authentication plugin.

#### Plugins

* Response Transformer Advanced (`response-transformer-advanced`)
  * Improved performance by not inheriting from the `BasePlugin` class.
  * Empty arrays are correctly preserved.
  * Prevent the plugin from throwing an error when its access handler did not get a chance to run (e.g., on short-circuited, unauthorized requests).
  * Standardized on `allow` instead of `whitelist` to specify the parameter names that should be allowed in response JSON body.
  * The plugin is now defensive against possible errors and nil header values.
  * Fixed an issue where the plugin was validating the value in `config.replace.body` against the content type as defined in the Content-Type response header.

* Request Transformer Advanced (`request-transformer-advanced`)
  * Template errors are properly thrown.

* Open ID Connect (`openid-connect`)
  * Fixed DB-less to reload private key JWTS on each request.

* Rate Limiting Advanced (`rate-limiting-advanced`)
  * Fixed per service rate limiting.

* LDAP Authentication Advanced (`ldap-auth-advanced`)
  * Return a 500 when there's an error.
  * Respond with a 401 instead of 403.
  * Case-sensitive groups.

* Collector (`collector`, for Brain and Immunity)
  * Fixed a bug that would make the plugin try to parse request/response body regardless of the content-type.

* GraphQL Rate Limiting Advanced (`gql-rate-limiting-advanced`)
  * Fixed configuration using transformation that breaks in hybrid mode.

* Updated for 2.1.0.0 compatibility
  * Proxy Cache Advanced (`proxy-cache-advanced`)
  * Canary (`canary`)
  * Rate Limiting Advanced (`rate-limiting-advanced`)
  * Collector (`collector`)
  * Vault Authentication (`vault-auth`)
  * Mutual TLS Authentication (`mtls-auth`)
  * Route Transformer Advanced(`route-transformer-advanced`)
  * GraphQL Proxy Caching Advanced (`gql-proxy-cache-advanced`)
  * GraphQL Rate Limiting Advanced (`gql-rate-limiting-advanced`)


### Known Issues and Workarounds

* Key Authentication (`key-auth-enc`) does not function in hybrid deployment mode.

* Breaking changes
  * `run_on` is removed from plugins, as it has not been used for a long time but compatibility was kept in 1.x. Any plugin with `run_on` will now break because the schema no longer contains that entry. If testing custom plugins against this beta release, update the plugin's schema.lua file and remove the `run_on` field.

  * The Correlation ID (`correlation-id`) plugin has a higher priority than in CE. This is an incompatible change with CE in case `correlation-id` is configured against a Consumer.

  * The ability to share an entity between Workspaces is no longer supported. The new method requires a copy of the entity to be created in the other Workspaces.

## 1.5.0.11
**Release Date** 2021/04/22

This release includes internal updates that do not affect product functionality.

### Fixes

#### Enterprise
- In Kong Manager, users could receive an empty set of roles from an API response, even when valid RBAC
  roles existed in the database because of a filtering issue with portal and default roles on a paginated set.
  With this fix, if valid RBAC roles exist in the database an API request returns with those valid roles.

## 1.5.0.10
**Release Date** 2021/03/26

### Fixes

#### Core
- Fixed an issue where certain incoming URI may make it possible to bypass security rules applied
on Route objects. This fix make such attacks more difficult by always normalizing the incoming
request's URI before matching against the Router.
- Sanitize path postfix for additional security.

#### Enterprise
- Added pgp signature to Bintray-rpm package of `kong-enterprise`, version 1.5.0.9.
- Added the following updates with backport of bypass security vulnerability:
  - Support for read transformations
  - Support for `X-Forwarded-Prefix`
  - `X-Forwarded-Path` header

#### Developer Portal
- Before, when enabling application registration with key authentication, developers who created
applications were able to see all Services for which the application registration plugin was enabled,
regardless of the permissions granted to their role. With this fix, developers who create applications
will only see Services if the role they are assigned to has been granted permissions to the relevant
specs.

## 1.5.0.9
**Release Date** 2020/12/31

### Fixes

#### Core
-  OpenSSL version bumped to 1.1.1i.
  The OpenSSL version bump is related to CVE-2020-1971. We have performed an extensive review of OpenSSL usage in Kong and have found the following:
  - The core product is not vulnerable to the high severity CVE-2020-1971.
  - The `mtls-auth` plugin had a potential exploit associated with with CVE-2020-1971, but it would require an attacker to control a trusted CA or have admin port access, which [we recommend you block from attackers](https://docs.konghq.com/latest/secure-admin-api/) for numerous reasons. The updated OpenSSL version in this release additionally protects the `mtls-auth` plugin.
  - As a precautionary measure, we have bumped the OpenSSL dependency version to OpenSSL 1.1.1i.

#### Kong Enterprise
- RCE (Remote Code Execution) Plugin Mitigations:
  Several Kong plugins allow arbitrary code execution by design, including the `serverless` plugin (also known as `pre-function` and `post-function` capabilities) and the `exit-transformer` plugin (for example, allows an administrator to configure a Lua-based response transformation). Changes include:
  - A new change in this release locks down these plugins so that they have limited functions available in a sandbox, providing significant additional security for a user with an exposed admin port.
  - Functions such as "require" are no longer available to scripts that run in these plugins for security purposes, because allowing "require" allows embedded additional arbitrary code execution.
  - **Important**: This change causes a **breaking change** in this patch release and it cannot be avoided. Our recommendation is that [users lock down their admin ports](https://docs.konghq.com/latest/secure-admin-api/) to avoid attackers trying to exploit any API gateway, like Kong, to gain access to internal networks. If you need the previous release behavior, including the ability to arbitrarily "require" libraries or if you want to lock things down further, we have introduced three new settings you can use:
    - `KONG_UNTRUSTED_LUA = off | sandbox | on` Sets whether any custom Lua code can be used outside of Kong's distributed code. Defaults to "sandbox".
    - `KONG_UNTRUSTED_LUA_SANDBOX_REQUIRES = foo,bar` Which libraries, if any, you want to require in the sandbox. Defaults to an empty list.
    - `KONG_UNTRUSTED_LUA_SANDBOX_ENVIRONMENT = kong.request` Any additional objects you want to pass through to the sandbox environments.  Defaults to an empty list.

    For detailed information about these new properties, see the [property reference documentation](https://docs.konghq.com/enterprise/2.3.x/property-reference/#untrusted_lua).

#### Breaking Changes
- See *RCE (Remote Code Execution) Plugin Mitigations* in the Kong Enterprise section.


## 1.5.0.8
**Release Date** 2020/11/17

### Fixes

#### **OpenID Connect Library**
  - Changed to disable HS-signature verification by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Fixes vulnerability in the OpenID Connect and JWT Signer Plugins. Login to the [Kong Enterprise Support Portal](https://support.konghq.com/support/s/) for [OIDC advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-OIDC-Plugin) and [JWT advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-JWT-Signer-Plugin) details.


## 1.5.0.7
**Release Date** 2020/11/11

### Fixes

#### Kong Gateway

* Fixed PUT request issue causing unique violation error for workspaces.
* Improved cache warmup performance for reduced database calls.
* Added migration to create TTL indices.

#### Kong Manager

* Fixed broken link to docs and updated text on Dev Portals page.

#### Developer Portal

* Fixed issue to allow users to delete developers.

#### Dependencies

* Updated lua-resty-openssl version to 0.6.8.

#### Plugins

* Added ability to preserve empty arrays correctly.


## 1.5.0.6
**Release Date** 2020/10/01

### Features

#### Kong Gateway

* Allow PostgreSQL keepalive time to be configurable.

#### Kong Manager

* Added path to service on display page.

#### Plugins

* Rate Limiting Advanced (`rate-limiting-advanced`)
  * Added RateLimit headers for draft Request for Comments (RFC).

### Fixes

#### Kong Gateway

* Fixed propagation of posted health check across Nginx workers.

#### Plugins

* Collector (`collector`, for Brain and Immunity)
  * Fixed bug caused when trying to call `select_all`.
  * Fixed bug caused when trying to read a request body when parsing was unknown.
  * Fixed bug caused when using the `basic_serializer` in the access stage.

* Request Validator (`request-validator`)
  * Upgraded `lua-resty-ljsonschema` library to v1.1.0.

## 1.5.0.5
**Release Date** 2020/08/13

### Fixes

#### Kong Gateway
* Optimized Admin API requests when a large number of entities are in the system and RBAC is enabled.
* Improved Kong handling of the encoding of sparce arrays

#### Kong Manager
* Fixed the creation of default roles and permissions when a new Workspace is created.

#### Developer Portal
* Fixed the creation of pages, partials, and specs in the legacy Developer Portal.
* Fixed Catalog updates in the Developer Portal when a spec is deleted.
* Fixed an issue when updating a spec in the legacy Developer Portal.

#### Plugins
* Request Validator
  * Requires a top-level `type` parameter for jsonschema
  * Bumped version to 1.0.0

## 1.5.0.4
**Release Date** 2020/06/26

### Fixes

#### Kong Gateway
* Upgraded PostgreSQL driver to support selecting the TLS version when connecting to Postgres.
* Fixed issue causing incorrect `service_count` for license report endpoint.

#### Kong Manager
* Exposed Routes `path_handling` attribute from the Admin API in Kong Manager.

#### Plugins
* OpenID Connect
  * Fixed Consumers to call the correct function when setting an anonymous Consumer (introduced with 1.5.0).
  * Fixed unauthorized responses giving 403 instead of 401 as a status code (introduced with 1.5.0).

* Collector
  * Fixed issue that occurred when Kong returned a 404 and caused logs to fill with messages.


## 1.5.0.3
**Release Date** 2020/05/28

### Fixes

#### Kong Gateway
* Fixed window counters issue caused when multiple sets of Redis cluster addresses are configured across multiple rate-limiting-advanced plugins
* Fixed an issue where authentication plugins could not load legacy and empty `config.anonymous` strings from the database
* Reduced the log level of one line in the Balancer code from `ERROR` to `WARN`

#### Kong Manager
* Included a reference to Kong's EULA in Kong Manager

#### Plugins
* Forward Proxy Advanced
  * Fixed a runtime error caused by moving Vitals to the log phase

* Mutual TLS Authentication
  * Fixed issue to correctly skip verification when mode is `IGNORE_CA_ERROR`

* OpenID Connect
  * Added support for Redis Clusters for session storage
  * Added `config.session_redis_connect_timeout`
  * Added `config.session_redis_read_timeout`
  * Added `config.session_redis_send_timeout`
  * Added `config.session_redis_ssl`
  * Added `config.session_redis_ssl_verify`
  * Added `config.session_redis_server_name`
  * Added `config.session_redis_cluster_nodes`
  * Added `config.session_redis_cluster_maxredirections`
  * Added `config.preserve_query_args`
  * Added `config.introspection_headers_client`
  * Chore cookie removal function to be more robust
  * Changed `config.verify_parameters` default parameter from `true` to `false`
  * Bumped `lua-resty-session` dependency to 3.5
  * Changed in issuer normalization that also removes standard OAuth 2.0 Authorization Server Metadata suffix from issuer
  * Refactored code base for easier maintenance
  * openid-connect library
    * Added support for same kid but different `alg` lookups
    * Added support for OAuth 2.0 Authorization Server Metadata (rfc8414)

* Request Validator
  * Fixed support for numeric keys

* Auth plugins
  * Fixed support for setting `anonymous=""`

## 1.5.0.2
**Release Date** 2020/04/28

### Fixes

#### Kong Gateway Community
* Fixed an issue where the frequent Target CRUD could result in a broken load balancer

#### Kong Manager
* Fixed the sorting order of Routes.
* Fixed an issue where editing a Developer meta field could cause the custom field name to revert to the default value
* Fixed an issue where listing Developers and Files only showed the first page of results

## 1.5.0.1
**Release Date:** 2020/04/16

### Fixes

#### Plugins
* Kong OpenID Connect Library
  * Changes  `client_secret_jwk ` and  `private_key_jwt ` to not pass the rfc7521 optional  `client_id ` as it was causing a problem with Okta
* OpenID Connect
  * Fixes `openid_connect/jwks` to not use `err_t` with JWKS custom DAO that is not returning the `err_t`
  * Fixes JWKS custom DAO to not return cache hit level as a third return value on errors. Previously, it was sometimes inaccurately treated as `err_t`
  * Adds a teardown migration to create the `oic_jwks` row, so that it is not needed to create on init_worker
* Request Transformer Advanced
  * Fixes bug when adding a header with the same name as a removed one
  * Improves performance by not inheriting from the BasePlugin class
  * Converts the plugin away from deprecated functions

## 1.5.0.0
**Release Date:** 2020/04/09

### Features

#### Kong Gateway Community

* Includes open-source features contained in Kong Gateway Community 1.4 and 1.5 releases, with the exception that Kong Enterprise does not support running on ARM processors at this time

#### Kong Manager
* Redesigned Service and Route pages to support Immunity Alerts
* Services, Routes, Consumers, and other entity lists are sortable
* Services, Routes, Consumers, and other entities can be viewed and exported as JSON
* Consumer Alerts added to the Immunity Alerts page
* Approve, reject, and revoke Portal Application Service Contracts
* Associate Portal Specs with Services through Documents

#### Kong Developer Portal
* [**BETA**](https://docs.konghq.com/enterprise/latest/introduction/key-concepts/#beta): Developers can create Applications to consume Services using the Portal Application Registration plugin

#### Plugins
* Kong OpenID Connect Library
  * Add support for `client_secret_jwt` and `private_key_jwt`
* OpenID Connect
  * Add support for dynamic login redirect uri
  * Add support for `config.session_strategy` configuration parameter
  * Add support for `session_cookie_idletime` configuration parameter
  * Make consumer cache keys generated similarly as in JWT Signer plugin
  * Add support for `client_secret_jwt` and `private_key_jwt` authentication
  * Add `config.client_auth`
  * Add `config.client_alg`
  * Add `config.client_jwk`
  * Add `config.introspection_endpoint_auth_method`
  * Add `config.revocation_endpoint_auth_method`
  * Add `config.display_errors`
  * Change `config.token_endpoint_auth_method` to include `client_secret_jwt` and `private_key_jwt`
  * Add support for `cookie` for `config.bearer_token_param_type`
  * Add support for `config.bearer_token_cookie_name`
* JWT Signer
  * Add support for more signing algorithms: HS256, HS384, HS512, RS512, ES256, ES384, ES512, PS256, PS384, PS512, EdDSA
* IP Restriction
    * Supports IPv6 addresses
* MTLS Auth
    * Support for OCSP
    * Support for CRL
* Collector
    * Rewritten to follow more modern plugin approaches
    * Added functionality to power Consumer Alerts
* Kafka Log
    * Support for API version of a produce request
* [**BETA**](https://docs.konghq.com/enterprise/latest/introduction/key-concepts/#beta) Portal Application Registration
    * Allow Portal Applications to request access and consume Services
* Serverless functions
    * Add the ability to run functions in each request phase
* Upstream TLS
    * The Upstream TLS plugin is not available in the Kong Enterprise 1.5.x release and is not supported. This plugin was deprecated in Kong Enterprise 1.3.0.0 and is only functional with Kong Enterprise versions 0.35 and 0.36. Be sure to remove this plugin before upgrading to the 1.5.x release to avoid errors or issues with your upgrade

### Fixes
#### Kong Gateway
* Fixes a bug where entities loaded through cache warmup did not include Workspace properly
* Fixes a bug that could prevent a `ca_certificate` from being saved if it was more than 2713 bytes
* Fixes a bug where a route collision was not detected when the content type of a POST request was sent as `application/x-www-form-urlencoded`
* Fixes a bug where a route collision was not detected when a PATCH request was sent to the `/services/service_id/routes/route_id` endpoint
* Added headers and `snis` route collision detection capabilities
* Fixes an inconsistency where it was still possible to execute `db_export` despite it not being supported in Kong Enterprise

#### Kong Manager
* Fixes a bug that prevented updating a Service with a tag
* Fixes a bug in file permission on kconfig.js
* Fixes a bug configuring the OpenID Connect plugin
* Fixes a bug when resetting the password of an admin that is not in the default Workspace
* Fixes a bug where the Response Rate Limiting plugin could not be applied to a consumer

#### Kong Developer Portal
* Improve caching of Developers when accessing proxy via Developer Credentials
* Fixes a bug with a redirect on logout
* Fixes a bug when redirecting to login from a spec in a non-default workspace
* Fixes a bug with account verification links in Portals using sub-domains
* Fixes a bug with validation of * value for `portal_cors_origins` in Workspace config
* Fixes various styling issues

#### Plugins
* Kong OpenID Connect Library
  * **IMPORTANT** Fix standard claims verification issue where the access token was only checked for `iss` and `exp`, but not the other optional checks
  * Change `string.sub` to `string.byte` to lessen the garbage generation
  * Change `jwks` as there is no need to pass length argument to `ecc.point` or `ecc.scalar` functions anymore
  * Make `iss` and `exp` claims on access token validate only when specified
* OpenID Connect
  * Fixes cluster invalidate consumer cache
  * Fixes pcall kong.configuration to handle command-line invocations
  * Optimize consumer cache key invalidations
  * Unified session handling code in a single place
  * Make the code more robust by checking the right data types
  * Fixes issue when bearer `auth_method` was disabled that it was not disabled if introspection was enabled
  * Bump `lua-resty-session` dependency to 3.1
* JWT Signer
  * Fixes consumer invalidation so that it now happens cluster wide, reverting the change made in 1.0.2
  * Change the plugin so that it does not inherit anymore from BasePlugin
  * Fixes a problem with RSA signature truncation in some edge case reported by a customer
  * Updated lua-resty-nettle version to address jwt-signer plugin issue
* Logging plugins will strip `authorization` header
* CorrelationID
  * Raise the priority of the plugin so it is run first on a request
* Request Terminator
  * Do not send a `Content-Length` header with a 204 response

### Known Issue and Workaround
* Mutual TLS Authentication Plugin
  * For the parameter `config.revocation_check_mode`, the default value `IGNORE_CA_ERROR` has a known issue in version 1.5.0.0 and later. As a workaround, manually set the value to `SKIP`


## 1.3.0.3
**Release Date:** 2020/11/19

### Fixes

#### **OpenID Connect Library**
  - Changed to disable HS-signature verification by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Fixes vulnerability in the OpenID Connect and JWT Signer Plugins. Login to the [Kong Enterprise Support Portal](https://support.konghq.com/support/s/) for [OIDC advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-OIDC-Plugin) and [JWT advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-JWT-Signer-Plugin) details.

## 1.3.0.2
**Release Date:** 2020/02/20

### Features

#### Kong Gateway

* Adds support for Amazon Linux 2
* Compiles NGINX OpenTracing module with Kong (currently only available for Amazon Linux 2 and Docker Alpine)
  * Includes a Datadog tracer for Amazon Linux 2 at /usr/local/kong/lib/libdd_opentracing_plugin.so
  * Includes a Jaeger tracer for Docker Alpine at /usr/local/kong/lib/libjaegertracing.so
* Provides a default logrotate configuration file
* Adds support for `pg_ssl_required` configuration which prevents connection to non-SSL enabled PostgreSQL server
* Adds support for regular expressions when using `audit_log_ignore_paths`
* Allows the Kong Enterprise systemd service to be reloaded with systemctl reload kong-enterprise-edition

#### Kong Manager

* Kafka plugins can now be configured

#### **Plugins**

* OpenID Connect
    * Fixes header encoding to use Base64 (non-URL variant) with padding
    * Adds support for keyring encryption of `client_id` and `client_secret`
    * Adds support for None with `config.session_cookie_samesite` and `config.authorization_cookie_samesite`
    * Adds support for `config.session_cookie_maxsize`
    * Bumps `lua-resty-session` dependency to 2.26
* Rate Limiting Advanced
    * Adds support for authentication when using Redis Sentinel node
* Response Transformer Advanced
    * Adds support for removal of specific header values of a given header field, including with regular expression
* Request Validator
    * Adds configuration to plugin which allows it to return validation error back to the client as part of request response
* AWS Lambda
    * Additional AWS regions support

### Fixes

#### Kong Gateway

* Fixes a condition that could put a target of an upstream into an improper `DNS_ERROR` state
* Resolves a problem when using routes with custom header based routing that could lead to incorrect route matching
* Improves `LUA_CPATH` handling
* Improves behavior and log messages when rate-limiting counter shared dict is out of space
* Resolves possible database deadlock situation when under high load conditions
* Resolves possible race condition on Cassandra when under high load of Admin API CRUD operations

#### Kong Developer Portal

* Fixes a bug that could lead to a stack overflow in certain conditions

#### Kong Manager

* Fixes incorrect schema violation error `claims_to_verify` when entering configuration for JWT plugin
* Kong and Kong Manager now start correctly from a custom prefix

#### Plugins

* Mutual TLS Authentication
    * Bug fixes related to configuration and ACL plugin usage
* OpenAPI2Kong
    * Fixes a bug related to garbage collection
* Proxy Caching Advanced
    * Fixes to allow Kong to properly cache responses when requests are passed through an additional NGINX before reaching Kong

## 1.3.0.1
**Release Date:** 2019/12/19

### Features

* Kong Enterprise now officially supports RHEL 8
* Kong Enterprise now has a License Reports module for customers to view current usage metrics. For more information, contact your Kong Account Executive.
* (Alpha feature) Kong Enterprise can now perform encryption-at-rest for sensitive fields within the data store (PostgreSQL or Cassandra).

#### Kong Developer Portal

* Adds ability to customize the email templates used by the Kong Developer Portal
* Portal-CLI
    * Adds more robust support for Windows
    * Adds command line support for optional arguments to override the CLI configuration file

#### Kong Manager

* RBAC token control: A new property `rbac_token_enabled` on an Admin allows you to control whether that Admin can use and reset their RBAC token. When it is true, the Admin can log in to Kong Manager and can use their RBAC token on the Admin API. When it is false, the Admin can only use the Admin API in conjunction with a valid session.

#### Plugins

* OpenAPI2Kong
    - Adds trace to errors to identify the originating YAML/JSON element that caused the error.
* Key Authentication - Encrypted
    - Provides key authentication for Routes and Services, with authentication tokens stored in a format that is encrypted at rest.


### Changes

* Removes the openapi2kong API endpoint

#### Kong Manager

* Adds icons for new Plugins
* Adds ability for read-only admins to view plugin configurations

### Fixes

* Fixes issue where settings in the kong configuration file did not always update `.kong_env `
* Fixes issue where updating a plugin with a similar payload as its initial configuration resulted in a schema violation
* Fixes issue where `db_import` would fail due to missing libraries

#### Kong Developer Portal

* Fixes various spec formatting issues
* Fixes issue where URLs were rendering incorrectly in code snippets
* Fixes issue where numeric keys were incorrectly parsed in yaml spec files
* Fixes issue where certain Swagger paths erred when header parameters were included
* Fixes issue where code snippets ignored JSON
* Fixes issue where Admins could not create new `portal.conf.yaml` or `router.conf.yaml` files from the Editor
* Portal-CLI
    * Fixes issue where `deploy` did not remove files remotely that had been removed locally

#### Kong Manager

* Fixes issue where breadcrumbs for Routes and Services showed the `uuid` instead of the name
* Fixes issue where the JWT plugin did not include `RS512` in the list of supported algorithms
* Fixes issue where users with no role saw a blank page on the “Dev Portals” tab
* Fixes issue where Service Map did not show the correct line colors indicating traffic time
* Fixes issue where Service Map showed incorrect placeholder text for selecting a Workspace
* Fixes issue where viewing an RBAC user in Workspace redirected to a blank page
* Fixes issue where registration links would not generate if RBAC was disabled
* Fixes issue where resetting a password did not enforce password complexity rules
* Fixes issue where LDAP Auth would not accept CamelCase in group names
* Fixes issue where `Average Error Rate` was incorrectly displayed on the Workspace Overview
* Fixes issue where schemas and validation endpoints were not scoped correctly to Workspaces, resulting in incorrectly denying users permission to certain resources. Roles that allow Create and Update on an entity must include Read permission on the schema and validation endpoints for that entity.
* Fixes formatting issue where Dev Portal URLs would overflow their containers on the Dev Portal Overview page

#### Plugins

* AWS Lambda
    * Fixes issue where Kong Enterprise did not package the AWS Lambda plugin with IAM Role support (versions less than 3.0.1). Now Kong Enterprise packages the latest version of the plugin, 3.0.1.
* JWT
    * Fixes schema issue where colons in string values were incorrectly parsed
* OpenAPI2Kong
    * Fixes unsupported OAuth 2.0 security flows to handle an array instead of an object
    * Fixes issue where an array was added to empty routes, this fix will improve compatibility with decK
    * Fixes issue that incorrectly added `body-validation`
* Request Validator
    * Fixes size limitation on the number of validation rules
* MTLS Authentication
    * Fixes issue where disabled `mtls-auth` plugins were not correctly ignored while creating SNIs map

## 1.3
**Release Date:** 2019/11/05

### Kong Gateway
- **Kong Enterprise 1.3** inherits the following changes from **Kong Gateway 1.3**:

### Changes

#### Dependencies

- The required OpenResty version has been bumped to
  [1.15.8.1](http://openresty.org/en/changelog-1015008.html). If you are
  installing Kong from one of our distribution packages, you are not affected
  by this change. See [#4382](https://github.com/Kong/kong/pull/4382).
  With this new version comes a number of improvements:
  * The new [ngx\_http\_grpc\_module](https://nginx.org/en/docs/http/ngx_http_grpc_module.html).
  * Configurable of upstream keepalive connections by timeout or number of
    requests.
  * Support for ARM64 architectures.
  * LuaJIT GC64 mode for x86_64 architectures, raising the LuaJIT GC-managed
    memory limit from 2GB to 128TB and producing more predictable GC
    performance.
- From this version on, the new
  [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module) Nginx
  module is **required** to be built into OpenResty for Kong to function
  properly. This new module allows Kong to support new features such as mutual
  TLS authentication. If you are installing Kong from one of our distribution
  packages, you are not affected by this change.
  [openresty-build-tools#26](https://github.com/Kong/openresty-build-tools/pull/26)

**Note:** if you are not using one of our distribution packages and compiling
OpenResty from source, you must still apply Kong's [OpenResty
patches](https://github.com/kong/openresty-patches) (and, as highlighted above,
compile OpenResty with the new lua-kong-nginx-module). Our new
[openresty-build-tools](https://github.com/Kong/openresty-build-tools)
repository will allow you to do both easily.

#### Core

- Bug fixes in the router *may, in some edge-cases*, result in
  different Routes being matched. It was reported to us that the router behaved
  incorrectly in some cases when configuring wildcard Hosts and regex paths
  (e.g. [#3094](https://github.com/Kong/kong/issues/3094)). It may be so that
  you are subject to these bugs without realizing it. Please ensure that
  wildcard Hosts and regex paths Routes you have configured are matching as
  expected before upgrading.
  See [9ca4dc0](https://github.com/Kong/kong/commit/9ca4dc09fdb12b340531be8e0f9d1560c48664d5),
  [2683b86](https://github.com/Kong/kong/commit/2683b86c2f7680238e3fe85da224d6f077e3425d), and
  [6a03e1b](https://github.com/Kong/kong/commit/6a03e1bd95594716167ccac840ff3e892ed66215)
  for details.
- Upstream connections are now only kept-alive for 100 requests or 60 seconds
  (idle) by default. Previously, upstream connections were not actively closed
  by Kong. This is a (non-breaking) change in behavior, inherited from Nginx
  1.15, and configurable via new configuration properties (see below).

#### Configuration

- The `upstream_keepalive` configuration property is deprecated, and
  replaced by the new `nginx_http_upstream_keepalive` property. Its behavior is
  almost identical, but the notable difference is that the latter leverages the
  [injected Nginx
  directives](https://konghq.com/blog/kong-ce-nginx-injected-directives)
  feature added in Kong 0.14.0.
  In future releases, we will gradually increase support for injected Nginx
  directives. We have high hopes that this will remove the occasional need for
  custom Nginx configuration templates.
  [#4382](https://github.com/Kong/kong/pull/4382)

### Additions

#### Core

- **Native gRPC proxying.** Two new protocol types; `grpc` and
  `grpcs` correspond to gRPC over h2c and gRPC over h2. They can be specified
  on a Route or a Service's `protocol` attribute (e.g. `protocol = grpcs`).
  When an incoming HTTP/2 request matches a Route with a `grpc(s)` protocol,
  the request will be handled by the
  [ngx\_http\_grpc\_module](https://nginx.org/en/docs/http/ngx_http_grpc_module.html),
  and proxied to the upstream Service according to the gRPC protocol
  specifications. Not all Kong plugins are compatible with
  gRPC requests yet.  [#4801](https://github.com/Kong/kong/pull/4801)
- **Mutual TLS** handshake with upstream services. The Service
  entity now has a new `client_certificate` attribute, which is a foreign key
  to a Certificate entity. If specified, Kong will use the Certificate as a
  client TLS cert during the upstream TLS handshake.
  [#4800](https://github.com/Kong/kong/pull/4800)
- **Route by any request header**. The router now has the ability
  to match Routes by any request header (not only `Host`). The Route entity now
  has a new `headers` attribute, which is a map of headers names and values.
  E.g. `{ "X-Forwarded-Host": ["example.org"], "Version": ["2", "3"] }`.
  [#4758](https://github.com/Kong/kong/pull/4758)
- **Least-connection load-balancing**. A new `algorithm` attribute
  has been added to the Upstream entity. It can be set to `"round-robin"`
  (default), `"consistent-hashing"`, or `"least-connections"`.
  [#4528](https://github.com/Kong/kong/pull/4528)
- Healthchecks now use the combination of IP + Port + Hostname when storing
  upstream health information. Previously, only IP + Port were used. This means
  that different virtual hosts served behind the same IP/port will be treated
  differently with regards to their health status. New endpoints were added to
  the Admin API to manually set a Target's health status.
  [#4792](https://github.com/Kong/kong/pull/4792)

#### Configuration

- A new section in the `kong.conf` file describes [injected Nginx
  directives](https://konghq.com/blog/kong-ce-nginx-injected-directives)
  (added to Kong 0.14.0) and specifies a few default ones.
  In future releases, we will gradually increase support for injected Nginx
  directives. We have high hopes that this will remove the occasional need for
  custom Nginx configuration templates.
  [#4382](https://github.com/Kong/kong/pull/4382)
- New configuration properties allow for controlling the behavior of
  upstream keepalive connections. `nginx_http_upstream_keepalive_requests` and
  `nginx_http_upstream_keepalive_timeout` respectively control the maximum
  number of proxied requests and idle timeout of an upstream connection.
  [#4382](https://github.com/Kong/kong/pull/4382)
- New flags have been added to the `*_listen` properties: `deferred`, `bind`,
  and `reuseport`.
  [#4692](https://github.com/Kong/kong/pull/4692)

#### Admin API

- Many endpoints now support more levels of nesting for ease of access.
  For example: `/services/:services/routes/:routes` is now a valid API
  endpoint.
  [#4713](https://github.com/Kong/kong/pull/4713)
- The API now accepts `form-urlencoded` payloads with deeply nested data
  structures. Previously, it was only possible to send such data structures
  via JSON payloads.
  [#4768](https://github.com/Kong/kong/pull/4768)

#### Plugins

- jwt-auth: The new `header_names` property accepts an array of header names
  the JWT plugin should inspect when authenticating a request. It defaults to
  `["Authorization"]`.
  [#4757](https://github.com/Kong/kong/pull/4757)
- [azure-functions](https://github.com/Kong/kong-plugin-azure-functions):
  Bumped to 0.4 for minor fixes and performance improvements.
- kubernetes-sidecar-injector:
  The plugin is now more resilient to Kubernetes schema changes. Note that it is
  now deprecated, and that Kong recommends using kuma.io instead.
- [serverless-functions](https://github.com/Kong/kong-plugin-serverless-functions):
    - Bumped to 0.3 for minor performance improvements.
    - Functions can now have upvalues.
- [prometheus](https://github.com/Kong/kong-plugin-prometheus): Bumped to
  0.4.1 for minor performance improvements.
- cors: add OPTIONS, TRACE and CONNECT to default allowed methods
  [#4899](https://github.com/Kong/kong/pull/4899)
  Thanks to [@eshepelyuk](https://github.com/eshepelyuk) for the patch!
- upstream-tls: The Upstream TLS plugin is deprecated as of Kong Enterprise 1.3.0.0 and is only functional with Kong Enterprise versions 0.35 and 0.36. Be sure to remove this plugin before upgrading to the 1.5.x release to avoid errors or issues with your upgrade, as the plugin will no longer be supported.

#### PDK

- New function `kong.service.set_tls_cert_key()`. This functions sets the
  client TLS certificate used while handshaking with the upstream service.
  [#4797](https://github.com/Kong/kong/pull/4797)

### Fixes

#### Core

- Router: Fixed a bug causing invalid matches when configuring two or more
  Routes with a plain `hosts` attribute shadowing another Route's wildcard
  `hosts` attribute. Details of the issue can be seen in
  [01b1cb8](https://github.com/Kong/kong/pull/4775/commits/01b1cb871b1d84e5e93c5605665b68c2f38f5a31).
  [#4775](https://github.com/Kong/kong/pull/4775)
- Router: Ensure regex paths always have priority over plain paths. Details of
  the issue can be seen in
  [2683b86](https://github.com/Kong/kong/commit/2683b86c2f7680238e3fe85da224d6f077e3425d).
  [#4775](https://github.com/Kong/kong/pull/4775)
- Cleanup of expired rows in PostgreSQL is now much more efficient thanks to a
  new query plan.
  [#4716](https://github.com/Kong/kong/pull/4716)
- Improved various query plans against Cassandra instances by increasing the
  default page size.
  [#4770](https://github.com/Kong/kong/pull/4770)

#### Plugins

- cors: ensure non-preflight OPTIONS requests can be proxied.
  [#4899](https://github.com/Kong/kong/pull/4899)
  Thanks to [@eshepelyuk](https://github.com/eshepelyuk) for the patch!
- Consumer references in various plugin entities are now
  properly marked as required, avoiding credentials that map to no Consumer.
  [#4879](https://github.com/Kong/kong/pull/4879)
- hmac-auth: Correct the encoding of HTTP/1.0 requests.
  [#4839](https://github.com/Kong/kong/pull/4839)
- oauth2: empty client_id wasn't checked, causing a server error.
  [#4884](https://github.com/Kong/kong/pull/4884)
- response-transformer: preserve empty arrays correctly.
  [#4901](https://github.com/Kong/kong/pull/4901)

#### CLI

- Fixed an issue when running `kong restart` and Kong was not running,
  causing stdout/stderr logging to turn off.
  [#4772](https://github.com/Kong/kong/pull/4772)

#### Admin API

- Ensure PUT works correctly when applied to plugin configurations.
  [#4882](https://github.com/Kong/kong/pull/4882)

#### PDK

- Prevent PDK calls from failing in custom content blocks.
  This fixes a misbehavior affecting the Prometheus plugin.
  [#4904](https://github.com/Kong/kong/pull/4904)
- Ensure `kong.response.add_header` works in the `rewrite` phase.
  [#4888](https://github.com/Kong/kong/pull/4888)

### Enterprise-Exclusives

#### Changes

- Kong Service Mesh is transitioned and upgraded to our next-generation service mesh offering named “Kuma”. Go to kuma.io for more information about using Kuma.
- Phone home logging now uses a new shared dict: lua_shared_dict kong_reports_workspaces 1m;  If you use a custom nginx template, make sure it's there if you use phl.
- To configure Upstream TLS, use the NGINX directives [`proxy_ssl_trusted_certificate`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate), [`proxy_ssl_verify`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify), and [`proxy_ssl_verify_depth`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify_depth) instead of the Upstream TLS plugin. The plugin is only functional for versions 0.35 and 0.36.

### Features

- (Alpha feature) Kong Enterprise now has a License Reports module for customers to view current usage metrics. For more information, contact your Kong Account Executive.

#### Kong Enterprise Gateway

- gRPC support

- Upstream mTLS support (API-only)

- DB-export (API-only)

- Routing by header

- Cassandra - refresh cluster topology

- RPM packages are now signed with our own GPG keys. You can download our public key at https://bintray.com/user/downloadSubjectPublicKey?username=kong

- Route validation strategy now configurable and can enforce a route pattern by configuration

- OpenID Connect Library:
    - Add support for ES256 signing and key generation
    - Add support for ES384 signing and key generation
    - Add support for ES512 signing and key generation
    - Add support for PS256 signing and key generation
    - Add support for PS384 signing and key generation
    - Add support for PS512 signing and key generation
    - Add support for EdDSA signing, key generation and verification
    - Update `lua-resty-nettle` dependency to 1.0

#### Docker

- Improved security by allowing the CentOS and Alpine images to run as the `kong` user.

#### Kong Manager

- RBAC User Management (manage Admin API access within Kong Manager)

- Service Directory Group to Kong Role Mapping (map AD groups or other service directory systems to roles & permission sets within Kong)

- Service Map

  - View requests flowing through Kong
  - View Immunity notifications within Service Map, click to alert section

- Immunity alert management & detail section

  - Filterable by entity, severity
  - Links through to alerted entities

- Admin Password Strength Configuration
  - Configure and enforce strong Admin passwords
- Admin Login Attempts
  - Configure allowed login attempts to the Kong Manager

#### Dev Portal

- Easy theming within Kong Manager

  - Easily set your color scheme, logo/branding, and go

- Developer Permissions

  - Decide what specs or content different sets of developers can access.

- Separation of templates and user content

  - Enable content editors to make changes with no coding required
  - Easier future release/upgrades path

- Flat file system

  - Full access to JS/assets, customers can load a single page app, or serverside rendered portal we offer out of the box

- Full serverside rendering

  - No need to hit the API via ajax for additional information in relationship to Kong, templating data object allows access to Kong data directly at load

  - Enables more extensive caching of pages/assets

- Declarative configuration out of the box

  - Allows for more UI integrations

  - Conf files allow for source controlled configuration of your dev portal, including

    - Routing

    - Auth config

    - Permissions

    - Theming (colors, logos, meta info)

- Developer Password Strength Configuration
    - Configure and enforce strong Developer passwords

- Developer Login Attempts
    - Configure allowed login attempts to the Developer Portal

#### Plugins

- gRPC support, API & Kong Manager

- Upstream mTLS support

- DB export, API-only

- Routing by header

- Request Size Limiting - enhanced units on size limit
- Request Transformer Advanced - Support for filtering JSON body with new configuration `config.whitelist.body`
- Response Transformer Advanced:
    - Support for filtering JSON body with new configuration config.whitelist.body, Support arbitrary transformations via Lua functions
    - Fixes a bug where the plugin was returning an empty body in the response for status codes outside of those specified in `config.replace.if_status`. For example, if we specified a `config.replace.if_status=404` and a body `config.replace.body=test` and the status code was 200, the response would be empty.

- Route Transformer Advanced - New
- GraphQL Proxy Cache Advanced - New
- GraphQL Rate Limiting Advanced - New
- Degraphql - New
- Exit Transformer - New
- Kafka Log - New
- Kafka Upstream - New
- mTLS Auth:
    - Update cert request logic ask client cert when:
      - To every route irrespective of workspace when plugin enabled in global scope
      - To every route irrespective of workspace when plugin applied at service level but not all its routes have SNIs set
      - To every route irrespective of workspace when plugin applied at route level but SNIs not set on route
      - To specific route only when plugin applied at route level and it has SNIs set
    - skip_consumer_lookup config to skip consumer lookup if request has trusted client certificate.
    - authenticated_group_by config to block/allow validated certificate using ACL plugin
- Key-Auth keys now support a ttl property and can expire
- AWS Lambda plugin supports IAM roles
- Session plugin can now store authenticated groups from other authentication plugins. 

#### CLI
- Adds runner

### Fixes

#### Plugins

##### OpenID Connect

- Fixes issue when discovery did not return issuer information (against OpenID Connect specification), and which could lead to 500 error on 401 and 403 responses.

##### LDAP Auth Advanced

- LDAP Auth Advanced - fixed issue where plugin tries to start a secure connection on an existing pooled connection from previous requests

##### Request Transformer Advanced

- Fixes a bug where the plugin was returning an empty body in the response for status codes outside of those specified in `config.replace.if_status`. For example, if we specified a `config.replace.if_status=404` and a body `config.replace.body=test` and the status code was 200, the response would be empty.

#### Kong Enterprise Gateway

- Fixes: audit log entries did not include timestamps indicating when the event occurred.
- Fixes: allow put requests to nonexistent foreign entities.
- Fixes: granular tracing did not work when certain plugins (for example, the key-auth) were used.

#### Docker

- Fixes: centos and alpine images did not work on some OpenShift setups with relaxed anyuid SCC settings.


## 0.36-7
**Release Date** 2020/11/20

### Fixes

#### **OpenID Connect Library**
  - Changed to disable HS-signature verification by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Fixes vulnerability in the OpenID Connect and JWT Signer Plugins. Login to the [Kong Enterprise Support Portal](https://support.konghq.com/support/s/) for [OIDC advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-OIDC-Plugin) and [JWT advisory](https://support.konghq.com/support/s/article/Kong-Security-Advisory-JWT-Signer-Plugin) details.

## 0.36-6

**Release Date:** 2020-06-18

### Fixes
- Fixes Kong PDK `get_method()` function to return a correct HTTP method when there are connectivity issues with the Upstream.
- Reverted Service Mesh changes which affect `proxy_ssl_*` directives.


## 0.36-5

**Release Date:** 2020-04-02

### Fixes
- Fixes an issue with jwt-signer plugin that requires only lua-resty-nettle update.


## 0.36-4

**Release Date:** 2019/12/12

### Fixes

- `migrate-community-to-enterprise` script changed from batch query execution to multiple single queries
for Cassandra strategy.
- Fixes Workspace counters calculation logic when you run `migrate-community-to-enterprise` script.
- Fixes DAO fetching functionality to fetch all requested records from the database instead of first `1000`
records that was before.
- Updated Nettle version from `3.4.1` to `3.5.1` which is required by the plugins that use `OIDC` library to work properly.
- Fixes an issue where enabling tracing and setting a tracing header caused all HTTPS requests to fail immediately when
attempting to fetch headers during the ssl_cert phase.


## 0.36-3

**Release Date:** 2019/11/18

### Features

- Adds an endpoint `/entities/migrate` for migrating entities from Community Edition to Enterprise Edition.

#### Plugins

- **`kong-openid-connect`**
    - Add support for ES256 signing and key generation
    - Add support for ES384 signing and key generation
    - Add support for ES512 signing and key generation
    - Add support for PS256 signing and key generation
    - Add support for PS384 signing and key generation
    - Add support for PS512 signing and key generation
    - Add support for EdDSA signing, key generation and verification
    - Update lua-resty-nettle dependency to 1.0
    - Change verification JWT header's typ claim by adding support for at+jwt that for example IdentityServer4
    is using by default.
    - Change issuer verification bit more permissive (e.g. the difference in ending slash (present or absent)
    does not make the verification to fail)

### Fixes

- Fixes router proxy path issues.


## 0.36-2

### Notifications
- **Kong Enterprise 0.36** inherits from **Kong 1.2.1** with some exceptions:
  * Declarative Configuration and DB-less mode of Kong Gateway is designed for limited scenarios that do not allow for the Kong Enterprise to function as-is. As such the mode is not available in Kong Enterprise today.

**Release Date:** 2019/8/30

### Features

#### Dev Portal
- Adds `custom_id` field to developers to allow easier mapping

#### Plugins
- **Request-transformer**
  - Allows rendering values from kong.ctx.shared

### Fixes

#### Plugins
- **Rate Limiting Advanced**
  - Fixes an issue where user failed to import Rate Limiting Advanced
  declarative YAML file via `kong config db_import`

#### Core
- **Workspaces**
  - Fixes an issue where user can rename a workspace with `PUT` request
- **Migrations**
  - Fixes an issue where migration from 0.35-x to 0.36-x making plugin `protocols`
  field mandatory during `PATCH` request.
  - Fixes an issue where unique fields of entities are not migrated properly when
  migrating from Kong CE to EE using CLI `kong migrations migrate-community-to-enterprise`
- **Vitals**
  - Fixes an issue where Kong fails to remove old stats table when they are not part of public
  schema


## 0.36-1

### Notifications
- **Kong Enterprise 0.36** inherits from **Kong 1.2.1** with some exceptions:
  * Declarative Configuration and DB-less mode of Kong Gateway is designed for limited scenarios that do not allow for the Kong Enterprise to function as-is. As such the mode is not available in Kong Enterprise today.

**Release Date:** 2019/8/19

### Fixes

- Fixes NGINX CVEs:
  * [CVE-2018-16843](https://nvd.nist.gov/vuln/detail/CVE-2018-16843)
  * [CVE-2018-16844](https://nvd.nist.gov/vuln/detail/CVE-2018-16844)
  * [CVE-2019-9511](https://nvd.nist.gov/vuln/detail/CVE-2019-9511)
  * [CVE-2019-9513](https://nvd.nist.gov/vuln/detail/CVE-2019-9513)
  * [CVE-2019-9516](https://nvd.nist.gov/vuln/detail/CVE-2019-9516)
- Fixes issue in which Enterprise will not start if configured with a stream listen directive
- Fixes issue in which LuaPath is not correctly configured and prevents use of Luarocks

## 0.36

### Notifications
- **Kong Enterprise 0.36** inherits from **Kong 1.2.1** with some exceptions:
  * Declarative Configuration and DB-less mode of Kong Gateway is designed for limited scenarios that do not allow for the Kong Enterprise to function as-is. As such the mode is not available in Kong Enterprise today.

**Release Date:** 2019/8/5

### Features

#### Core

- Support for **wildcard SNI matching**: the
  `ssl_certificate_by_lua` phase and the stream `preread` phase) is now able to
  match a client hello SNI against any registered wildcard SNI. This is
  particularly helpful for deployments serving a certificate for multiple
  subdomains.
- **HTTPS Routes can now be matched by SNI**: the `snis` Route
  attribute (previously only available for `tls` Routes) can now be set for
  `https` Routes and is evaluated by the HTTP router.
- **Native support for HTTPS redirects**: Routes have a new
  `https_redirect_status_code` attribute specifying the status code to send
  back to the client if a plain text request was sent to an `https` Route.
- Schema fields can now be marked as immutable.
- Support for loading custom DAO strategies from plugins.
- Support for IPv6 to `tcp` and `tls` Routes.
- **Transparent proxying** - the `service` attribute on
  Routes is now optional; a Route without an assigned Service will
  proxy transparently
- Support for **tags** in entities
  - Every core entity now adds a `tags` field
- New `protocols` field in the Plugin entity, allowing plugin instances
  to be set for specific protocols only (`http`, `https`, `tcp` or `tls`).
  - It filters out plugins during execution according to their `protocols` field
  - It throws an error when trying to associate a Plugin to a Route
    which is not compatible, protocols-wise, or to a Service with no
    compatible routes.

#### Configuration

- **Asynchronous router updates**: a new configuration property
  `router_consistency` accepts two possible values: `strict` and `eventual`.
  The former is the default setting and makes router rebuilds highly
  consistent between Nginx workers. It can result in long tail latency if
  frequent Routes and Services updates are expected. The latter helps
  preventing long tail latency issues by instructing Kong to rebuild the router
  asynchronously (with eventual consistency between Nginx workers).
- **Database cache warmup**: Kong can now preload entities during
  its initialization. A new configuration property (`db_cache_warmup_entities`)
  was introduced, allowing users to specify which entities should be preloaded.
  DB cache warmup allows for ahead-of-time DNS resolution for Services with a
  hostname. This feature reduces first requests latency, improving the overall
  P99 latency tail.
- Improved PostgreSQL connection management: two new configuration properties
  have been added: `pg_max_concurrent_queries` sets the maximum number of
  concurrent queries to the database, and `pg_semaphore_timeout` allows for
  tuning the timeout when acquiring access to a database connection. The
  default behavior remains the same, with no concurrency limitation.
- New option in `kong.conf`: `pg_schema` to specify PostgreSQL schema
  to be used
- The Stream subsystem now supports Nginx directive injections
  - `nginx_stream_*` (or `KONG_NGINX_STREAM_*` environment variables)
    for injecting entries to the `stream` block
  - `nginx_sproxy_*` (or `KONG_NGINX_SPROXY_*` environment variables)
    for injecting entries to the `server` block inside `stream`

#### Admin API

- Add a **schema validation endpoint for entities**: a new
  endpoint `/schemas/:entity_name/validate` can be used to validate an instance
  of any entity type in Kong without creating the entity itself.
- Add **memory statistics** to the `/status` endpoint. The response
  now includes a `memory` field, which contains the `lua_shared_dicts` and
  `workers_lua_vms` fields with statistics on shared dictionaries and workers
  Lua VM memory usage.
  - When using the new `database=off` configuration option,
    the Admin API endpoints for entities (such as `/routes` and
    `/services`) are read-only, since the configuration can only
    be updated via `/config`
- Admin API endpoints now support searching by tag
  (for example, `/consumers?tags=example_tag`)
  - You can search by multiple tags:
     - `/services?tags=serv1,mobile` to search for services matching tags `serv1` and `mobile`
     - `/services?tags=serv1/serv2` to search for services matching tags `serv1` or `serv2`
- New Admin API endpoint `/tags/` for listing entities by tag: `/tags/example_tag`

#### PDK

- New function `kong.node.get_memory_stats()`. This function returns statistics
  on shared dictionaries and workers Lua VM memory usage, and powers the memory
  statistics newly exposed by the `/status` endpoint.
- New PDK function: `kong.client.get_protocol` for obtaining the protocol
  in use during the current request
- New PDK function: `kong.nginx.get_subsystem`, so plugins can detect whether
  they are running on the HTTP or Stream subsystem

#### Plugins

- Logging plugins: log request TLS version, cipher, and verification status.
- Plugin development: inheriting from `BasePlugin` is now optional. Avoiding
  the inheritance paradigm improves plugins' performance.
- Support for ACL **authenticated groups**, so that authentication plugins
  that use a 3rd party (other than Kong) to store credentials can benefit
  from using a central ACL plugin to do authorization for them.
- The Kubernetes Sidecar Injection plugin is now bundled into Kong for a
  smoother K8s experience.
- AWS Lambda now includes the AWS China region.

#### CLI

- **Bulk database import** using the same declarative
  configuration format as the in-memory mode, using the new command:
  `kong config db_import kong.yml`. This command upserts all
  entities specified in the given `kong.yml` file in bulk.
   * Known issue for db_import/db_export in Kong Enterprise
      - `db_import` supports all API Gateway entities, with the exception of Admins and RBAC users and roles. This limitation is because credentials are hashed.
      - `db_export` is not supported at all.
- New command: `kong config init` to generate a template `kong.yml`
  file to get you started
- New command: `kong config parse kong.yml` to verify the syntax of
  the `kong.yml` file before using it
- New option `--wait` in `kong quit` to ease graceful termination when using orchestration tools.

### Fixes

#### Core

- Resolve hostnames properly during initialization of Cassandra contact points
- Fix health checks for Targets that need two-level DNS resolution
  (e.g. SRV → A → IP)
- Fix serialization of map types in the Cassandra backend
- Fix target cleanup and cascade-delete for Targets
- Avoid crash when failing to obtain list of Upstreams
- Disallow invalid timeout value of 0ms for attributes in Services
- DAO fix for foreign fields used as primary keys
- Cassandra: ensures serial consistency is `LOCAL_SERIAL` when a
  datacenter-aware load balancing policy is in use. This fixes unavailability
  exceptions sometimes experienced when connecting to a multi-datacenter
  cluster with cross-datacenter connectivity issues.
- Schemas: fixes an issue in the schema validator that would not allow specifying
  `false` in some schema rules, such a `{ type = "boolean", eq = false }`.
- Fixes an underlying issue with regards to database entities cache keys
  generation.
- Ensure the migration path for Cassandra does not corrupt the
  database schema.
- Allow the `kong config init` command to run without a pointing to a prefix
  directory.
- Adds support for [`db_cache_warmup_entities`](/gateway/latest/reference/configuration/#db_cache_warmup_entities),
  which allows Kong to pre-load all necessary entries into Kong nodes' memory on start.
- Provides support in declarative configuration for **Workspaces** and **RBAC**.
- Provides support for the Redis Cluster library.
- Active healthchecks: `http` checks are not performed for `tcp` and `tls`
  Services anymore; only `tcp` healthchecks are performed against such
  Services.
- Fix an issue where updates in migrations would not correctly populate default
  values.
- Improvements in the reentrancy of Cassandra migrations.
- Fix an issue causing the PostgreSQL strategy to not bootstrap the schema when
  using a PostgreSQL account with limited permissions.
- Address issue where field type "record" nested values reset on update
- Correctly manage primary keys of type "foreign"

#### Admin API

- Proper support for `PUT /{entities}/{entity}/plugins/{plugin}`
- Fix Admin API inferencing of map types using form-encoded
- Accept UUID-like values in `/consumers?custom_id=`

#### Dev Portal

- Adds *per workspace* **Session Config**. The Dev Portal will now allow
session configuration for every portal-per-workspace instance.
- Adds **email verification**. Developers will be sent a verification link after
requesting access to a Dev Portal.

#### Plugins

- **Request Validator**
  - Adds support for JSON Schema Draft 4
  - Adds support for parameter validation
  - Adds the option to override validation for specific content types
- **OAuth2 Introspection**
  - Can now find and load consumers by `username` and `custom_id`. OAuth2
  `username` maps to **Consumer's** `username`, while the `client_id` maps to a
  **Consumer's** `custom_id`
  - New `consumer_by` configuration allows users to customize whether **Consumers**
  are fetched by `client_id` or `username` (returned by the introspection request)
  - New `introspect_request` configuration that causes the plugin to send
  information about the **current request** as **headers** in the **introspection endpoint**
  **request**. Currently, the **request path** and **HTTP methods** are sent as `X-Request-Path`
  and `X-Request-Http-Method` headers
  - New `custom_introspection_headers` configuration list of user-supplied
  headers to be sent in the **introspection endpoint request**
  - New `custom_claims_forward` configuration list of additional claims. The
  **introspection endpoint request** will return this list to forward as headers
  to the **upstream service request**.
- basic-auth, ldap-auth, key-auth, jwt, hmac-auth: fixed
  status code for unauthorized requests: they now return HTTP 401
  instead of 403
- tcp-log: remove spurious trailing carriage return
- jwt: fix `typ` handling for supporting JOSE (JSON Object
  Signature and Validation)
- Fixes to the best-effort auto-converter for legacy plugin schemas
- Ensures the `cassandra_local_datacenter` configuration property is specified
  when a datacenter-aware Cassandra load balancing policy is in use.
- request-transformer: fixes an issue that would prevent adding a body to
  requests without one.
- kubernetes-sidecar-injector: fixes an issue causing mutating webhook calls to
  fail.
- basic-auth: ignore password if nil on basic auth credential patch
- http-log: Simplify queueing mechanism. Fixed a bug where traces were lost
  in some cases.
- request-transformer: validate header values in plugin configuration.
- rate-limiting: added index on rate-limiting metrics.
- **Upstream-tls**
  - Fixes an issue where bundled **certificates** in PEM format were not loaded into
  the certificate store correctly.
- ldap-auth: ensure TLS connections are reused.
- oauth2: ensured access tokens preserve their `token_expiration` value when
  migrating from previous Kong versions.

#### Workspaces

- Fixes permission bug where an **Admin** with `workspace-super-admin` **Role** was
not able to access the **Workspace** that the **Role** was assigned to.

#### Upstreams

- Fixes an issue where it was not possible to delete an **Upstream** object if it had no associated **Target**.

#### Kong Manager

- Fixes a bug where Kong Manager could only display 100 **Workspaces**.
- Fixes a bug where a **Route's** details would not include a link to a **Service** that did not have a name.

#### Dev Portal

- Fixes a bug in the sign-up meta fields that caused data to disappear when a **Developer** is updated.
- Fixes an issue where clicking on a **Developer** after clicking the credentials section ACL causes a 500 error.

#### CLI

- Fix `kong db_import` to support inserting entities without specifying a UUID
  for their primary key. Entities with a unique identifier (e.g. `name` for
  Services) can have their primary key omitted.
- The `kong migrations [up|finish] -f` commands does not run anymore if there
  are no previously executed migrations.

### Changes

- **Brain**
  - Renames **Brain** to **Collector**

## 0.35-5
**Release Date:** 2020/05/14

### Fixes
- Reverted breaking changes introduced by [PR #3780](https://github.com/Kong/kong/pull/3780) involving the handling of slashes inside the router.
- Reverted service mesh changes affecting `proxy_ssl_*` directives.

## 0.35-4
**Release Date:** 2019/08/19

### Notifications
- **Kong Enterprise 0.35-3** inherits from **Kong 1.0.3**; read the
[Kong Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#103)
for details.

### Fixes
- Fixes for NGINX CVEs resolving security vulnerabilities in the HTTP/2 protocol which may cause excessive memory consumption and CPU usage: [CVE-2018-16843](https://nvd.nist.gov/vuln/detail/CVE-2018-16843), [CVE-2018-16844](https://nvd.nist.gov/vuln/detail/CVE-2018-16844), [CVE-2019-9511](https://nvd.nist.gov/vuln/detail/CVE-2019-9511), [CVE-2019-9513](https://nvd.nist.gov/vuln/detail/CVE-2019-9513), and [CVE-2019-9516](https://nvd.nist.gov/vuln/detail/CVE-2019-9516)

## 0.35-3
**Release Date:** 2019/07/17

### Notifications
- **Kong Enterprise 0.35-3** inherits from **Kong 1.0.3**; read the
[Kong Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#103)
for details.

### Features

#### Core
- New CLI migrations command `migrate-apis` to convert all existing API objects to **Services and Routes**
- New CLI migrations command `migrate-community-to-enterprise` for moving Core entities to Enterprise entities
- Support for Redis Cluster as a backend for `rate-limiting-advanced` and `proxy-cache` plugins
- Cache-warming configuration to load specified entities at startup to improve first request latency

#### Kong Manager
- New page to reset **RBAC** token and manage user password

#### Plugins
- `upstream-tls` - allows verification of upstream certificates, custom CA certificates, and verification depth

### Fixes

#### Core
- Correctly count `workspace_entities` when moving from previous versions

#### Dev Portal
- Dev Portal Docs now point to 0.35
- Unauthenticated Spec rendering is fixed

#### Plugins
- **`jwt-signer`**
  - Fix **IMPORTANT!** verify expiry and scopes checks on JWT tokens
  - Fix finding Consumer by custom ID
  - Fix runtime error on unexpected function, `kong.log.error` -> `kong.log.err`
  - Change invalidation to happen locally, not cluster wide, each node invalidates on their own
- **`openid-connect`**
  - Change invalidations to local invalidation instead of cluster-wide invalidation
  - Fix **Admin API** to properly call the cleanup function on entity endpoint
  - Fix `hide_credentials` not clearing X-Access-Token header
  - Change debug logging to not log about disabled authentication methods
  - Change TTL code and fix some edge cases


## 0.35-1
**Release Date:** 2019/05/28

### Notifications
- **Kong Enterprise 0.35-1** inherits from **Kong 1.0.3**; read the
[Kong Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#103)
for details.

### Features

#### Plugins
  - Allow **Redis** strategy configuration for **Rate Limiting Advanced**

### Fixes

#### Kong Manager
- If a Kong Manager **Super Admin** was already created, setting
`KONG_PASSWORD` during `migrations up` to **0.35** would error. Running
migrations when **Super Admin** already exists and `KONG_PASSWORD`
environment variable is set is fixed.

#### Dev Portal
- Fixes Dev Portal documentation not showing after upgrading to 0.35
- Fixes Dev Portal OAPI spec rendering of long request URL wrapping

#### Plugins
- `rate-limiting-advanced` schema validation rules prevented use of
Redis Sentinel (`config.strategy=redis` and
`config.redis.sentinel_addresses`) for counters data store. Validation
rule is fixed.

#### Core
- Upgrade from **0.34-1** to **0.35** using **Cassandra** no longer creates
duplicate **Workspace**.
- Migrations from **0.34-1**to **0.35** did not properly handle **Certificates**
and **SNIs** in context of **Workspaces**. Migrating from **0.34-1** with
this fix does not support zero downtime in this release. To get a fully
functional **0.35** instance with **Certificates**, you must run `migrations
finish`. Proper creation of **Workspace** links for **Certificates** and
**SNIs** is fixed.
- **Cassandra** `read before write` pattern did not correctly use schema
defaults and prevented `PATCH` of the **Plugins** entity. Usage of schema
default values in **Cassandra** `read before write` pattern is fixed.
- `plugins.run_on default` now correctly set on migrations upgrade.
<hr/>

## 0.35
**Release Date:** 2019/05/17

### Notifications
- **Kong Enterprise 0.35** inherits from **Kong 1.0.3**; read the
[Kong Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#103)
for details.

### Changes

#### Admin API
  - **RBAC**: Following Kong 1.0's changes, referenced (`foreign_key`) entities
  like RBAC Users and RBAC Roles are returned as nested JSON tables instead of
  flattened `role_id` or `user_id` fields in top-level entity.
  - `user_token` must now be provided when creating a new **RBAC** user (in a
  POST request to `rbac/users`) and is no longer auto-generated if left blank

#### Core
  - New **RBAC** user tokens are not stored in plaintext. If upgrading to this
  version, any existing tokens will remain in plaintext until either a) the
  token is used in an Admin API call or b) the `rbac_user` record is PATCHed
  even if the PATCH request includes the existing value of `user_token`).

### Features

#### Kong Manager
  - User information is no longer stored in local storage. A user exchanges
  credentials for a session. See the [**Session Plugin**](/hub/kong-inc/session/)
  for details.
  - Enable and view **Plugins** in context of a **Service** and **Route**
  - Type-ahead service name/ID search on routes form
  - Easily scan/copy IDs in service table
  - Contextual help and error messages for forms
  - Adds page breadcrumbs
  - In-context documentation links
  - Global navigation links to documentation and Support Portal
  - Improved Info tab for cluster & config info
  - Detailed debug tracing can be enabled which outputs information about
  various portions of the request lifecycle, such as DB or DNS queries,
  plugin execution, core handler timing, etc

#### Dev Portal
  - **Dev Portal** files now rendered server-side for increased performance.
  - Developers can now sign up to multiple **Workspaces** with the same email
  address.
  - **Dev Portal** is disabled for each **Workspace** by default.
  - Default theme shipped with **Kong Enterprise** now supports IE11.
  - User information is no longer stored in local storage. A user exchanges
  credentials for a session. See the [**Session Plugin**](/hub/kong-inc/session/)
  for details.
  - **Dev Portal** page, partial, and specification look-ups moved to
  server-side.
  - Added support for OAS3 body parameters.
  - Added CORS header configuration option to workspace portal configuration
  object to allow explicit CORS configuration.
  - Added a live editor built on VSCode core for improved customization of
  **Dev Portal** within **Kong Manager**
  - Added custom registration fields support and custom registration field
  interface.
  - Added methods to links in the sidebar on documentation in the default portal
  theme.
  - Added hover states to drop-downs in the sidebar of documentation in the
  default portal theme.
  - Added a right border to the sidebar in the default portal theme.
  - Changed `full Name` registration field to be a custom registration field,
  and can be managed through the custom fields interface in **Kong Manager**.
  - Changed custom checkbox to native checkbox in the default **Dev Portal**
  theme on the dashboard.

#### Plugins
  - **Response Transformer Advanced** (_NEW_):
    - Conditional transformations on response status through the new flag
    if_status, a subfield in all transformations (e.g., `add.if_status`,
    `remove.if_status`); the transformation only happens if the response code
    matches one of the codes in the `if_status field`
    - Full-body replacement through the new config.replace.body
    - Added a support of status code ranges for `if_status` configuration
    parameter. Now you can provide status code ranges and single status codes
    together (e.g., `201-204,401`)
  - **Request Validator** (_NEW_):
    - Validate the request body against a schema; if the payload is not
    valid JSON or if it doesn't conform to the schema, the plugin returns a 400
    Bad Request response before the request reaches upstream. This version of
    the plugin **does not** support JSON Schema; it uses Kong's schema format
  - **Canary**:
    - Healthchecks: new configuration upstream_fallback allows the plugin to
    skip applying the canary upstream if it's not healthy. Note: it only works
    if the host specified in upstream_host points to a Kong upstream, and if
    that upstream has healthchecks enabled on it)
  - **Oauth2 Introspection**:
    - Set Id to Rate limiting may detect calls to introspection endpoint
    - Set credential id to allow rate limiting based on access token
  - **The Kong Session Plugin**:
    - The Kong Session Plugin adds session support for **Kong Manager** and
    Dev Portal. Sessions can be stored via cookie or database. See the
    accompanying documentation for how to configure the plugin for use with
    **Kong Manager**.
  - **Vault-Auth**:
    - Authenticate requests via Vault. See
    [**Vault Auth**](/hub/kong-inc/vault-auth/) for details.
  - **OpenID Connect**:
    - Update `lua-resty-http` to `>= 0.13`
    - Update `lua-resty-session` to `2.23`
    - Add `config.authorization_endpoint`
    - Add `config.token_endpoint`
    - Add `config.response_type`
    - Add `config.token_post_args_client`
    - Add `config.token_headers_names`
    - Add `config.token_headers_values`
    - Add `config.introspection_post_args_names`
    - Add `config.introspection_post_args_values`
    - Add `config.instrospection_post_args_client`
    - Add `config.session_secret`
    - Add `config.session_cookie_renew`
    - Add `config.ignore_signature`
    - Add `config.cache_ttl_max`
    - Add `config.cache_ttl_min`
    - Add `config.cache_ttl_neg`
    - Add `config.cache_ttl_resurrect`
    - Add `config.upstream_session_id_header`
    - Add `config.downstream_session_id_header`
    - Add `tokens` option to `config.login_tokens` to return full token endpoint
    results with `response` or `redirect` specified in `config.login_action`
    - Add `introspection` option to `config.login_tokens` to return
    introspection results with `response` or `redirect` specified in
    `config.login_action`
    - Change Kong 1.0 support
    - Change Refresh-token headers can now have `Bearer` in front of the token.
    - Change to forbid only unapproved developers
    - Change `config.scopes_claim` is also searched in introspected jwt token
    results
    - Change `config.audience_claim` is also searched in introspected jwt token
    results
    - Change `config.consumer_claim` is also searched in introspected jwt token
    results
    - Change `config.consumer_claim` is also searched with user info when
    `config.search_user_info` is enabled
    - Change `config.credential_claim` is searched from `id token` as well
    - Change `config.credential_claim` is also searched in introspected jwt
    token results
    - Change `config.credential_claim` is also searched with user info when
    `config.search_user_info` is enabled
    - Change `config.authenticated_groups_claim` is searched from `id token`
    as well
    - Change `config.authenticated_groups_claim` is also searched with user
    info when `config.search_user_info` is enabled
    - Change `config.upstream_headers_claims` and
    `config.downstream_headers_claims` are now searched from introspection
    results, jwt access token and id token, and user info when
    `config.search_user_info` is enabled
    - Change `id_token` is not anymore copied over when refreshing tokens to
    prevent further claims verification errors. The token endpoint can return a
    new id token, or user info can be used instead.
    - Change hide `secret` from admin api
    - Change `config.issuer` to semi-optional (you still need to specify it but
    code won't error if http request to issuer fails)
    - Change more reentrant migrations
    - Change issuer to be optional
    - Change signature verification to look suitable key by algorithm as well
    in case where key identifier is missing or cannot be found
    - Remove developer status/type check from plugin
    - Remove `daos` that were never used
    - Remove all the sub-plugins (openid-connect-verification,
    openid-connect-authentication, and openid-connect-protection)
    - Fix issue with Kong OAuth 2.0 and OpenID Connect sharing incompatible
    values with same cache key
  - **Forward Proxy**:
    - Fix an issue preventing the plugin from working with requests using
    chunked TE
  - **LDAP Auth Advanced**:
    - Added LDAPS protocol support
    - Added tests for multiple connection strategies
    - Fixed an issue where plugin tries to start a secure connection on an
    existing pooled connection from previous requests
  - **StatsD Advanced**
    - Added filter by status code functionality for responses to be logged.
    Admins can add status code ranges for responses which want to be logged and
    sent to StatsD server. If Admin doesn't provide any status code, all
    responses will be logged.
#### Security
  - Set security headers in **Kong Manager** and **Dev Portal**
  - Guard against frame misuse in **Kong Manager** and **Dev Portal**

### Fixes

#### Kong Manager
- Clear option for turning off New Relic data collection
- Keyword search bug fixed in **Kong Manager**
- Info tab of **Kong Manager** no longer empty (shows license information)
- Custom **Plugins** viewable within plugin groupings
- Error messages on **Workspace** form don't remain longer than intended
- Column overflow issue in services table in **Kong Manager** fixed
- New **Routes** were accidentally accepting strings for `regex_priority` when
submitting a new **Routes**, fixed as part of **Kong 1.0** merge
- Fixes CORS breaking when configuring `KONG_ADMIN_API_URI` with a port.
- Fixes issue in **Kong Manager** where **Dev Portal** pages would display
the wrong content when disabled from `kong.conf`.
- Fixes issue in **Kong Manager** where email validation would accept invalid
inputs.

#### Dev Portal
- Fixes issue in **Dev Portal** where email validation would accept invalid
inputs.
- Fixes **Dev Portal** "Forgot Email" template URL pointing to the wrong location.
- Fixes CORS error shown when loading content if **Dev Portal** is improperly
configured.
- Fixes default spec renderer improperly rendering request bodies.
- Fixes issues in the portal theme preventing loading in Internet Explorer
- Fixes long titles overflowing and stretching the sidebar in the default
portal theme.
- Fixes sidebar drop-down arrow not rotating in default portal theme.
- Fixes sidebar overlapping main body content in default portal theme.
- Fixes main body content overflowing container in default portal theme.
- Fixes issue in the default portal theme where transitioning from the mobile
to full-screen would retain the sidebar overlay.
- Fixes issue in the default portal theme where links on documentation would
not navigate due to spaces.
- Fixes issue in the default portal theme where on logout a user would be
redirected to the default workspace portal.
- Fixes issue in the portal theme sync script where environment flags were not
properly evaluated as booleans.
- Fixes issue in the portal theme sync script where relative links would add
the theme name to files inserted on a workspace.
<hr/>

## 0.34-1
**Release Date:** 2018/12/19

### Notifications
- **Kong EE 0.34** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.34** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon

### Changes
- **Kong Manager**
  - Email addresses are stored in lower-case. These addresses must be case-insensitively unique. In previous versions, you could store mixed case email addresses. A migration for PostgreSQL converts all existing email addresses to lower case. Cassandra users should review the email address of their admins and developers and update them to lower-case if necessary. Use the Kong Manager or the Admin API to make these updates.
- **Plugins**
  - **Forward Proxy**
    - Do not do a DNS request to the original upstream that would be discarded anyway as proxy will manage the resolving of the configured host.
  - **OpenID Connect**
    - Remove obsolete daos (adds migration)
    - Hide secret from Admin API (used with sessions)
    - Bump lua-resty-session to 2.23
    - Change token verification to check token types when requested

### Features
- **Dev Portal**
  - [kong_portal_templates](https://github.com/Kong/kong-portal-templates) repository:
    - A public repository containing dev portal themes, examples, and dev tools for working with the Dev Portal template files.
  - sync.js:
    - Script which allows dev portal developers to `push`, `pull`, and `watch` the most up to date template files to and from kong to their local machine.
  - default portal theme:
    - Directory containing the most up to date version of the default portal template files that ship with Kong EE each release.
  - Bug fixes, updates, and template features will be pushed here regularly and independently of the EE release cycle.
  - Dev Portal now caches static JS assets
- **Plugins**
  - **OpenID Connect**
    - add `config.http_proxy_authorization` (note: this is not yet in upstream lua-resty-http)
    - add `config.https_proxy_authorization` (note: this is not yet in upstream lua-resty-http)
    - add `config.no_proxy`
    - add `config.logout_revoke_access_token`
    - add `config.logout_revoke_refresh_token`
    - add `config.refresh_token_param_name`
    - add `config.refresh_token_param_type`
    - add `config.refresh_tokens`
- **CORE**
  - **License**
    - Added an increasingly "loud" logging to notify via nginx logs as the expiration date approaches.
      - 90 days before the expiration date: Daily WARN log
      - 30 days before the expiration date: Daily ERR log
      - After the expiration date: Daily CRIT log
  - **DB**
    - **Cassandra**
      - Support request-aware load-balancing policies in conf &
        DAOs. `cassandra_lb_policy` now supports two new
        policies RequestRoundRobin and RequestDCAwareRoundRobin.

### Fixes
- **Admin API**
  - Prevent creating or modifying developers and admins through the
    /consumers endpoints
  - Prevent creating or modifying consumers through the /admins
    endpoints
  - Fix error on /admins when trying to create an admin with the
    same name as an existing RBAC user
  - Roll back if a POST to /admins fails
- **Dev Portal**
  - KONG_PORTAL_AUTH_CONF parameter values can now handle escaped
    characters such as #
  - ACL plugin credential management no longer accessible from Dev
    Portal client
  - "Return to login" CTA on the password-reset page now redirects
    to appropriate workspace
  - Improved support for OAS 3 specifications
  - General SwaggerUI improvements
  - Developer approval email will only send once (on first
    approval).  A developer will not receive an additional email if
    they are revoked and re-approved.
- **Kong Manager**
  - When creating a new workspace, always create roles for that workspace
  - List workspace roles in alphabetical order
  - Provide a button on the Admin show page to generate a registration URL
  - Fix misleading error message when adding an existing user to a
    new workspace
  - Add validation of image type when creating a workspace with an avatar
  - Add configuration fields and icon for the JWT signer plugin
  - Clean up console errors due to lack of permissions
  - Make the UTC button on Vitals charts work in Firefox
  - Change the display order of plugins to match the Plugin Hub
- **CORE**
  - **Workspaces**
    - When removing an entity from a workspace, delete the entity
      itself if it only belongs to that workspace.
    - Developers nor admins do not affect consumer counters in
      workspaces. Only proxy consumers do.
  - **DB**
    - **Cassandra**
      - Fix an issue where Insert operation fails to return an entity as not all Cassandra nodes are synced yet while reading the data.
      - Now Kong will make one try to fetch the inserted row before throwing error. (Fix: https://support.konghq.com/hc/en-us/requests/6217 )
- **Plugins**
  - **Rate-limiting**
    - Use database-based redis connection pool to reduce unnecessary select call
  - **Response-ratelimiting**
    - Use database-based redis connection pool to reduce unnecessary select call
  - **OpenID Connect**
    - Fix schema `self_check` to verify issuer only when given (e.g. when using `PATCH` to update configuration)
<hr/>

## 0.34
**Release Date:** 2018/11/17

### Notifications
- **Kong EE 0.34** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.34** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon

- **Kong Manager**
  - The name of the `Admin GUI` has changed to `Kong Manager`
- **Licensing**
  - License expiration logs: Kong will start logging the license expiration date once a day - with a `WARN` log - 90 days before the expiry; 30 days before, the log severity increases to `ERR` and, after expiration, to `CRIT`

### Changes
- **Admin API**
  - The system-generated `default` role for an RBAC user is no longer accessible via the Admin API
  - Auto-config OAPI endpoint available for Admin API (configure services & routes via Swagger)
- **Workspaces**
  - Workspaces on Workspaces has been disabled, meaning that workspaces do not apply on `/workspaces/` endpoints
  - Renaming workspaces is no longer allowed
- **Vitals**
  - Now enabled by default when starting Kong for the first time
- **Dev Portal**
  - **Breaking change** - change of config options
  - `portal_gui_url` is removed, and `protocol`, `host`, and `portal_gui_use_subdomains` added
  - `protocol` and `host` replace `portal_gui_url`
  - `portal_gui_use_subdomains` avoids conflicts if base path name matches workspace name
- **Plugins**
  - **Prometheus**
    - **Warning** - Dropped metrics that were aggregated across services in Kong. These metrics can be obtained much more efficiently using queries in Prometheus.
  - **Zipkin**
    - Add kong.node.id tag
  - **Proxy Cache**
    - Add `application/json` to config `content-type`
  - **All logging plugins**
    - Workspace of the request is logged
  - **StatsD Advanced**
    - Add workspace support with new metrics `status_count_per_workspace`
  - **OpenID Connect**
    - NOTE - If using an older version of the OpenID Connect plugin, with sub-plugins, Kong will not start after upgrading to 0.34. Sub-plugins are now disabled by default will be removed completely in subsequent releases. To make sure Kong starts, enable OIDC sub-plugins manually, with the custom_plugins configuration directive - or through the `KONG_CUSTOM_PLUGINS` environment variable; for example:

    Set the following in the kong.conf file:

    ```
    custom_plugins=openid-connect-verification,openid-connect-authentication,openid-connect-protection
    ```
    Or the following environment variable:
    ```
    KONG_CUSTOM_PLUGINS=openid-connect-verification,openid-connect-authentication,openid-connect-protection
    ```
    The all-in-one version of OIDC is enabled by default (and is not deprecated).

    - Always log the original error message when authorization code flow verification fails
    - Optimize usage of ngx.ctx by loading it once and then passing it to functions
    - **Breaking change** - Change config.ssl_verify default to false.

### Features

- **Dev Portal**
  - Filterable API list
  - Improved portal management in Kong Manager
    - Overview page with quick links to portal, create pages
    - Split out pages, specs, partials for ease of navigation
  - SMTP support and admin/access request workflow improvements
  - Global search
  - Option for one dev portal per workspace, and option to enable within Kong Manager
  - Improved OAS 3.0 support
  - Markdown support
- **Kong Manager**
  - Workspaces are now configurable in Kong Manager
    - Creation, management of workspaces for super admin
    - RBAC assignment globally for super admin
    - Vitals is workspace-aware
  - Support for inviting additional users
  - Self-service credential management
  - General UI cleanup (tables, modals, forms, notifications)
  - New menu/navigation system
- **Vitals**
  - Functionality to support storing Vitals data in Prometheus (via the StatsD Advanced plugin)
  - InfluxDB support for Vitals
- **Plugins**
  - HTTPS support for **Forward Proxy plugin**
  - **Route by header** added to the package - docs can be found [here](https://docs.konghq.com/hub/kong-inc/route-by-header/)
  - **JWT Signer** added to the package - docs can be found [here](https://docs.konghq.com/hub/kong-inc/jwt-signer/)
  - **OpenID Connect**
    - Add `config.unauthorized_error_message`
    - Add `config.forbidden_error_message`
    - Add `config.http_proxy`
    - Add `config.https_proxy`
    - Add `config.keepalive`
    - Add `config.authenticated_groups_claim`
    - Add `config.rediscovery_lifetime`
    - Add support for `X-Forwarded-*` headers in automatic `config.redirect_uri` generation
    - Add `config.session_cookie_path`
    - Add `config.session_cookie_domain`
    - Add `config.session_cookie_samesite`
    - Add `config.session_cookie_httponly`
    - Add `config.session_cookie_secure`
    - Add `config.authorization_cookie_path`
    - Add `config.authorization_cookie_domain`
    - Add `config.authorization_cookie_samesite`
    - Add `config.authorization_cookie_httponly`
    - Add `config.authorization_cookie_secure`
- **CORE**
  - Admin API and DAO Audit Log
  - **Healthchecks**
    - HTTPS support
  - **License**
    - Added an increasingly `loud` logging to notify via nginx logs as the expiration date approaches
      - 90 days before the expiration date: Daily `WARN` log
      - 30 days before the expiration date: Daily `ERR` log
      - After the expiration date: Daily `CRIT` log
- **Workspaces**
  - Added endpoint `/workspaces/:ws_id/meta` that provides info about workspace `ws_id`. Current counts of entities per entity type are returned

### Fixes
- **CORE**
  - **Plugin runloop**
    - Fix issue where Log phase plugins are not executed for request with non-matching routes.
    Note: For request with non-matching routes, every logging phase plugin enabled in the cluster will run irrespective of the workspace where it's configured
  - **Workspaces**
    - Logging plugins log workspace info about requests
    - Fix issue where attempt to share an entity outside the current request's workspace would result in an Internal Server Error
    - Fix issue where a global plugin would be executed for a workspace where it doesn't belong
  - **RBAC**
    - Fix issue where admin could grant privileges to workspaces on which they don't have permissions
    - Permissions created with the `/rbac/roles/:role/endpoints` endpoint receive the current request's workspace instead of the default workspace
    - Return HTTP status code 500 for database errors instead of 401 and 404
    - Fix issue where a user with Admin privilege was able to access RBAC admin endpoints
  - **DAO**
    - Allow self-signed certificates in Cassandra connections
    - check for schema consensus in Cassandra migration
    - Ensure ScyllaDB compatibility in Cassandra migration
  - **Config**
    - IPv6 addresses in listen configuration directives are correctly parsed
  - **Certificates & SNIs**
    - Fix issue where internal server error was returned when CRUD operations were performed on Certificate endpoint
- **Plugins**
  - **Request Termination**
    - Allow user to unset the value of `config.body` or `config.message` or both
  - **Zipkin**
    - Fix failures when request is invalid or exits early
    - Fix issue when service name is missing
  - **Proxy Cache**
    - Fix issue where responses were not cached if they met at least one positive criteria and did not meet any negative criteria
    - Allow caching of responses without an explicit `public` directive in the `Cache-Control` header
  - **HMAC Authentication**
    - Fix issue where request was not correctly validated against the digest header when `config.validate_request_body` was set and request had no body

  - **OpenID Connect**
    - Fix `cache.tokens_load` ttl fallback to access token exp in case when expires_in is missing
    - Fix headers to not set when header value is `ngx.null` (a bit more robust now)
    - Fix encoding of complex upstream and downstream headers
    - Fix multiple authentication plugins AND / OR scenarios
    - Fix expiry leeway counting when there is refresh token available and when there is not.
    - Fix issue when using password grant or client credentials grant with token caching enabled, and rotating keys on IdP that caused the cached tokens to give 403. The cached tokens will now be flushed and new tokens will be retrieved from the IdP.
    - Fix a bug that prevented sub-plugins from loading the issuer data.
<hr/>

## 0.33-2
**Release Date:** 2018/10/09

### Notifications

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

### Fixes

- **Core**
  - **DB**
      - [lua-cassandra](https://github.com/thibaultcha/lua-cassandra/blob/master/CHANGELOG.md#132) version bumped to 1.3.2
          - Fix an issue encountered in environments with DNS load-balancing in effect for contact_points provided as hostnames (e.g.Kubernetes with `contact_points = { "cassandra" }`).

  - **Plugin Runloop**
      - Plugin runloop performance optimizations
        - Reduce the number of invocations of the plugins iterator by attempting to load configurations only for plugins we know are configured on the cluster
        - Pre-calculate plugins cache key
        - Avoid unnecessary L2 cache deserialization

  - **Balancer**
      - Fix issue where Upstream for different workspace getting cached to same key
      - Fix an issue where Balancer are not run into limited workspace scope

  - **Dev Portal**
      - Fix an issue which may expose information on the URL query string
      - **Breaking**: If you are updating from a previous version (not a clean install), you will need to update the files below in order to take advantage of security and performance updates.

**unauthenticated/login (page)**


{% raw %}
```html
{{#> unauthenticated/layout pageTitle="Login" }}

  {{#*inline "content-block"}}

  <div class="authentication">
    {{#unless authData.authType}}
        <h1>404 - Not Found</h1>
    {{/unless}}
    {{#if authData.authType}}
      <h1>Login</h1>
      <form id="login" method="post">
        {{#if (eq authData.authType 'basic-auth')}}
          <label for="username">Email</label>
          <input id="username" type="text" name="username" required />
          <label for="password">Password</label>
          <input id="password" type="password" name="password" required />
          <button id="login-button" class="button button-primary" type="submit">Login</button>
        {{/if}}
        {{#if (eq authData.authType 'key-auth')}}
          <label for="key">Api Key</label>
          <input id="key" type="text" name="key" required />
          <button id="login-button" class="button button-primary" type="submit">Login</button>
        {{/if}}

        {{#if (eq authData.authType 'openid-connect')}}
        <a href="{{config.PROXY_URL}}" class="button button-outline">
          <svg class="google-button-icon" viewBox="0 0 366 372" xmlns="http://www.w3.org/2000/svg"><path d="M125.9 10.2c40.2-13.9 85.3-13.6 125.3 1.1 22.2 8.2 42.5 21 59.9 37.1-5.8 6.3-12.1 12.2-18.1 18.3l-34.2 34.2c-11.3-10.8-25.1-19-40.1-23.6-17.6-5.3-36.6-6.1-54.6-2.2-21 4.5-40.5 15.5-55.6 30.9-12.2 12.3-21.4 27.5-27 43.9-20.3-15.8-40.6-31.5-61-47.3 21.5-43 60.1-76.9 105.4-92.4z" id="Shape" fill="#EA4335"/><path d="M20.6 102.4c20.3 15.8 40.6 31.5 61 47.3-8 23.3-8 49.2 0 72.4-20.3 15.8-40.6 31.6-60.9 47.3C1.9 232.7-3.8 189.6 4.4 149.2c3.3-16.2 8.7-32 16.2-46.8z" id="Shape" fill="#FBBC05"/><path d="M361.7 151.1c5.8 32.7 4.5 66.8-4.7 98.8-8.5 29.3-24.6 56.5-47.1 77.2l-59.1-45.9c19.5-13.1 33.3-34.3 37.2-57.5H186.6c.1-24.2.1-48.4.1-72.6h175z" id="Shape" fill="#4285F4"/><path d="M81.4 222.2c7.8 22.9 22.8 43.2 42.6 57.1 12.4 8.7 26.6 14.9 41.4 17.9 14.6 3 29.7 2.6 44.4.1 14.6-2.6 28.7-7.9 41-16.2l59.1 45.9c-21.3 19.7-48 33.1-76.2 39.6-31.2 7.1-64.2 7.3-95.2-1-24.6-6.5-47.7-18.2-67.6-34.1-20.9-16.6-38.3-38-50.4-62 20.3-15.7 40.6-31.5 60.9-47.3z" fill="#34A853"/></svg>
          <span class="google-button-text">Sign in with Google</span>
        </a>
        {{/if}}
      </form>
    {{/if}}
  </div>

  {{/inline}}

{{/unauthenticated/layout}}
```
{% endraw %}


**unauthenticated/register (page)**


{% raw %}
```html
{{#> unauthenticated/layout pageTitle="Register" }}

    {{#*inline "content-block"}}
    <div class="authentication">
      <h1>Request Access</h1>
      <div class="alert alert-info">
        <b>Please fill out the below form and we will notify you once your request gets approved.</b>
      </div>
      <form id="register" method="post">
        <label for="full_name">Full Name</label>
        <input id="full_name" type="text" name="full_name" required />
        {{#if (eq authData.authType 'basic-auth')}}
          <label for="email">Email</label>
          <input id="email_basic" type="text" name="email" required />
          <label for="password">Password</label>
          <input id="password_basic" type="password" name="password" required />
        {{/if}}
        {{#if (eq authData.authType 'key-auth')}}
          <label for="email">Email</label>
          <input id="email_key" type="text" name="email" required />
          <label for="key">Api Key</label>
          <input id="key" type="text" name="key" required />
        {{/if}}
        {{#if (eq authData.authType 'openid-connect')}}
          <label for="email">Email</label>
          <input id="email-oidc" type="text" name="email" required />
        {{/if}}
        <button class="button button-primary" type="submit">Sign Up</button>
      </form>
    </div>
    {{/inline}}

{{/unauthenticated/layout}}
```
{% endraw %}


**unauthenticated/custom-css (partial)**


{% raw %}
```html
{{!--
    |--------------------------------------------------------------------------
    | Here's where the magic happens. This is where you can add your own
    | custom CSS as well as override any default styling we've provided.
    | This file is broken up by section, but feel free to organize as you
    | see fit!
    |
    |--------------------------------------------------------------------------
    |
    --}}

    {{!-- Custom fonts --}}
    {{!-- <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css" rel="stylesheet"> --}}

    <style>
    /*
    |--------------------------------------------------------------------------
    | Typography:
    | h1, h2, h3, h4, h5, h6, p
    |--------------------------------------------------------------------------
    |
    */

    h1 {}

    h2 {}

    h3 {}

    h4 {}

    h5 {}

    h6 {}

    p {}

    /* Header */
    #header {}

    /* Sidebar */
    #sidebar {}

    /* Footer */
    #footer {}

    /* Swagger UI */
    .swagger-ui .side-panel {}

    /*
    |--------------------------------------------------------------------------
    | Code block prismjs theme.
    | e.g. https://github.com/PrismJS/prism-themes
    |--------------------------------------------------------------------------
    |
    */

    .token.block-comment,
    .token.cdata,
    .token.comment,
    .token.doctype,
    .token.prolog {
      color: #999
    }

    .token.punctuation {
      color: #ccc
    }

    .token.attr-name,
    .token.deleted,
    .token.namespace,
    .token.tag {
      color: #e2777a
    }

    .token.function-name {
      color: #6196cc
    }

    .token.boolean,
    .token.function,
    .token.number {
      color: #f08d49
    }

    .token.class-name,
    .token.constant,
    .token.property,
    .token.symbol {
      color: #f8c555
    }

    .token.atrule,
    .token.builtin,
    .token.important,
    .token.keyword,
    .token.selector {
      color: #cc99cd
    }

    .token.attr-value,
    .token.char,
    .token.regex,
    .token.string,
    .token.variable {
      color: #7ec699
    }

    .token.entity,
    .token.operator,
    .token.url {
      color: #67cdcc
    }

    .token.bold,
    .token.important {
      font-weight: 700
    }

    .token.italic {
      font-style: italic
    }

    .token.entity {
      cursor: help
    }

    .token.inserted {
      color: green
    }

</style>
```
{% endraw %}


- **Plugins**
  - **LDAP Auth Advanced**
      - Fix an issue where the plugin fails to authenticate a user when the LDAP server doesn't return the user's password as part of the search result
      - Fix issue where the username field wasn't allowed to contain non-alaphanumeric characters
<hr/>

## 0.33-1
**Release Date:** 2018/09/05

### Notifications

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

### Changes

- **Plugins**
  - **HMAC Auth**
      - Attempt signature generation without querystring arguments if the newer signature verification, that includes querystring, fails
  - **StatsD Advanced**
      - Improve performance when constructing the metrics key
      - Allow hostname to be written into the key prefix, based on a boolean plugin config flag

### Fixes

- **Core**
  - **RBAC**
      - Fix an issue where entities are not added to the role-entities table when id is not the primary key
      - Fix an issue where role-entities and role-endpoints relationships are not deleted when role is removed
      - Fix issue leading to SNI creation failure when RBAC is on
  - **Workspaces**
      - Fix an issue where authentication keys prefixed with a workspace name would be considered valid
    - **DB**
      - Cassandra
        - Fix Cassandra unique violation check on update
    - **Migrations**
      - Remove dependency on "public" schema or "pg_default" tablespaces in PostgreSQL - such a dependency would cause migrations to fail if such tablespaces weren't being used
    - **Healthchecks**
      - Fix Host header in active healthchecks
      - Fix for connection timeouts on passive healthchecks
  - **Dev Portal**
      - Fix issue leading migrations `2018-04-10-094800_dev_portal_consumer_types_statuses` and `2018-05-08-143700_consumer_dev_portal_columns` to fail
      - Automatically log users in after registering when auto-approve is on
      - Reduce the size of the mobile breakpoint
      - Improve performance and file sizes of bundled code
      - Fix issue causing Portal to list spec files twice
      - Swagger Improvements:
          - Fix for rendering OAS 3.0 spec files
          - Ensure that page loading isn't blocked by Swagger UI rendering

- **Plugins**
  - **LDAP Auth & LDAP Auth Advanced**
      - Fix an issue where a request would fail when the password field had more than 128 characters in length
      - Make the password part of the cache key, so that an invalid credential can be cached without blocking valid credentials
  - **Zipkin**
      - Fix operation when service and/or route are missing
      - Fix cause of missing kong.credential field
      - Support for deprecated Kong "api" entity via kong.api tag
  - **Rate Limiting Advanced Plugin**
      - Fix issue preventing the plugin to correctly propagate configuration changes across Kong Nginx workers
      - Fix issue preventing the plugin to load configuration and create sync timers
      - Fix plugin name in log messages
  - **Canary**
      - Fixed the type attribute for port configuration setting
  - **Forward Proxy**
      - Fix Kong core dependency causing the access phase handle to fail
  - **Proxy Cache**
      - Fix issue leading to cache key collision in some scenarios - e.g., for requests issued by the same consumer
      - Fix cache key for Routes and Services: previously, distinct routes/services entities would be given the same cache key

## 0.33
**Release Date:** 2018/07/24

### Notifications

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires PostgreSQL 9.5+
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

### Changes

- **Vitals**
  - Internal proxies are no longer tracked
  - Admin API endpoint `/vitals/consumers/:username_or_id/nodes`, deprecated in 0.32, has been removed
- **Prometheus Plugin**
  - The plugin uses a dedicated shared dictionary. If you use a custom template, define the following for Prometheus:

    ```
    lua_shared_dict prometheus_metrics 5m;
    ```
- **OpenID Connect Plugin**
  - Change `config_consumer_claim` from string to array

### Features

- **Core**
  - **New RBAC implementation**, supporting both endpoint and entity-level
  access control - read the docs [here][rbac-overview]
  - **Workspaces**, allowing segmentation of Admin API entities - read the docs
  [here][workspaces-overview]. Note that workspaces are available in the API only,
  and not in the Admin GUI
- **Admin GUI**
  - Log in to the Admin GUI using Kong's own authentication plugins; supported
  plugins are key-auth, basic-auth, and ldap-auth-advanced.  Use of other
  authentication plugins has not been tested.
  - Add ability to see what plugins are configured on a consumer
- **Dev Portal**
  - Revoked Dev Portal Users/Consumers are blocked at proxy
  - Files API Improvements
  - File editor in Admin GUI
  - Consumer API usage on Dev Portal user area
- **OpenID Connect Plugin**
  - Add `config.consumer_optional`
  - Add `config.token_endpoint_auth_method`
  - Add `consumer.status` check for internal authentication
- **Forward Proxy Plugin**
  - Add support for delayed response
  - Add `via` header
- **Canary Plugin**
  - Added whitelist and blacklist options to be able to select consumers instead of having random consumers
  - Added a port parameter to be able to be set a new port for the alternate upstream
- **LDAP Auth Advanced**
  - Find consumers by `consumer_by` fields and map to ldap-auth user. This will set the authenticated consumer so that `X-Consumer-{ID, USERNAME, CUSTOM_ID}` headers are set and consumer functionality is available
  - Add fields
      - `consumer_by`: optional, default: `{username, custom_id}`
      - `consumer_optional`: optional, default: `false`
- **StatsD Plugin**
  - New plugin; see documentation [here][statsd-docs]
- **Prometheus Plugin**
  - New plugin; see documentation [here][prometheus-docs]

### Fixes

- **Core**
  - **Healthchecks**: health status no longer resets when a Target is added to an Upstream
  - **Runloop**: properly throw errors from plugins fetch
  - **DB**: fix double-wraping of `err_t` strategy error
- **Plugins**
  - Azure delayed response
  - Lambda delayed response
  - Request Termination delayed response
- **Admin GUI**
  - Fix a problem where a plugin value cannot be unset
  - Fix a problem where error messages on the login screen fail to display
- **Portal**
  - Auto-approve messaging
- **OpenID Connect Plugin**
  - Fix `kong_oauth2` `auth_method` so that it works without having to also add bearer or introspection to `config.auth_method`
  - Fix `ngx.ctx.authenticated_credential` so that it isn't set when a value with `config.credential_claim` isn't found
- **Zipkin Plugin**
  - Fix an issue with how timestamps can sometimes be encoded with scientific notation, causing the Zipkin collector to refuse some traces
- **LDAP Auth Advanced Plugin**
  - Fix require statements pointing to Kong CE's version of the plugin
  - Fix usage of the LuaJIT FFI, where an external symbol was not accessed properly, resulting in an Internal Server Error
- **Rate Limiting Advanced Plugin**
  - Fix an issue in Cassandra migrations that would stop the migration process
  - Allow existing plugin configurations without a value for the recently-introduced introduced `dictionary_name` field to use the default dictionary for the plugin - `kong_rate_limiting_counters`.
  - Customers using a custom Nginx template are advised to check if such a dictionary is defined in their template:

    ```
    lua_shared_dict kong_rate_limiting_counters 12m;
    ```
<hr/>

## 0.32
**Release Date:** 2018/05/24

### Notifications

- **Kong EE 0.32** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.32** has these notices from **Kong CE 0.13**:
  - Support for **PostgreSQL 9.4 has been removed** - starting with 0.32, Kong Enterprise will not start with PostgreSQL 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires PostgreSQL 9.5+
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: The `latest` tag in Kong Enterprise Docker repository changed from CentOS to Alpine - which might result in breakage if additional packages are assumed to be in the image, as the Alpine image only contains a minimal set of packages installed
- **OpenID Connect**
  - The plugins listed below were deprecated in favor of the all-in-one openid-connect plugin:
      - `openid-connect-authentication`
      - `openid-connect-protection`
      - `openid-connect-verification`

### Changes

- **New Data Model** - Kong EE 0.32 is the first Enterprise version including the [**new model**](https://github.com/Kong/kong/blob/master/CHANGELOG.md#core-2), released with Kong CE 0.13, which includes Routes and Services
- **Rate Limiting Advanced**
  - **Breaking** - the Enterprise Rate Limiting plugin, named `rate-limiting` up to EE 0.31, was renamed `rate-limiting-advanced` and CE Rate Limiting was imported as `rate-limiting`. Any Admin API calls that were previously targeting the Enterprise Rate Limiting plugin in Kong EE up to 0.31 need to be updated to target `rate-limiting-advanced`
  - Rate Limiting Advanced, similarly to CE rate-limiting, now uses a dedicated shared dictionary named `kong_rate_limiting_counters` for its counters; if you are using a custom template, make sure to define the following shared memory zones:

    ```
    lua_shared_dict kong_rate_limiting_counters 12m;
    ```
- **Vitals**
  - Vitals uses two dedicated shared dictionaries. If you use a custom template, define the following shared memory zones for Vitals:

    ```
    lua_shared_dict kong_vitals_counters 50m;
    lua_shared_dict kong_vitals_lists     1m;
    ```
  You can remove any existing shared dictionaries that begin with `kong_vitals_`, e.g., `kong_vitals_requests_consumers`
- **OpenID Connect**
  - Remove multipart parsing of ID tokens - they were not proxy safe
  - Change expired or non-active access tokens to give `401` instead of `403`

### Features

- **Admin GUI**
  - New Listeners (Admin GUI + Developer Portal)
  - Routes and Services GUI
  - New Plugins thumbnail view
  - Healthchecks GUI
  - Syntax for form-encoded array elements
  - Dev Portal Overview tab
  - Developers management tab
- **Vitals**
  - **Status Code** tracking - GUI and API
      - Status Code groups per Cluster - counts of `1xx`, `2xx`, `3xx`, `4xx`, `5xx` groups across the cluster over time. Visible in the Admin GUI at `ADMIN_URL/vitals/status-codes`
      - Status Codes per Service - count of individual status codes correlated to a particular service. Visible in the Admin GUI at `ADMIN_URL/services/{service_id}`
      - Status Codes per Route - count of individual status codes correlated to a particular route. Visible in the Admin GUI at `ADMIN_URL/routes/{route_id}`
      - Status Codes per Consumer and Route - count of individual status codes returned to a given consumer on a given route.  Visible in the Admin GUI at `ADMIN_URL/consumers/{consumer_id}`
- **Dev Portal**
  - Code Snippets
  - Developer "request access" full life-cycle
  - Default Dev Portal included in Kong distributions (with default theme)
  - Authentication on Dev Portal out of box (uncomment in Kong.conf)
  - Docs for Routes/Services for Dev Portal
  - Docs for Admin API
  - **Requires Migration** - `/files` endpoint is now protected by RBAC
- **Plugins**
  - **Rate Limiting Advanced**: add a `dictionary_name` configuration, to allow using a custom dictionary for storing counters
  - **Requires Migration - Rate Limiting CE** is now included in EE
  - **Request Transformer CE** is now included in EE
  - **Edge Compute**: plugin-based, Lua-only preview
  - **Proxy Cache**: Customize the cache key, selecting specific headers or query params to be included
  - **Opentracing Plugin**: Kong now adds detailed spans to Zipkin and Jaeger distributed tracing tools
  - **Azure Functions Plugin**: Invoke Azure functions from Kong
  - **LDAP Advanced**: LDAP plugin with augmented ability to search by LDAP fields
- **OpenID Connect**
  - Add `self_check` function to validate that OIDC discovery information can be downloaded
  - Bearer token is now looked up on `Access-Token` and `X-Access-Token` headers in addition to Authorization Bearer header (query and body args are supported as before)
  - JWKs are rediscovered and the new keys are cached cluster wide (works better with keys rotation schemes)
  - Admin API does self-check for discovery endpoint when the plugin is added and reports possible errors back
  - Add configuration directives
      - `config.extra_jwks_uris`
      - `config.credential_claim`
      - `config.session_storage`
      - `config.session_memcache_prefix`
      - `config.session_memcache_socket`
      - `config.session_memcache_host`
      - `config.session_memcache_port`
      - `config.session_redis_prefix`
      - `config.session_redis_socket`
      - `config.session_redis_host`
      - `config.session_redis_port`
      - `config.session_redis_auth`
      - `config.session_cookie_lifetime`
      - `config.authorization_cookie_lifetime`
      - `config.forbidden_destroy_session`
      - `config.forbidden_redirect_uri`
      - `config.unauthorized_redirect_uri`
      - `config.unexpected_redirect_uri`
      - `config.scopes_required`
      - `config.scopes_claim`
      - `config.audience_required`
      - `config.audience_claim`
      - `config.discovery_headers_names`
      - `config.discovery_headers_values`
      - `config.introspect_jwt_tokens`
      - `config.introspection_hint`
      - `config.introspection_headers_names`
      - `config.introspection_headers_values`
      - `config.token_exchange_endpoint`
      - `config.cache_token_exchange`
      - `config.bearer_token_param_type`
      - `config.client_credentials_param_type`
      - `config.password_param_type`
      - `config.hide_credentials`
      - `config.cache_ttl`
      - `config.run_on_preflight`
      - `config.upstream_headers_claims`
      - `config.upstream_headers_names`
      - `config.downstream_headers_claims`
      - `config.downstream_headers_names`

### Fixes

- **Core**
  - **Healthchecks**
      - Fix an issue where updates made through `/health` or `/unhealth` wouldn't be propagated to other Kong nodes
      - Fix internal management of healthcheck counters, which corrects detection of state flapping
  - **DNS**: a number of fixes and improvements were made to Kong's DNS client library, including:
      - The ring-balancer now supports `targets` resolving to an SRV record without port information (`port=0`)
      - IPv6 nameservers with a scope in their address (For example, `nameserver fe80::1%wlan0`) will now be skipped instead of throwing errors
- **Rate Limiting Advanced**
  - Fix `failed to upsert counters` error
  - Fix issue where an attempt to acquire a lock would result in an error
  - Mitigate issue where lock acquisitions would lead to RL counters being lost
- **Proxy Cache**
  - Fix issue where proxy-cache would short-circuit requests that resulted in a cache hit, not allowing subsequent plugins - e.g., logging plugins - to run
  - Fix issue where PATCH requests would result in a 500 response
  - Fix issue where Proxy Cache would overwrite X-RateLimit headers
- **Request Transformer**
  - Fix issue leading to an Internal Server Error in cases where the Rate Limiting plugin returned a 429 Too Many Requests response
- **AWS Lambda**
  - Fix issue where an empty array `[]` was returned as an empty object `{}`
- **Galileo - DEPRECATED**
  - Fix issue that prevented Galileo from reporting requests that were cached by proxy-cache
  - Fix issue that prevented Galileo from showing request/response bodies of requests served by proxy-cache
- **OpenID Connect**
  - Fix `exp` retrieval
  - Fix `jwt_session_cookie` verification
  - Fix consumer mapping using introspection where the claim was searched in an inexistent location
  - Fix header values when their callbacks fail to get the value - instead of setting their values as `function ...`
  - Fix `config.scopes` when set to `null` or `""` so that it doesn't add an OpenID scope forcibly, as the plugin is not only OpenID Connect only, but also OAuth2
<hr/>

## 0.31-1
**Release Date:** 2018/04/25

### Changes

- New shared dictionaries named `kong_rl_counters` and `kong_db_cache_miss` were defined in Kong’s default template - customers using custom templates are encouraged to update them to include those, as they avoid the reuse of the `kong_cache` shared dict; such a reuse is known to be one of the culprits behind `no memory` errors - see diff below
- The rate-limiting plugin now accepts a `dictionary_name` argument, which is used for temporarily storing rate-limiting counters

*NOTE*: if you use a custom Nginx configuration template, apply the following patch to your template:

```
diff --git a/kong/templates/nginx_kong.lua b/kong/templates/nginx_kong.lua
index 15682975..653a7ddd 100644
--- a/kong/templates/nginx_kong.lua
+++ b/kong/templates/nginx_kong.lua
@@ -29,7 +29,9 @@ lua_socket_pool_size ${{LUA_SOCKET_POOL_SIZE}};
 lua_max_running_timers 4096;
 lua_max_pending_timers 16384;
 lua_shared_dict kong                5m;
+lua_shared_dict kong_rl_counters   12m;
 lua_shared_dict kong_cache          ${{MEM_CACHE_SIZE}};
+lua_shared_dict kong_db_cache_miss 12m;
 lua_shared_dict kong_process_events 5m;
 lua_shared_dict kong_cluster_events 5m;
 lua_shared_dict kong_vitals_requests_consumers 50m;
```

### Fixes

- Bump mlcache to 2.0.2 and mitigates a number of issues known to be causing `no memory` errors
- Fixes an issue where boolean values (and boolean values as strings) were not correctly marshalled when using Cassandra
- Fixes an issue in Redis Sentinel configuration parsing

## 0.31
**Release Date:** 2018/03/16

Kong Enterprise 0.31 is shipped with all the changes present in Kong Community Edition 0.12.3, as well as with the following additions:

### Changes
- Galileo plugin is disabled by default in this version, needing to be explicitly enabled via the custom_plugins configuration
  - *NOTE*: If a user had the Galileo plugin applied in an older version and migrate to 0.31, Kong will fail to restart unless the user enables it via the [custom_plugins](/gateway-oss/latest/configuration/#custom_plugins) configuration; however, it is still possible to enable the plugin per API or globally without adding it to custom_plugins
- OpenID Connect plugin:
  - Change `config.client_secret` from `required` to `optional`
- Change `config.client_id` from `required` to `optional`
- If `anonymous` consumer is not found Internal Server Error is returned instead of Forbidden
- **Breaking Change** - `config.anonymous` now behaves similarly to other plugins and doesn't halt execution or proxying (previously it was used just as a fallback for consumer mapping) and the plugin always needed valid credentials to be allowed to proxy if the client wasn't already authenticated by higher priority auth plugin
- Anonymous consumer now uses a simple cache key that is used in other plugins
- In case of auth plugins concatenation, the OpenID Connect plugin now removes remnants of anonymous

### Fixes
- **Admin GUI**
  - Remove deprecated orderlist field from Admin GUI Upstreams entity settings
  - Fix issue where Admin GUI would break when running Kong in a custom prefix
  - Fix issue where Healthchecks had a field typed as number instead of string.
  - Fix issue where Healthchecks form had incorrect default values.
  - Fix issue where table row text was overflowing and expanding the page.
  - Fix issue where notification bar in mobile view could have text overflow beyond the container.
  - Fix issue where deleting multiple entities in a list would cause the delete modal to not show.
  - Fix issue where cards on the dashboard were not evenly sized and spaced.
  - Fix issue where cards on the dashboard in certain widths could have text overflow beyond their container.
  - Fix issue where Array's on Plugin Entities were not being processed and sent to the Admin API.
  - Fix issue where Models were improperly handled when not updated and not sending default values properly.
  - Fix issue where Plugin lists were not displaying config object.
  - Fix issue where Kong was not processing SSL configuration for Admin GUI

- **OpenID Connect plugin**
  - Fixed anonymous consumer mapping

- **Vitals**

  - Correct the stats returned in the "metadata" attribute of the /vitals/consumers/:consumer_id/* endpoints
  - Correct a problem where workers get out of sync when adding their data to cache
  - Correct inconsistencies in chart axes when toggling between views or when Kong has no traffic

- **Proxy Cache**
  - Fix issue that prevented cached requests from showing up in Vitals or Total Requests graphs
  - Fixes inherited from Kong Community Edition 0.12.3.

### Features
- Admin GUI
  - Add notification bar alerting users that their license is about to expire, and has expired.
  - Add new design to vitals overview, table breakdown, and a new tabbed chart interface.
  - Add top-level vitals section to the sidebar.

- Requires migration - Vitals
  - New datastore support: Cassandra 2.1+
  - Support for averages for Proxy Request Latency and Upstream Latency

- Requires migration - Dev Portal
  - Not-production-ready feature preview of:
    - "Public only" Portal - no authentication (the portal is fully accessible to anyone who can access it)
    - Authenticated Portal - Developers must log in, and then they can see what they are entitled to see
<hr/>

## 0.30
**Release Date:** 2018/01/24

Kong Enterprise 0.30 is shipped with all the changes present in [Kong Community Edition 0.12.1](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0121---20180118), as well as with the following additions:

### Notifications

- EE 0.30 inherits dependency **deprecation** notices from CE 0.12. See the "Deprecation Notes" section of Kong 0.12.0 changelog
- ⚠️ By default, the Admin API now only listens on the local interface. We consider this change to be an improvement in the default security policy of Kong. If you are already using Kong, and your Admin API still binds to all interfaces, consider updating it as well. You can do so by updating the `admin_listen` configuration value, like so: `admin_listen = 127.0.0.1:8001`.

- 🔴 Note to Docker users: Beware of this change as you may have to ensure that your Admin API is reachable via the host's interface. You can use the `-e KONG_ADMIN_LISTEN` argument when provisioning your container(s) to update this value; for example, `-e KONG_ADMIN_LISTEN=0.0.0.0:8001`.

### Changes
- **Renaming of Enterprise plugin**
  - `request-transformer` becomes `request-transformer-advanced`

- **Rate-limiting** plugin
  - Change default `config.identifier` in EE's from `ip` to `consumer`

- **Vitals**
  - Aggregate minutes data at the same time as seconds data
  - **Breaking Change:** Replace previous Vitals API (part of the Admin API) with new version. **Not backwards compatible.**
  - **Upgrading from Kong EE (0.29) will result in the loss of previous Vitals data**

- **Admin GUI**
  - Vitals chart settings stored in local storage
  - Improve vital chart legends
  - Change Make A Wish email to <a href="mailto:wish@konghq.com`>wish@konghq.com</a>

- **OpenID Connect Plugins**
  - Change `config.login_redirect_uri` from `string` to `array`
  - Add new configuration parameters
    - config.authorization_query_args_client
    - config.client_arg
    - config.logout_redirect_uri
    - config.logout_query_arg
    - config.logout_post_arg
    - config.logout_uri_suffix
    - config.logout_methods
    - config.logout_revoke
    - config.revocation_endpoint
    - config.end_session_endpoint

- **OpenID Connect Library**
  - Function `authorization:basic` now return as a third parameter, the grant type if one was found - previously, it returned parameter location in HTTP request
  - Issuer is no longer verified on discovery as some IdPs report different value (it is still verified with claims verification)

**Added**

- New **Canary Release plugin**

- Vitals
  - Addition of "node-specific" dimension for previously-released metrics (Kong Request Latency and Datastore Cache)
  - New metrics and dimensions:
    - **Request Count per Consumer**, by Node or Cluster
    - **Total Request Count**, by Node or Cluster
    - **Upstream Latency** (the time between a request being sent upstream by Kong, and the response being received by Kong), by Node or Cluster
  - All new metrics and dimensions accessible in **Admin GUI and API**
  - **Important limitations and notifications:**
    - PostgreSQL 9.5+ only - no Cassandra support yet
    - Upgrading from the previous version of Kong EE will result in all historic Vitals data being dropped
    - The previous Vitals API (which is part of the Admin API) is replaced with a new, better one (the old API disappears, and there is no backwards compatibility)

  - **Proxy Cache**
    - Implement Redis (stand-alone and Sentinel) caching of proxy cache entities

  - **Enterprise Rate Limiting**
    - Provide **fixed-window** quota rate limiting (which is essentially what the CE rate-limiting plugin does) in addition to the current sliding window rate limiting
    - Add *hide_client_headers* configuration to disable response headers returned by the rate limiting plugin

  - **Admin GUI**
    - Addition of **"Form Control Grouping"** for the new Upstream health-check configuration options.
    - Add **Healthy** or **Unhealthy** buttons for the new health-check functionality on Upstream Targets table.
    - Add **Hostname** and **Hostname + Id** reporting and labeling functionality to Vitals components.
    - Add **Total Requests per Consumer** chart to individual consumer pages.
    - Add **Total Requests** and **Upstream Latency** charts to the Vitals page.
    - Add information dialogs for vital charts next to chart titles.
    - Introduced **Total Requests** chart on Dashboard.
    - Automatically saves chart preferences and restores on reload.

  - **OpenID Connect plugins**
    - Support passing dynamic arguments to authorization endpoint from client
    - Support logout with optional revocation and RP-initiated logout

  - Features inherited from [Kong Community Edition 0.12.0](https://github.com/Kong/kong/blob/master/CHANGELOG.md#added) - includes:
    - Health checks
    - Hash-based load balancing
    - Logging plugins track unauthorized and rate-limited requests
    - And more...

### Fixes
- **Proxy Cache**
  - Better handling of input configuration data types. In some cases configuration sent from the GUI would case requests to be bypassed when they should have been cached.

- **OAuth2 Introspection**
  - Improved error handling in TCP/HTTP connections to the introspection server.

- **Vitals**
  - Aggregating minutes at the same time as seconds are being written.
  - Returning more than one minute's worth of seconds data.

- **Admin GUI**
  - Input type for Certificates is now a text area box.
  - Infer types based on default values and object type from the API Schema for Plugins.

- Fixes inherited from Kong Community Edition 0.12.0.

---

[rbac-overview]: /gateway/latest/production/access-control/enable-rbac/
[workspaces-overview]: /gateway/latest/kong-enterprise/workspaces/
[statsd-docs]: /hub/kong-inc/statsd/
[prometheus-docs]: /hub/kong-inc/prometheus/
