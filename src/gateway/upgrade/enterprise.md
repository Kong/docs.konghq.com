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
distinction between major, minor, and patch versions. The upgrade
path for major and minor versions differs depending on the previous version
from which you are migrating:

- If you are migrating from 2.x.x, upgrading to 2.8.x is a
**minor** upgrade. You can upgrade from any 2.1.x or later version directly to
2.8.x.

- If you are migrating from 1.x.x, upgrading to 2.8.x is a **major**
upgrade. While you can upgrade directly to the latest version, be aware of any
breaking changes between the 1.x and 2.x series noted in this document
(both this version and prior versions) and in the Gateway changelogs.

    See specific breaking changes in the Kong Gateway changelogs:
    [open-source (OSS)](https://github.com/Kong/kong/blob/2.0.0/CHANGELOG.md#200) and
    [Enterprise](/gateway/changelog/#2131). Since Kong Gateway is built on an
    open-source foundation, any breaking changes in OSS affect all Gateway packages.

In either case, you can review the [upgrade considerations](#upgrade-considerations),
then follow the [database migration](#migrate-db) instructions.

## Upgrade considerations

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

If you are adding a new plugin to your installation, you need to run
`kong migrations up` with the plugin name specified. For example,
`KONG_PLUGINS=oauth2`.

### Kong Manager breaking changes

Version 2.7.x introduced a new way to configure the OIDC plugin to map IdP roles
to Kong Manager admin accounts.

If you are upgrading from 2.6.x or earlier,
you must now specify the `admin_claim` instead of the `consumer_claim` in your
OIDC config file. For more information, see
[OIDC Authenticated Group Mapping](/gateway/{{page.kong_version}}/configure/auth/kong-manager/oidc-mapping/).

### Dev Portal migrations

There are no migrations necessary for the Dev Portal when upgrading from 2.7.x to
2.8.x.

If you are currently using the Dev Portal in 1.5.x or earlier,
[manually migrate the files](/enterprise/2.1.x/developer-portal/latest-migrations)
to version 2.1.x before continuing.

### Hybrid mode considerations

{:.important}
> **Important:** If you are currently running in [hybrid mode](/gateway/{{page.kong_version}}/plan-and-deploy/hybrid-mode/),
upgrade the control plane first, and then the data planes.

* If you are currently running 2.7.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/gateway/{{page.kong_version}}/plan-and-deploy/hybrid-mode/hybrid-mode-setup/)
  after running the migration.
* Custom plugins (either your own plugins or third-party plugins that are not shipped with Kong)
  need to be installed on both the control plane and the data planes in hybrid mode. Install the
  plugins on the control plane first, and then the data planes.
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

This ensures that all instances are using the new Kong package before running
`kong migrations finish`.

## Upgrade from 1.x.x - 2.7.x to 2.8.x {#migrate-db}

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
[install 2.8.x on a fresh datastore](#install-28x-on-a-fresh-datastore).

### Postgres

1. Download 2.8.x, and configure it to point to the same
   datastore as your old (1.x.x-2.x.x) cluster.
2. Run `kong migrations up`.
3. After that finishes running, both the old (1.x.x-2.x.x) and new (2.8.x) clusters can
   now run simultaneously on the same datastore. Start provisioning 2.8.x nodes,
   but do _not_ use their Admin API yet.

   {:.important}
   > **Important:** If you need to make Admin API requests,
   these should be made to the old cluster's nodes. This prevents
   the new cluster from generating data that is not understood by the old
   cluster.

4. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 2.8.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
5. When your traffic is fully migrated to the 2.8.x cluster, decommission your
   old nodes.
6. From your 2.8.x cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old cluster
   that still points to the same datastore.

     Run this command _only_ when you are
     confident that your migration was successful. From now on, you can safely make
     Admin API requests to your 2.8.x nodes.

### Cassandra

Due to internal changes, the table schemas used by {{site.ee_product_name}} 2.8.x on Cassandra
are incompatible with those used by {{site.ee_product_name}} 2.1.x or lower. Migrating using the usual commands
`kong migrations up` and `kong migrations finish` will require a small
window of downtime, since the old and new versions cannot use the
database at the same time.

Alternatively, to keep your previous version fully operational while the new
one initializes, transfer the data to a new keyspace using a database dump, as
described below:

1. Download 2.8.x, and configure it to point to a new keyspace.

2. Run `kong migrations bootstrap`.

   Once that finishes running, both the old (1.x.x-2.1.x) and new (2.8.x)
   clusters can now run simultaneously, but the new cluster does not
   have any data yet.
3. On the old cluster, run `kong config db_export`. This will create
   a file named `kong.yml` with a database dump.
4. Transfer the file to the new cluster and run
   `kong config db_import kong.yml`. This will load the data into the new cluster.
5. Gradually divert traffic away from your old nodes, and into
   your 2.7.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
6. When your traffic is fully migrated to the 2.8.x cluster,
   decommission your old nodes.

### Install 2.8.x on a fresh datastore

For installing on a fresh datastore, {{site.ee_product_name}} 2.8.x has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 2.8.x cluster from a fresh datastore. By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
$ kong migrations bootstrap [-c /path/to/kong.conf]
$ kong start [-c /path/to/kong.conf]
```
