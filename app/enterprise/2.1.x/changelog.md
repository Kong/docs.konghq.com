---
title: Kong Gateway Changelog
---

<!-- vale off -->

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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
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
- [ACME](/hub/kong-inc/acme) (`acme`) (updated to v0.2.14)
  - Bump `lua-resty-acme` to v0.6.x; this fixes several issues with Pebble test server.
- [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  - HS-signature verification is now disabled by default.
  - Changed to use `client_secret` as a fallback secret for HS-signature verification only when it is a string and has more than one character in it.
  - Updated `lua-resty-session` dependency to 3.7.
- [JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
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
* [Mutual TLS Authentication](/hub/kong-inc/mtls-auth) (`mtls-auth`)
  * Ensure that the basic serializer generates the `request.tls.client_verify`
  field based on this module's validation result.
* [Request Validator](/hub/kong-inc/request-validator) (`request-validator`)
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

* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

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
