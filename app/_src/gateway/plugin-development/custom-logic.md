---
title: Implementing Custom Logic
book: plugin_dev
chapter: 3
---

{:.note}
> **Note**: This chapter assumes that you are familiar with
[Lua](http://www.lua.org/).

A {{site.base_gateway}} plugin allows you to inject custom logic (in Lua) at several
entry-points in the life-cycle of a request/response or a tcp stream
connection as it is proxied by {{site.base_gateway}}. To do so, the file
`kong.plugins.<plugin_name>.handler` must return a table with one or
more functions with predetermined names. Those functions will be
invoked by {{site.base_gateway}} at different phases when it processes traffic.

{% if_version gte: 3.4.x %}
The first parameter they take is always `self`. All functions except `init_worker`
and `configure` can receive a second parameter which is a table with the plugin
configuration. The `configure` receives an array of all configurations for the
specific plugin.
{% endif_version %}

{% if_version lte:3.3.x %}
The first parameter they take is always `self`. All functions except `init_worker`
can receive a second parameter which is a table with the plugin configuration.
{% endif_version %}

## Module

```
kong.plugins.<plugin_name>.handler
```

## Available contexts

If you define any of the following functions in your `handler.lua`
file you'll implement custom logic at various entry-points
of {{site.base_gateway}}'s execution life-cycle:

- **[HTTP Module]** *is used for plugins written for HTTP/HTTPS requests*
{% if_version lte: 3.3.x %}

| Function name       | Phase             | Request Protocol        | Description
|---------------------|-------------------|-------------------------|------------
| `init_worker`       | [init_worker]     | *                        | Executed upon every Nginx worker process's startup.
| `certificate`       | [ssl_certificate] | `https`, `grpcs`, `wss`  | Executed during the SSL certificate serving phase of the SSL handshake.
| `rewrite`           | [rewrite]         | *                        | Executed for every request upon its reception from a client as a rewrite phase handler. <br> In this phase, neither the `Service` nor the `Consumer` have been identified, hence this handler will only be executed if the plugin was configured as a global plugin.
| `access`            | [access]          | `http(s)`, `grpc(s)`, `ws(s)` | Executed for every request from a client and before it is being proxied to the upstream service.
| `ws_handshake`      | [access]          | `ws(s)`                  | Executed for every request to a WebSocket service just before completing the WebSocket handshake.
| `response`          | [access]          | `http(s)`, `grpc(s)`     | Replaces both `header_filter()` and `body_filter()`. Executed after the whole response has been received from the upstream service, but before sending any part of it to the client.
| `header_filter`     | [header_filter]   | `http(s)`, `grpc(s)`     | Executed when all response headers bytes have been received from the upstream service.
| `ws_client_frame`   | [content]         | `ws(s)`                  | Executed for each WebSocket message received from the client.
| `ws_upstream_frame` | [content]         | `ws(s)`                  | Executed for each WebSocket message received from the upstream service.
| `body_filter`       | [body_filter]     | `http(s)`, `grpc(s)`     | Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. This function can be called multiple times if the response is large. See the [lua-nginx-module] documentation for more details.
| `log`               | [log]             | `http(s)`, `grpc(s)`     | Executed when the last response byte has been sent to the client.
| `ws_close`          | [log]             | `ws(s)`                  | Executed after the WebSocket connection has been terminated.

{:.note}
> **Note:** If a module implements the `response` function, {{site.base_gateway}} will automatically activate the "buffered proxy" mode, as if the [`kong.service.request.enable_buffering()` function][enable_buffering] had been called. Because of a current Nginx limitation, this doesn't work for HTTP/2 or gRPC upstreams.

To reduce unexpected behaviour changes, {{site.base_gateway}} does not start if a plugin implements both `response` and either `header_filter` or `body_filter`.

- **[Stream Module]** *is used for Plugins written for TCP and UDP stream connections*

| Function name   | Phase                                                                        | Description
|-----------------|------------------------------------------------------------------------------|------------
| `init_worker`   | [init_worker]                                                                | Executed upon every Nginx worker process's startup.
| `preread`       | [preread]                                                                    | Executed once for every connection.
| `log`           | [log](https://github.com/openresty/stream-lua-nginx-module#log_by_lua_block) | Executed once for each connection after it has been closed.
| `certificate`   | [ssl_certificate] | Executed during the SSL certificate serving phase of the SSL handshake.

{% endif_version %}

{% if_version gte: 3.4.x %}
| Function name       | Phase               | Request Protocol              | Description
|---------------------|---------------------|-------------------------------|------------
| `init_worker`       | [init_worker]       | *                             | Executed upon every Nginx worker process's startup.
| `configure`         | [init_worker]/timer | *                             | Executed every time the Kong plugin iterator is rebuilt (after changes to configure plugins).
| `certificate`       | [ssl_certificate]   | `https`, `grpcs`, `wss`       | Executed during the SSL certificate serving phase of the SSL handshake.
| `rewrite`           | [rewrite]           | *                             | Executed for every request upon its reception from a client as a rewrite phase handler. <br> In this phase, neither the `Service` nor the `Consumer` have been identified, hence this handler will only be executed if the plugin was configured as a global plugin.
| `access`            | [access]            | `http(s)`, `grpc(s)`, `ws(s)` | Executed for every request from a client and before it is being proxied to the upstream service.
| `ws_handshake`      | [access]            | `ws(s)`                       | Executed for every request to a WebSocket service just before completing the WebSocket handshake.
| `response`          | [access]            | `http(s)`, `grpc(s)`          | Replaces both `header_filter()` and `body_filter()`. Executed after the whole response has been received from the upstream service, but before sending any part of it to the client.
| `header_filter`     | [header_filter]     | `http(s)`, `grpc(s)`          | Executed when all response headers bytes have been received from the upstream service.
| `ws_client_frame`   | [content]           | `ws(s)`                       | Executed for each WebSocket message received from the client.
| `ws_upstream_frame` | [content]           | `ws(s)`                       | Executed for each WebSocket message received from the upstream service.
| `body_filter`       | [body_filter]       | `http(s)`, `grpc(s)`          | Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. This function can be called multiple times if the response is large. See the [lua-nginx-module] documentation for more details.
| `log`               | [log]               | `http(s)`, `grpc(s)`          | Executed when the last response byte has been sent to the client.
| `ws_close`          | [log]               | `ws(s)`                       | Executed after the WebSocket connection has been terminated.

{:.note}
> **Note:** If a module implements the `response` function, {{site.base_gateway}} will automatically activate the "buffered proxy" mode, as if the [`kong.service.request.enable_buffering()` function][enable_buffering] had been called. Because of a current Nginx limitation, this doesn't work for HTTP/2 or gRPC upstreams.

To reduce unexpected behaviour changes, {{site.base_gateway}} does not start if a plugin implements both `response` and either `header_filter` or `body_filter`.

- **[Stream Module]** *is used for Plugins written for TCP and UDP stream connections*

| Function name   | Phase                                                                        | Description
|-----------------|------------------------------------------------------------------------------|------------
| `init_worker`   | [init_worker]                                                                | Executed upon every Nginx worker process's startup.
| `configure`     | [init_worker]/timer                                                         | Executed every time the Kong plugin iterator is rebuilt (after changes to configure plugins).
| `preread`       | [preread]                                                                    | Executed once for every connection.
| `log`           | [log](https://github.com/openresty/stream-lua-nginx-module#log_by_lua_block) | Executed once for each connection after it has been closed.
| `certificate`   | [ssl_certificate]                                                            | Executed during the SSL certificate serving phase of the SSL handshake.



All of those functions, except `init_worker` and `configure`, take one parameter which is given
by {{site.base_gateway}} upon its invocation: the configuration of your plugin. This parameter
is a Lua table, and contains values defined by your users, according to your
plugin's schema (described in the `schema.lua` module). More on plugins schemas
in the [next chapter]({{page.book.next.url}}). The `configure` is called with an array of all the enabled
plugin configurations for the particular plugin (or in case there is no active configurations
to plugin, a `nil` is passed). `init_worker` and `configure` happens outside
requests or frames, while the rest of the phases are bound to incoming request/frame.

Note that UDP streams don't have real connections.  {{site.base_gateway}} will consider all
packets with the same origin and destination host and port as a single
connection.  After a configurable time without any packet, the connection is
considered closed and the `log` function is executed.

{:.note}
> The `configure` handler was added in Kong 3.5, and has been backported to 3.4 LTS. 
We are currently looking feedback for this new phase,
> and there is a slight possibility that its signature might change in a future.
{% endif_version %}

## handler.lua specifications

{{site.base_gateway}} processes requests in **phases**. A plugin is a piece of code that gets
activated by {{site.base_gateway}} as each phase is executed while the request gets proxied.

{% if_version gte:3.4.x %}
Phases are limited in what they can do. For example, the `init_worker` phase
does not have access to the `config` parameter because that information isn't
available when kong is initializing each worker. On the other hand the `configure`
is passed with all the active configurations for the plugin (or `nil` if not configured).
{% endif_version %}
{% if_version lte: 3.3.x %}
Phases are limited in what they can do. For example, the `init_worker` phase
does not have access to the `config` parameter because that information isn't
available when kong is initializing each worker.
{% endif_version %}
A plugin's `handler.lua` must return a table containing the functions it must
execute on each phase.

{{site.base_gateway}} can process HTTP and stream traffic. Some phases are executed
only when processing HTTP traffic, others when processing stream,
and some (like `init_worker` and `log`) are invoked by both kinds of traffic.

In addition to functions, a plugin must define two fields:

* `VERSION` is an informative field, not used by {{site.base_gateway}} directly. It usually
  matches the version defined in a plugin's Rockspec version, when it exists.
* `PRIORITY` is used to sort plugins before executing each of their phases.
  Plugins with a higher priority are executed first. See the
  [plugin execution order](#plugins-execution-order) below
  for more info about this field.

The following example `handler.lua` file defines custom functions for all
the possible phases, in both http and stream traffic. It has no functionality
besides writing a message to the log every time a phase is invoked. Note
that a plugin doesn't need to provide functions for all phases.

```lua
local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10,
}

function CustomHandler:init_worker()
  -- Implement logic for the init_worker phase here (http/stream)
  kong.log("init_worker")
end

{% if_version gte:3.4.x -%}
function CustomHandler:configure(configs)
  -- Implement logic for the configure phase here
  --(called whenever there is change to any of the plugins)
  kong.log("configure")
end
{%- endif_version %}

function CustomHandler:preread(config)
  -- Implement logic for the preread phase here (stream)
  kong.log("preread")
end

function CustomHandler:certificate(config)
  -- Implement logic for the certificate phase here (http/stream)
  kong.log("certificate")
end

function CustomHandler:rewrite(config)
  -- Implement logic for the rewrite phase here (http)
  kong.log("rewrite")
end

function CustomHandler:access(config)
  -- Implement logic for the access phase here (http)
  kong.log("access")
end

function CustomHandler:ws_handshake(config)
  -- Implement logic for the WebSocket handshake here
  kong.log("ws_handshake")
end

function CustomHandler:header_filter(config)
  -- Implement logic for the header_filter phase here (http)
  kong.log("header_filter")
end

function CustomHandler:ws_client_frame(config)
  -- Implement logic for WebSocket client messages here
  kong.log("ws_client_frame")
end

function CustomHandler:ws_upstream_frame(config)
  -- Implement logic for WebSocket upstream messages here
  kong.log("ws_upstream_frame")
end

function CustomHandler:body_filter(config)
  -- Implement logic for the body_filter phase here (http)
  kong.log("body_filter")
end

function CustomHandler:log(config)
  -- Implement logic for the log phase here (http/stream)
  kong.log("log")
end

function CustomHandler:ws_close(config)
  -- Implement logic for WebSocket post-connection here
  kong.log("ws_close")
end

-- return the created table, so that Kong can execute it
return CustomHandler
```

Note that in the example above we are using Lua's `:` shorthand syntax for
functions taking `self` as a first parameter. An equivalent non-shorthand version
of the `access` function would be:

``` lua
function CustomHandler.access(self, config)
  -- Implement logic for the rewrite phase here (http)
  kong.log("access")
end
```

The plugin's logic doesn't need to be all defined inside the `handler.lua` file.
It can be split into several Lua files (also called *modules*).
The `handler.lua` module can use `require` to include other modules in your plugin.

For example, the following plugin splits the functionality into three files.
`access.lua` and `body_filter.lua` return functions. They are in the same
folder as `handler.lua`, which requires and uses them to build the plugin:

```lua
-- handler.lua
local access = require "kong.plugins.my-custom-plugin.access"
local body_filter = require "kong.plugins.my-custom-plugin.body_filter"

local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10
}

CustomHandler.access = access
CustomHandler.body_filter = body_filter

return CustomHandler
```

```lua
-- access.lua
return function(self, config)
  kong.log("access phase")
end
```

```lua
-- body_filter.lua
return function(self, config)
  kong.log("body_filter phase")
end
```

See [the source code of the Key-Auth Plugin](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua)
for an example of a real-life handler code.

### Migrating from BasePlugin module

The `BasePlugin` module is deprecated and has been removed from
{{site.base_gateway}}. If you have an old plugin that uses this module, replace
the following section:

```lua
--  DEPRECATED --
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()
CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 10
```

with the current equivalent:
```lua
local CustomHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 10,
}
```

You don't need to add a `:new()` method or call any of the `CustomHandler.super.XXX:(self)`
methods.

## WebSocket Plugin Development
{:.badge .enterprise}

{:.warning}
> **Warning**: The WebSocket PDK is under active development and is
considered unstable at this time. Backwards-incompatible changes may be made
to these functions.

### Handler Functions

Requests to services with the `ws` or `wss` protocol take a different path through
the proxy than regular http requests. Therefore, there are some differences in behavior
that must be accounted for when developing plugins for them.

The following handlers are _not_ executed for WebSocket services:
 - `access`
 - `response`
 - `header_filter`
 - `body_filter`
 - `log`

The following handlers are _unique to_ WebSocket services:
  - `ws_handshake`
  - `ws_client_frame`
  - `ws_upstream_frame`
  - `ws_close`

The following handlers are executed for both WebSocket _and_ non-Websocket services:
  - `init_worker`
  {% if_version gte:3.4.x -%}
  - `configure`
  {% endif_version -%}
  - `certificate` (TLS/SSL requests only)
  - `rewrite`

Even with these differences, it is possible to develop plugins that support both WebSocket
and non-WebSocket services. For example:

```lua
-- handler.lua
--
-- I am a plugin that implements both WebSocket and non-WebSocket handlers.
--
-- I can be enabled for ws/wss services, http/https/grpc/grpcs services, or
-- even as global plugin.
local MultiProtoHandler = {
  VERSION = "0.1.0",
  PRIORITY = 1000,
}

function MultiProtoHandler:access()
  kong.ctx.plugin.request_type = "non-WebSocket"
end

function MultiProtoHandler:ws_handshake()
  kong.ctx.plugin.request_type = "WebSocket"
end


function MultiProtoHandler:log()
  kong.log("finishing ", kong.ctx.plugin.request_type, " request")
end

-- the `ws_close` handler for this plugin does not implement any WebSocket-specific
-- business logic, so it can simply be aliased to the `log` handler
MultiProtoHandler.ws_close = MultiProtoHandler.log

return MultiProtoHandler
```

As seen above, the `log` and `ws_close` handlers are parallel to each other. In
many cases, one can be aliased to the other without having to write any
additional code. The `access` and `ws_handshake` handlers are also very similar in
this regard. The notable difference lies in which PDK functions are/aren't available
in each context. For instance, the `kong.request.get_body()` PDK function cannot be
used in an `access` handler because it is fundamentally incompatible with this kind
of request.


### WebSocket requests to non-WebSocket services

When WebSocket traffic is proxied via an http/https service, it is treated as a
non-WebSocket request. Therefore, the http handlers (`access`, `header_filter`, etc)
will be executed and _not_ the WebSocket handlers (`ws_handshake`, `ws_close`, etc).

## Plugin Development Kit

Logic implemented in those phases will most likely have to interact with the
request/response objects or core components (e.g. access the cache, and
database). {{site.base_gateway}} provides a [Plugin Development Kit][pdk] (or "PDK") for such
purposes: a set of Lua functions and variables that can be used by Plugins to
execute various gateway operations in a way that is guaranteed to be
forward-compatible with future releases of {{site.base_gateway}}.

When you are trying to implement some logic that needs to interact with {{site.base_gateway}}
(e.g. retrieving request headers, producing a response from a plugin, logging
some error or debug information), you should consult the [Plugin Development
Kit Reference][pdk].


## Plugins execution order

Some plugins might depend on the execution of others to perform some
operations. For example, plugins relying on the identity of the consumer have
to run **after** authentication plugins. Considering this, {{site.base_gateway}} defines
**priorities** between plugins execution to ensure that order is respected.

Your plugin's priority can be configured via a property accepting a number in
the returned handler table:

```lua
CustomHandler.PRIORITY = 10
```

The higher the priority, the sooner your plugin's phases will be executed in
regard to other plugins' phases (such as `:access()`, `:log()`, etc.).

### Kong plugins

All of the plugins bundled with {{site.base_gateway}} have a static priority.
This can be adjusted dynamically using the `ordering` option. See
[Dynamic Plugin Ordering](/gateway/{{page.release}}/kong-enterprise/plugin-ordering/)
for more information.

{% navtabs %}
{% navtab OSS %}

The following list includes all plugins bundled with open-source
{{site.base_gateway}}.

{:.note}
> **Note:** The Correlation ID plugin's priority changes depending on
> whether you're running it in open-source or Free mode.
> Free mode uses the {{site.ee_product_name}} package.
> Switch to the **Enterprise** tab to see the correct priority for this plugin.

The current order of execution for the bundled plugins is:

{% plugins_priority_table oss %}

{% endnavtab %}
{% navtab Enterprise %}
The following list includes all plugins bundled with a {{site.ee_product_name}}
subscription. This priority order also applies to plugins running in Free mode, 
which uses the {{site.ee_product_name}} package.

The current order of execution for the bundled plugins is:

{% plugins_priority_table enterprise %}

{% endnavtab %}
{% endnavtabs %}

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[pdk]: /gateway/{{page.release}}/plugin-development/pdk
[HTTP Module]: https://github.com/openresty/lua-nginx-module
[Stream Module]: https://github.com/openresty/stream-lua-nginx-module
[init_worker]: https://github.com/openresty/lua-nginx-module#init_worker_by_lua_block
[ssl_certificate]: https://github.com/openresty/lua-nginx-module#ssl_certificate_by_lua_block
[rewrite]: https://github.com/openresty/lua-nginx-module#rewrite_by_lua_block
[access]: https://github.com/openresty/lua-nginx-module#access_by_lua_block
[header_filter]: https://github.com/openresty/lua-nginx-module#header_filter_by_lua_block
[body_filter]: https://github.com/openresty/lua-nginx-module#body_filter_by_lua_block
[log]: https://github.com/openresty/lua-nginx-module#log_by_lua_block
[preread]: https://github.com/openresty/stream-lua-nginx-module#preread_by_lua_block
[enable_buffering]: /gateway/{{page.release}}/plugin-development/pdk/kong.service.request/#kongservicerequestenable_buffering
[content]: https://github.com/openresty/lua-nginx-module#content_by_lua_block

<!-- vale on -->
