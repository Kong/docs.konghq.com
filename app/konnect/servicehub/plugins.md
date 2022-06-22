---
title: Manage Plugins
no_version: true
content-type: reference
---

Any {{site.base_gateways}} plugins supported in a self-managed hybrid mode
deployment are also accessible through Service Hub or the Runtime Manager.

## Kong plugins in Konnect Cloud

### Plugin configuration

You can configure a plugin in {{site.konnect_saas}} by scoping it to an object,
or applying it globally.

* A **scoped** plugin applies configuration only to a specific service, route,
or consumer. You can configure plugins on
[services](/konnect/servicehub/enable-service-plugin) and
[routes](/konnect/servicehub/enable-route-plugin) through Service Hub, and on
[consumers](/konnect/runtime-manager/gateway-config)
through the Runtime Manager.

* If you want to apply a plugin **globally** &ndash; that is, to all services,
routes, and consumers in a runtime group &ndash; set it up through the
[Runtime Manager](/konnect/runtime-manager/gateway-config).

### Functionality differences from self-managed Kong Gateway

Application registration is built into the Service Hub.
[Enabling it on a service](/konnect/dev-portal/applications/enable-app-reg)
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

{{site.konnect_saas}} supports the use of custom plugins. You can write new custom plugins using this [template](https://github.com/Kong/kong-plugin) as a guide. Every custom plugin must meet the following requirements: 

* Admin API extensions must not contain an `api.lua` file. 
* Custom plugin database tables must not contain a `dao.lua` file.
* Custom function validations:
  - Must be written in Lua.
  - Must be self-contained within the schema.
* Third-party library dependencies: 
  - Plugins that require third-party libraries can be installed within the handler portion of the plugin code once the plugin is installed on the {{site.base_gateway}} data plane.
  - The `schema.lua` file must not contain any calls to the `require()` function. 

If your plugin meets these requirements and you want to use it in
{{site.konnect_saas}}, contact [Kong Support](https://support.konghq.com/).

{:.important}
> Custom plugins can't be added directly through the {{site.konnect_saas}} application.
