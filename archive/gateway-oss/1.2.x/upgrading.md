---
title: Upgrade guide
---

<div class="alert alert-warning">
  <strong>Note:</strong> What follows is the upgrade guide for 1.2.x.
  If you are trying to upgrade to an earlier version of Kong, please read
  <a href="https://github.com/Kong/kong/blob/master/UPGRADE.md">UPGRADE.md file in the Kong repo</a>
</div>

This guide will inform you about breaking changes you should be aware of
when upgrading, as well as take you through the correct sequence of steps
in order to obtain a **no-downtime** migration in different upgrade
scenarios.

## Upgrade to `1.2`

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between "major", "minor" and "patch" versions. The upgrade path
will be different on which previous version from which you are migrating.
If you are upgrading from 0.x, this is a major upgrade. If you are
upgrading from 1.0.x or 1.1.x, this is a minor upgrade. Both scenarios are
explained below.


## 1. Dependencies

If you are using the provided binary packages, all necessary dependencies
are bundled. If you are building your dependencies by hand, you should
be aware of the following changes:

- The required OpenResty version is 1.13.6.2, but for a full feature set,
  including stream routing and service mesh abilities with mutual TLS, you need
  Kong's [openresty-patches](https://github.com/kong/openresty-patches).
  Note that the set of patches was updated from 1.0 to 1.2.
- The minimum required OpenSSL version is 1.1.1. If you are building by hand,
  make sure all dependencies, including LuaRocks modules, are compiled using
  the same OpenSSL version. If you are installing Kong from one of our
  distribution packages, you are not affected by this change.

## 2. Breaking Changes

Kong 1.2 does not include any breaking changes over Kong 1.0 or 1.1, but Kong 1.0
included a number of breaking changes over Kong 0.x. If you are upgrading
from 0.14,x, please read the section on
[Kong 1.0 Breaking Changes](#kong-1-0-breaking-changes) carefully before
proceeding.

## 3. Suggested Upgrade Path

### Upgrade from `0.x` to `1.2`

The lowest version that Kong 1.2 supports migrating from is 0.14.1. if you
are migrating from a previous 0.x release, please migrate to 0.14.1 first.

For upgrading from 0.14.1 to Kong 1.2, the steps for upgrading are the same as
upgrading from 0.14.1 to Kong 1.0. Please follow the steps described in the
"Migration Steps from 0.14" in the [Suggested Upgrade Path for Kong
1.0](#kong-1-0-upgrade-path).

### Upgrade from `1.0.x` or `1.1.x` to `1.2`

Kong 1.2 supports a no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that there is no need to fully copy
the data, but this also means that they are designed in such a way so that
the new version of Kong is able to use the data as it is migrated, and to do
it in a way so that the old Kong cluster keeps working until it is finally
time to decomission it. For this reason, the full migration is now split into
two steps, which are performed via commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong 1.2).

1. Download 1.2, and configure it to point to the same datastore
   as your old (1.0 or 1.1) cluster. Run `kong migrations up`.
2. Once that finishes running, both the old and new (1.2) clusters can now
   run simultaneously on the same datastore. Start provisioning
   1.2 nodes, but do not use their Admin API yet. If you need to
   perform Admin API requests, these should be made to the old cluster's nodes.
   The reason is to prevent the new cluster from generating data
   that is not understood by the old cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 1.2 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 1.2 cluster,
   decommission your old nodes.
5. From your 1.2 cluster, run: `kong migrations finish`.
   From this point on, it will not be possible to start
   nodes in the old cluster pointing to the same datastore anymore. Only run
   this command when you are confident that your migration
   was successful. From now on, you can safely make Admin API
   requests to your 1.2 nodes.

### Upgrade Path from 1.2 Release Candidates

The process is the same as for upgrading from 1.0 listed above, but on step 1
you should run `kong migrations up --force` instead.

### Installing 1.2 on a Fresh Datastore

For installing on a fresh datastore, Kong 1.2 have the `kong migrations
bootstrap` command. The following commands can be run to prepare a new 1.2
cluster from a fresh datastore:

```
$ kong migrations bootstrap [-c config]
$ kong start [-c config]
```
