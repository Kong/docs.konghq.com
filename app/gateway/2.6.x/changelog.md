---
title: Kong Gateway Changelog
---

<!-- vale off -->
## 2.6.1.0
**Release Date** 2022/04/07

### Fixes

#### Enterprise

* Fixed an issue with RBAC where `endpoint=/kong workspace=*` would not let the `/kong` endpoint be accessed from all workspaces
* Fixed an issue with RBAC where admins without a top level `endpoint=*` permission could not add any RBAC rules, even if they had `endpoint=/rbac` permissions. These admins can now add RBAC rules for their current workspace only.

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log) (`http-log`)
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

* [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`) and
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
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
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
- **New plugin:** [jq](/hub/kong-inc/jq) (`jq`)
  The jq plugin enables arbitrary jq transformations on JSON objects included in API requests or responses.
- [Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
  The Kafka Log plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Kafka Upstream](/hub/kong-inc/kafka-upstream) (`kafka-upstream`)
  The Kafka Upstream plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  - The Rate Limiting Advanced plugin now has a new identifier type, `path`, which allows rate limiting by
    matching request paths.
  - The plugin now has a `local` strategy in the schema. The local strategy automatically sets `config.sync_rate` to -1.
  - The highest sync-rate configurable was a 1 second interval. This sync-rate has been increased by reducing
    the minimum allowed interval from 1 to 0.020 second (20ms).
- [OPA](/hub/kong-inc/opa) (`opa`)
  The OPA plugin now has a request path parameter, which makes setting policies on a path easier for administrators.
- [Canary](/hub/kong-inc/canary) (`canary`)
  The Canary plugin now has the option to hash on the header (falls back on IP, and then random).
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  Upgrade to v2.1.0 to maintain version compatibility with older data planes.
  - Features from v2.0.x include the following:
    - The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
    - The plugin now supports JWE Introspection.
  - Feature from to v2.1.x includes the following:
    - The plugin now has a new param, `by_username_ignore_case`, which allows `consumer_by` username values to be
      matched case-insensitive with Identity Provider claims.
- [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced) (`request-transformer-advanced`)
  - This release includes a fix for the URL encode transformed path. The plugin now uses PDK functions to set upstream URI
    by replacing `ngx.var.upstream_uri` so the urlencode is taken care of.
- [AWS-Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  The plugin will now try to detect the AWS region by using `AWS_REGION` and
  `AWS_DEFAULT_REGION` environment variables (when not specified with the plugin configuration).
  This allows users to specify a 'region' on a per Kong node basis, adding the ability to invoke the
  Lambda function in the same region where Kong is located.
  [#7765](https://github.com/Kong/kong/pull/7765)
- [Datadog](/hub/kong-inc/datadog) (`datadog`)
  The Datadog plugin now allows `host` and `port` config options be configured from environment variables,
  `KONG_DATADOG_AGENT_HOST` and `KONG_DATADOG_AGENT_PORT`. This update enables users to set
   different destinations on a per Kong node basis, which makes multi-DC setups easier and in Kubernetes helps
   with the ability to run the Datadog agents as a daemon-set.
  [#7463](https://github.com/Kong/kong/pull/7463)
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  The Prometheus plugin now includes a new metric, `data_plane_cluster_cert_expiry_timestamp`, to expose the Data Plane's `cluster_cert`
   expiry timestamp for improved monitoring in Hybrid Mode.
  [#7800](https://github.com/Kong/kong/pull/7800).
- [GRPC-Gateway](/hub/kong-inc/grpc-gateway) (grpc-gateway)
  - Fields of type `.google.protobuf.Timestamp` on the gRPC side are now
    transcoded to and from ISO8601 strings in the REST side.
    [#7538](https://github.com/Kong/kong/pull/7538)
  - URI arguments like `..?foo.bar=x&foo.baz=y` are interpreted as structured
    fields, equivalent to `{"foo": {"bar": "x", "baz": "y"}}`.
    [#7564](https://github.com/Kong/kong/pull/7564)
- [Request Termination](/hub/kong-inc/request-termination) (`request-termination`)
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
- The [Keyring Encryption](/enterprise/2.6.x/db-encryption/) feature is no longer in an alpha quality state.
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
- [ACME](/hub/kong-inc/acme) (`acme`)
  Dots in wildcard domains are escaped.
  [#7839](https://github.com/Kong/kong/pull/7839).
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  Upstream's health info now includes previously missing `subsystem` field.
  [#7802](https://github.com/Kong/kong/pull/7802).
- [Proxy-Cache](/hub/kong-inc/proxy-cache) (`proxy-cache`)
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
- **New plugin:** [jq](/hub/kong-inc/jq) (`jq`)
  The jq plugin enables arbitrary jq transformations on JSON objects included in API requests or responses.
- [Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
  The Kafka Log plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Kafka Upstream](/hub/kong-inc/kafka-upstream) (`kafka-upstream`)
  The Kafka Upstream plugin now supports TLS, mTLS, and SASL auth. SASL auth includes support for PLAIN, SCRAM-SHA-256,
  and delegation tokens.
- [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  - The Rate Limiting Advanced plugin now has a new identifier type, `path`, which allows rate limiting by
    matching request paths.
  - The plugin now has a `local` strategy in the schema. The local strategy automatically sets `config.sync_rate` to -1.
  - The highest sync-rate configurable was a 1 second interval. This sync-rate has been increased by reducing
    the minimum allowed interval from 1 to 0.020 second (20ms).
- [OPA](/hub/kong-inc/opa) (`opa`)
  The OPA plugin now has a request path parameter, which makes setting policies on a path easier for administrators.
- [Canary](/hub/kong-inc/canary) (`canary`)
  The Canary plugin now has the option to hash on the header (falls back on IP, and then random).
- [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  Upgrade to v2.1.0 to maintain version compatibility with older data planes.
  - Features from v2.0.x include the following:
    - The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
    - The plugin now supports JWE Introspection.
  - Feature from to v2.1.x includes the following:
    - The plugin now has a new param, `by_username_ignore_case`, which allows `consumer_by` username values to be
      matched case-insensitive with Identity Provider claims.
- [AWS-Lambda](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  The plugin will now try to detect the AWS region by using `AWS_REGION` and
  `AWS_DEFAULT_REGION` environment variables (when not specified with the plugin configuration).
  This allows users to specify a 'region' on a per Kong node basis, adding the ability to invoke the
  Lambda function in the same region where Kong is located.
  [#7765](https://github.com/Kong/kong/pull/7765)
- [Datadog](/hub/kong-inc/datadog) (`datadog`)
  The Datadog plugin now allows `host` and `port` config options be configured from environment variables,
  `KONG_DATADOG_AGENT_HOST` and `KONG_DATADOG_AGENT_PORT`. This update enables users to set
   different destinations on a per Kong node basis, which makes multi-DC setups easier and in Kubernetes helps
   with the ability to run the Datadog agents as a daemon-set.
  [#7463](https://github.com/Kong/kong/pull/7463)
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  The Prometheus plugin now includes a new metric, `data_plane_cluster_cert_expiry_timestamp`, to expose the Data Plane's `cluster_cert`
   expiry timestamp for improved monitoring in Hybrid Mode.
  [#7800](https://github.com/Kong/kong/pull/7800).
- [GRPC-Gateway](/hub/kong-inc/grpc-gateway) (grpc-gateway)
  - Fields of type `.google.protobuf.Timestamp` on the gRPC side are now
    transcoded to and from ISO8601 strings in the REST side.
    [#7538](https://github.com/Kong/kong/pull/7538)
  - URI arguments like `..?foo.bar=x&foo.baz=y` are interpreted as structured
    fields, equivalent to `{"foo": {"bar": "x", "baz": "y"}}`.
    [#7564](https://github.com/Kong/kong/pull/7564)
- [Request Termination](/hub/kong-inc/request-termination) (`request-termination`)
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
- The [Keyring Encryption](/enterprise/2.6.x/db-encryption/) feature is no longer in an alpha quality state.

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
- [ACME](/hub/kong-inc/acme) (`acme`)
  Dots in wildcard domains are escaped.
  [#7839](https://github.com/Kong/kong/pull/7839).
- [Prometheus](/hub/kong-inc/prometheus) (`prometheus`)
  Upstream's health info now includes previously missing `subsystem` field.
  [#7802](https://github.com/Kong/kong/pull/7802).
- [Proxy-Cache](/hub/kong-inc/proxy-cache) (`proxy-cache`)
  Fixed an issue where the plugin would sometimes fetch data from the cache but not return it.
  [#7775](https://github.com/Kong/kong/pull/7775)
