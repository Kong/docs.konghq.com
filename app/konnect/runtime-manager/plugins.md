---
title: Manage Plugins
content_type: reference
---

Plugins lets you extend {{site.konnect_short_name}} functionality. You can
find a full list of all Kong plugins on the [Plugin Hub](/hub/).

## Kong plugins in {{site.konnect_saas}}

### Plugin configuration

Manage {{site.konnect_short_name}} plugins through the [Runtime Manager](https://cloud.konghq.com/us/runtime-manager)

You can scope a plugin to an object, or apply it globally.

* A **scoped** plugin applies configuration only to a specific service, route,
or consumer. Set up scoped plugins through the Runtime Manager.

* If you want to apply a plugin **globally** &ndash; that is, to all services,
routes, and consumers in a runtime group &ndash; use the
Runtime Manager.

### Application registration

Application registration is built into API Products.
[Enabling it on an API product version](/konnect/dev-portal/applications/enable-app-reg/)
also enables two plugins in read-only mode: ACL, and one of Key Auth or OpenID
Connect. These plugins appear in the service's plugin list, and you can view their
configurations, but you can't edit or delete them directly.

### Plugin limitations

Rate limiting plugins default to the `redis` strategy, for which you must
provide your own Redis server. You can also use `local` to apply rate limiting
per individual data plane.

The following plugins are not available with {{site.konnect_saas}}:
* OAuth2 Authentication
* Apache OpenWhisk
* Vault Auth
* Key Authentication Encrypted

See the [plugin compatibility chart](/hub/plugins/compatibility/)
for a full comparison of plans and network configurations that each plugin
supports.

## Custom plugins

{{site.konnect_saas}} supports the use of custom plugins. You can write new custom plugins using this [template](https://github.com/Kong/kong-plugin) as a guide. Every custom plugin must meet the following requirements:

* Admin API extensions must not contain an `api.lua` file.
* Custom plugin database tables must not contain a `dao.lua` file.
* Custom validation functions must be written in Lua and be self-contained within the schema.
* The `schema.lua` file must not contain any `require()` statements.
* Plugins that require third-party libraries must reference them in the `handler.lua` file.

If your plugin meets these requirements and you want to use it in
{{site.konnect_saas}}, contact [Kong Support](https://support.konghq.com/).

{:.important}
> Custom plugins can't be added directly through the {{site.konnect_saas}} application.
