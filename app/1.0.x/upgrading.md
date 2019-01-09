---
title: Upgrade guide
---

<div class="alert alert-warning">
  <strong>Note:</strong> What follows is the upgrade guide for 1.0.x.
  If you are trying to upgrade to an earlier version of Kong, please read
  <a href="https://github.com/Kong/kong/blob/master/UPGRADE.md">UPGRADE.md file in the Kong repo</a>
</div>

This guide will inform you about breaking changes you should be aware of
when upgrading, as well as take you through the correct sequence of steps
in order to obtain a **no-downtime** migration in different upgrade
scenarios.

## Upgrade to `1.0.0`

This is a major release of Kong, and includes a number of new features
as well as breaking changes.

This version introduces **a new schema format for plugins**, **changes in
Admin API endpoints**, **database migrations**, **Nginx configuration
changes**, and **removed configuration properties**.

In this release, the **API entity is removed**, along with its related
Admin API endpoints.

This section will highlight breaking changes that you need to be aware of
before upgrading and will describe the recommended upgrade path. We recommend
that you consult the full [1.0.0
Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md) for a
complete list of changes and new features.

## 1. Breaking Changes

### Dependencies

- The required OpenResty version is 1.13.6.2, but for a full feature set,
  including stream routing and service mesh abilities with mutual TLS, you need
  Kong's [openresty-patches](https://github.com/kong/openresty-patches).
- The minimum required OpenSSL version is 1.1.1. If you are building by hand,
  make sure all dependencies, including LuaRocks modules, are compiled using
  the same OpenSSL version. If you are installing Kong from one of our
  distribution packages, you are not affected by this change.

### Configuration

- The `custom_plugins` directive is removed (deprecated since 0.14.0).
  Use `plugins` instead, which you can use not only to enable
  custom plugins, but also to disable bundled plugins.
- The default value for `cassandra_lb_policy` changed from `RoundRobin`
  to `RequestRoundRobin`.
- Kong generates a new template file for stream routing,
  `nginx-kong-stream.conf`, included in the `stream` block
  of its top-level Nginx configuration file. If you use
  a custom Nginx configuration and wish to use stream
  routing, you can generate this file using `kong prepare`.
- The Nginx configuration file has changed, which means that you need to update
  it if you are using a custom template. The changes are detailed in the following diff:

``` diff
diff --git a/kong/templates/nginx_kong.lua b/kong/templates/nginx_kong.lua
index d4e416bc..8f268ffd 100644
--- a/kong/templates/nginx_kong.lua
+++ b/kong/templates/nginx_kong.lua
@@ -66,7 +66,9 @@ upstream kong_upstream {
     balancer_by_lua_block {
         Kong.balancer()
     }
+> if upstream_keepalive > 0 then
     keepalive ${{UPSTREAM_KEEPALIVE}};
+> end
 }

 server {
@@ -85,7 +87,7 @@ server {
 > if proxy_ssl_enabled then
     ssl_certificate ${{SSL_CERT}};
     ssl_certificate_key ${{SSL_CERT_KEY}};
-    ssl_protocols TLSv1.1 TLSv1.2;
+    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
     ssl_certificate_by_lua_block {
         Kong.ssl_certificate()
     }
@@ -200,7 +202,7 @@ server {
 > if admin_ssl_enabled then
     ssl_certificate ${{ADMIN_SSL_CERT}};
     ssl_certificate_key ${{ADMIN_SSL_CERT_KEY}};
-    ssl_protocols TLSv1.1 TLSv1.2;
+    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;

     ssl_session_cache shared:SSL:10m;
     ssl_session_timeout 10m;
```

### Core

- The **API** entity and related concepts such as the
  `/apis` endpoint, are removed. These were deprecated since
  0.13.0. Instead, use **Routes** to configure your
  endpoints and **Services** to configure your upstream
  services.
