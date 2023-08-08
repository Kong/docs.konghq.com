<!-- shared with the Plugin Hub: Plugin Overview, Kong Gateway: Developing Plugins Overview, and Kong Gateway: Understanding Kong: Plugins -->
## What are plugins?

{{site.base_gateway}} is a Lua application designed to load and execute Lua or Go modules, which
we commonly refer to as _plugins_. Kong provides a set of standard Lua
plugins that get bundled with {{site.base_gateway}}. The set of plugins you
have access to depends on your installation: open-source, enterprise, or either
of these {{site.base_gateway}} options running on Kubernetes.

Custom plugins can also be developed by the Kong Community and are supported
and maintained by the plugin creators. If they are published on the Kong Plugin
Hub, they are called Community or Third-Party plugins. 

## Why use plugins?

Plugins provide advanced functionality and extend the use of the {{site.base_gateway}},
which allows you to add new features to your implementation. Plugins can be configured to run in
a variety of contexts, ranging from a specific route to all upstreams, and can
execute actions inside Kong before or after a request has been proxied to the
upstream API, as well as on any incoming responses.

## Plugin compatibility with deployment types

{{site.base_gateway}} can be deployed in a variety of ways, and not all plugins
are fully compatible with each mode. See [Plugin Compatibility](/konnect/compatibility#plugin-compatibility)
for a comparison.


## Precedence 

A single plugin instance always runs _once_ per request. The
configuration with which it runs depends on the entities it has been
configured for.
Plugins can be configured for various entities, combinations of entities, or
even globally. This is useful, for example, when you want to configure a plugin
a certain way for most requests, but make _authenticated requests_ behave
slightly differently.

Therefore, there is an order of precedence for running a plugin when it has
been applied to different entities with different configurations. The amount of entities configured to a specific plugin directly correlate to its priority. The more entities configured to a plugin the higher its order of precedence is. 
The complete order of precedence for plugins configured to multiple entities is: 



1. Plugins configured on a combination of a consumer, a route, and a service.
    (Consumer means the request must be authenticated).
2. Plugins configured on a combination of a consumer group, service, and a route.
    (Consumer group means the request must be authenticated).
3. Plugins configured on a combination of a consumer and a route.
    (Consumer means the request must be authenticated).
4. Plugins configured on a combination of a consumer and a service.
5. Plugins configured on a consumer group and route.
6. Plugins configured on a consumer group and service.
7. Plugins configured on a route and service.
8. Plugins configured on a consumer.
9. Plugins configured on a consumer group.
10. Plugins configured on a route.
11. Plugins configured on a service. 
12. Plugins configured globally. 



## Terminology
**Plugin**
: An extension to the {{site.base_gateway}}, written in Lua or Go.

**Kong plugin**
: A plugin developed, maintained, and supported by Kong.

**Third-party or Community plugin**
: A custom plugin developed, maintained, and supported by an external developer,
not by Kong. Kong does not test these plugins, or update their version
compatibility. If you need more information or need to have a third-party plugin
updated, contact the maintainer by clicking [Report an issue](https://github.com/Kong/docs.konghq.com/issues) in the plugin
documentation's sidebar.

**Service**
: The Kong entity representing an external upstream API or microservice.

**Route**
: The Kong entity representing a way to map downstream requests to upstream
services.

**Consumer**
: An entity that makes requests for Kong to proxy. It represents either a user
or an external service.

**Credential**
: The API key. A unique string associated with a consumer. 

**Upstream**
: The Kong entity that refers to your own API/service sitting behind Kong,
to which client requests are forwarded.


## Plugin versioning

Each plugin has its own internal versioning scheme. These versions differ from
{{site.base_gateway}} versions.

### Kong plugins

For plugins developed and maintained by Kong, plugin versioning generally has
no impact on your implementation, other than to find out which versions of Kong
contain which plugin features. Kong plugins are bundled with the
{{site.base_gateway}}, so compatible plugin versions are already associated
with the correct version of Kong.

### Third-party plugins

Because third-party plugins are not maintained by Kong and are not bundled with
the {{site.base_gateway}}, version compatibility is a bigger concern. See each
individual plugin's page for its tested compatibility.

If the versions on the plugin page are outdated, contact the maintainer through
the Support link in the plugin documentation's sidebar.

## Developing custom plugins

Kong provides an entire development environment for developing plugins,
including Lua and Go SDKs, database abstractions, migrations, and more.

Plugins consist of modules interacting with the request/response objects or
streams via a Plugin Development Kit (or PDK) to implement arbitrary logic.
Kong provides PDKs for two languages: Lua and Go. Both of these PDKs are sets
of functions that a plugin can use to facilitate interactions between plugins
and the core (or other components) of Kong.

To start creating your own plugins, check out the PDK documentation:
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
