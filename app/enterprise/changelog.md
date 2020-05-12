---
title: Kong Enterprise Changelog
layout: changelog
---

## 1.5.0.2
**Release Date** 2020/04/28

### Fixes

#### Kong Gateway Community
* Fixed an issue where the frequent Target CRUD could result in a broken load balancer. 

#### Kong Manager
* Fixed the sorting order of Routes.
* Fixed an issue where editing a Developer meta field could cause the custom field name to revert to the default value.
* Fixed an issue where listing Developers and Files only showed the first page of results.

## 1.5.0.1
**Release Date:** 2020/04/16

### Fixes

#### Plugins
* Kong OpenID Connect Library
  * Changes  `client_secret_jwk ` and  `private_key_jwt ` to not pass the rfc7521 optional  `client_id ` as it was causing a problem with Okta.
* OpenID Connect
  * Fixes `openid_connect/jwks` to not use `err_t` with JWKS custom DAO that is not returning the `err_t`.
  * Fixes JWKS custom DAO to not return cache hit level as a third return value on errors. Previously, it was sometimes inaccurately treated as `err_t`.
  * Adds a teardown migration to create the `oic_jwks` row, so that it is not needed to create on init_worker.
* Request Transformer Advanced
  * Fixes bug when adding a header with the same name as a removed one.
  * Improves performance by not inheriting from the BasePlugin class.
  * Converts the plugin away from deprecated functions.
 

## 1.5.0.0
**Release Date:** 2020/04/09

### Features

#### Kong Gateway Community 

* Includes open-source features contained in Kong Gateway Community 1.4 and 1.5 releases, with the exception that Kong Enterprise does not support running on ARM processors at this time.

#### Kong Manager
* Redesigned Service and Route pages to support Immunity Alerts
* Services, Routes, Consumers, and other entity lists are sortable
* Services, Routes, Consumers, and other entities can be viewed and exported as JSON
* Consumer Alerts added to the Immunity Alerts page
* Approve, reject, and revoke Portal Application Service Contracts
* Associate Portal Specs with Services through Documents

#### Kong Developer Portal
* [**BETA**](https://docs.konghq.com/enterprise/latest/introduction/key-concepts/#beta): Developers can create Applications to consume Services using the Portal Application Registration plugin.

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

## 1.3.0.2
**Release Date:** 2020/02/20

### Features

#### Kong Gateway

* Adds support for Amazon Linux 2
* Compiles NGINX OpenTracing module with Kong (currently only available for Amazon Linux 2 and Docker Alpine)
  * Includes a Datadog tracer for Amazon Linux 2 at /usr/local/kong/lib/libdd_opentracing_plugin.so
  * Includes a Jaeger tracer for Docker Alpine at /usr/local/kong/lib/libjaegertracing.so
* Provides a default logrotate configuration file
* Adds support for `pg_ssl_required` configuration which prevents connection to non-SSL enabled Postgres server
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
* (Alpha feature) Kong Enterprise can now perform encryption-at-rest for sensitive fields within the data store (Postgres or Cassandra).

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

- Bugfixes in the router *may, in some edge-cases*, result in
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
  directives](https://konghq.com/blog/kong-ce-nginx-injected-directives/)
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
  specifications.  :warning: Note that not all Kong plugins are compatible with
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
  directives](https://konghq.com/blog/kong-ce-nginx-injected-directives/)
  (added to Kong 0.14.0) and specifies a few default ones.
  In future releases, we will gradually increase support for injected Nginx
  directives. We have high hopes that this will remove the occasional need for
  custom Nginx configuration templates.
  [#4382](https://github.com/Kong/kong/pull/4382)
- New configuration properties allow for controling the behavior of
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
- [kubernetes-sidecar-injector](https://github.com/Kong/kubernetes-sidecar-injector):
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
- Request Transformer Advanced - Support for filtering JSON body with new configration `config.whitelist.body`
- Response Transformer Advanced:
    - Support for filtering JSON body with new configration config.whitelist.body, Support arbitrary transformations via Lua functions
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
    - authenticated_group_by config to block/allow validated certificate using ACL plugi
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
    - Change verification JWT header's typ claim by adding support for at+jwtthat for example IdentityServer4
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
  field mandtory durin `PATCH` request.
  - Fixes an issue where unique fields of entites are not migrated properly when
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
- New option in `kong.conf`: `pg_schema` to specify Postgres schema
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
- Adds support for [`db_cache_warmup_entities`](/enterprise/0.36-x/property-reference/#db_cache_warmup_entities),
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
`config.redis.sentinel_addresses`) for counters datastore. Validation
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
  credentials for a session. See the [**Session Plugin**](/hub/kong-inc/sessions)
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
  credentials for a session. See the [**Session Plugin**](/hub/kong-in/sessions)
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
    [**Vault Auth**](/hub/kong-inc/vault-auth) for details.
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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon

### Changes
- **Kong Manager**
  - Email addresses are stored in lower-case. These addresses must be case-insensitively unique. In previous versions, you could store mixed case email addresses. A migration for Postgres converts all existing email addresses to lower case. Cassandra users should review the email address of their admins and developers and update them to lower-case if necessary. Use the Kong Manager or the Admin API to make these updates.
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
  - Bugfixes, updates, and template features will be pushed here regularly and independently of the EE release cycle.
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
  - KONG_PORTAL_AUTH_CONF param values can now handle escaped
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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
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
    - Ensure ScyllaDB compatibility in Cassandra migraton
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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
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
    | Helpful articles on customizing your Developer Portal:
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/introduction/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/getting-started/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/understand/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/customization/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/authentication/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/faq/
    |
    |--------------------------------------------------------------------------
    |
    --}}

    {{!-- Custom fonts --}}
    {{!-- <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css" rel="stylesheet"> --}}

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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
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
      - Remove dependency on "public" schema or "pg_default" tablespaces in Postgres - such a dependency would cause migrations to fail if such tablespaces weren't being used
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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires Postgres 9.5+
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
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise will not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires Postgres 9.5+
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
      - IPv6 nameservers with a scope in their address (eg. `nameserver fe80::1%wlan0`) will now be skipped instead of throwing errors
- **Rate Limiting Advanced**
  - Fix `failed to upsert counters` error
  - Fix issue where an attempt to acquire a lock would result in an error
  - Mitigate issue where lock acquisitions would lead to RL counters being lost
- **Proxy Cache**
  - Fix issue where proxy-cache would shortcircuit requests that resulted in a cache hit, not allowing subsequent plugins - e.g., logging plugins - to run
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
  - *NOTE*: If a user had the Galileo plugin applied in an older version and migrate to 0.31, Kong will fail to restart unless the user enables it via the [custom_plugins](/latest/configuration/#custom_plugins) configuration; however, it is still possible to enable the plugin per API or globally without adding it to custom_plugins
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
    - "Public only" Portal - no authentication (eg. the portal is fully accessible to anyone who can access it)
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

[rbac-overview]: /enterprise/0.33-x/rbac/overview
[workspaces-overview]: /enterprise/0.33-x/workspaces/overview
[statsd-docs]: /enterprise/0.33-x/plugins/statsd-advanced
[prometheus-docs]: /plugins/prometheus
