---
title: Manage Plugins
no_version: true
---

Any {{site.base_gateways}} plugins supported in a self-managed hybrid mode
deployment are also accessible through ServiceHub or the Shared Config page.

## Kong plugins in Konnect Cloud

### Plugin configuration

You can configure a plugin in {{site.konnect_saas}} by scoping it to an object,
or applying it globally.

* A **scoped** plugin applies configuration only to a specific service, route,
or consumer. You can configure plugins on
[services](/konnect/legacy/manage-plugins/enable-service-plugin) and
[routes](/konnect/legacy/manage-plugins/enable-route-plugin) through ServiceHub, and on
[consumers](/konnect/legacy/manage-plugins/shared-config) through the Shared Config page.

* If you want to apply a plugin **globally** &ndash; that is, to all services,
routes, and consumers in a cluster &ndash; set it up through the
[Shared Config page](/konnect/legacy/manage-plugins/shared-config/).

### Functionality differences from self-managed Kong Gateway

Application registration is built into the ServiceHub.
[Enabling it on a service](/konnect/legacy/dev-portal/applications/enable-app-reg)
also enables two plugins in read-only mode: ACL, and one of Key Auth or OpenID
Connect. These plugins appear in the service's plugin list, and you can view their
configurations, but you can't edit or delete them directly.

### Plugin limitations

Rate limiting plugins default to the `redis` strategy, for which you must
provide your own Redis server. You can also use `local` to apply rate limiting
per individual data plane.

The following plugins are not available with {{site.konnect_saas}}:
* OAuth2 Authentication
* OAuth2 Introspection
* Apache OpenWhisk
* Vault Auth

See the [plugin compatibility chart](/konnect-platform/compatibility/plugins)
for a full comparison of plans and network configurations that each plugin
supports.

## Custom plugins

Currently, there is no way to add a custom plugin
directly through the {{site.konnect_saas}} application. Contact Kong
Support to get them manually added to your organization.

Custom plugins must not have the following:

* Admin API extensions: No `api.lua` file
* Custom plugin database tables: No `dao.lua` file
* Custom function validations: No function definitions in `schema.lua`
* Code that runs on the control plane in the plugin handler:
  * No `init_worker` callback
  * No Lua code outside of the top-level functions
* Third-party library dependencies: No `require()` calls to modules that are
not bundled by default with {{site.konnect_product_name}}

If your plugin meets these requirements and you want to use it in
{{site.konnect_saas}}, contact [Kong Support](https://support.konghq.com/).