- The old DAO implementation (`kong.dao`) is removed,
  which includes the old schema validation library. This
  has implications to plugin developers, listed below.
  - The last remaining entities that were converted to
    the new DAO implementation were Plugins, Upstreams
    and Targets. This has implications to the Admin API,
    listed below.

### Plugins

Kong 1.0.0 marks the introduction of version 1.0.0 of
the Plugin Development Kit (PDK). No major changes are
made to the PDK compared to release 0.14, but some older
non-PDK functionality which was possibly used by custom
plugins is now removed.

- Plugins now use the new schema format introduced by the
  new DAO implementation, for both plugin schemas
  (in `schema.lua`) and custom DAO entities (`daos.lua`).
  To ease the transition of plugins, the plugin loader
  in 1.0 includes a *best-effort* schema auto-translator
  for `schema.lua`, which should be sufficient for many
  plugins (in 1.0.0rc1, our bundled plugins used the
  auto-translator; they now use the new format).
  - If your plugin using the old format in `schema.lua`
    fails to load, check the error logs for messages
    produced by the auto-translator. If a field cannot
    be auto-translated, you can make a gradual conversion
    of the schema file by adding a `new_type` entry to
    the field table translation of the format. See,
    for example, the [key-auth schema in 1.0.0rc1](https://github.com/Kong/kong/blob/1.0.0rc1/kong/plugins/key-auth/schema.lua#L39-L54).
    The `new_type` annotation is ignored by Kong 0.x.
  - If your custom plugin uses custom DAO objects (i.e.
    if it includes a `daos.lua` file), it needs to be
    converted to the new format. Their code also needs
    to be adjusted accordingly, replacing uses of
    `singletons.dao` or `kong.dao` by `kong.db` (note
    that this module exposes a different API from the
    old DAO implementation).
- Some Kong modules that had their functionality replaced
  by the PDK in 0.14.0 are now removed:
  - `kong.tools.ip`: use `kong.ip` from the PDK instead.
  - `kong.tools.public`: replaced by various functionalities
    of the PDK.
  - `kong.tools.responses`: use `kong.response.exit` from the PDK instead. You
    might want to use `kong.log.err` to log internal server errors as well.
- The `kong.api.crud_helpers` module was removed.
  Use `kong.api.endpoints` instead if you need to customize
  the auto-generated endpoints.

### Admin API

- With the removal of the API entity, the `/apis` endpoint
  is removed; accordingly, other endpoints that accepted
  `api_id` no longer do so. Use Routes and Services instead.
- All entity endpoints now use the new Admin API implementaion.
  This means their requests and responses now use the same
  syntax, which was already in use in endpoints such as
  `/routes` and `/services`.
  - All endpoints now use the same syntax for
    referencing other entities as `/routes`
    (for example, `"service":{"id":"..."}` instead of
    `"service_id":"..."`), both in requests and responses.
    - This change affects `/plugins` as well as
      plugin-specific endpoints.
  - Array-typed values are not specified as a
    comma-separated list anymore. It must be specified as a
    JSON array or using the various formats supported by
    the url-formencoded array notation of the new Admin API
    implementation (`a[1]=x&a[2]=y`, `a[]=x&a[]=y`,
    `a=x&a=y`).
    - This change affects attributes of the `/upstreams` endpoint.
  - Error responses for the updated endpoints use
    the new standardized format.
  - As a result of being moved to the new Admin API implementation,
    all endpoints supporting `PUT` do so with proper semantics.
  - See the [Admin API
    reference](https://docs.konghq.com/1.0.x/admin-api)
    for more details.

## 2. Deprecation Notices

There are no deprecation notices in this release.

## 3. Suggested Upgrade Path

### Preliminary Checks

If your cluster is running a version lower than 0.14, you need to
upgrade to 0.14.1 first instead. Upgrading from a pre-0.14 cluster
straight to Kong 1.0 is **not** supported.

If you still use the deprecated API entity to configure your endpoints and
upstream services (via `/apis`) instead of using Routes for endpoints (via
`/routes`) and Services for upstream services (via `/services`), now is the
time to do so. Kong 1.0 will refuse to run migrations if you have any entity
configured using `/apis` in your datastore. Create equivalent Routes and
Services and delete your APIs. (Note that Kong does not do this automatically
because the naive option of creating a Route and Service pair for each API
would miss the point of the improvements brought by Routes and Services;
the ideal mapping of Routes and Services depends on your microservice
architecture.)

If you use additional plugins other than the ones bundled with Kong,
make sure they are compatible with Kong 1.0 prior to upgrading.
See the section above on Plugins for information on plugin compatibility.

### Migration Steps from 0.14

Kong 1.0 introduces a new, improved migrations framework.
It supports a no-downtime, Blue/Green migration model for upgrading
from 0.14.x. The full migration is now split into two steps,
which are performed via commands `kong migrations up` and
`kong migrations finish`.

For a no-downtime migration from a 0.14 cluster to a 1.0 cluster,
we recommend the following sequence of steps:

1. Download 1.0, and configure it to point to the same datastore
   as your 0.14 cluster. Run `kong migrations up`.
2. Both 0.14 and 1.0 nodes can now run simultaneously on the same
   datastore. Start provisioning 1.0 nodes, but do not use their
   Admin API yet. Prefer making Admin API requests to your 0.14 nodes
   instead.
3. Gradually divert traffic away from your 0.14 nodes, and into
   your 1.0 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 1.0 cluster,
   decommission your 0.14 nodes.
5. From your 1.0 cluster, run: `kong migrations finish`.
   From this point on, it will not be possible to start 0.14
   nodes pointing to the same datastore anymore. Only run
   this command when you are confident that your migration
   was successful. From now on, you can safely make Admin API
   requests to your 1.0 nodes.

At any step of the way, you may run `kong migrations list` to get
a report of the state of migrations. It will list whether there
are missing migrations, if there are pending migrations (which have
already started in the `kong migrations up` step and later need to
finish in the `kong migrations finish` step) or if there
are new migrations available. The status code of the process will
also change accordingly:

* `0` - migrations are up-to-date
* `1` - failed inspecting the state of migrations (e.g. database is down)
* `3` - database needs bootstrapping:
  you should run `kong migrations bootstrap` to install on
  a fresh datastore.
* `4` - there are pending migrations: once your old cluster is
  decomissioned you should run `kong migrations finish` (step 5 above).
* `5` - there are new migrations: you should start a migration
  sequence (beginning from step 1 above).

### Migration Steps from 1.0 Release Candidates

The process is the same as for upgrading for 0.14 listed above, but on step 1
you should run `kong migrations up --force` instead.

## Upgrade Path for Patch Releases

There are no migrations in upgrades between current or
future patch releases of the same minor release of Kong
(e.g. 1.0.0 to 1.0.1, 1.0.1 to 1.0.4, etc.). Therefore, the
upgrade process is simpler.

Assuming that Kong is already running on your system, acquire the latest
version from any of the available [installation
methods](https://getkong.org/install/) and proceed to install it, overriding
your previous installation.

If you are planning to make modifications to your configuration, this is a
good time to do so.

Then, run migration to upgrade your database schema:

```shell
$ kong migrations up [-c configuration_file]
```

If the command is successful, and no migration ran
(no output), then you only have to
[reload](https://getkong.org/docs/latest/cli/#reload) Kong:

```shell
$ kong reload [-c configuration_file]
```

**Reminder**: `kong reload` leverages the Nginx `reload` signal that seamlessly
starts new workers, which take over from old workers before those old workers
are terminated. In this way, Kong will serve new requests via the new
configuration, without dropping existing in-flight connections.

## Installing 1.0 on a Fresh Datastore

For installing on a fresh datastore, Kong 1.0 introduces the `kong migrations
bootstrap` command. The following commands can be run to prepare a new 1.0
cluster from a fresh datastore:

```
$ kong migrations bootstrap [-c config]
$ kong start [-c config]
```


