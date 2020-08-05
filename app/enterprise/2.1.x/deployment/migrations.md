---
title: Migrating from 1.5.x to 2.1.x
toc: true
---

## Overview

Upgrade to major and patch {{site.ee_product_name}} releases using the
`kong migrations` commands.

You can also use the commands to migrate all {{site.ce_product_name}} entities
to {{site.ee_product_name}}.

### Upgrade Path for Major Kong Enterprise Releases

If you are not on {{site.ee_product_name}} 1.5.x, you must first incrementally
upgrade to 1.5.x before upgrading to 2.1.x. Zero downtime is possible but not
guaranteed when upgrading incrementally from versions 0.36.x to 1.3.x to 1.5.x.

### Prerequisites for Migrating to 2.1

* If running a version of {{site.ee_product_name}} earlier than 1.3,
  [migrate to 1.3](/enterprise/1.3-x/deployment/migrations/) first.
* If running a version of {{site.ee_product_name}} earlier than 1.5,
  [migrate to 1.5](/enterprise/1.5.x/deployment/migrations/) first.

### Migrating from 1.5.x to 2.1.x

{{site.ee_product_name}} supports the no downtime migration model. This means
that while the migration is in process, you have two Kong clusters with different
versions running that are sharing the same database. This is sometimes referred
to as the
[blue-green migration model](https://en.wikipedia.org/wiki/Blue-green_deployment).

The migrations are designed so that there is no need to fully copy
the data. Kong migrations are designed such that the new version of {{site.ee_product_name}}
is able to use the data as it is migrated, and to do so in a way so that the old
Kong cluster keeps working until it is finally time to decommission it. For this
reason, the full migration is split into two commands:

- `kong migrations up`: performs only non-destructive operations
- `kong migrations finish`: puts the database in the final expected state

1. Download 2.1.x, and configure it to point to the same datastore as your old
   1.5.x cluster.
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
   old 1.5 nodes.
6. From your 2.1 cluster, run `kong migrations finish`. From this point onward,
   it is no longer possible to start nodes in the old 1.5 cluster that still points
   to the same datastore. Run this command _only_ when you are confident that
   your migration was successful. From now on, you can safely make Admin API
   requests to your 2.1 nodes.

### Installing 2.1 on a fresh datastore

For installing on a fresh datastore, {{site.ee_product_name}} 2.1 has the
`kong migrations bootstrap` command. You can run the following commands to
prepare a new 2.1 cluster from a fresh datastore:

```
$ kong migrations bootstrap [-c config]
$ kong start [-c config]
```

## Migrating from Kong Community Gateway 2.1 to Kong Enterprise 2.1

{{site.ee_product_name}} 2.1 includes a command parameter `migrate-community-to-enterprise`
to migrate all {{site.ce_product_name}} entities to {{site.ee_product_name}}.

### Prerequisites for Migrating to 2.1

* If running a version of {{site.ce_product_name}} earlier than 1.5,
  [upgrade to Kong 1.5](/1.5.x/upgrading/) before upgrading to
  {{site.ee_product_name}} 2.1.

<div class="alert alert-red">
     <strong>Warning:</strong> This action is irreversible, therefore it is strongly
     recommended to back up your production data before migrating from
     {{site.ce_product_name}} to {{site.ee_product_name}}.
</div>

The following steps guide you through the migration process.

1. Download {{site.ee_product_name}} 2.1 and configure it to point to the
   same datastore as your {{site.ce_product_name}} 2.1 node. The migration command
   expects the datastore to be up-to-date on any pending migration:

   ```shell
   $ kong migrations up [-c config]
   $ kong migrations finish [-c config]
   ```

2. After all {{site.ee_product_name}} migrations are up-to-date, run the
   migration command:

   ```shell
   $ kong migrations migrate-community-to-enterprise [-c config] [-f] [-y]
   ```
3. Confirm that all of the entities are now available on your
   {{site.ee_product_name}} node.

### Upgrade Path for Patch Releases

There are no migrations in upgrades between current or
future patch releases of the same minor release of {{site.ee_product_name}}
(for example, 1.5.0.0 to 1.5.0.1; 2.1.0.0 to 2.1.0.1, and so forth). Therefore,
the upgrade process is simpler for patch releases.

#### Prerequisites

- Assuming that {{site.ee_product_name}} is already running on your system,
  acquire the latest version from any of the available
  [installation methods](https://docs.konghq.com/enterprise/2.1.x/deployment/installation/overview/)
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

## Troubleshooting migrations



## Migrate the Dev Portal templates

{% include /md/{{page.kong_version}}/migrations/migrate-dev-portal.md %}
