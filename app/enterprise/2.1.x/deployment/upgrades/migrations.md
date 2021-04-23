---
title: Migrating Kong Enterprise from 1.5.x to 2.1.x
toc: true
---

## Overview

Upgrade to major, minor, and patch {{site.ee_product_name}} releases using the
`kong migrations` commands.

You can also use the commands to migrate all {{site.ce_product_name}} entities
to {{site.ee_product_name}}. See
[Migrating from Kong Gateway to Kong Enterprise](/enterprise/2.1.x/deployment/upgrades/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade Path for Kong Enterprise Releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and [patch](#patch) versions. The upgrade path
for major and minor versions differs depending on the previous version from which
you are migrating.

### Version Prerequisites for Migrating to Kong Enterprise 2.1

If you are not on {{site.ee_product_name}} 1.5.x, you must first incrementally
upgrade to 1.5.x before upgrading to 2.1.x. Zero downtime is possible but _not_
guaranteed if you are upgrading incrementally between versions, from 0.36.x to 1.3.x to 1.5.x.
Plan accordingly.

* If running a version of {{site.ee_product_name}} earlier than 1.3,
  [migrate to 1.3](/enterprise/1.3-x/deployment/migrations/) first.
* If running a version of {{site.ee_product_name}} earlier than 1.5,
  [migrate to 1.5](/enterprise/1.5.x/deployment/migrations/) first.


### Upgrade Considerations and Breaking Changes

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

* If you are adding a new plugin to your installation, you need to run
  `kong migrations up` with the plugin name specified. For example,
  `KONG_PLUGINS=oauth2`.
* The [Portal Application Registration](/hub/kong-inc/application-registration) plugin
  was in beta status for both 1.5.x and 2.1.x beta versions. Using the plugin in
  a 2.1.x production environment requires a fresh installation and configuration
  of the plugin. The 2.1.x plugin requires authentication to be configured separately
  on the same Service. See
  [authorization provider strategy](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/).
* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not
  support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.
* [Hybrid mode](/enterprise/{{page.kong_version}}/deployment/hybrid-mode/). If
  you are currently running 1.5.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup/)
  after running the migration. Custom plugins
  (either your own plugins or third-party plugins that are not shipped with Kong)
  need to be installed on both the Control Plane and the Data Plane in Hybrid mode.
* [Custom plugins and entities](/enterprise/{{page.kong_version}}/deployment/upgrades/custom-changes).
  If you have custom plugins and entities, there are some breaking changes and
  extra steps you need to take when migrating to 2.1.x.
* The Kong Developer Portal has undergone a number of breaking changes. If you
  are currently using the Developer Portal, it will no longer work without
  [manually migrating files](/enterprise/{{page.kong_version}}/developer-portal/latest-migrations).

### Migrating from 1.5.x (or 2.1.x-beta) to 2.1.x

**Note:** There is not an upgrade migration path from 1.5.x to 2.1.x-beta.

Due to internal changes, the table schemas used by Kong 2.1.x are incompatible
with those used by Kong 1.5.x. Migrating using the usual commands `kong
migrations up` and `kong migrations finish` will require a small window of
downtime, since the old and new versions cannot use the database at the same
time.

Alternatively, if you are able to perform a rolling restart of your Kong 1.5.x
cluster you can use the following steps to cache entities and continue serving
traffic while the upgrade is performed:

1. Update the Kong 1.5.x cluster and set the
   [`db_cache_warmup_entities`](https://docs.konghq.com/enterprise/1.5.x/property-reference/#db_cache_warmup_entities)
   configuration value. Specify all the entities Kong has configured.
2. Perform a rolling [restart](https://docs.konghq.com/1.5.x/cli/#kong-restart) of the Kong 1.5.x nodes
   to pick up this new configuration value:

   ```shell
   $ kong restart [-c configuration_file]
   ```

   Monitor the `pg_stat_statements` on the Postgres server to ensure no
   additional entities need to be warmed in the cache (added to the
   `db_cache_warmup_entities` configuration).

3. From this point onward, it is no longer possible to start nodes in the old
   1.5 (or 2.1.x-beta) cluster or access its admin API. Traffic will continue to
   be served.
4. Download 2.1.x, and configure it to point to the same datastore as your old
   1.5.x (or 2.1.x-beta) cluster.
5. Run `kong migrations up` on the 2.1.x cluster.
6. Run `kong migrations finish` on the 2.1.x cluster. From now on, you can
   safely make Admin API requests to your 2.1 nodes.
7. Start provisioning 2.1 nodes.
8. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 2.1 cluster. Monitor your traffic to make sure everything
   is going smoothly.
9. When your traffic is fully migrated to the 2.1 cluster, decommission your
   old 1.5 (or 2.1.x-beta) nodes.

### Installing 2.1 on a fresh datastore

For installing on a fresh datastore, {{site.ee_product_name}} 2.1 has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 2.1 cluster from a fresh datastore. By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
$ kong migrations bootstrap [-c /path/to/kong.conf]
$ kong start [-c /path/to/kong.conf]
```

## Patch Releases {#patch}

There are no migrations in upgrades between current or
future patch releases of the same minor release of {{site.ee_product_name}}
(for example, 1.5.0.0 to 1.5.0.1; 2.1.1.0 to 2.1.1.1, and so forth). Therefore,
the upgrade process is simpler for patch releases.

### Prerequisites

- Assuming that {{site.ee_product_name}} is already running on your system,
  acquire the latest version from any of the available
  [installation methods](https://docs.konghq.com/enterprise/{{page.kong_version}}/deployment/installation/overview/)
  and install it, overriding your previous installation.

- If you are planning to make modifications to your configuration, this is an
  opportune time to do so.

1. Run migrations to upgrade your database schema:

   ```shell
   $ kong migrations up [-c configuration_file]
   ```

2. If the command is successful, and no migration ran (no output),
   then you only have to
   [reload](https://docs.konghq.com/2.1.x/cli/#kong-reload) Kong:

   ```shell
   $ kong reload [-c configuration_file]
   ```

**Reminder:** The `kong reload` command leverages the Nginx `reload` signal that
seamlessly starts new workers, which then take over from old workers before they
are terminated. Kong serves new requests using the new
configuration without dropping existing in-flight connections.
