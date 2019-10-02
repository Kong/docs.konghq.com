---
title: Kong Enterprise
layout: docs
---

## Kong Enterprise  1.3-α Release Notes
**Private Alpha Release Date:** 2019/10/02

### Kong Gateway
- **Kong Enterprise 1.3-α** inherits the following changes from **Kong Gateway 1.3**:

#### Changes

###### Dependencies

- The required OpenResty version has been bumped to
  [1.15.8.1](http://openresty.org/en/changelog-1015008.html). If you are
  installing Kong from one of our distribution packages, you are not affected
  by this change. See [#4382](https://github.com/Kong/kong/pull/4382).
  With this new version comes a number of improvements:
  1. The new [ngx\_http\_grpc\_module](https://nginx.org/en/docs/http/ngx_http_grpc_module.html).
  2. Configurable of upstream keepalive connections by timeout or number of
     requests.
  3. Support for ARM64 architectures.
  4. LuaJIT GC64 mode for x86_64 architectures, raising the LuaJIT GC-managed
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

###### Core

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

###### Configuration

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

#### Additions

##### Core

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

##### Configuration

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

##### Admin API

- Many endpoints now support more levels of nesting for ease of access.
  For example: `/services/:services/routes/:routes` is now a valid API
  endpoint.
  [#4713](https://github.com/Kong/kong/pull/4713)
- The API now accepts `form-urlencoded` payloads with deeply nested data
  structures. Previously, it was only possible to send such data structures
  via JSON payloads.
  [#4768](https://github.com/Kong/kong/pull/4768)

##### Plugins

- jwt-auth: The new `header_names` property accepts an array of header names
  the JWT plugin should inspect when authenticating a request. It defaults to
  `["Authorization"]`.
  [#4757](https://github.com/Kong/kong/pull/4757)
- [azure-functions](https://github.com/Kong/kong-plugin-azure-functions):
  Bumped to 0.4 for minor fixes and performance improvements.
- [kubernetes-sidecar-injector](https://github.com/Kong/kubernetes-sidecar-injector):
  The plugin is now more resilient to Kubernetes schema changes.
- [serverless-functions](https://github.com/Kong/kong-plugin-serverless-functions):
    - Bumped to 0.3 for minor performance improvements.
    - Functions can now have upvalues.
- [prometheus](https://github.com/Kong/kong-plugin-prometheus): Bumped to
  0.4.1 for minor performance improvements.
- cors: add OPTIONS, TRACE and CONNECT to default allowed methods
  [#4899](https://github.com/Kong/kong/pull/4899)
  Thanks to [@eshepelyuk](https://github.com/eshepelyuk) for the patch!

##### PDK

- New function `kong.service.set_tls_cert_key()`. This functions sets the
  client TLS certificate used while handshaking with the upstream service.
  [#4797](https://github.com/Kong/kong/pull/4797)

#### Fixes

##### Core

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

##### Plugins

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

##### CLI

- Fixed an issue when running `kong restart` and Kong was not running,
  causing stdout/stderr logging to turn off.
  [#4772](https://github.com/Kong/kong/pull/4772)

##### Admin API

- Ensure PUT works correctly when applied to plugin configurations.
  [#4882](https://github.com/Kong/kong/pull/4882)

##### PDK

- Prevent PDK calls from failing in custom content blocks.
  This fixes a misbehavior affecting the Prometheus plugin.
  [#4904](https://github.com/Kong/kong/pull/4904)
- Ensure `kong.response.add_header` works in the `rewrite` phase.
  [#4888](https://github.com/Kong/kong/pull/4888)



### Enterprise-Exclusive Features

#### Kong Enterprise Gateway

- gRPC support

- Upstream mTLS support (API-only)

- DB-export (API-only)

- Routing by header

##### Kong Manager

- RBAC User Management (manage Admin API access within Kong Manager)

- Service Directory Group to Kong Role Mapping (map AD groups or other service directory systems to roles & permission sets within Kong) - not available in the Alpha build

- Service Map

  - View requests flowing through Kong
  - View Immunity notifications within Service Map, click to alert section

- Immunity alert management & detail section
  
  - Filterable by entity, severity
  - Links through to alerted entities

##### Dev Portal

- Easy theming within Kong Manager

  - Easily set your color scheme, logo/branding, and go

- Developer RBAC

  - Decide what specs, or content within specs/portal, that different sets of developers can access.

  - Permissions within single workspace/portal, will be expanding in coming releases

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

##### Plugins

- gRPC support, API & Kong Manager

- Upstream mTLS support, API-only

- DB export, API-only

- Routing by header, API-only

#### Fixes

##### Plugins

###### OpenID Connect

- Fix issue when discovery did not return issuer information (against OpenID Connect specification), and which could lead to 500 error on 401 and 403 responses.
- Fix issue when discovery did not return issuer information (against OpenID Connect specification), and which could lead to 500 error on 401 and 403 responses.
