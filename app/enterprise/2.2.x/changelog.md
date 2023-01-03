---
title: Kong Gateway Changelog
---

<!-- vale off -->

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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
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
- [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
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
- [AWS Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  - The plugin now respects `skip_large_bodies` config setting when using AWS API Gateway compatibility.
- [ACME](/hub/kong-inc/acme) (`acme`)
  - Bump `lua-resty-acme` to v0.6.x; this fixes several issues with Pebble test server.
- [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
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
- [Mutual TLS Authentication](/hub/kong-inc/mtls-auth) (`mtls-auth`)
  - Fixed (log) updating auth errors to handle fallthrough scenarios.
  - Fixed (route, ws) ensuring workspace options are used for cache lookups.
- [Forward Proxy Advanced](/hub/kong-inc/forward-proxy)(`forward-proxy`)
  - Fixed an issue where PDK logging phase check causes an error.
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  - Bumped `lua-resty-session` dependency to 3.8 to allow passing connection options to redis cluster client.
- [Session](/hub/kong-inc/session) (`session`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  - Added `config.enable_hs_signatures` (`false` is the default).
  - Added `config.session_compressor`.
- [JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
  - Added `config.enable_hs_signatures` (`false` is the default).
- [AWS Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  - Added support for `isBase64Encoded` flag in Lambda function responses.
- [gRPC-Web](/hub/kong-inc/grpc-web) (`grpc-web`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  - HS-signature verification is now disabled by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Updated `lua-resty-session` dependency to 3.7.
- [JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
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
    OpenResty from source, you must still apply Kong's <a href="https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/openresty-patches">
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
- [AWS Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  - Bumped to version 3.5.0.
  [#6379](https://github.com/Kong/kong/pull/6379)
  - Added support for the `isBase64Encoded` flag in Lambda function responses.
- [gRPC Web](/hub/kong-inc/grpc-web) (`grpc-web`)
  - Introduced the configuration parameter `pass_stripped_path`, which, if set
  to true, causes the plugin to pass the stripped request path (see the
  [`strip_path`](/enterprise/latest/admin-api/#route-object) Route attribute)
  to the upstream gRPC service.
- [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`)
  - Added support for rate limiting by path using the `limit_by = "path"`
  configuration attribute. Thanks [KongGuide](https://github.com/KongGuide) for
  the patch!
  [#6286](https://github.com/Kong/kong/pull/6286)
- [Correlation ID](/hub/kong-inc/correlation-id) (`correlation-id`)
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
