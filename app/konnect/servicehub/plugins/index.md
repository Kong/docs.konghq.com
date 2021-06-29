---
title: Manage Plugins
no_version: true
---

Any {{site.ee_gateway_names}} plugins supported in a self-managed hybrid mode
deployment are also accessible through ServiceHub.

## Kong plugins in Konnect Cloud

### Scoped vs global plugins
In ServiceHub, all plugins attached to services and routes are **scoped** to
an object, and only apply their configurations to that object.

If you want to apply a plugin **globally** &ndash; that is, to all services, routes,
and consumers in a cluster &ndash; or scope it to a specific consumer,
set it up through [shared configuration](/konnect/shared-config/plugins).

### Functionality differences from self-managed Kong Gateway

The Portal Application Registration plugin is enabled automatically when you
[enable application registration](/konnect/dev-portal/administrators/app-registration/enable-app-reg)
for the Dev Portal. You don't need to enable it directly.

Conversely, don't delete the Application Registration plugin directly.
[Disable application registration](/konnect/dev-portal/administrators/app-registration/disable-app-reg)
from the service overview only.

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

## Custom plugins and serverless functions

Currently, there is no way to add a custom plugin or a serverless function
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

**See more:**
* [Plugin compatibility](/konnect-platform/compatibility/plugins)
* [Configure a plugin on a Service](/konnect/servicehub/plugins/enable-service-plugin)
* [Configure a plugin on a Route](/konnect/servicehub/plugins/enable-route-plugin)
