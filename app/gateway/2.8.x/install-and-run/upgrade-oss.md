---
# Generated via autodoc/upgrading/generate.lua in the kong/kong repo
title: Upgrade Kong Gateway OSS
badge: oss
---

This document guides you through the process of upgrading {{site.ce_product_name}} to the **latest version**.
To upgrade to prior versions, find the version number in the
[Upgrade doc in GitHub](https://github.com/Kong/kong/blob/master/UPGRADE.md).

## Suggested upgrade path

Unless indicated otherwise in one of the upgrade paths of this document, it is
possible to upgrade Kong **without downtime**.

Assuming that Kong is already running on your system, acquire the latest
version from any of the available [installation methods](https://getkong.org/install/)
and proceed to install it, overriding your previous installation.

**If you are planning to make modifications to your configuration, this is a
good time to do so**.

Then, run migration to upgrade your database schema:

```shell
$ kong migrations up [-c configuration_file]
```

If the command is successful, and no migration ran
(no output), then you only have to
[reload](https://docs.konghq.com/gateway-oss/2.7.x/cli/#kong-reload) Kong:

```shell
$ kong reload [-c configuration_file]
```

**Reminder**: `kong reload` leverages the Nginx `reload` signal that seamlessly
starts new workers, which take over from old workers before those old workers
are terminated. In this way, Kong will serve new requests via the new
configuration, without dropping existing in-flight connections.

## Upgrade to `2.7.x`

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between "major", "minor", and "patch" versions. The upgrade path
will be different depending on which previous version from which you are migrating.

If you are migrating from 2.x.x, upgrading into 2.7.x is a
minor upgrade, but read below for important instructions on database migration,
especially for Cassandra users.

If you are migrating from 1.x, upgrading into 2.7.x is a major upgrade,
so, in addition, be aware of any [breaking changes](https://github.com/Kong/kong/blob/master/UPGRADE.md#breaking-changes-2.0)
between the 1.x and 2.x series below, further detailed in the
[CHANGELOG.md](https://github.com/Kong/kong/blob/2.0.0/CHANGELOG.md#200) document.


### Dependencies

If you are using the provided binary packages, all necessary dependencies
for the gateway are bundled and you can skip this section.

If you are building your dependencies by hand, there are changes since the
previous release, so you will need to rebuild them with the latest patches.

The required OpenResty version for kong 2.7.x is
[1.19.9.1](https://openresty.org/en/changelog-1019003.html). This is more recent
than the version in Kong 2.5.0 (which used `1.19.3.2`). In addition to an upgraded
OpenResty, you will need the correct [OpenResty patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/openresty-patches)
for this new version, including the latest release of [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module).
The [kong-build-tools](https://github.com/Kong/kong-build-tools)
repository contains [openresty-build-tools](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools),
which allows you to more easily build OpenResty with the necessary patches and modules.

There is a new way to deploy Go using Plugin Servers.
For more information, see [Developing Go plugins](https://docs.konghq.com/gateway-oss/2.6.x/external-plugins/#developing-go-plugins).

### Template changes

There are **Changes in the Nginx configuration file**, between kong 2.0.x,
2.1.x, 2.2.x, 2.3.x, 2.4.x, 2.5.x, 2.6.x and 2.7.x

To view the configuration changes between versions, clone the
[Kong repository](https://github.com/kong/kong) and run `git diff`
on the configuration templates, using `-w` for greater readability.

Here's how to see the differences between previous versions and 2.7.x:

```
git clone https://github.com/kong/kong
cd kong
git diff -w 2.0.0 2.7.0 kong/templates/nginx_kong*.lua
```

**Note:** Adjust the starting version number
(2.0.x, 2.1.x, 2.2.x, 2.3.x, 2.4.x, 2.5.x, 2.6.x, 2.7.x) to the version number you are currently using.

To produce a patch file, use the following command:

```
git diff 2.0.0 2.7.0 kong/templates/nginx_kong*.lua > kong_config_changes.diff
```

**Note:** Adjust the starting version number
(2.0.x, 2.1.x, 2.2.x, 2.3.x, 2.4.x, 2.5.x, 2.6.x, 2.7.x) to the version number you are currently using.


### Suggested upgrade path

**Version prerequisites for migrating to version 2.7.x**

The lowest version that Kong 2.7.x supports migrating from is 1.0.x.
If you are migrating from a version lower than 0.14.1, you need to
migrate to 0.14.1 first. Then, once you are migrating from 0.14.1,
please migrate to 1.5.x first.

The steps for upgrading from 0.14.1 to 1.5.x are the same as upgrading
from 0.14.1 to Kong 1.0. Please follow the steps described in the
"Migration Steps from 0.14" in the

[Suggested Upgrade Path for Kong 1.0](https://github.com/Kong/kong/blob/master/UPGRADE.md#kong-1-0-upgrade-path)
with the addition of the `kong migrations migrate-apis` command,
which you can use to migrate legacy `apis` configurations.

Once you migrated to 1.5.x, you can follow the instructions in the section
below to migrate to 2.7.x.

### Upgrade from `1.0.x` - `2.2.x` to `2.7.x`

**Postgres**

Kong 2.7.x supports a no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that the new version of Kong is able to use
the database as it is migrated while the old Kong cluster keeps working until
it is time to decommission it. For this reason, the migration is split into
two steps, performed via commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong 2.7.x).

1. Download 2.7.x, and configure it to point to the same datastore
   as your old (1.0 to 2.0) cluster. Run `kong migrations up`.
2. After that finishes running, both the old (2.x.x) and new (2.7.x)
   clusters can now run simultaneously. Start provisioning 2.7.x nodes,
   but do not use their Admin API yet. If you need to perform Admin API
   requests, these should be made to the old cluster's nodes. The reason
   is to prevent the new cluster from generating data that is not understood
   by the old cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 2.7.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 2.7.x cluster,
   decommission your old nodes.
5. From your 2.7.x cluster, run: `kong migrations finish`.
   From this point on, it will not be possible to start
   nodes in the old cluster pointing to the same datastore anymore. Only run
   this command when you are confident that your migration
   was successful. From now on, you can safely make Admin API
   requests to your 2.7.x nodes.

**Cassandra**

Deprecation notice:
Cassandra as a backend database for Kong Gateway is deprecated. This means the feature will eventually be removed. Our target for Cassandra removal is the Kong Gateway 4.0 release, and some new features might not be supported with Cassandra in the Kong Gateway 3.0 release.

Due to internal changes, the table schemas used by Kong 2.7.x on Cassandra
are incompatible with those used by Kong 2.1.x (or lower). Migrating using the usual commands
`kong migrations up` and `kong migrations finish` will require a small
window of downtime, since the old and new versions cannot use the
database at the same time. Alternatively, to keep your previous version fully
operational while the new one initializes, you will need to transfer the
data to a new keyspace via a database dump, as described below:

1. Download 2.7.x, and configure it to point to a new keyspace.
   Run `kong migrations bootstrap`.
2. Once that finishes running, both the old (pre-2.1) and new (2.7.x)
   clusters can now run simultaneously, but the new cluster does not
   have any data yet.
3. On the old cluster, run `kong config db_export`. This will create
   a file `kong.yml` with a database dump.
4. Transfer the file to the new cluster and run
   `kong config db_import kong.yml`. This will load the data into the new cluster.
5. Gradually divert traffic away from your old nodes, and into
   your 2.7.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
6. When your traffic is fully migrated to the 2.7.x cluster,
   decommission your old nodes.

### Installing 2.7.x on a fresh datastore

The following commands should be used to prepare a new 2.7.x cluster from a
fresh datastore. By default the `kong` CLI tool will load the configuration
from `/etc/kong/kong.conf`, but you can optionally use the flag `-c` to
indicate the path to your configuration file:

```
$ kong migrations bootstrap [-c /path/to/your/kong.conf]
$ kong start [-c /path/to/your/kong.conf]
```
Unless indicated otherwise in one of the upgrade paths of this document, it is
possible to upgrade Kong **without downtime**.

Assuming that Kong is already running on your system, acquire the latest
version from any of the available [installation methods](https://getkong.org/install/)
and proceed to install it, overriding your previous installation.

**If you are planning to make modifications to your configuration, this is a
good time to do so**.

Then, run migration to upgrade your database schema:

```shell
$ kong migrations up [-c configuration_file]
```

If the command is successful, and no migration ran
(no output), then you only have to
[reload](https://docs.konghq.com/gateway-oss/2.7.x/cli/#kong-reload) Kong:

```shell
$ kong reload [-c configuration_file]
```

**Reminder**: `kong reload` leverages the Nginx `reload` signal that seamlessly
starts new workers, which take over from old workers before those old workers
are terminated. In this way, Kong will serve new requests via the new
configuration, without dropping existing in-flight connections.
