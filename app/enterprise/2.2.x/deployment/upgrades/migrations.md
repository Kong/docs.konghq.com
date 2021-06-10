---
title: Migrating Kong Enterprise from 2.1.x to 2.2.x
toc: true
---

## Overview

Upgrade to major, minor, and patch {{site.ee_product_name}} releases using the
`kong migrations` commands.

You can also use the commands to migrate all {{site.ce_product_name}} entities
to {{site.ee_product_name}}. See
[Migrating from Kong Gateway to Kong Enterprise](/enterprise/2.2.x/deployment/upgrades/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade Path for Kong Enterprise Releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and [patch](#patch) versions. The upgrade path
for major and minor versions differs depending on the previous version from which
you are migrating:

- Upgrading from 2.1.x to 2.2.x is a minor upgrade; however, read below for important
instructions on [database migration](#migrate-db), especially for Cassandra users.

- Upgrading from from 1.x is a major upgrade. Follow the [Version Prerequisites](#prereqs-v).
Be aware of any noted breaking changes as documented in the version to which you are upgrading.

### Version Prerequisites for Migrating to Kong Enterprise 2.2.x {#prereqs-v}

If you are not on {{site.ee_product_name}} 2.1.x, you must first incrementally
upgrade to 2.1.x before upgrading to 2.2.x. Zero downtime is possible but _not_
guaranteed if you are upgrading incrementally between versions, from 0.36.x to 1.3.x to
1.5.x to 2.1.x to 2.2.x. Plan accordingly.

* If running a version of {{site.ee_product_name}} earlier than 1.3,
  [migrate to 1.3](/enterprise/1.3-x/deployment/migrations/) first.
* If running a version of {{site.ee_product_name}} earlier than 1.5,
  [migrate to 1.5](/enterprise/1.5.x/deployment/migrations/) first.
* If running a version of {{site.ee_product_name}} earlier than 2.1,
  [migrate to 2.1](/enterprise/2.1.x/deployment/upgrades/migrations/) first.

#### Dev Portal Migrations

There are no migrations necessary for the Dev Portal when upgrading from 2.1.x to
2.2.x.

If you are currently using the Developer Portal in 1.5.x, it will no longer work without
[manually migrating files](/enterprise/2.1.x/developer-portal/latest-migrations) to version 2.1.x.


### Upgrade Considerations

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

* [Hybrid mode](/enterprise/{{page.kong_version}}/deployment/hybrid-mode/):
  * **Important:** If you are currently running in hybrid mode, upgrade the Control Plane first, and
    then the Data Planes.
  * If you are currently running 2.2.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup/)
  after running the migration.
  * Custom plugins (either your own plugins or third-party plugins that are not shipped with Kong)
  need to be installed on both the Control Plane and the Data Planes in Hybrid mode. Install the
  plugins on the Control Plane first, and then the Data Planes.
  * The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not
    support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.
* If you are adding a new plugin to your installation, you need to run
  `kong migrations up` with the plugin name specified. For example,
  `KONG_PLUGINS=oauth2`.


### Migrating Databases for Upgrades {#migrate-db}

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

#### Postgres

1. Download 2.2.x, and configure it to point to the same datastore as your old
   2.1.x (or 2.2.x-beta) cluster.
2. Run `kong migrations up`.
3. After that finishes running, both the old (2.1.x) and new (2.2.x) clusters can
   now run simultaneously on the same datastore. Start provisioning 2.2.x nodes,
   but do _not_ use their Admin API yet.

   **Important:** If you need to make Admin API requests,
   these should be made to the old cluster's nodes. This prevents
   the new cluster from generating data that is not understood by the old
   cluster.

4. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 2.2.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
5. When your traffic is fully migrated to the 2.2.x cluster, decommission your
   old 2.1.x (or 2.2.x-beta) nodes.
6. From your 2.2.x cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old 2.1.x (or 2.2.x-beta) cluster
   that still points to the same datastore. Run this command _only_ when you are
   confident that your migration was successful. From now on, you can safely make
   Admin API requests to your 2.2.x nodes.

#### Cassandra

Due to internal changes, the table schemas used by {{site.ee_product_name}} 2.1.x on Cassandra
are incompatible with those used by {{site.ee_product_name}} 2.2.x. Migrating using the usual commands
`kong migrations up` and `kong migrations finish` will require a small
window of downtime, since the old and new versions cannot use the
database at the same time. Alternatively, to keep your previous version fully
operational while the new one initializes, you will need to transfer the
data to a new keyspace using a database dump, as described below:

1. Download 2.2.x, and configure it to point to a new keyspace.

2. Run `kong migrations bootstrap`.

   Once that finishes running, both the old (2.1.x) and new (2.2.x)
   clusters can now run simultaneously, but the new cluster does not
   have any data yet.
3. On the old cluster, run `kong config db_export`. This will create
   a file named `kong.yml` with a database dump.
4. Transfer the file to the new cluster and run
   `kong config db_import kong.yml`. This will load the data into the new cluster.
5. Gradually divert traffic away from your old nodes, and into
   your 2.2.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
6. When your traffic is fully migrated to the 2.2.x cluster,
   decommission your old nodes.

### Installing 2.2.x on a fresh datastore

For installing on a fresh datastore, {{site.ee_product_name}} 2.2.x has the
`kong migrations bootstrap` command. Run the following commands to
prepare a new 2.2.x cluster from a fresh datastore. By default, the `kong` CLI tool
loads the configuration from `/etc/kong/kong.conf`, but you can optionally use
the `-c` flag to indicate the path to your configuration file:

```bash
$ kong migrations bootstrap [-c /path/to/kong.conf]
$ kong start [-c /path/to/kong.conf]
```
