---
title: Upgrade Kong Gateway
---

Upgrade to major, minor, and patch {{site.base_gateway}}
releases using the `kong migrations` commands.

You can also use the commands to migrate all {{site.base_gateway}} open-source entities
to {{site.base_gateway}} (Enterprise). See
[Migrating from {{site.ce_product_name}} to {{site.base_gateway}}](/gateway/{{page.kong_version}}/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade path for {{site.base_gateway}} releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions.

The upgrade to 3.0.x is a **major** upgrade.
The lowest version that Kong 3.0.x supports migrating from is 2.1.x.

{:.important}
> **Important**: Blue-green migration in traditional mode for versions below 2.8.2 to 3.0.x is not supported.
The 2.8.2.x release includes blue-green migration support. If you want
to perform migrations for traditional mode with no downtime, please upgrade to at least 2.8.2.0, [then migrate to 3.0.x](#migrate-db).

While you can upgrade directly to the latest version, be aware of any
breaking changes between the 2.x and 3.x series noted in this document
(both this version and prior versions) and in the
[open-source (OSS)](https://github.com/Kong/kong/blob/release/3.0.x/CHANGELOG.md#300) and
[Enterprise](/gateway/changelog/#3000) Gateway changelogs. Since {{site.base_gateway}}
is built on an open-source foundation, any breaking changes in OSS affect all {{site.base_gateway}} packages.

{{site.base_gateway}} does not support directly upgrading from 1.x to 3.0.x.
If you are running 1.x, upgrade to 2.1.0 first at minimum, then upgrade to 3.0.x from there.

In either case, you can review the [upgrade considerations](#upgrade-considerations-and-breaking-changes),
then follow the [database migration](#migrate-db) instructions.

## Upgrade considerations and breaking changes

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

### Deployment

Amazon Linux 1 and Debian 8 (Jessie) containers and packages are deprecated and are no longer produced for new versions of {{site.base_gateway}}.

#### Blue-green deployments

**Traditional mode**: Blue-green upgrades from versions of 2.8.1 and below to 3.0.0 are not currently supported.
This is a known issue planned to be fixed in the next 2.8 release. When that version is released, 2.x users should upgrade to that version before beginning a blue-green upgrade to 3.0.

**Hybrid mode**: See the [upgrade instructions](#migrate-db) below.

### Dependencies

If you are using the provided binary packages (except Debian and RHEL), all necessary dependencies
for the gateway are bundled and you can skip this section.

As of {{ site.base_gateway }} 3.0, our Debian and RHEL images are built with minimal dependencies and run through automated security scanners before being published.
They only contain the bare minimum required to run {{site.base_gateway}}.
If you would like further customize the base image and any dependencies, you can
[build your own Docker images](/gateway/{{page.kong_version}}/install/docker/build-custom-images).

If you are using Debian, RHEL, or building your dependencies by hand, there are changes since the
previous release, so you will need to rebuild them with the latest patches.

The required OpenResty version for {{site.base_gateway}} 3.0.x is
[1.21.4.1](https://openresty.org/en/ann-1021004001.html). In addition to an upgraded
OpenResty, you need the correct [OpenResty patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/patches)
for this new version, including the latest release of [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module).
The [kong-build-tools](https://github.com/Kong/kong-build-tools)
repository contains [openresty-build-tools](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools),
which allows you to more easily build OpenResty with the necessary patches and modules.

### Migrations

The migration helper library (mostly used for Cassandra migrations) is no longer supplied with {{site.base_gateway}}.

PostgreSQL migrations can now have an `up_f` part like Cassandra
migrations, designating a function to call. The `up_f` part is
invoked after the `up` part has been executed against the database
for both PostgreSQL and Cassandra.

### Kong plugins

If you are adding a new plugin to your installation, you need to run
`kong migrations up` with the plugin name specified. For example,
`KONG_PLUGINS=tls-handshake-modifier`.

The 3.0 release includes the following new plugins:
* [OpenTelemetry](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
* [TLS Handshake Modifier](/hub/kong-inc/tls-handshake-modifier/) (`tls-handshake-modifier`)
* [TLS Metadata Headers](/hub/kong-inc/tls-metadata-headers/) (`tls-metadata-headers`)
* [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`)
* [WebSocket Validator](/hub/kong-inc/websocket-validator/) (`websocket-validator`)

Kong plugins no longer support `CREDENTIAL_USERNAME` (`X-Credential-Username`).
Use the constant `CREDENTIAL_IDENTIFIER` (`X-Credential-Identifier`) when
setting the upstream headers for a credential.

The ability to scope plugins to consumer groups was added in {{site.base_gateway}} version 3.4. Running a mixed-version {{site.base_gateway}} cluster (3.4 control plane, and <=3.3 data planes) is not supported when using consumer-group scoped plugins. 

#### Deprecations and changed parameters

The [StatsD Advanced](/hub/kong-inc/statsd-advanced/) plugin
has been deprecated and will be removed in 4.0.
All capabilities are now available in the [StatsD](/hub/kong-inc/statsd/) plugin.

The following plugins have had configuration parameters changed or removed. You will need to carefully review and update your configuration as needed:

**[ACL](/hub/kong-inc/acl/), [Bot Detection](/hub/kong-inc/bot-detection/), and [IP Restriction](/hub/kong-inc/ip-restriction/)**
* Removed the deprecated `blacklist` and `whitelist` configuration parameters. Use `allow` or `deny` instead.

**[ACME](/hub/kong-inc/ACME/)**
* The default value of the `auth_method` configuration parameter is now `token`.

**[AWS Lambda](/hub/kong-inc/aws-lambda/)**
* The AWS region is now required. You can set it through the plugin configuration with the `aws_region` field parameter, or with environment variables.
* The plugin now allows `host` and `aws_region` fields to be set at the same time, and always applies the SigV4 signature.

**[HTTP Log](/hub/kong-inc/http-log/)**
* The `headers` field now only takes a single string per header name,
where it previously took an array of values.

**[JWT](/hub/kong-inc/jwt/)**
* The authenticated JWT is no longer put into the nginx
context (`ngx.ctx.authenticated_jwt_token`). Custom plugins which depend on that
value being set under that name must be updated to use Kong's shared context
instead (`kong.ctx.shared.authenticated_jwt_token`) before upgrading to 3.0.

**[Prometheus](/hub/kong-inc/prometheus/)**
* High cardinality metrics are now disabled by default.

* The following metric names were adjusted to add units to standardize where possible:
  * `http_status` to `http_requests_total`.
  * `latency` to `kong_request_latency_ms` (HTTP), `kong_upstream_latency_ms`, `kong_kong_latency_ms`, and `session_duration_ms` (stream).
      Kong latency and upstream latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.
  * `kong_bandwidth` to `kong_bandwidth_bytes`.
  * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into `nginx_connections_total`.
  * `request_count` and `consumer_status` were merged into `http_requests_total`.
      If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.

* Other metric changes:
  * Removed the following metric: `http_consumer_status`.
  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * The plugin doesn't export status codes, latencies, bandwidth and upstream
  health check metrics by default. They can still be turned on manually by setting `status_code_metrics`,
  `lantency_metrics`, `bandwidth_metrics` and `upstream_health_metrics` respectively.

**[Pre-function](/hub/kong-inc/pre-function/) and [Post-function](/hub/kong-inc/post-function/) plugins**
* Removed the deprecated `config.functions` configuration parameter from the
`post-fuction` and `pre-function` plugins' schemas. Use the `config.access` phase instead.

**[StatsD](/hub/kong-inc/statsd/)**
* Any metric name that is related to a service now has a `service.` prefix: `kong.service.<service_identifier>.request.count`.
  * The metric `kong.<service_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.status.<status>`.
  * The metric `kong.<service_identifier>.user.<consumer_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.user.<consumer_identifier>.status.<status>`.

* The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.

**[Proxy Cache](/hub/kong-inc/proxy-cache/), [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/), and [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/)**
* These plugins don't store response data in `ngx.ctx.proxy_cache_hit` anymore.
* Logging plugins that need the response data must now read it from `kong.ctx.shared.proxy_cache_hit`.

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
    This does not change the order of execution for plugins in a standard {{site.base_gateway}} installation.

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
    - `vault-auth` change from `1003` to `1350`

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

* As of 3.0, {{site.base_gateway}}'s schema library's `process_auto_fields` function will not make deep
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

{{site.base_gateway}} no longer uses a heuristic to guess whether a `route.path` is a regex pattern. From 3.0 onward,
all regex paths must start with the `"~"` prefix, and all paths that don't start with `"~"` will be considered plain text.
The migration process should automatically convert the regex paths when upgrading from 2.x to 3.0.

The normalization rules for `route.path` have changed. {{site.base_gateway}} now stores the unnormalized path, but
the regex path always pattern-matches with the normalized URI. Previously, {{site.base_gateway}} replaced percent-encoding
in the regex path pattern to ensure different forms of URI matches.
That is no longer supported. Except for the reserved characters defined in
[rfc3986](https://datatracker.ietf.org/doc/html/rfc3986#section-2.2),
write all other characters without percent-encoding.

### Declarative and DB-less

The version number (`_format_version`) of declarative configuration has been bumped to `3.0` for changes on `route.path`.
Declarative configurations with older versions will be upgraded to `3.0` during migrations.

{:.important}
> **Do not sync (`deck sync`) declarative configuration files from 2.8 or earlier to 3.0.**
Old configuration files will overwrite the configuration and create compatibility issues.
To grab the updated configuration, `deck dump` the 3.0 file after migrations are completed.

It is no longer possible to use the `.lua` format to import a declarative configuration file from the `kong`
CLI tool. Only JSON and YAML formats are supported. If your update procedure with {{site.base_gateway}} involves
executing `kong config db_import config.lua`, convert the `config.lua` file into a `config.json` or `config.yml` file
before upgrading.

### Admin API
{% if_version lte:3.4.x %}
The Admin API endpoint `/vitals/reports` has been removed.
{% endif_version %}
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
{{site.base_gateway}} version back, check the upgrade path recommendations.

Although not required, users should upgrade their chart version and {{site.base_gateway}} version independently.
In the event of any issues, this will help clarify whether the issue stems from changes in
Kubernetes resources or changes in {{site.base_gateway}}.

For specific Kong for Kubernetes version upgrade considerations, see
[Upgrade considerations](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md)

#### Kong deployment split across multiple releases

The standard chart upgrade automation process assumes that there is only a single {{site.base_gateway}} release
in the {{site.base_gateway}} cluster, and runs both `migrations up` and `migrations finish` jobs.

If you split your {{site.base_gateway}} deployment across multiple Helm releases (to create proxy-only
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

This ensures that all instances are using the new {{site.base_gateway}} package before running
`kong migrations finish`.

### Hybrid mode considerations

{:.important}
> **Important:** If you are currently running in [hybrid mode](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/),
upgrade the control plane first, and then the data planes.

* If you are currently running 2.8.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/setup/)
  after running the migration.
* Custom plugins (either your own plugins or third-party plugins that are not shipped with {{site.base_gateway}})
  need to be installed on both the control plane and the data planes in hybrid mode. Install the
  plugins on the control plane first, and then the data planes.
* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin does not
    support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

### Template changes

There are changes in the Nginx configuration file between every minor and major
version of {{site.base_gateway}} starting with 2.0.x.

In 3.0.x, the deprecated alias of `Kong.serve_admin_api` was removed.
If your custom Nginx templates still use it, change it to `Kong.admin_content`.

{% navtabs %}
{% navtab OSS %}
To view all of the configuration changes between versions, clone the
[Kong repository](https://github.com/kong/kong) and run `git diff`
on the configuration templates, using `-w` for greater readability.

Here's how to see the differences between previous versions and 3.0.x:

```
git clone https://github.com/kong/kong
cd kong
git diff -w 2.0.0 3.0.0 kong/templates/nginx_kong*.lua
```

Adjust the starting version number (2.0.0 in the example) to the version number you are currently using.

To produce a patch file, use the following command:

```
git diff 2.0.0 3.0.0 kong/templates/nginx_kong*.lua > kong_config_changes.diff
```

Adjust the starting version number to the version number (2.0.0 in the example) you are currently using.

{% endnavtab %}
{% navtab Enterprise %}

The default template for {{site.base_gateway}} can be found using this command
on the system running your {{site.base_gateway}} instance:
`find / -type d -name "templates" | grep kong`.

When upgrading, make sure to run this command on both the old and new clusters,
diff the files to identify any changes, and apply them as needed.

{% endnavtab %}
{% endnavtabs %}


## Upgrade from 2.1.x - 2.8.x to 3.0.x {#migrate-db}

Follow the instructions for your backing data store to migrate to the new version.
If you prefer to use a fresh data store and only migrate your `kong.conf` file,
see the instructions to
[install 3.0.x on a fresh data store](#install-30x-on-a-fresh-data-store).

As with all upgrades make a backup of your data store before beginning the process.

You should not make changes to configuration with the Admin API during migration, as it may lead to unexpected behavior and
break your configuration.

**Version prerequisites for migrating to version 3.0.x**

If you are migrating from 2.7.x or lower versions, first [migrate to 2.8.1](#upgrade-from-10x---22x-to-28x).

Once you have migrated to 2.8.x, you can follow the instructions in the section
below to migrate to 3.0.x.

### Upgrade from 2.8.x (x>=2) to 3.0.x for traditional mode (blue-green)

{:.note}
> These instructions only work with 2.8.2.x.

1. Clone your database.
2. Download 3.0.x, and configure it to point to the cloned data store.
   Run `kong migrations up` and `kong migrations finish`.
3. Start the 3.0.x cluster.
4. Now both the old (2.8.x) and new (3.0.x)
   clusters can now run simultaneously. Start provisioning 3.0.x nodes.
3. Gradually divert traffic away from your old nodes, and into
   your 3.0.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 3.0.x cluster,
   decommission your old nodes.

### Upgrade to 3.0.x for hybrid mode

Data planes can serve traffic during the process of migration.

1. Download 3.0.x.
2. Decommission your old control plane.
3. Configure the new control plane to point to the same data store
   as your old control plane. Run `kong migrations up` and `kong migrations finish`.
4. Start the new control plane. It is expected that old data planes may complain
about connection failure to the control plane.
5. Start new data planes.
6. Gradually divert traffic away from your old data planes, and into
   your 3.0.x data planes. Monitor your traffic to make sure everything
   is going smoothly.
7. When your traffic is fully migrated to the 3.0.x cluster,
   decommission your old nodes.

## Install 3.0.x on a fresh data store

For installing on a fresh data store, {{site.base_gateway}} 3.0.x has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 3.0.x cluster from a fresh data store.

By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
kong migrations bootstrap [-c /path/to/kong.conf]
kong start [-c /path/to/kong.conf]
```

Assuming that {{site.base_gateway}} is already running on your system, acquire the latest
version from any of the available [installation methods](/gateway/{{page.kong_version}}/install/)
and install it, overriding your previous installation.

**If you are planning to make modifications to your configuration, this is a
good time to do so**.

Then, run migrations to upgrade your database schema:

```shell
kong migrations up [-c configuration_file]
```

If the command is successful, and no migration ran
(no output), then you only have to
[reload](/gateway/{{page.kong_version}}/reference/cli/#kong-reload) {{site.base_gateway}}:

```shell
kong reload [-c configuration_file]
```

**Reminder**: `kong reload` leverages the Nginx `reload` signal that seamlessly
starts new workers, which take over from old workers before those old workers
are terminated. In this way, {{site.base_gateway}} will serve new requests via the new
configuration, without dropping existing in-flight connections.
