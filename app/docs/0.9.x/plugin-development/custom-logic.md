---
title: Plugin Development - Write custom logic
book: plugin_dev
chapter: 3
---

# {{page.title}}

#### Module

```
"kong.plugins.<plugin_name>.handler"
```

---

<div class="alert alert-warning">
  <strong>Note:</strong> This chapter assumes that you are familiar with <a href="http://www.lua.org/">Lua</a> and the <a href="https://github.com/openresty/lua-nginx-module">lua-nginx-module API</a>.
</div>

Kong allows you to execute custom code at different times in the lifecycle of a request. To do so, you have to implement one or several of the methods of the `base_plugin.lua` interface. Those methods are to be implemented in a module at: `"kong.plugins.<plugin_name>.handler"`

---

### Available request contexts

Kong allows you to write your code in all of the lua-nginx-module contexts. Each function to implement in your `handler.lua` file will be executed when the context is reached for a request:

| Function name           | lua-nginx-module context           | Description
|-------------------------|------------------------------------|--------------
| `:init_worker()`         | [init_worker_by_lua]               | Executed upon every Nginx worker process's startup.
| `:certificate()`         | [ssl_certificate_by_lua_block]     | Executed during the SSL certificate serving phase of the SSL handshake.
| `:access()`              | [access_by_lua]                    | Executed for every request upon it's reception from a client and before it is being proxied to the upstream service.
| `:header_filter()`       | [header_filter_by_lua]             | Executed when all response headers bytes have been received from the upstream service.
| `:body_filter()`         | [body_filter_by_lua]               | Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. hence this method can be called multiple times if the response is large. See the lua-nginx-module documentation for more details.
| `:log()`                 | [log_by_lua]                       | Executed when the last response byte has been sent to the client.

All of those functions take one parameter given by Kong: the configuration of your plugin. This parameter is a simple Lua table, and will contain values defined by your users, according to the schema of your choice. More on that in the [next chapter]({{page.book.next}}).

[ssl_certificate_by_lua_block]: https://github.com/openresty/lua-nginx-module#ssl_certificate_by_lua_block
[init_worker_by_lua]: https://github.com/openresty/lua-nginx-module#init_worker_by_lua
[access_by_lua]: https://github.com/openresty/lua-nginx-module#access_by_lua
[header_filter_by_lua]: https://github.com/openresty/lua-nginx-module#header_filter_by_lua
[body_filter_by_lua]: https://github.com/openresty/lua-nginx-module#body_filter_by_lua
[log_by_lua]: https://github.com/openresty/lua-nginx-module#log_by_lua

---

### handler.lua specifications

The `handler.lua` file must return a table implementing the functions you wish to be executed. In favor of brevity, here is a commented example module implementing all the available methods:

<div class="alert alert-warning">
  <strong>Note:</strong> Kong uses the <a href="https://github.com/rxi/classic">rxi/classic</a> module to simulate classes in Lua and ease the inheritence pattern.
</div>

```lua
-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- in your `error.log` file (where all logs are printed).
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instanciate itself
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

Of course, the logic of your plugin itself can be abstracted away in another module, and called from your `handler` module. Many existing plugins have already chosen this pattern when their logic is verbose, but it is purely optional:

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

---

### Plugins execution order

<div class="alert alert-warning">
  <strong>Note:</strong> This is still a work-in-progress API. For thoughts on how plugins execution order should be configurable in the future, see <a href="https://github.com/Mashape/kong/issues/267">Mashape/kong#267</a>.
</div>

Some plugins might depend on the execution of others to perform some operations. For example, plugins relying on the identity of the consumer have to run **after** authentication plugins. Considering this, Kong defines **priorities** between plugins execution to ensure that order is respected.

Your plugin's priority can be configured via a property accepting a number in the returned handler table:

```lua
CustomHandler.PRIORITY = 10
```

The higher the priority, the sooner your plugin's phases will be executed in regard to other plugins' phases (such as `:access()`, `:log()`, etc...). The current authentication plugins have a priority of `1000`.

---

Next: [Store configuration &rsaquo;]({{page.book.next}})

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
