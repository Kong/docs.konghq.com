---
title: Plugin Development - Implementing custom logic
book: plugin_dev
chapter: 3
---

<div class="alert alert-warning">
  <strong>Note:</strong> This chapter assumes that you are familiar with
  <a href="http://www.lua.org/">Lua</a>.
</div>

## Introduction

A Kong plugin allows you to inject custom logic (in Lua) at several
entry-points in the life-cycle of a request/response as it is proxied by Kong.
To do so, one must implement one or several of the methods of the
`base_plugin.lua` interface. Those methods are to be implemented in a module
namespaced under: `kong.plugins.<plugin_name>.handler`

## Module

```
kong.plugins.<plugin_name>.handler
```

## Available request contexts

The plugins interface allows you to override any of the following methods in
your `handler.lua` file to implement custom logic at various entry-points
of the execution life-cycle of Kong:

| Function name           | lua-nginx-module context           | Description
|-------------------------|------------------------------------|--------------
| `:init_worker()`         | [init_worker_by_lua]               | Executed upon every Nginx worker process's startup.
| `:certificate()`         | [ssl_certificate_by_lua_block]     | Executed during the SSL certificate serving phase of the SSL handshake.
| `:rewrite()`             | [rewrite_by_lua_block]             | Executed for every request upon its reception from a client as a rewrite phase handler. *NOTE* in this phase neither the `api` nor the `consumer` have been identified, hence this handler will only be executed if the plugin was configured as a global plugin!
| `:access()`              | [access_by_lua]                    | Executed for every request from a client and before it is being proxied to the upstream service.
| `:header_filter()`       | [header_filter_by_lua]             | Executed when all response headers bytes have been received from the upstream service.
| `:body_filter()`         | [body_filter_by_lua]               | Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. hence this method can be called multiple times if the response is large. See the [lua-nginx-module] documentation for more details.
| `:log()`                 | [log_by_lua]                       | Executed when the last response byte has been sent to the client.

All of those functions take one parameter which is given by Kong upon its
invocation: the configuration of your plugin. This parameter is a Lua table,
and contains values derined by your users, according to your plugin's schema
(described in the `schema.lua` module). More on plugins schemas in the [next
chapter]({{page.book.next}}).

[init_worker_by_lua]: https://github.com/openresty/lua-nginx-module#init_worker_by_lua
[ssl_certificate_by_lua_block]: https://github.com/openresty/lua-nginx-module#ssl_certificate_by_lua_block
[rewrite_by_lua_block]: https://github.com/openresty/lua-nginx-module#rewrite_by_lua_block
[access_by_lua]: https://github.com/openresty/lua-nginx-module#access_by_lua
[header_filter_by_lua]: https://github.com/openresty/lua-nginx-module#header_filter_by_lua
[body_filter_by_lua]: https://github.com/openresty/lua-nginx-module#body_filter_by_lua
[log_by_lua]: https://github.com/openresty/lua-nginx-module#log_by_lua

---

## handler.lua specifications

The `handler.lua` file must return a table implementing the functions you wish
to be executed. In favor of brevity, here is a commented example module
implementing all the available methods:

<div class="alert alert-warning">
  <strong>Note:</strong> Kong uses the
  <a href="https://github.com/rxi/classic">rxi/classic</a> module to simulate
  classes in Lua and ease the inheritance pattern.
</div>

```lua
-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- in your `error.log` file (where all logs are printed).
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instantiate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end

function CustomHandler:init_worker()
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.init_worker(self)

  -- Implement any custom logic here
end

function CustomHandler:certificate(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.certificate(self)

  -- Implement any custom logic here
end

function CustomHandler:rewrite(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.rewrite(self)

  -- Implement any custom logic here
end

function CustomHandler:access(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.access(self)

  -- Implement any custom logic here
end

function CustomHandler:header_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.header_filter(self)

  -- Implement any custom logic here
end

function CustomHandler:body_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.body_filter(self)

  -- Implement any custom logic here
end

function CustomHandler:log(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  CustomHandler.super.log(self)

  -- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return CustomHandler
```

Of course, the logic of your plugin itself can be abstracted away in another
module, and called from your `handler` module. Many existing plugins have
already chosen this pattern when their logic is verbose, but it is purely
optional:

```lua
local BasePlugin = require "kong.plugins.base_plugin"

-- The actual logic is implemented in those modules
local access = require "kong.plugins.my-custom-plugin.access"
local body_filter = require "kong.plugins.my-custom-plugin.body_filter"

local CustomHandler = BasePlugin:extend()

function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end

function CustomHandler:access(config)
  CustomHandler.super.access(self)

  -- Execute any function from the module loaded in `access`,
  -- for example, `execute()` and passing it the plugin's configuration.
  access.execute(config)
end

function CustomHandler:body_filter(config)
  CustomHandler.super.body_filter(self)

  -- Execute any function from the module loaded in `body_filter`,
  -- for example, `execute()` and passing it the plugin's configuration.
  body_filter.execute(config)
end

return CustomHandler
```

See [the source code of the Key-Auth plugin](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua) for an example of a real-life
handler code.

---

## Plugin Development Kit

Logic implemented in those phases will most likely have to interact with the
request/response objects or core components (e.g. access the cache,
database...). Kong provides a [Plugin Development Kit][pdk] (or "PDK") for such
purposes: a set of Lua functions and variables that can be used by plugins to
execute various gateway operations in a way that is guaranteed to be
forward-compatible with future releases of Kong.

When you are trying to implement some logic that needs to interact with Kong
(e.g. retrieving request headers, producing a response from a plugin, logging
some error or debug information...), you should consult the [Plugin Development
Kit Reference][pdk].

---

## Plugins execution order

Some plugins might depend on the execution of others to perform some
operations. For example, plugins relying on the identity of the consumer have
to run **after** authentication plugins. Considering this, Kong defines
**priorities** between plugins execution to ensure that order is respected.

Your plugin's priority can be configured via a property accepting a number in
the returned handler table:

```lua
CustomHandler.PRIORITY = 10
```

The higher the priority, the sooner your plugin's phases will be executed in
regard to other plugins' phases (such as `:access()`, `:log()`, etc...).

The current order of execution for the bundled plugins is:

Plugin                    | Priority
-------------------------:|:------------
pre-function              | `+inf`
zipkin                    | 100000
ip-restriction            | 3000
bot-detection             | 2500
cors                      | 2000
jwt                       | 1005
oauth2                    | 1004
key-auth                  | 1003
ldap-auth                 | 1002
basic-auth                | 1001
hmac-auth                 | 1000
request-size-limiting     | 951
acl                       | 950
rate-limiting             | 901
response-ratelimiting     | 900
request-transformer       | 801
response-transformer      | 800
aws-lambda                | 750
azure-functions           | 749
prometheus                | 13
http-log                  | 12
statsd                    | 11
datadog                   | 10
file-log                  | 9
udp-log                   | 8
tcp-log                   | 7
loggly                    | 6
syslog                    | 4
galileo                   | 3
request-termination       | 2
correlation-id            | 1
post-function             | -1000

---

Next: [Store configuration &rsaquo;]({{page.book.next}})

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[pdk]: /{{page.kong_version}}/pdk
