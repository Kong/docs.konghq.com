<!-- shared with the Plugin Hub: Plugin Overview and Kong Gateway: Plugins -->
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