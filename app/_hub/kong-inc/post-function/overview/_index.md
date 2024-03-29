---
nav_title: Overview
---

The Post-function plugin (otherwise known as Kong Functions, Post-Plugin) lets
you dynamically run Lua code from Kong, after other plugins in each phase.

The plugin can be applied to individual services, routes, or globally.

This plugin is part of a pair of serverless plugins. 
If you need to run Lua code _before_ other plugins in each phase, use the 
[Pre-function](/hub/kong-inc/pre-function/) plugin.

{:.important}
> **Warning:** The Pre-function and Post-function serverless plugins
  allow anyone who can enable the plugin to execute arbitrary code.
  If your organization has security concerns about this, 
  [disable the plugins](/gateway/latest/reference/configuration/#untrusted_lua)
  in your `kong.conf` file.

## Sandboxing

The provided Lua environment is sandboxed.

{% include /md/plugins-hub/sandbox.md %}

## Upvalues

You can return a function to run on each request,
allowing for upvalues to keep state in between requests:

```lua
-- this runs once on the first request
local count = 0

return function()
  -- this runs on each request
  count = count + 1
  ngx.log(ngx.ERR, "hello world: ", count)
end
```

## Minifying Lua

Since we send our code over in a string format, it is advisable to use either
curl file upload `@file.lua` (see demonstration) or to minify your Lua code
using a [minifier][lua-minifier].

[lua-minifier]: https://mothereff.in/lua-minifier

## Get started with Post-functions

* [Configuration reference](/hub/kong-inc/post-function/configuration/)
* [Basic configuration example](/hub/kong-inc/post-function/how-to/basic-example/)
* [Get started with post-functions: changing request headers](/hub/kong-inc/post-function/how-to/)
* [Running functions in multiple phases](/hub/kong-inc/post-function/how-to/phases/)

