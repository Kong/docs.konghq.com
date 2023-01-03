---
title: Kong Gateway Changelog
---

<!-- vale off -->

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

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)
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

* When using secrets management in free mode, only the [environment variable](/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/env) backend is available. AWS, GCP, and HashiCorp vault backends require an Enterprise license.

* Fixed an issue in Kong Manager where entity detail pages were empty and didn't list existing entities.
The following entities were affected:
  * Route lists on service pages
  * Upstreams
  * Certificates
  * SNIs
  * RBAC roles

* Fixed an issue where the browser hung when creating an upstream with the existing host and port.

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  * Fixed a caching issue in hybrid mode, where the data plane node would try to retrieve a new JWK from the IdP every time.
  The data plane node now looks for a cached JWK first.

* [Proxy Caching Advanced](/hub/kong-inc/proxy-cache-advanced) (`proxy-cache-advanced`)
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

* [Mocking](/hub/kong-inc/mocking) (`mocking`)
  * Fixed an issue where the plugin didn't accept empty values in examples.

* [ACME](/hub/kong-inc/acme) (`acme`)
  * The `domains` plugin parameter can now be left empty.
  When `domains` is empty, all TLDs are allowed.
  Previously, the parameter was labelled as optional, but leaving it empty meant that the plugin retrieved no certificates at all.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Fixed an issue with nested array parsing.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
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

* [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)

* [HTTP Log](/hub/kong-inc/http-log) (`http-log`)
  * Log output is now restricted to the workspace the plugin is running in. Previously,
  the plugin could log requests from outside of its workspace.

* [Mocking](/hub/kong-inc/mocking) (`mocking`)
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

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
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

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Fixed rate limiting advanced errors that appeared when the Rate Limiting
  Advanced plugin was not in use.
  * Fixed an error where rate limiting counters were not updating response
  headers due to incorrect key expiration tracking.
  Redis key expiration is now tracked properly in `lua_shared_dict kong_rate_limiting_counters`.

* [Forward Proxy](/hub/kong-inc/forward-proxy) (`forward-proxy`)
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

* [HTTP Log](/hub/kong-inc/http-log) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`
* [Forward Proxy](/hub/kong-inc/forward-proxy) (`forward-proxy`)
  * Use lowercase when overwriting the `host` header
* [StatsD Advanced](/hub/kong-inc/statsd-advanced) (`statsd-advanced`)
  * Added support for setting `workspace_identifier` to `workspace_name`
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
  * Skip namespace creation if the plugin is not enabled. This prevents the error "[rate-limiting-advanced] no shared dictionary was specified" being logged.
* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)
  * Support passwords that contain a `:` character
* [OpenID Connect](/hub/kong-inc/openid-connect) (`openid-connect`)
  * Provide valid upstream headers e.g. `X-Consumer-Id`, `X-Consumer-Username`
* [JWT Signer](/hub/kong-inc/jwt-signer) (`jwt-signer`)
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
[secrets management and vault support](/gateway/latest/plan-and-deploy/security/secrets-management/).
You can now store confidential values such as usernames and passwords
as secrets in secure vaults. Kong Gateway can then reference these secrets,
making your environment more secure.

  The beta includes `get` support for the following vault implementations:
  * [AWS Secrets Manager](/gateway/latest/plan-and-deploy/security/secrets-management/backends/aws-sm)
  * [HashiCorp Vault](/gateway/latest/plan-and-deploy/security/secrets-management/backends/hashicorp-vault)
  * [Environment variable](/gateway/latest/plan-and-deploy/security/secrets-management/backends/env)

  As part of this support, some plugins have certain fields marked as
  *referenceable*. See the plugin section of the Kong Gateway 2.8 changelog for
  details.

  Test out secrets management using the
  [getting started guide](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started),
  and check out the documentation for the Kong Admin API [`/vaults-beta` entity](/gateway/latest/admin-api/#vaults-beta-entity).

  {:.important}
  > This feature is in beta. It has limited support and implementation details
  may change. This means it is intended for testing in staging environments
  only, and **should not** be deployed in production environments.

* You can customize the transparent dynamic TLS SNI name.

  Thanks, [@zhangshuaiNB](https://github.com/zhangshuaiNB)!
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
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [Forward Proxy Advanced](/hub/kong-inc/forward-proxy/) (`forward-proxy`)

  * Added `http_proxy_host`, `http_proxy_port`, `https_proxy_host`, and
  `https_proxy_port` configuration parameters for mTLS support.

      {:.important}
      > These parameters replace the `proxy_port` and `proxy_host` fields, which
      are now **deprecated** and planned to be removed in 3.x.x.

  * The `auth_password` and `auth_username` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)

  * Added the ability to identify a Kafka cluster using the `cluster_name` configuration parameter.
   By default, this field generates a random string. You can also set your own custom cluster identifier.

  * **Beta feature:** The `authentication.user` and `authentication.password` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced) (`ldap-auth-advanced`)

  * **Beta feature:** The `ldap_password` and `bind_dn` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [Vault Authentication](/hub/kong-inc/vault-auth/) (`vault-auth`)

  * **Beta feature:** The `vaults.vault_token` form field is now marked as
  referenceable, which means it can be securely stored as a
  [secret](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)

  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

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
  securely stored as [secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
  in a vault. References must follow a [specific format](/gateway/{{page.kong_version}}/kong-enterprise/security/secrets-management/reference-format).

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

* [Rate Limiting](/hub/kong-inc/rate-limiting) (`rate-limiting`)
  * Fixed a 500 error associated with performing arithmetic functions on a nil
  value by adding a nil value check after performing `ngx.shared.dict` operations.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) (`rate-limiting-advanced`)
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

* [Exit Transformer](/hub/kong-inc/exit-transformer) (`exit-transformer`)
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
