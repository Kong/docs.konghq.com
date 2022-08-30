---
title: Upgrade Kong Gateway
badge: free
---

Upgrade to major, minor, and patch {{site.ee_product_name}} (Enterprise package)
releases using the `kong migrations` commands.

You can also use the commands to migrate all {{site.ce_product_name}} entities
to {{site.ee_product_name}}. See
[Migrating from {{site.ce_product_name}} to {{site.base_gateway}}](/gateway/{{page.kong_version}}/install-and-run/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade path for Kong Gateway releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions.

The upgrade to 3.0.x is a **major** upgrade.
While you can upgrade directly to the latest version, be aware of any
breaking changes between the 2.x and 3.x series noted in this document
(both this version and prior versions) and in the Gateway changelogs.

{{site.base_gateway}} does not support directly upgrading from 1.x to 3.0.x.
If you are running 1.x, upgrade to 2.1.0 first at minimum, then upgrade to 3.0.x from there.

See specific breaking changes in the Kong Gateway changelogs:
[open-source (OSS)](https://github.com/Kong/kong/blob/3.0.0/CHANGELOG.md#300) and
[Enterprise](/gateway/changelog/#3000). Since Kong Gateway is built on an
open-source foundation, any breaking changes in OSS affect all Gateway packages.

In either case, you can review the [upgrade considerations](#upgrade-considerations),
then follow the [database migration](#migrate-db) instructions.

## Upgrade considerations

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

### Deployment

Amazon Linux 1 and Debian 8 (Jessie) containers and packages are deprecated and are no longer produced for new versions of Kong Gateway.

As of {{ site.base_gateway }} 3.0, our Debian and RHEL images are built with minimal dependencies and run through automated security scanners before being published.
They only contain the bare minimum required to run Kong. If you would like further customize the base image and any dependencies, you can [build your own Docker images](/gateway/{{page.kong_version}}/install/docker/build-custom-images).

Blue-green deployments from Kong Gateway versions before 2.1.0 are not supported with 3.0.0.
Upgrade to 2.1.0 or later before upgrading to 3.0.x to use blue-green deployment.

### Migrations

The migration helper library (mostly used for Cassandra migrations) is no longer supplied with Kong Gateway.

PostgreSQL migrations can now have an `up_f` part like Cassandra
migrations, designating a function to call. The `up_f` part is
invoked after the `up` part has been executed against the database
for both PostgreSQL and Cassandra.

### Kong plugins

If you are adding a new plugin to your installation, you need to run
`kong migrations up` with the plugin name specified. For example,
`KONG_PLUGINS=tls-handshake-modifier`.

The 3.0 release includes the following new plugins:
* [OpenTelemetry](/hub/kong-inc/opentelemetry) (`opentelemetry`)
* [TLS Handshake Modifier](/hub/kong-inc/tls-handshake-modifier/) (`tls-handshake-modifier`)
* [TLS Metadata Headers](/hub/kong-inc/tls-metadata-headers/) (`tls-metadata-headers`)
* [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`)
* [WebSocket Validator](/hub/kong-inc/websocket-validator/) (`websocket-validator`)

Kong plugins no longer support `CREDENTIAL_USERNAME` (`X-Credential-Username`).
Use the constant `CREDENTIAL_IDENTIFIER` (`X-Credential-Identifier`) when
setting the upstream headers for a credential.

#### Deprecations and changed parameters

The [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`) plugin
has been deprecated and will be removed in 4.0.
All capabilities are now available in the [StatsD](/hub/kong-inc/statsd/) plugin.

The following plugins have had configuration parameters changed or removed. You will need to carefully review and update your configuration as needed:

* [ACL](/hub/kong-inc/acl/) (`acl`), [Bot Detection](/hub/kong-inc/bot-detection) (`bot-detection`), and [IP Restriction](/hub/kong-inc/ip-restriction/) (`ip-restriction`): Removed the deprecated `blacklist` and `whitelist` configuration parameters. Use `allow` or `deny` instead.

* [ACME](/hub/kong-inc/ACME/) (`acme`): The default value of the `auth_method` configuration parameter is now `token`.

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * The AWS region is now required. You can set it through the plugin configuration with the `aws_region` field parameter, or with environment variables.
  * The plugin now allows `host` and `aws_region` fields to be set at the same time, and always applies the SigV4 signature.

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`): The `headers` field now only takes a single string per header name,
  where it previously took an array of values.

* [JWT](/hub/kong-inc/jwt/) (`jwt`): The authenticated JWT is no longer put into the nginx
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
    * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into to `nginx_hconnections_total` (or `nginx_current_connections`?)
    *  `request_count` and `consumer_status` were merged into http_requests_total.

        If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.
  * Removed the following metric: `http_consumer_status`
  * New metrics:
    * `session_duration_ms`: monitoring stream connections.
    * `node_info`: Single gauge set to 1 that outputs the node's ID and Kong Gateway version.

  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * The plugin doesn't export status codes, latencies, bandwidth and upstream
  health check metrics by default. They can still be turned on manually by setting `status_code_metrics`,
  `lantency_metrics`, `bandwidth_metrics` and `upstream_health_metrics` respectively.

* [Serverless Functions](/hub/kong-inc/serverless-functions/) (`post-function` or `pre-function`): Removed the deprecated `config.functions` configuration parameter from the Serverless Functions plugins' schemas. Use the `config.access` phase instead.

* [StatsD](/hub/kong-inc/statsd/) (`statsd`):
  * Any metric name that is related to a service now has a `service.` prefix: `kong.service.<service_identifier>.request.count`.
    * The metric `kong.<service_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.status.<status>`.
    * The metric `kong.<service_identifier>.user.<consumer_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.user.<consumer_identifier>.status.<status>`.
  * The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.

* [Proxy Cache](/hub/kong-inc/proxy-cache/) (`proxy-cache`), [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`), and [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`): These plugins don't store response data in `ngx.ctx.proxy_cache_hit` anymore.
    Logging plugins that need the response data must now read it from `kong.ctx.shared.proxy_cache_hit`.

### Custom plugins and the PDK

* DAOs in plugins must be listed in an array, so that their loading order is explicit. Loading them in a
  hash-like table is no longer supported.
* Plugins MUST now have a valid `PRIORITY` (integer) and `VERSION` ("x.y.z" format)
  field in their `handler.lua` file, otherwise the plugin will fail to load.
* The old `kong.plugins.log-serializers.basic` library was removed in favor of the PDK
  function `kong.log.serialize`. Upgrade your plugins to use the PDK.
* The support for deprecated legacy plugin schemas was removed. If your custom plugins
  still use the old (`0.x era`) schemas, you are now forced to upgrade them.

* Updated the priority for some plugins.

    This is important for those who run custom plugins as it may affect the sequence in which your plugins are executed.
    This does not change the order of execution for plugins in a standard Kong Gateway installation.

    Old and new plugin priority values:
    - `acme` changed from `1007` to `1705`
    - `basic-auth` changed from `1001` to `1100`
    - `hmac-auth` changed from `1000` to `1030`
    - `jwt` changed from `1005` to `1450`
    - `key-auth` changed from `1003` to `1250`
    - `ldap-auth` changed from `1002` to `1200`
    - `oauth2` changed from `1004` to `1400`
    - `rate-limiting` changed from `901` to `910`
    - `pre-function` changed from `+inf` to `1000000`.

* The `kong.request.get_path()` PDK function now performs path normalization
  on the string that is returned to the caller. The raw, non-normalized version
  of the request path can be fetched via `kong.request.get_raw_path()`.

* `pdk.response.set_header()`, `pdk.response.set_headers()`, `pdk.response.exit()` now ignore and emit warnings for manually set `Transfer-Encoding` headers.

* The PDK is no longer versioned.

* The JavaScript PDK now returns `Uint8Array` for `kong.request.getRawBody`,
  `kong.response.getRawBody`, and `kong.service.response.getRawBody`.
  The Python PDK returns `bytes` for `kong.request.get_raw_body`,
  `kong.response.get_raw_body`, and `kong.service.response.get_raw_body`.
  Previously, these functions returned strings.

* The `go_pluginserver_exe` and `go_plugins_dir` directives are no longer supported.
If you are using
 [Go plugin server](https://github.com/Kong/go-pluginserver), migrate your plugins to use the
 [Go PDK](https://github.com/Kong/go-pdk) before upgrading.

* As of 3.0, Kong Gateway's schema library's `process_auto_fields` function will not make deep
  copies of data that is passed to it when the given context is `select`. This was
  done to avoid excessive deep copying of tables where we believe the data most of
  the time comes from a driver like `pgmoon` or `lmdb`.

  If a custom plugin relied on `process_auto_fields` not overriding the given table, it must make its own copy
  before passing it to the function now.

* The deprecated `shorthands` field in Kong plugin or DAO schemas was removed in favor
  of the typed `shorthand_fields`. If your custom schemas still use `shorthands`, you
  need to update them to use `shorthand_fields`.

* The support for `legacy = true/false` attribute was removed from Kong schemas and
  Kong field schemas.

* The Kong singletons module `kong.singletons` was removed in favor of the PDK `kong.*`.

### New router

Kong Gateway no longer uses a heuristic to guess whether a `route.path` is a regex pattern. From 3.0 onward,
all regex paths must start with the `"~"` prefix, and all paths that don't start with `"~"` will be considered plain text.
The migration process should automatically convert the regex paths when upgrading from 2.x to 3.0.

The normalization rules for `route.path` have changed. Kong Gateway now stores the unnormalized path, but
the regex path always pattern-matches with the normalized URI. Previously, Kong Gateway replaced percent-encoding
in the regex path pattern to ensure different forms of URI matches.
That is no longer supported. Except for the reserved characters defined in
[rfc3986](https://datatracker.ietf.org/doc/html/rfc3986#section-2.2),
write all other characters without percent-encoding.

### Declarative and DB-less

The version number (`_format_version`) of declarative configuration has been bumped to `3.0` for changes on `route.path`.
Declarative configurations with older versions will be upgraded to `3.0` automatically.

It is no longer possible to use the `.lua` format to import a declarative configuration file from the `kong`
CLI tool. Only JSON and YAML formats are supported. If your update procedure with Kong Gateway involves
executing `kong config db_import config.lua`, convert the `config.lua` file into a `config.json` or `config.yml` file
before upgrading.

### Admin API

The Admin API endpoint `/vitals/reports` has been removed.

`POST` requests on `/targets` endpoints are no longer able to update
existing entities. They are only able to create new ones.
If you have scripts that use `POST` requests to modify `/targets`, change them to `PUT`
requests to the appropriate endpoints before updating to Kong 3.0.

The list of reported plugins available on the server now returns a table of
metadata per plugin instead of a boolean `true`.

### Configuration

The Kong constant `CREDENTIAL_USERNAME` with the value of `X-Credential-Username` has been
removed.

The default value of `lua_ssl_trusted_certificate` has changed to `system` to automatically load the trusted CA list from the system CA store.

The deprecated alias of `Kong.serve_admin_api` was removed. If your custom Nginx
templates still use it, change it to `Kong.admin_content`.

The data plane config cache mechanism and its related configuration options
(`data_plane_config_cache_mode` and `data_plane_config_cache_path`) have been removed in favor of LMDB.

`ngx.ctx.balancer_address` was removed in favor of `ngx.ctx.balancer_data`.

### Kong for Kubernetes considerations

The Helm chart automates the upgrade migration process. When running `helm upgrade`,
the chart spawns an initial job to run `kong migrations up` and then spawns new
Kong pods with the updated version. Once these pods become ready, they begin processing
traffic and old pods are terminated. Once this is complete, the chart spawns another job
to run `kong migrations finish`.

While the migrations themselves are automated, the chart does not automatically ensure
that you follow the recommended upgrade path. If you are upgrading from more than one minor
Kong version back, check the upgrade path recommendations for Kong open source or Kong Gateway.

Although not required, users should upgrade their chart version and Kong version independently.
In the event of any issues, this will help clarify whether the issue stems from changes in
Kubernetes resources or changes in Kong.

For specific Kong for Kubernetes version upgrade considerations, see
[Upgrade considerations](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md)

#### Kong deployment split across multiple releases

The standard chart upgrade automation process assumes that there is only a single Kong release
in the Kong cluster, and runs both `migrations up` and `migrations finish` jobs.

If you split your Kong deployment across multiple Helm releases (to create proxy-only
and admin-only nodes, for example), you must set which migration jobs run based on your
upgrade order.

To handle clusters split across multiple releases, you should:

1. Upgrade one of the releases with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=true \
   --set migrations.postUpgrade=false
   ```
2. Upgrade all but one of the remaining releases with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=false \
   --set migrations.postUpgrade=false
   ```
3. Upgrade the final release with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=false \
   --set migrations.postUpgrade=true
   ```

This ensures that all instances are using the new Kong package before running
`kong migrations finish`.

## Upgrade from 2.1.x - 2.8.x to 3.0.x {#migrate-db}

{{site.ee_product_name}} supports the zero downtime migration model. This means
that while the migration is in process, you have two Kong clusters with different
versions running that are sharing the same database. This is sometimes referred
to as the
[blue-green migration model](https://en.wikipedia.org/wiki/Blue-green_deployment).

The migrations are designed so that there is no need to fully copy
the data. The new version of {{site.ee_product_name}} is able to use the data as it
is migrated, and the old Kong cluster keeps working until it is finally time to
decommission it. For this reason, the full migration is split into two commands:

- `kong migrations up`: performs only non-destructive operations
- `kong migrations finish`: puts the database in the final expected state (DB-less
  mode is not supported in {{site.ee_product_name}})

Follow the instructions for your backing data store to migrate to the new version.
If you prefer to use a fresh data store and only migrate your `kong.conf` file,
see the instructions to
[install 3.0.x on a fresh datastore](#install-28x-on-a-fresh-datastore).

### PostgreSQL

1. Download 3.0.x, and configure it to point to the same
   datastore as your old (2.1.x-2.8.x) cluster.
2. Run `kong migrations up`.
3. After that finishes running, both the old (2.1.x-2.8.x) and new (3.0.x) clusters can
   now run simultaneously on the same datastore. Start provisioning 3.0.x nodes,
   but do _not_ use their Admin API yet.

   {:.important}
   > **Important:** If you need to make Admin API requests,
   these should be made to the old cluster's nodes. This prevents
   the new cluster from generating data that is not understood by the old
   cluster.

4. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 3.0.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
5. When your traffic is fully migrated to the 3.0.x cluster, decommission your
   old nodes.
6. From your 3.0.x cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old cluster
   that still points to the same datastore.

     Run this command _only_ when you are
     confident that your migration was successful. From now on, you can safely make
     Admin API requests to your 3.0.x nodes.

### Cassandra

Due to internal changes, the table schemas used by {{site.ee_product_name}} 2.8.x on Cassandra
are incompatible with those used by {{site.ee_product_name}} 2.1.x or lower. Migrating using the usual commands
`kong migrations up` and `kong migrations finish` will require a small
window of downtime, since the old and new versions cannot use the
database at the same time.

Alternatively, to keep your previous version fully operational while the new
one initializes, transfer the data to a new keyspace using a database dump, as
described below:

1. Download 3.0.x, and configure it to point to a new keyspace.

2. Run `kong migrations bootstrap`.

   Once that finishes running, both the old (2.1.x-2.8.x) and new (3.0.x)
   clusters can now run simultaneously, but the new cluster does not
   have any data yet.
3. On the old cluster, run `kong config db_export`. This will create
   a file named `kong.yml` with a database dump.
4. Transfer the file to the new cluster and run
   `kong config db_import kong.yml`. This will load the data into the new cluster.
5. Gradually divert traffic away from your old nodes, and into
   your 3.0.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
6. When your traffic is fully migrated to the 3.0.x cluster,
   decommission your old nodes.

### Install 3.0.x on a fresh datastore

For installing on a fresh datastore, {{site.ee_product_name}} 3.0.x has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 3.0.x cluster from a fresh datastore. By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
$ kong migrations bootstrap [-c /path/to/kong.conf]
$ kong start [-c /path/to/kong.conf]
```
