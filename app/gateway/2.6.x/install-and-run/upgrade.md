---
title: Upgrade Guide
toc: true
---

Upgrade to major, minor, and patch {{site.ee_product_name}} releases using the
`kong migrations` commands.

You can also use the commands to migrate all Kong Gateway OSS entities to Kong Gateway Enterprise. See
[Migrating from Kong Gateway to Kong Enterprise](/enterprise/{{page.kong_version}}/deployment/upgrades/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade path for Kong Gateway releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions. The upgrade 
path for major and minor versions differs depending on the previous version 
from which you are migrating:

- Upgrading from 2.5.x to 2.6.x is a minor upgrade; however, read below for important
instructions on [database migration](#migrate-db), especially for Cassandra users.

- Upgrading from from 1.x is a major upgrade. Follow the [Version Prerequisites](#version-prerequisites).
Be aware of any noted breaking changes as documented in the version to which you are upgrading.

### Version Prerequisites

If you are not on Kong Gateway 2.5.x, you must first incrementally
upgrade to 2.5.x before upgrading to 2.6.x. Zero downtime is possible but _not_
guaranteed if you are upgrading incrementally between versions, from 0.36.x to 1.3.x to
1.5.x to 2.1.x to 2.2.x to 2.3.x to 2.4.x to 2.5.x to 2.6.x., plan accordingly.

* If running a version of Kong Gateway earlier than 1.5,
  [migrate to 1.5](/enterprise/1.5.x/deployment/migrations/) first.
* If running a version of Kong Gateway earlier than 2.1,
  [migrate to 2.1](/enterprise/2.1.x/deployment/upgrades/migrations/) first.
* If running a version of Kong Gateway earlier than 2.2,
  [migrate to 2.2](/enterprise/2.2.x/deployment/upgrades/migrations/) first.
* If running a version of Kong Gateway earlier than 2.3,
  [migrate to 2.3](/enterprise/2.3.x/deployment/upgrades/migrations/) first.
* If running a version of Kong Gateway earlier than 2.4,
  [migrate to 2.4](/enterprise/2.4.x/deployment/upgrades/migrations/) first.
* If running a version of Kong Gateway earlier than 2.5,
  [migrate to 2.5](/enterprise/2.5.x/deployment/upgrades/migrations/) first.

### Dev Portal migrations

There are no migrations necessary for the Dev Portal when upgrading from 2.5.x to
2.6.x.

If you are currently using the Developer Portal in 1.5.x, it will no longer work without
[manually migrating files](/enterprise/2.1.x/developer-portal/latest-migrations) to version 2.1.x.

## Upgrade considerations

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

* If you are adding a new plugin to your installation, you need to run
  `kong migrations up` with the plugin name specified. For example,
  `KONG_PLUGINS=oauth2`.

### Dependencies

If you are using the provided binary packages, all necessary dependencies
for the gateway are bundled and you can skip this section.

If you are building your dependencies by hand, there are changes since the
previous release, so you will need to rebuild them with the latest patches.

The required OpenResty version for kong 2.6.x is
[1.19.9.1](https://openresty.org/en/changelog-1019003.html). This is more recent
than the version in Kong 2.5.0 (which used `1.19.3.2`). In addition to an upgraded
OpenResty, you will need the correct [OpenResty patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/openresty-patches)
for this new version, including the latest release of [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module).
The [kong-build-tools](https://github.com/Kong/kong-build-tools)
repository contains [openresty-build-tools](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools),
which allows you to more easily build OpenResty with the necessary patches and modules.

There is a new way to deploy Go using Plugin Servers.
For more information, see [Developing Go plugins](https://docs.konghq.com/gateway-oss/2.6.x/external-plugins/#developing-go-plugins).


There are **Changes in the Nginx configuration file**, between kong 2.0.x,
2.1.x, 2.2.x, 2.3.x, 2.4.x and 2.5.x.

To view the configuration changes between versions, clone the
[Kong repository](https://github.com/kong/kong) and run `git diff`
on the configuration templates, using `-w` for greater readability.

Here's how to see the differences between previous versions and 2.6.x:

```bash
git clone https://github.com/kong/kong
cd kong
git diff -w 2.0.0 2.6.0 kong/templates/nginx_kong*.lua
```

**Note:** Adjust the starting version number
(2.0.x, 2.1.x, 2.2.x, 2.3.x, 2.4.x or 2.5.x) to the version number you are currently using.

To produce a patch file, use the following command:

```bash
git diff 2.0.0 2.6.0 kong/templates/nginx_kong*.lua > kong_config_changes.diff
```

**Note:** Adjust the starting version number
(2.0.x, 2.1.x, 2.2.x, 2.3.x, 2.4.x or 2.5.x) to the version number you are currently using.

### Hybrid mode considerations

{:.important}
> **Important:** If you are currently running in [hybrid mode](/enterprise/{{page.kong_version}}/deployment/hybrid-mode/), 
upgrade the Control Plane first, and then the Data Planes.

* If you are currently running 2.6.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup/)
  after running the migration.
* Custom plugins (either your own plugins or third-party plugins that are not shipped with Kong)
  need to be installed on both the Control Plane and the Data Planes in Hybrid mode. Install the
  plugins on the Control Plane first, and then the Data Planes.
* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not
    support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

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

This ensures that all instances are using the new Kong package before running kong migrations finish.

## Migrate databases for Upgrades {#migrate-db}

Kong Gateway supports the zero downtime migration model. This means
that while the migration is in process, you have two Kong clusters with different
versions running that are sharing the same database. This is sometimes referred
to as the
[blue-green migration model](https://en.wikipedia.org/wiki/Blue-green_deployment).

The migrations are designed so that there is no need to fully copy
the data. The new version of Kong Gateway is able to use the data as it
is migrated, and the old Kong cluster keeps working until it is finally time to
decommission it. For this reason, the full migration is split into two commands:

- `kong migrations up`: performs only non-destructive operations
- `kong migrations finish`: puts the database in the final expected state (DB-less
  mode is not supported in Kong Gateway)

### Postgres

1. Download 2.6.x, and configure it to point to the same datastore as your old
   2.5.x (or 2.6.x-beta) cluster.
2. Run `kong migrations up`.
3. After that finishes running, both the old (2.5.x) and new (2.6.x) clusters can
   now run simultaneously on the same datastore. Start provisioning 2.6.x nodes,
   but do _not_ use their Admin API yet.

   {:.important}
   > **Important:** If you need to make Admin API requests,
   these should be made to the old cluster's nodes. This prevents
   the new cluster from generating data that is not understood by the old
   cluster.

4. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 2.6.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
5. When your traffic is fully migrated to the 2.6.x cluster, decommission your
   old 2.5.x (or 2.6.x-beta) nodes.
6. From your 2.6.x cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old 2.5.x (or 2.6.x-beta) cluster
   that still points to the same datastore. Run this command _only_ when you are
   confident that your migration was successful. From now on, you can safely make
   Admin API requests to your 2.6.x nodes.

### Cassandra

Due to internal changes, the table schemas used by Kong Gateway 2.6.x on Cassandra
are incompatible with those used by Kong Gateway 2.0.x. Migrating using the usual commands
`kong migrations up` and `kong migrations finish` will require a small
window of downtime, since the old and new versions cannot use the
database at the same time. Alternatively, to keep your previous version fully
operational while the new one initializes, you will need to transfer the
data to a new keyspace using a database dump, as described below:

1. Download 2.6.x, and configure it to point to a new keyspace.

2. Run `kong migrations bootstrap`.

   Once that finishes running, both the old (2.5.x) and new (2.6.x)
   clusters can now run simultaneously, but the new cluster does not
   have any data yet.
3. On the old cluster, run `kong config db_export`. This will create
   a file named `kong.yml` with a database dump.
4. Transfer the file to the new cluster and run
   `kong config db_import kong.yml`. This will load the data into the new cluster.
5. Gradually divert traffic away from your old nodes, and into
   your 2.5.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
6. When your traffic is fully migrated to the 2.6.x cluster,
   decommission your old nodes.

## Install Kong Gateway on a fresh datastore

For installing on a fresh datastore, Kong Gateway 2.6.x has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 2.6.x cluster from a fresh datastore. By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
kong migrations bootstrap [-c /path/to/kong.conf]
kong start [-c /path/to/kong.conf]
```
