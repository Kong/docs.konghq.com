---
title: Upgrade guide
---

<div class="alert alert-warning">
  <strong>Note:</strong> What follows is the upgrade guide for 1.3.x.
  If you are trying to upgrade to an earlier version of Kong, please read
  <a href="https://github.com/Kong/kong/blob/master/UPGRADE.md">UPGRADE.md file in the Kong repo</a>
</div>

This guide will inform you about breaking changes you should be aware of
when upgrading, as well as take you through the correct sequence of steps
in order to obtain a **no-downtime** migration in different upgrade
scenarios.

## Upgrade to `1.3`

Kong adheres to [semantic versioning](https://semver.org/), which makes a
as well as breaking changes.
distinction between "major", "minor" and "patch" versions. The upgrade path
will be different on which previous version from which you are migrating.

If you are upgrading from 0.x, this is a major upgrade. If you are
upgrading from 1.0.x, 1.1.x, or 1.2.x, this is a minor upgrade. Both
scenarios are explained below.

## 1. Breaking Changes

### Dependencies

If you are using the provided binary packages, all necessary dependencies
are bundled. If you are building your dependencies by hand, you should
be aware of the following changes:

- The required OpenResty version has been bumped to
  [1.15.8.1](http://openresty.org/en/changelog-1015008.html). If you are
  installing Kong from one of our distribution packages, you are not affected
  by this change.
- From this version on, the new
  [lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module) Nginx
  module is **required** to be built into OpenResty for Kong to function
  properly. If you are installing Kong from one of our distribution packages,
  you are not affected by this change.
  [openresty-build-tools#26](https://github.com/Kong/openresty-build-tools/pull/26)

**Note:** if you are not using one of our distribution packages and compiling
OpenResty from source, you must still apply Kong's [OpenResty
patches](https://github.com/kong/openresty-patches) (and, as highlighted above,
compile OpenResty with the new lua-kong-nginx-module). Our new
[openresty-build-tools](https://github.com/Kong/openresty-build-tools)
repository will allow you to do both easily.

### Core

- Bugfixes in the router *may, in some edge-cases*, result in different Routes
  being matched. It was reported to us that the router behaved incorrectly in
  some cases when configuring wildcard Hosts and regex paths (e.g.
  [#3094](https://github.com/Kong/kong/issues/3094)). It may be so that you are
  subject to these bugs without realizing it. Please ensure that wildcard Hosts
  and regex paths Routes you have configured are matching as expected before
  upgrading.
  [9ca4dc0](https://github.com/Kong/kong/commit/9ca4dc09fdb12b340531be8e0f9d1560c48664d5)
  [2683b86](https://github.com/Kong/kong/commit/2683b86c2f7680238e3fe85da224d6f077e3425d)
  [6a03e1b](https://github.com/Kong/kong/commit/6a03e1bd95594716167ccac840ff3e892ed66215)
- Upstream connections are now only kept-alive for 100 requests or 60 seconds
  (idle) by default. Previously, upstream connections were not actively closed
  by Kong. This is a (non-breaking) change in behavior inherited from Nginx
  1.15, and configurable via new configuration properties.

### Configuration

- The `upstream_keepalive` configuration property is deprecated, and replaced
  by the new `nginx_http_upstream_keepalive` property. Its behavior is almost
  identical, but the notable difference is that the latter leverages the
  [injected Nginx
  directives](https://konghq.com/blog/kong-ce-nginx-injected-directives/)
  feature added in Kong 0.14.0.

## 2. Suggested Upgrade Path

### Upgrade from `0.x` to `1.3`

The lowest version that Kong 1.3 supports migrating from is 0.14.1. if you
are migrating from a previous 0.x release, please migrate to 0.14.1 first.

For upgrading from 0.14.1 to Kong 1.3, the steps for upgrading are the same as
upgrading from 0.14.1 to Kong 1.0. Please follow the steps described in the
"Migration Steps from 0.14" in the [Suggested Upgrade Path for Kong
1.0](#kong-1-0-upgrade-path).

### Upgrade from `1.0.x` - `1.2.x` to `1.3`

Kong 1.3 supports the no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that there is no need to fully copy
the data, but this also means that they are designed in such a way so that
the new version of Kong is able to use the data as it is migrated, and to do
it in a way so that the old Kong cluster keeps working until it is finally
time to decommission it. For this reason, the full migration is now split into
two steps, which are performed via commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong 1.2).

1. Download 1.3, and configure it to point to the same datastore as your old
   (1.0 - 1.2) cluster. Run `kong migrations up`.
2. Once that finishes running, both the old and new (1.3) clusters can now run
   simultaneously on the same datastore. Start provisioning 1.3 nodes, but do
   not use their Admin API yet. If you need to perform Admin API requests,
   these should be made to the old cluster's nodes.  The reason is to prevent
   the new cluster from generating data that is not understood by the old
   cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 1.3 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 1.3 cluster, decommission your
   old nodes.
5. From your 1.3 cluster, run: `kong migrations finish`.  From this point on,
   it will not be possible to start nodes in the old cluster pointing to the
   same datastore anymore. Only run this command when you are confident that
   your migration was successful. From now on, you can safely make Admin API
   requests to your 1.3 nodes.

### Installing 1.3 on a Fresh Datastore

The following commands should be used to prepare a new 1.3 cluster from a fresh
datastore:

```
$ kong migrations bootstrap [-c config]
$ kong start [-c config]
```
