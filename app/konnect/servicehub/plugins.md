---
title: Manage Plugins
no_version: true
content_type: reference
---

Plugins lets you extend {{site.konnect_short_name}} functionality. You can
find a full list of all Kong plugins on the [Plugin Hub](/hub).

## Kong plugins in {{site.konnect_saas}}

### Plugin configuration

Manage {{site.konnect_short_name}} plugins through the Service Hub or
the Runtime Manager.

You can scope a plugin to an object, or apply it globally.

* A **scoped** plugin applies configuration only to a specific service, route,
or consumer. You can configure plugins on
[services](/konnect/servicehub/enable-service-plugin) and
[routes](/konnect/servicehub/enable-route-plugin) through Service Hub, and on
[consumers](/konnect/runtime-manager/gateway-config)
through the Runtime Manager.

* If you want to apply a plugin **globally** &ndash; that is, to all services,
routes, and consumers in a runtime group, using the
[Runtime Manager](/konnect/runtime-manager/gateway-config).

### Application registration

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
* Apache OpenWhisk
* Vault Auth
* DeGraphQL
* GraphQL Rate Limiting Advanced
* Key Authentication Encrypted

See the [plugin compatibility chart](/hub/plugins/compatibility)
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
