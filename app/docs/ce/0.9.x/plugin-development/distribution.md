---
title: Plugin Development - Distribute your plugin
book: plugin_dev
chapter: 10
---

# {{page.title}}

As mentioned many times in this guide, Kong heavily relies on your modules being available in your `LUA_PATH` under specific names.

As already mentioned in the [file structure] chapter, we make Kong aware that it has to look for your plugin's modules by adding it to the `custom_plugins` property in your configuration file. Example:

```
custom_plugins = my-custom-plugin
```

Kong will now look for modules named:

```
"kong.plugins.my-custom-plugin.api"
"kong.plugins.my-custom-plugin.daos"
"kong.plugins.my-custom-plugin.handler"
"kong.plugins.my-custom-plugin.migrations.cassandra"
"kong.plugins.my-custom-plugin.migrations.postgres"
"kong.plugins.my-custom-plugin.schema"
"kong.plugins.my-custom-plugin.hooks"
```

You need to make these modules available in your LUA_PATH.

---

### Distribute your modules

The preferred way to do so is to use [Luarocks](https://luarocks.org/), a package manager for Lua modules. It calls such modules "rocks". **Your module does not have to live inside the Kong repository!**, but it can be if that's how you'd like to maintain your Kong setup.

By defining your modules (and their eventual dependencies) in a [rockspec] file, you can install those modules on your platform via Luarocks. You can also upload your module on Luarocks and make it available to everyone!

Here is an example rockspec which would use the "builtin" build type to define modules in Lua notation and their corresponding file:

```
package = "my-kong-plugin"
version = "1.0-1"
source = {
  url = "..."
}
description = {
  summary = "A Kong plugin.",
  license = "MIT/X11"
}
dependencies = {
  "lua ~> 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.my-kong-plugin.api"] = "/path/to/api.lua",
    ["kong.plugins.my-kong-plugin.daos"] = "/path/to/daos.lua",
    ["kong.plugins.my-kong-plugin.handler"] = "/path/to/handler.lua",
    ["kong.plugins.my-kong-plugin.schema"] = "/path/to/schema.lua",
    ["kong.plugins.my-kong-plugin.hooks"] = "/path/to/hooks.lua",
    ["kong.plugins.my-kong-plugin.migrations.cassandra"] = "/path/to/schema/migrations/cassandra.lua",
    ["kong.plugins.my-kong-plugin.migrations.postgres"] = "/path/to/schema/migrations/postgres.lua"
  }
}
```

Learn more about creating your rockspec [here][rockspec].

---

[rockspec]: https://github.com/keplerproject/luarocks/wiki/Creating-a-rock
