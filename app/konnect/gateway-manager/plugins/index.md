---
title: Kong Gateway Plugins in Konnect
content_type: reference
---

Plugins let you extend {{site.konnect_short_name}} functionality. 
You can choose from any number of [bundled plugins](/hub/?compatibility=konnect&support=kong-inc) 
in {{site.konnect_short_name}}, or write your own [custom plugins](#custom-plugins).

## Plugin configuration

You can manage both bundled and custom plugins through the 
[{% konnect_icon runtimes %} Gateway Manager](https://cloud.konghq.com/us/gateway-manager).

You can scope a plugin to a specific {{site.base_gateway}} entity, or apply it globally
within a control plane:

* A **scoped** plugin applies configuration only to a specific service, route,
consumer, or consumer group.

* A **global** plugin applies to all services, routes, consumers, and consumer 
groups in a control plane.

In both cases, plugins are managed within a specific control plane. If you need a plugin to 
apply to multiple control planes, configure a plugin instance separately for each one, 
or create a [control plane group](/konnect/gateway-manager/control-plane-groups/).

Open the **Plugins** menu from within a control plane to access and manage its list of plugins:

![List of plugins in a control plane](/assets/images/products/konnect/gateway-manager/plugins/konnect-plugin-list.png)

### Custom plugins

You can also [apply your own custom plugins](/konnect/gateway-manager/plugins/add-custom-plugin/) 
through the Gateway Manager.

The {{site.konnect_short_name}} control plane only needs a Lua schema file. Using that
schema, it creates a plugin configuration object in {{site.konnect_short_name}}, which you
can access via the Konnect UI or the custom plugins API. This means that {{site.konnect_short_name}}
only sees a custom plugin's configuration options, and does not see any other data.

{:.note}
> **Note**: For adding custom plugins to a Dedicated Cloud Gateway, see 
[Custom plugins in Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/custom-plugins/).

To run in {{site.konnect_short_name}}, every custom plugin must meet the following requirements:

* **General requirements:**
  * Each custom plugin must have a unique name.
  * All plugin files must also be deployed to **each** {{site.base_gateway}} data plane node.
* **File structure requirements:**
  * The plugin must not contain an `api.lua` file as Admin API extensions are not supported. 
  * The plugin must not contain the `dao.lua` or `migrations.lua` files as custom data entities are not supported.
* **Code and language requirements:** 
  * The schema for your custom plugin must be written in Lua.
  * Custom validation functions must be written in Lua and be self-contained within the `schema.lua` file.
  * The `schema.lua` file must not contain any `require()` statements.
  * Plugins that require third-party libraries must reference them in the `handler.lua` file.

![Custom plugins](/assets/images/products/konnect/gateway-manager/plugins/konnect-custom-plugins.png){:.image-border}

### Application registration plugins

Application registration is built into API Products.
When you [enable application registration on an API product version](/konnect/dev-portal/applications/enable-app-reg/), 
{{site.konnect_short_name}} also automatically enables two plugins in read-only mode: 
ACL, and either Key Auth or OpenID Connect. 
These plugins appear in the service's plugin list, and you can view their
configurations, but you can't edit or delete them directly.

### Plugin limitations

Some bundled {{site.base_gateway}} plugins are not available in {{site.konnect_short_name}}, or
have configuration requirements specific to {{site.konnect_short_name}}.

* Rate limiting plugins default to the `redis` strategy, which you must
provide your own Redis server for. You can also use `local` to apply rate limiting
per individual data plane node.

* A small number of {{site.base_gateway}} plugins are not available in {{site.konnect_short_name}}. See the [plugin compatibility chart](/konnect/compatibility/#plugin-compatibility)
for the full list, as well as a breakdown of the pricing tiers that each plugin is available in, and for specific {{site.konnect_short_name}} notes for each plugin.

## More information

### Kong bundled plugins
* [Kong plugins in {{site.konnect_short_name}}](/hub/?compatibility=konnect&support=kong-inc)

### Custom plugins
* [Add a custom plugin in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/add-custom-plugin/)
* [Edit or delete custom plugins in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/update-custom-plugin/)
* [Custom plugins in Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/custom-plugins/)
* [Custom plugin schema endpoints (Control Plane Config API)](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas)
* [Custom plugin template](https://github.com/Kong/kong-plugin)
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)
