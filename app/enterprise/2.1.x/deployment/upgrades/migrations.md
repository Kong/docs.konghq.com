---
title: Migrating Kong Enterprise from 1.5.x to 2.1.x
toc: true
---

## Overview

Upgrade to major, minor, and patch {{site.ee_product_name}} releases using the
`kong migrations` commands.

You can also use the commands to migrate all {{site.ce_product_name}} entities
to {{site.ee_product_name}}. See [Migrating from Kong Gateway to Kong Enterprise](#migrate-ce-ee).

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
* The [Rate Limiting Advanced](/hub/rate-limiting-advanced) plugin does not
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
  [manually migrating files](#migrate-dev-portal).

### Migrating from 1.5.x (or 2.1.x-beta) to 2.1.x

**Note:** There is not an upgrade migration path from 1.5.x to 2.1.x-beta.

{{site.ee_product_name}} supports the zero downtime migration model. This means
that while the migration is in process, you have two Kong clusters with different
versions running that are sharing the same database. This is sometimes referred
to as the
[blue-green migration model](https://en.wikipedia.org/wiki/Blue-green_deployment).

The migrations are designed so that there is no need to fully copy
the data. The new version of {{site.ee_product_name}} is able to use the data as it
is migrated, and the old
Kong cluster keeps working until it is finally time to decommission it. For this
reason, the full migration is split into two commands:

- `kong migrations up`: performs only non-destructive operations
- `kong migrations finish`: puts the database in the final expected state (DB-less
  mode is not supported in {{site.ee_product_name}})

1. Download 2.1.x, and configure it to point to the same datastore as your old
   1.5.x (or 2.1.x-beta) cluster.
2. Run `kong migrations up`.
3. After that finishes running, both the old (1.5) and new (2.1) clusters can
   now run simultaneously on the same datastore. Start provisioning 2.1 nodes,
   but do _not_ use their Admin API yet.

   **Important:** If you need to make Admin API requests,
   these should be made to the old cluster's nodes. This prevents
   the new cluster from generating data that is not understood by the old
   cluster.

4. Gradually divert traffic away from your old nodes, and redirect traffic to
   your 2.1 cluster. Monitor your traffic to make sure everything
   is going smoothly.
5. When your traffic is fully migrated to the 2.1 cluster, decommission your
   old 1.5 (or 2.1.x-beta) nodes.
6. From your 2.1 cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old 1.5 (or 2.1.x-beta) cluster
   that still points to the same datastore. Run this command _only_ when you are
   confident that your migration was successful. From now on, you can safely make
   Admin API requests to your 2.1 nodes.

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

## Migrating from Kong Community Gateway 2.1 to Kong Enterprise 2.1 {#migrate-ce-ee}

As of {{site.ee_product_name}} 2.1, it is no longer necessary to explicitly
run the `migrate-community-to-enterprise` command parameter to to migrate all
Kong Gateway entities to Kong Enterprise. Running the `kong migrations` commands
performs that migration command on your behalf.

**Important:** You can only migrate to a {{site.ee_product_name}} version that
supports the same {{site.ce_product_name}} version.

### Prerequisites

<div class="alert alert-red">
     <strong>Warning:</strong> This action is irreversible, therefore it is strongly
     recommended to back up your production data before migrating from
     {{site.ce_product_name}} to {{site.ee_product_name}}.
</div>

* If running a version of {{site.ce_product_name}} earlier than 2.1,
  [upgrade to Kong 2.1](/2.1.x/upgrading/) before migrating
  {{site.ce_product_name}} to {{site.ee_product_name}} 2.1.

The following steps guide you through the migration process.

1. Download {{site.ee_product_name}} 2.1 and configure it to point to the
   same datastore as your {{site.ce_product_name}} 2.1 node. The migration
   command expects the datastore to be up-to-date on any pending migration:

   ```shell
   $ kong migrations up [-c configuration_file]
   $ kong migrations finish [-c configuration_file]
   ```
2. Confirm that all of the entities are now available on your
   {{site.ee_product_name}} node.

## Migrate the Dev Portal templates {#migrate-dev-portal}

{% include /md/{{page.kong_version}}/migrations/migrate-dev-portal.md %}
