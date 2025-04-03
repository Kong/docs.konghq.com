<!-- shared with the Plugin Hub: Plugin Overview, Kong Gateway: Developing Plugins Overview, and Kong Gateway: Understanding Kong: Plugins -->
## What are plugins?

{{site.base_gateway}} is a Lua application designed to load and execute modules, which
we commonly refer to as _plugins_. Plugins provide advanced functionality and extend the
use of the {{site.base_gateway}}, allowing you to add more features to your implementation.

Kong provides a set of
[standard Lua plugins](/hub/?support=kong-inc) that get bundled with {{site.base_gateway}} and
{{site.konnect_short_name}}.

You can also [develop custom plugins](#developing-custom-plugins), adding your own custom functionality to {{site.base_gateway}}.

## Scoping plugins

You can run plugins in various contexts, depending on your environment needs.
Each plugin can run globally, or be scoped to some combination of the following:
* Services
* Routes
* Consumers
* Consumer groups

Using scopes, you can customize how Kong handles functions in your environment,
either before a request is sent to your backend services or after it receives a response.
For example, if you apply a plugin to a single [**route**](/gateway/latest/key-concepts/routes/), that plugin will trigger only on the specific path requests take through your system.
On the other hand, if you apply the plugin [**globally**](#global-scope), it will run on every request, regardless of any other configuration.

### Global scope
A global plugin is not associated to any service, route, consumer, or consumer group is considered global, and will be run on every request,
regardless of any other configuration.

* In self-managed {{site.ee_product_name}}, the plugin applies to every entity in a given workspace.
* In self-managed {{site.ce_product_name}}, the plugin applies to your entire environment.
* In {{site.konnect_short_name}}, the plugin applies to every entity in a given control plane.

Every plugin supports a subset of these scopes.

See the [scope compatibility](/hub/plugins/compatibility/#scopes) reference for all supported scopes for each plugin.

### Precedence

A single plugin instance always runs _once_ per request. The
configuration with which it runs depends on the entities it has been
configured for.
Plugins can be configured for various entities, combinations of entities, or even globally.
This is useful, for example, when you want to configure a plugin a certain way for most requests but make _authenticated requests_ behave slightly differently.

Therefore, there is an order of precedence for running a plugin when it has been applied to different entities with different configurations. The number of entities configured to a specific plugin directly correlates to its priority. The more entities a plugin is configured for, the higher its order of precedence.

The complete order of precedence for plugins configured to multiple entities is:

1. **Consumer** + **route** + **service**: Highest precedence, affecting authenticated requests that match a specific consumer on a particular route and service.
1. **Consumer group** + **service** + **route**: Affects groups of authenticated users across specific services and routes.
1. **Consumer** + **route**: Targets authenticated requests from a specific consumer on a particular route.
1. **Consumer** + **service**: Applies to authenticated requests from a specific consumer accessing any route within a given service.
1. **Consumer group** + **route**: Affects groups of authenticated users on specific routes.
1. **Consumer group** + **service**: Applies to all routes within a specific service for groups of authenticated users.
1. **Route** + **service**: Targets all consumers on a specific route and service.
1. **Consumer**: Applies to all requests from a specific, authenticated consumer across all routes and services.
1. **Consumer group**: Affects all routes and services for a designated group of authenticated users.
1. **Route**: Specific to given route.
1. **Service**: Specific to given service.
1. **Globally configured plugins**: Lowest precedence, applies to all requests across all services and routes regardless of consumer status.

Only the first matched instance is selected, and all other instances of the same plugin are ignored for the current request context. For example, if you configure the `rate-limiting-advanced` plugin for both the service *foo* and the route *bar* of that service, the instance associated with the route *bar* is executed due to the order of precedence. 

To work around this limitation, you can create two routes for the service *foo* and bind a separate `rate-limiting-advanced` plugin to each route. If you need to run the plugin twice, you can point the service *foo* to another route (*baz*) within the same {{site.base_gateway}}.

{:.note}
> **Note on precedence for consumer groups**:
When a consumer is a member of two consumer groups, each with a scoped plugin,
{{site.base_gateway}} ensures deterministic behavior by executing only one of these plugins.
However, the specific rules that govern this behavior are not defined and are subject to change in future releases.

## Plugin compatibility with deployment types

{{site.base_gateway}} can be deployed in a variety of ways, and not all plugins
are fully compatible with each mode. See [Plugin Compatibility](/hub/plugins/compatibility#plugin-compatibility)
for a comparison.

## Custom plugins

### Developing custom plugins

Kong provides an entire development environment for developing plugins,
including Plugin Development Kits (or PDKs), database abstractions, migrations, and more.

Plugins consist of modules interacting with the request/response objects or
streams via a PDK to implement arbitrary logic.
Kong provides PDKs in the following languages:
* [Lua](/gateway/latest/plugin-development/)
* [Go](/gateway/latest/plugin-development/pluginserver/go/)
* [Python](/gateway/latest/plugin-development/pluginserver/python/)
* [JavaScript](/gateway/latest/plugin-development/pluginserver/javascript/)

These PDKs are sets of functions that a plugin can use to facilitate interactions between plugins
and the core (or other components) of Kong.

To start creating your own plugins, review the [Getting Started documentation](/gateway/latest/plugin-development/get-started/),
or see the following references:
* [Plugin Development Kit reference](/gateway/latest/plugin-development/pdk/)
* [Other Language Support](/gateway/latest/plugin-development/pluginserver/go/)

### Third-party plugins

Through partnerships with third parties, Kong lists some [third-party custom plugins](/hub/?support=community%2Cpremium-partner) on the Kong Plugin Hub.
These plugins are maintained by Kong partners.
If you would like to have your plugin featured on the Kong Plugin Hub, we encourage you to become a [Kong Partner](https://konghq.com/partners/).

## See also

* [Kong Plugin Hub](/hub/): All Kong bundled plugins and partner plugins
* [Supported scopes for each plugin](/hub/plugins/compatibility/#scopes)
* [Supported topologies for each plugin](/hub/plugins/compatibility/)
* [Supported protocols for each plugin](/hub/plugins/compatibility/#protocols)
