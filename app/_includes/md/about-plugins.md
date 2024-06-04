<!-- shared with the Plugin Hub: Plugin Overview, Kong Gateway: Developing Plugins Overview, and Kong Gateway: Understanding Kong: Plugins -->
## What are plugins?

{{site.base_gateway}} is a Lua application designed to load and execute Lua or Go modules, which
we commonly refer to as _plugins_. Kong provides a set of
[standard Lua plugins](/hub/?support=kong-inc) that get bundled with {{site.base_gateway}} and
{{site.konnect_short_name}}. The set of plugins you
have access to depends on your [license tier](/hub/plugins/license-tiers/).

Custom plugins are also developed by the Kong Community and are supported
and maintained by the plugin creators. If they are published on the [Kong Plugin
Hub](/hub/), they are called Community or Third-Party plugins. For more information on developing plugins, see the [Kong Plugin Development Kit](/gateway/latest/plugin-development/pdk/)

## Why use plugins?

Plugins provide advanced functionality and extend the use of the {{site.base_gateway}}, allowing you to add new features to your implementation. Plugins can be configured to run in various contexts. For example, plugins can be applied to a single [**route**](/gateway/latest/key-concepts/services/), which is the specific path requests take through your system, or they can be used across all [**upstreams**](/gateway/latest/key-concepts/upstreams), which are the servers or services that process these requests after they pass through {{site.base_gateway}}. 

By using plugins, you gain the ability to customize how Kong handles functions in your environment, either before a request is sent to your backend services or after it receives a response. 

## Plugin compatibility with deployment types

{{site.base_gateway}} can be deployed in a variety of ways, and not all plugins
are fully compatible with each mode. See [Plugin Compatibility](/hub/plugins/compatibility#plugin-compatibility)
for a comparison.

## Precedence

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
1. **Consumer Group**: Affects all routes and services for a designated group of authenticated users.
1. **Route**: Specific to given route.
1. **Service**: Specific to given service. 
1. **Globally configured plugins**: Lowest precedence, applies to all requests across all services and routes regardless of consumer status.

### Precedence for consumer groups

When a consumer is a member of two consumer groups, each with a scoped plugin, {{site.base_gateway}} ensures deterministic behavior by executing only one of these plugins. However, the specific rules that govern this behavior are not defined and are subject to change in future releases.

## Terminology
**Plugin**
: An extension to {{site.base_gateway}}.

:  For plugins developed and maintained by Kong, plugin versioning generally does not impact your implementation, other than helping you determine which versions of Kong contain specific plugin features.
Kong plugins are bundled with the {{site.base_gateway}}, ensuring that compatible plugin versions are already associated with the correct version of Kong.

**Kong plugin** or **Kong bundled plugin**
: A plugin developed, maintained, and [supported by Kong](/hub/?support=kong-inc).

: Unlike third-party plugins, which are not maintained by Kong and are not bundled with the {{site.base_gateway}}, version compatibility for Kong plugins is less of a concern.
: If the versions on a plugin page is outdated, contact the maintainer directly.

**Plugin supported by 3rd party**
: A plugin categorized under "Contact 3rd party for support." This custom plugin is developed, tested, and maintained by an external developer, not by Kong.
Unless explicitly labeled as a technical partner, Kong does not test these plugins or maintain their version compatibility. If the versions listed on the plugin page is outdated, contact the maintainer directly.

**Technical partner plugin**
: A 3rd party custom plugin that has been validated by Kong and meets certain standards. Although these plugins are developed, tested, and maintained by an external developer, the plugin owner also ensures the plugin's version compatibility with {{site.base_gateway}}.

## Developing custom plugins

Kong provides an entire development environment for developing plugins,
including Lua and Go SDKs, database abstractions, migrations, and more.

Plugins consist of modules interacting with the request/response objects or
streams via a Plugin Development Kit (or PDK) to implement arbitrary logic.
Kong provides PDKs for two languages: Lua and Go. Both of these PDKs are sets
of functions that a plugin can use to facilitate interactions between plugins
and the core (or other components) of Kong.

To start creating your own plugins, review the [Getting Started documentation](/gateway/latest/plugin-development/get-started/).

For more information about the PDK, review the following documentation: 

* [Plugin Development Guide](/gateway/latest/plugin-development/)
* [Plugin Development Kit reference](/gateway/latest/plugin-development/pdk/)
* [Other Language Support](/gateway/latest/plugin-development/pluginserver/go/)

## Contributing custom plugins

If you are interested in sharing your custom plugin with other Kong users, you
must also submit plugin reference documentation to the Kong Plugin Hub. See the
[contribution guidelines](/contributing/plugin-docs/)
for adding documentation.

## Other key concepts

* For more information about available plugins, see the [Plugin Hub](/hub/).
* [Stages of software availability](/gateway/latest/stability/)
