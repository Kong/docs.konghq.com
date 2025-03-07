---
title: Kong Gateway Changelog Archive
no_version: true
---

<!-- vale off -->

This changelog covers Kong Gateway versions that have reached end of sunset support.
For archives of versions before 2.6, see the [Kong Gateway Enterprise changelog](/enterprise/changelog/).

Looking for recent releases? See [https://docs.konghq.com/gateway/changelog/](https://docs.konghq.com/gateway/changelog/) for the latest changes.

Archives:
- [Kong Gateway 3.x](#kong-gateway-3x)
- [Kong Gateway 2.x](#kong-gateway-2x)

## Kong Gateway 3.x

Archived Kong Gateway versions in the 3.x series.


## 3.2.2.5
**Release Date** 2023/10/12

### Fixes
#### Core

* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487). 
  
  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.
* Fixed a keyring issue where Kong Gateway nodes would fail to send keyring 
data when using the cluster strategy.
* Fixed an issue where an abnormal socket connection would be incorrectly reused when querying the PostgreSQL database.
* Added a `User=` specification to the systemd unit definition, enabling Kong Gateway to be controlled by systemd again.
  [#11066](https://github.com/Kong/kong/pull/11066)

#### Plugins
* [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`): Fixed an issue that caused the plugin to cache network failures when running certificate revocation checks.

* [**SAML**](/hub/kong-inc/saml/) (`saml`): Users will now receive a 500 error instead of being endlessly redirected when the Redis session storage is incorrectly configured.

### Dependencies

* Bumped `libxml2` from 2.10.2 to 2.11.5

## 3.2.2.4
**Release Date** 2023/09/15

### Breaking changes and deprecations

* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.2.2.4, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

    If you need to install Kong Gateway on Ubuntu 18.04, substitute a previous 3.2.x 
    patch version in the [installation instructions](/gateway/3.2.x/install/linux/ubuntu/).
- Amazon Linux 2022 artifacts are renamed to Amazon Linux 2023, based on AWS's own renaming.
- CentOS packages are now removed from the release and are no longer supported in future versions.

### Fixes
#### Enterprise

* Updated the datafile library to make the SAML plugin work again when Kong is controlled by systemd.
* Fixed an issue where the anonymous report couldn't be silenced by setting `anonymous_reports=false`.
* Fixed an issue where a crashing Go plugin server process would cause subsequent requests proxied through Kong to execute Go plugins with inconsistent configurations. The issue only affected scenarios where the same Go plugin is applied to different route or service entities. 

#### Plugins

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Correctly set the right table key on `log` and `message`.
  * If an invalid opaque token is provided but verification fails, print the correct error.
* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * The redis rate limiting strategy now returns an error when Redis Cluster is down.
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * The control plane no longer attempts to create namespace or synchronize counters with Redis.
* [**Response Transformer Advanced**](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Does not load response body when `if_status` does not match.
    

#### Kong Manager

* Fixed an issue where the Zipkin plugin prevented users from editing the `static_tags` configuration.
* Fixed an issue where the unavailable Datadog Tracing plugin displayed on the plugin installation page.
* Fixed an issue where some metrics were missing from the StatsD plugin.
* Fixed an issue where locale files were not found when using a non-default `admin_gui_path` configuration.
* Fixed an issue where endpoint permissions for application instances did not work as expected.
* Fixed an issue where some icons were shown as unreadable symbols and characters.
* Fixed an issue where users were redirected to pages under the default workspace when clicking links for services or routes of entities residing in other workspaces.
* Fixed an issue that failed to redirect OpenID Connect in Kong Manager if it was provided with an incorrect username.

### Dependencies

* `lua-resty-kafka` is bumped from 0.15 to 0.16
* Bumped `OpenSSL` from 1.1.1t to 3.1.1


## 3.2.2.3 
**Release Date** 2023/06/07

### Fixes
* Fixed an error with the `/config` endpoint. If `flatten_errors=1` was set and an invalid config was sent to the endpoint, a 500 error was incorrectly returned.

### Deprecations
* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

## 3.2.2.2
**Release Date** 2023/05/19

### Fixes

#### Core 
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  led to the corruption of chunk-encoded response data.
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
* Due to changes in GPG keys, using yum to install this release triggers a `Public key for kong-enterprise-edition-3.2.1.0.rhel7.amd64.rpm is not installed` error. The package *is* signed, however, it's signed with a different (rotated) key from the metadata service, which triggers the error in yum. To avoid this error, manually download the package from [{{site.links.download}}]({{site.links.download}}) and install it. 

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

* Changed the underlying operating system (OS) for our convenience Docker tags (for example, `latest`, `3.2.1.0`, `3.2`) from Debian to Ubuntu.

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
    * Split the plugin compatibility table into a [technical compatibility page](/hub/plugins/compatibility/) and a [license tiers](/hub/plugins/license-tiers/) page. 
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

## 3.1.1.6
**Release Date** 2023/10/12

### Fixes

#### Core
* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.

### Dependencies

* Bumped `libxml2` from 2.10.2 to 2.11.5

## 3.1.1.5 
**Release Date** 2023/08/25

### Features

* The Redis strategy of Rate Limiting now catches connection failures.
* Added the parameter `admin_auto_create` for automatically creating a Kong admin.
* Kong Manager supports the `POST` response method for OIDC based authentication

### Fixes 
#### Enterprise

* Fixed an issue with the plugin iterator where sorting would become mixed up when dynamic reordering was applied. This fix ensures proper sorting behavior in all scenarios.
* Fixed an issue where `resty.dns.client` leaked UDP sockets. 
* Fixed a bug where setting `anonymous_reports=false` would not silence anonymous reports.
* Fixed an issue with hybrid mode where vitals and analytics could not communicate through the cluster telemetry endpoint.
* Fixed the HTTP2 request handle in ARM artifacts.
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  led to the corruption of chunk-encoded response data. [#10816](https://github.com/Kong/kong/pull/10816)[#10824](https://github.com/Kong/kong/pull/10824)
* Fixed an issue where a crashing Go plugin server process would cause subsequent requests proxied through Kong to execute Go plugins with inconsistent configurations. The issue only affects scenarios where the same Go plugin is applied to different route or service entities.
* Fixed the Dynatrace implementation.

**Kong Manager**:
* Fixed an issue where configuration links would redirect users to the default workspace.
* Fixed an issue with Kong Manager when using OpenID Connect where passing invalid credentials was not resulting in a redirect. 

#### Plugins 
* Request Transformer Advanced: Fixed an issue that was causing some requests to be proxied with the wrong query parameters.
* Response Transformer Advanced: Fixed an issue where large decimals were rounded when the plugin was being used.
* Rate Limiting Advanced: 
  * Fixed an issue where the control plane was trying to sync the rate-limiting-advanced counters with Redis.
  * Fixed an issue where the `rl cluster_events` broadcasted the wrong data in traditional cluster mode.
* Oauth2: Fixed a bug that `refresh_token` could be shared across instances.

### Dependencies

* Bumped `OpenSSL` from 1.1.1t to 3.1.1
* Bumped`lua-resty-openssl` from 0.8.15 to 0.8.22
* Bumped `lua-resty-kafka` from 0.15 to 0.16



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
  led to the corruption of chunk-encoded response data.
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


## Kong Gateway 2.x

Archived Kong Gateway versions in the 2.x series from 2.6 and later. 
For earlier versions, see the [Kong Gateway Enterprise archive changelog](/enterprise/changelog/).

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
