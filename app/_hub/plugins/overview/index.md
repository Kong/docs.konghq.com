---
title: Plugin Overview
header_title: Plugin Overview
type: concept
---
## What are plugins?

Kong is a Lua application designed to load and execute Lua or Go modules, which
we commonly refer to as _plugins_. Kong provides a set of standard Lua
plugins that get bundled with {{site.base_gateway}}. The set of plugins you
have access to depends on your installation: open-source, enterprise, or either
of these {{site.base_gateway}} options running on Kubernetes.

Custom plugins can also be developed by the Kong Community, and are supported
and maintained by the plugin creators. If they are published on the Kong Plugin
Hub, they are called Community or Third-Party plugins. For the full explanation
of what this means, see the [Terminology](#terminology) section.

## Why use plugins?

Plugins provide advanced functionality and extend the use of the {{site.base_gateway}},
which allows you to add new features to your implementation. Plugins can be configured to run in
a variety of contexts, ranging from a specific Route to all Upstreams, and can
execute actions inside Kong before or after a request has been proxied to the
upstream API, as well as on any incoming responses.

## Plugin compatibility with deployment types

{{site.base_gateway}} can be deployed in a variety of ways, and not all plugins
are fully compatible with each mode. See [Plugin Compatibility](/konnect-platform/compatibility/plugins)
for a comparison.


## Terminology
**Plugin**
: An extension to the {{site.base_gateway}}, written in Lua or Go.

**Kong plugin**
: A plugin developed, maintained, and supported by Kong.

**Third-party or Community plugin**
: A custom plugin developed, maintained, and supported by an external developer,
not by Kong. Kong does not test these plugins, or update their version
compatibility. If you need more information or need to have a third-party plugin
updated, contact the maintainer through the Support link in a plugin
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
: A unique string associated with a Consumer; also referred to as an API key.

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
* [Plugin Development Guide](/gateway/latest/plugin-development) and the
[Plugin Development Kit reference](/gateway/latest/pdk)
* [Other Language Support](/gateway/latest/reference/external-plugins)

## Contributing custom plugins

If you are interested in sharing your custom plugin with other Kong users, you
must also submit plugin reference documentation to the Kong Plugin Hub. See the
[contribution guidelines](/contributing/)
for adding documentation.
