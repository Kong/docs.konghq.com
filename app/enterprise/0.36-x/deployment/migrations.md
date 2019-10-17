---
title: Migrating to 0.36
---

### Prerequisites for Migrating to 0.36

* If running a version of **Kong Enterprise** earlier than 0.35, [migrate to 0.35](/enterprise/0.35-x/deployment/migrations/) first.
* If running a version of **Kong** earlier than 1.2, [upgrade to Kong 1.2](/1.2.x/upgrading/) before upgrading to Kong Enterprise 0.36.

### Changes and Configuration to Consider before Upgrading

* If using RBAC with Kong Manager, it will be necessary to manually add the [Session Plugin configuration values](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager).
* Kong Manager and the Admin API must share the same domain in order to use the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies" target="_blank">SameSite</a> directive. If they are on separate domains, `cookie_samesite` must be set to `“off”`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager)
* Kong Manager must be served over HTTPS in order for the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies" target="_blank">Secure</a> directive to work. If using Kong Manager with only HTTP, e.g. on `localhost`, then `cookie_secure` must be set to `false`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security)
* Instances where the Portal and Files API are on different hostnames require that they at least share a common root, and that the `cookie_domain` setting of the Portal session configuration be that common root. For example, if the Portal itself is at `portal.kong.example` and the Files API is at `files.kong.example`, `cookie_domain=.kong.example`.
* Portal-related `rbac_role_endpoints` will be updated to adhere to changes in the Dev Portal API. This only applies to Portal-related endpoints that were present in or set by Kong Manager; any user-generated endpoints will need to be updated manually.  The endpoints that will be updated automatically are as follows:

```
'/portal/*'                     => '/developers/*', '/files/*'
'/portal/developers'            => '/developers/*'
'/portal/developers/*'          => '/developers/*'
'/portal/developers/*/*'        => '/developers/*/*'
'/portal/developers/*/email'    => '/developers/*/email'
'/portal/developers/*/meta'     => '/developers/*/meta'
'/portal/developers/*/password' => '/developers/*/password'
'/portal/invite'                => '/developers/invite'
```
* As a result of the switch to server-side rendering, a few portal template files need to be updated or replaced to regain full functionality:
    1. Replace contents of partial `spec/index-vue` with contents of:
    [https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/spec/index-vue.hbs](https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/spec/index-vue.hbs)
    2. Replace contents of partial `search/widget-vue` with contents of:
    [https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/search/widget-vue.hbs](https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/search/widget-vue.hbs)
    3. Create or update partial  `unauthenticated/assets/icons/search-header` with contents of:
    [https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-header.hbs](https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-header.hbs)
    4. Create or update partial  `unauthenticated/assets/icons/loading` with contents of:
    [https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/loading.hbs](https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/loading.hbs)
    5. Create or update partial `unauthenticated/assets/icons/search-widget` with contents of:
    [https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-widget.hbs](https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-widget.hbs)

### Migration Steps from 0.35 to 0.36

For a no-downtime migration from a 0.35 cluster to a 0.36 cluster:

1. Download 0.36, and configure it to point to the same datastore as your 0.35 cluster.
2. Run `kong migrations up`. Both 0.35 and 0.36 nodes can now run simultaneously on the same datastore.
3. Start provisioning 0.36 nodes.
4. Gradually divert traffic away from your 0.35 nodes, and into your 0.36 cluster. Monitor your traffic to make sure everything is going smoothly.
5. When your traffic is fully migrated to the 0.35 cluster, decommission your 0.35 nodes.
6. From your 0.36 cluster, run `kong migrations finish`. From this point on, it will not be possible to start 0.35 nodes pointing to the same datastore anymore. Only run this command when you are confident that your migration was successful. From now on, you can safely make Admin API requests to your 0.36 nodes.

At any step of the way, you may run `kong migrations list` to get a report of the state of migrations. It will list whether there are missing migrations, if there are pending migrations (which have already started in the `kong migrations up` step and later need to finish in the `kong migrations finish` step) or if there are new migrations available. The status code of the process will also change accordingly:

* `0` - migrations are up-to-date
* `1` - failed inspecting the state of migrations (e.g. database is down)
* `3` - database needs bootstrapping: you should run `kong migrations bootstrap` to install on a fresh datastore.
* `4` - there are pending migrations: once your old cluster is decommissioned you should run `kong migrations finish` (step 5 above).
* `5` - there are new migrations: you should start a migration sequence (beginning from step 1 above).

### Migration Steps from Kong 1.2 to Kong Enterprise 0.36

<div class="alert alert-warning">
  <strong>Note:</strong> This action is irreversible, therefore it is highly recommended to have a backup of production data.
</div>

Kong Enterprise 0.36 includes a command to migrate all Kong entities to Kong Enterprise. The following steps will guide you through the migration process.

First download Kong Enterprise 0.36, and configure it to point to the same datastore as your Kong 1.2 node. The migration command expects the datastore to be up to date on any pending migration:

```shell
$ kong migrations up [-c config]
$ kong migrations finish [-c config]
```

Once all Kong Enterprise migrations are up to date, the migration command can be run as:

```shell
$ kong migrations migrate-community-to-enterprise [-c config] [-f] [-y]
```

Confirm now that all the entities are now available on your Kong Enterprise 0.36 node.
