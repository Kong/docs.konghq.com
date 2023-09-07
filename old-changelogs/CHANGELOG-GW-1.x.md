<!-- vale off -->

# Kong Gateway Changelog 1.x

This changelog covers 1.x versions that have reached end of sunset support.

Looking for recent releases? See [https://docs.konghq.com/gateway/changelog/](https://docs.konghq.com/gateway/changelog/) for the latest changes.

Archives:
- [Gateway 0.x](/old-changelogs/CHANGELOG-GW-0.x.md)
- [Gateway 2.x](/old-changelogs/CHANGELOG-GW-2.x.md) (2.0.x-2.5.x)

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
