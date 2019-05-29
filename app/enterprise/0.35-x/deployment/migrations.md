---
title: Migrating to 0.35
---

### Prerequisites for Migrating to 0.35

* If running Kong Enterprise 0.34, it is necessary to upgrade to 0.34-1 first before migrating to 0.35. (Likewise, if running a version of Kong Enterprise earlier than 0.34, it is first necessary to [upgrade to 0.34](/enterprise/0.34-x/deployment-guide/#upgrading-to-034) before 0.34-1.)
* If running Kong versions 0.14 or 0.15, you must [upgrade to Kong 1.0](/1.0.x/upgrading/) before upgrading to Kong Enterprise 0.35. You cannot upgrade to Kong Enterprise 0.34 first.
* If running Kong version 0.13 or older, you can either upgrade to Kong 1.0 or Kong Enterprise 0.34 before upgrading to Kong Enterprise 0.35.
* If the datastore still has `API` entities instead of `Services` and `Routes`, upgrading to 0.35 will not be possible. `APIs` were deprecated in release 0.32 and are now removed from Kong. It is possible to convert `APIs` to `Services` and `Routes` and then remove the `APIs` on the 0.34 node.

### Changes and Configuration to Consider before Upgrading

* If using RBAC with Kong Manager, it will be necessary to manually add the [Session Plugin configuration values](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager).
* Kong Manager and the Admin API must share the same domain in order to use the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies" target="_blank">SameSite</a> directive. If they are on separate domains, `cookie_samesite` must be set to `“off”`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager)
* Kong Manager must be served over HTTPS in order for the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies" target="_blank">Secure</a> directive to work. If using Kong Manager with only HTTP, e.g. on `localhost`, then `cookie_secure` must be set to `false`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security)
* Instances where the Portal and Files API are on different hostnames require that they at least share a common root, and that the `cookie_domain` setting of the Portal session configuration be that common root. For example, if the Portal itself is at `portal.kong.example` and the Files API is at `files.kong.example`, `cookie_domain=.kong.example`.
* Portal-related `rbac_role_endpoints` will be updated to adhere to changes in the Dev Portal API.  This only applies to Portal-related endpoints that were present in or set by Kong Manager; any user-generated endpoints will need to be updated manually.  The endpoints that will be updated automatically are as follows:

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
* As a result of the switch to serverside rendering, a few portal template files need to be updated or replaced to regain full functionality:
    1. Replace contents of partial `spec/index-vue` with:
    https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/spec/index-vue.hbs
    2. Replace contents of partial `search/widget-vue` with:
    https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/search/widget-vue.hbs
    3. Create or update partial  `unauthenticated/assets/icons/search-header` with:
    https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-header.hbs
    4. Create or update partial  `unauthenticated/assets/icons/loading` with:
    https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/loading.hbs
    5. Create or update partial `unauthenticated/assets/icons/search-widget` with:
    https://raw.githubusercontent.com/Kong/kong-portal-templates/master/themes/default-ie11/partials/unauthenticated/assets/icons/search-widget.hbs

### Migration Steps from 0.34 to 0.35

Kong 0.35 introduces a new, improved migrations framework. The full migration is now split into two steps, which are performed via commands `kong migrations up` and `kong migrations finish`.

For a no-downtime migration from a 0.34 cluster to a 0.35 cluster:

1. Download 0.35, and configure it to point to the same datastore as your 0.34 cluster.
2. Run `kong migrations up`. Both 0.34 and 0.35 nodes can now run simultaneously on the same datastore.
3. Start provisioning 0.35 nodes, but **do not use** their Admin API yet.

    ⚠️ **Important:** When doing a Blue/Green upgrade in a 0.34 cluster where RBAC is enabled, if you make an Admin API request from a new 0.35 node, from then on, Admin API calls will only work from the new 0.35 node. This is because the new token will be hashed in the database and will fail on the old 0.34 nodes since they do not know how to verify the hashed token. Note also that Admins are present in a new cluster only after running `kong migrations finish`.

4. Gradually divert traffic away from your 0.34 nodes, and into your 0.35 cluster. Monitor your traffic to make sure everything is going smoothly.
5. When your traffic is fully migrated to the 0.35 cluster, decommission your 0.34 nodes.
6. From your 0.35 cluster, run: `kong migrations finish`. From this point on, it will not be possible to start 0.34 nodes pointing to the same datastore anymore. Only run this command when you are confident that your migration was successful. From now on, you can safely make Admin API requests to your 0.35 nodes.

At any step of the way, you may run `kong migrations list` to get a report of the state of migrations. It will list whether there are missing migrations, if there are pending migrations (which have already started in the `kong migrations up` step and later need to finish in the `kong migrations finish` step) or if there are new migrations available. The status code of the process will also change accordingly:

* `0` - migrations are up-to-date
* `1` - failed inspecting the state of migrations (e.g. database is down)
* `3` - database needs bootstrapping: you should run `kong migrations bootstrap` to install on a fresh datastore.
* `4` - there are pending migrations: once your old cluster is decommissioned you should run `kong migrations finish` (step 5 above).
* `5` - there are new migrations: you should start a migration sequence (beginning from step 1 above).
