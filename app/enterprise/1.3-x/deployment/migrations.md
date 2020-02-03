---
title: Migrating to 1.3
---

### Prerequisites for Migrating to 1.3

* If running a version of **Kong Enterprise** earlier than 0.36, [migrate to 0.36](/enterprise/0.36-x/deployment/migrations/) first.
* If running a version of **Kong** earlier than 1.3, [upgrade to Kong 1.3](/1.3.x/upgrading/) before upgrading to Kong Enterprise 1.3.

### Changes and Configuration to Consider before Upgrading

* If using RBAC with Kong Manager, it will be necessary to manually add the [Session Plugin configuration values](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager).
* Kong Manager and the Admin API must share the same domain in order to use the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies" target="_blank">SameSite</a> directive. If they are on separate domains, `cookie_samesite` must be set to `“off”`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager)
* Kong Manager must be served over HTTPS in order for the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies" target="_blank">Secure</a> directive to work. If using Kong Manager with only HTTP, e.g. on `localhost`, then `cookie_secure` must be set to `false`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security)
* The Kong Developer Portal has undergone a number of **Breaking Changes**, if you are currently using the Developer Portal, it will no longer work without manually migrating files, or enabling **Legacy Mode**. Learn more in [Kong Developer Portal - Whats new in 1.3](/enterprise/{{page.kong_version}}/developer-portal/overview)



### Migration Steps from 0.36 to 1.3

Kong Enterprise 1.3 supports the no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that there is no need to fully copy
the data, but this also means that they are designed in such a way so that
the new version of Kong Enterprise is able to use the data as it is migrated, and to do
it in a way so that the old Kong cluster keeps working until it is finally
time to decommission it. For this reason, the full migration is now split into
two steps, which are performed using commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong Enterprise 1.3).

1. Download 1.3, and configure it to point to the same datastore as your old
   (0.36) cluster. Run `kong migrations up`.
2. Once that finishes running, both the old and new (1.3) clusters can now run
   simultaneously on the same datastore. Start provisioning 1.3 nodes, but do
   not use their Admin API yet. If you need to perform Admin API requests,
   these should be made to the old cluster's nodes. The reason is to prevent
   the new cluster from generating data that is not understood by the old
   cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 1.3 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 1.3 cluster, decommission your
   old nodes.
5. From your 1.3 cluster, run: `kong migrations finish`. From this point on,
   it will not be possible to start nodes in the old cluster pointing to the
   same datastore anymore. Only run this command when you are confident that
   your migration was successful. From now on, you can safely make Admin API
   requests to your 1.3 nodes.

### Migration Steps from Kong 1.2 to Kong Enterprise 1.3

<div class="alert alert-warning">
  <strong>Note:</strong> This action is irreversible, therefore it is highly recommended to have a backup of production data.
</div>

Kong Enterprise 1.3 includes a command to migrate all Kong entities to Kong Enterprise. The following steps will guide you through the migration process.

First download Kong Enterprise 1.3, and configure it to point to the same datastore as your Kong 1.2 node. The migration command expects the datastore to be up to date on any pending migration:

```shell
$ kong migrations up [-c config]
$ kong migrations finish [-c config]
```

Once all Kong Enterprise migrations are up to date, the migration command can be run as:

```shell
$ kong migrations migrate-community-to-enterprise [-c config] [-f] [-y]
```

Confirm now that all the entities are now available on your Kong Enterprise 1.3 node.
