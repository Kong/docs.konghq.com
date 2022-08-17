---
title: Migrating to 1.5
---

### Prerequisites for Migrating to 1.5

* If running a version of **Kong Enterprise** earlier than 1.3, [migrate to 1.3](/enterprise/1.3-x/deployment/migrations/) first.
* If running a version of **Kong Community Gateway** earlier than 1.5, [upgrade to Kong 1.5](/1.5.x/upgrading/) before upgrading to Kong Enterprise 1.5.

### Changes and Configuration to Consider before Upgrading

* If using RBAC with Kong Manager, it will be necessary to manually add the [Session Plugin configuration values](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager).
* Kong Manager and the Admin API must share the same domain in order to use the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies" target="_blank">SameSite</a> directive. If they are on separate domains, `cookie_samesite` must be set to `“off”`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-kong-manager)
* Kong Manager must be served over HTTPS in order for the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies" target="_blank">Secure</a> directive to work. If using Kong Manager with only HTTP, e.g. on `localhost`, then `cookie_secure` must be set to `false`. Learn more in [Session Security](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/#session-security)
* The Kong Developer Portal has undergone a number of **Breaking Changes**, if you are currently using the Developer Portal, it will no longer work without manually migrating files, or enabling **Legacy Mode**. Learn more in [Kong Developer Portal - Whats new in 1.5](/enterprise/{{page.kong_version}}/developer-portal/)
* The Upstream TLS plugin was deprecated in version 1.3, and removed in version 1.5. If you have configured this plugin, remove the plugin before upgrading to version 1.5. Otherwise, {{site.ee_product_name}} will fail to start due to the missing plugin.


### Migration Steps from 1.3 to 1.5

Kong Enterprise 1.5 supports the no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that there is no need to fully copy
the data, but this also means that they are designed in such a way so that
the new version of Kong Enterprise is able to use the data as it is migrated, and to do
it in a way so that the old Kong cluster keeps working until it is finally
time to decommission it. For this reason, the full migration is now split into
two steps, which are performed using commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong Enterprise 1.5).

1. Download 1.5, and configure it to point to the same datastore as your old
   (1.3) cluster. Run `kong migrations up`.
2. Once that finishes running, both the old and new (1.5) clusters can now run
   simultaneously on the same datastore. Start provisioning 1.5 nodes, but do
   not use their Admin API yet. If you need to perform Admin API requests,
   these should be made to the old cluster's nodes. The reason is to prevent
   the new cluster from generating data that is not understood by the old
   cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 1.5 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 1.5 cluster, decommission your
   old nodes.
5. From your 1.5 cluster, run: `kong migrations finish`. From this point on,
   it will not be possible to start nodes in the old cluster pointing to the
   same datastore anymore. Only run this command when you are confident that
   your migration was successful. From now on, you can safely make Admin API
   requests to your 1.5 nodes.


### Migrating Developer Portal from 1.3 to 1.5
Below are the Developer Portal migrations required to move from **Kong Enterprise 1.3** to **Kong Enterprise 1.5**.
You can make these changes with our templates repository using the Kong Portal CLI, or directly in the Kong Editor. We suggest using the templates/CLI in order to take advantage of source control. Links to the templates repository, as well as the portal CLI, can be found below.
##### Links:
- [kong-portal-templates](https://github.com/Kong/kong-portal-templates)
- [kong-portal-cli](https://github.com/Kong/kong-portal-cli)
#### Create Files:
These files need to be created for the 1.5 Kong Developer Portal to function. Please create each file using the path and contents linked below.
- ##### create.txt
  - Templates Path: `/workspaces/default/content/applications/create.txt`
  - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/content/applications/create.txt
- ##### edit.txt
    - Templates Path: `/workspaces/default/content/applications/edit.txt`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/content/applications/edit.txt
- ##### index.txt
    - Templates Path: `/workspaces/default/content/applications/index.txt`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/content/applications/index.txt
- ##### view.txt
    - Templates Path: `/workspaces/default/content/applications/view.txt`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/content/applications/view.txt
- ##### dashboard-6616db8.min.js
    - Templates Path: `/workspaces/default/themes/base/assets/js/dashboard-6616db8.min.js`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/assets/js/dashboard-6616db8.min.js
- ##### swagger-ui-kong-theme-1edc216.min.js
    - Templates Path: `workspaces/default/themes/base/assets/js/swagger-ui-kong-theme-1edc216.min.js`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/assets/js/swagger-ui-kong-theme-1edc216.min.js
- ##### applications.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/applications.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/applications.html
- ##### create-app.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/create-app.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/create-app.html
- ##### edit-app.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/edit-app.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/edit-app.html
- ##### view-app.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/view-app.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/view-app.html
- ##### _app.html
    - Templates Path: `workspaces/default/themes/base/layouts/_app.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/_app.html
#### Replace Files:
These files already exist in your portal and need to be updated. Please replace their current contents with the content linked below.
- ##### header.html
    - Templates Path: `workspaces/default/themes/base/partials/header.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/partials/header.html
- ##### swagger-ui-kong-theme.css
    - Templates Path: `workspaces/default/themes/base/assets/styles/swagger-ui-kong-theme.css`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/assets/styles/swagger-ui-kong-theme.css
- ##### dashboard.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/dashboard.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/dashboard.html
- ##### invalidate-verification.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/invalidate-verification.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/invalidate-verification.html
- ##### resend-verification.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/resend-verification.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/resend-verification.html
- ##### resend-password.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/reset-password.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/reset-password.html
- ##### settings.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/settings.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/settings.html
- ##### spec-renderer.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/spec-renderer.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/spec-renderer.html
- ##### verify-account.html
    - Templates Path: `workspaces/default/themes/base/layouts/system/verify-account.html`
    - File Content: https://github.com/Kong/kong-portal-templates/blob/release/1.5.0.0/workspaces/default/themes/base/layouts/system/verify-account.html
#### Delete Files:
You can remove these files entirely from your Developer Portal.
- ##### dashboard-6ae0d66.min.js
    - Templates Path: `workspaces/default/themes/base/assets/js/dashboard-6ae0d66.min.js`
- ##### swagger-ui-kong-theme-667aef9.min.js
    - Templates Path: `workspaces/default/themes/base/assets/js/swagger-ui-kong-theme-667aef9.min.js`


### Migration Steps from Kong Community Gateway 1.5 to Kong Enterprise 1.5

<div class="alert alert-warning">
  <strong>Note:</strong> This action is irreversible, therefore it is highly recommended to have a backup of production data.
</div>

Kong Enterprise 1.5 includes a command to migrate all Kong Community Gateway entities to Kong Enterprise. The following steps will guide you through the migration process.

First, download Kong Enterprise 1.5 and configure it to point to the same datastore as your Kong Community Gateway 1.5 node. The migration command expects the datastore to be up to date on any pending migration:

```shell
$ kong migrations up [-c config]
$ kong migrations finish [-c config]
```

Once all Kong Enterprise migrations are up to date, the migration command can be run as:

```shell
$ kong migrations migrate-community-to-enterprise [-c config] [-f] [-y]
```

Confirm now that all the entities are now available on your Kong Enterprise 1.5 node.
