---
title: File Structure
book: plugin_dev
chapter: 3
---

{:.note}
> **Note**: This chapter assumes that you are familiar with
[Lua](http://www.lua.org/).

Consider your plugin as a set of [Lua
modules](http://www.lua.org/manual/5.1/manual.html#5.3). Each file described in
this chapter is to be considered as a separate module. Kong will detect and
load your plugin's modules if their names follow this convention:

```
kong.plugins.<plugin_name>.<module_name>
```

Your modules need to be accessible through your
[package.path](http://www.lua.org/manual/5.1/manual.html#pdf-package.path)
variable, which can be tweaked to your needs via the
[`lua_package_path`](/gateway/{{page.release}}/reference/configuration/#lua_package_path)
configuration property.
However, the preferred way of installing plugins is through
[LuaRocks](https://luarocks.org/), which Kong natively integrates with.
More on LuaRocks-installed plugins later in this guide.

To make Kong aware that it has to look for your plugin's modules, you'll have
to add it to the
[plugins](/gateway/{{page.release}}/reference/configuration/#plugins) property in
your configuration file, which is a comma-separated list. For example:

```yaml
plugins = bundled,my-custom-plugin # your plugin name here
```

Or, if you don't want to load any of the bundled plugins:

```yaml
plugins = my-custom-plugin # your plugin name here
```

Now, Kong will try to load several Lua modules from the following namespace:

```
kong.plugins.my-custom-plugin.<module_name>
```

Some of these modules are mandatory (e.g. `handler.lua`), and some are
optional, and will allow the plugin to implement some extra-functionalities
(e.g. `api.lua` to extend the Admin API endpoints).

Now let's describe exactly what are the modules you can implement and what
their purpose is.


## Basic plugin modules

In its purest form, a plugin consists of two mandatory modules:

```
simple-plugin
├── handler.lua
└── schema.lua
```

- [handler.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/handler.lua): the core of your plugin. It is an interface to implement, in
  which each function will be run at the desired moment in the lifecycle of a
  request / connection.
- [schema.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/schema.lua): your plugin probably has to retain some configuration entered
  by the user. This module holds the *schema* of that configuration and defines
  rules on it, so that the user can only enter valid configuration values.


## Advanced plugin modules

Some plugins might have to integrate deeper with Kong: have their own table in
the database, expose endpoints in the Admin API, etc. Each of those can be
done by adding a new module to your plugin. Here is what the structure of a
plugin would look like if it was implementing all of the optional modules:

```
complete-plugin
├── api.lua
├── daos.lua
├── handler.lua
├── migrations
│   ├── init.lua
│   └── 000_base_complete_plugin.lua
└── schema.lua
```

Here is the complete list of possible modules to implement and a brief
description of what their purpose is. This guide will go in details to let you
master each one of them.

| Module name            | Required   | Description
|:-----------------------|------------|------------
| [api.lua](https://github.com/Kong/kong/blob/master/autodoc/admin-api/data/admin-api.lua)          | No         | Defines a list of endpoints to be available in the Admin API to interact with the custom entities handled by your plugin.
| [daos.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/daos.lua)        | No         | Defines a list of DAOs (Database Access Objects) that are abstractions of custom entities needed by your plugin and stored in the data store.
| [handler.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/handler.lua)     | Yes        | An interface to implement. Each function is to be run by Kong at the desired moment in the lifecycle of a request / connection.
| [migrations/*.lua](https://github.com/Kong/kong/tree/master/kong/plugins/basic-auth/migrations) | No         | The database migrations (e.g. creation of tables). Migrations are only necessary when your plugin has to store custom entities in the database and interact with them through one of the DAOs defined by [daos.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/daos.lua).
| [schema.lua](https://github.com/Kong/kong/blob/master/kong/plugins/basic-auth/schema.lua)      | Yes        | Holds the schema of your plugin's configuration, so that the user can only enter valid configuration values.

The [Key-Auth plugin](/hub/kong-inc/key-auth/) is an example of plugin with this file structure.
See the [Key-Auth source code](https://github.com/Kong/kong/tree/master/kong/plugins/key-auth) for more details.

