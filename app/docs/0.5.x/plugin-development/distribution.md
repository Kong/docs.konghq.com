---
title: Plugin Development - Distribute your plugin
book: plugin_dev
chapter: 9
---

# {{page.title}}

As mentioned many times in this guide, Kong heavily relies on your modules being available in your `LUA_PATH` under specific names.

As already mentioned in the [file structure] chapter, we make Kong aware that it has to look for your plugin's modules by adding it to the `plugins_available` property in your configuration file. Example:

```yaml
plugins_available:
  - key-auth
  - rate-limiting
  - my-custom-plugin # your plugin name here
```

Kong will now look for modules named:

```
"kong.plugins.my-custom-plugin.api"
"kong.plugins.my-custom-plugin.daos"
"kong.plugins.my-custom-plugin.handler"
"kong.plugins.my-custom-plugin.migrations.cassandra"
"kong.plugins.my-custom-plugin.schema"
```

You need to make these modules available in your LUA_PATH.

---

### Distribute your modules

The preferred way to do so is to use [Luarocks](https://luarocks.org/), a package manager for Lua modules. It calls such modules "rocks". **Your module does not have to live inside the Kong repository!** It can be

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
      ["kong.plugins.my-kong-plugin.migrations.cassandra"] = "/path/to/migrations.cassandra.lua",
      ["kong.plugins.my-kong-plugin.schema"] = "/path/to/schema.lua"
    }
 }
```

Learn more about creating your rockspec [here][rockspec].

---

[rockspec]: https://github.com/keplerproject/luarocks/wiki/Creating-a-rock
