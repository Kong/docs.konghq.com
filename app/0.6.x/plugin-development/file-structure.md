---
title: Plugin Development - File Structure
book: plugin_dev
chapter: 2
---

## Introduction

<div class="alert alert-warning">
  <strong>Note:</strong> This chapter assumes that you are familiar with <a href="http://www.lua.org/">Lua</a>.
</div>

Consider your plugin as a set of [Lua modules](http://www.lua.org/manual/5.1/manual.html#6.3). Each file described in this chapter is to be considered as a separate module. Kong will detect and load your plugin's modules if their names follow this convention:

```
"kong.plugins.<plugin_name>.<module_name>"
```

> Your modules of course need to be accessible through your [package.path](http://www.lua.org/manual/5.1/manual.html#pdf-package.path) variable, which can be tweaked to your needs by the [lua-package-path](https://github.com/openresty/lua-nginx-module#lua_package_path) directive in your Nginx configuration. However, the preferred way of installing plugins is through [Luarocks](https://luarocks.org/). More on that later in this guide.

To make Kong aware that it has to look for your plugin's modules, you'll have to add it to the `custom_plugins` property in your configuration file. For example:

```yaml
custom_plugins:
  - my-custom-plugin # your plugin name here
```

Now, Kong will try to load the modules described in this chapter. Some of them are mandatory, but the ones that are not will be ignored and Kong will consider you do not make use of it. For example, Kong will load `"kong.plugins.my-custom-plugin.handler"` to retrieve and execute your plugin's logic.

Now let's describe what are the modules you can implement and what their purpose is.

---

### Basic plugin modules

In its purest form, a plugin consists of two mandatory modules:

```
simple-plugin
├── handler.lua
└── schema.lua
```

- [handler.lua]: the core of your plugin. It is an interface to implement, in which each function will be run at the desired moment in the lifecycle of a request.
- [schema.lua]: your plugin probably has to retain some configuration entered by the user. This module holds the *schema* of that configuration and defines rules on it, so that the user can only enter valid configuration values.

---

### Advanced plugin modules

Some plugins might have to integrate deeper with Kong: have their own table in the database, expose endpoints in the Admin API, etc... Each of those can be done by adding a new module to your plugin. Here is what the structure of a plugin would look like if it was implementing all of the optional modules:

```
complete-plugin
├── api.lua
├── daos.lua
├── handler.lua
├── migrations
│   └── cassandra.lua
├── hooks.lua
└── schema.lua
```

Here is the complete list of possible modules to implement and a brief description of what their purpose is. This guide will go in details to let you master each one of them.

| Module name        | Required   | Description
|:-------------------|------------|----------
| [api.lua]({{page.book.chapters.admin-api}})          | No         | Defines a list of endpoints to be available in the Admin API to interact with entities custom entities handled by your plugin.
| [daos.lua]({{page.book.chapters.custom-entities}})         | No         | Defines a list of DAOs (Database Access Objects) that are abstractions of custom entities needed by your plugin and stored in the datastore.
| [handler.lua]({{page.book.chapters.custom-logic}})      | Yes        | An interface to implement. Each function is to be run by Kong at the desired moment in the lifecycle of a request.
| [schema/migrations.lua]({{page.book.chapters.custom-entities}}) | No         | The corresponding migrations for a given datastore. Migrations are only necessary when your plugin has to store custom entities in the database and interact with them through one of the DAOs defined by [daos.lua].
| [hooks.lua]({{page.book.chapters.plugin-configuration}})       | No        | Implements the invalidation event handlers for the datastore entities defined in `daos.lua`. Required if you are storing entities in the in-memory cache, in order to invalidate them when they are being updated/deleted on the datastore.
| [schema.lua]({{page.book.chapters.plugin-configuration}})       | Yes        | Holds the schema of your plugin's configuration, so that the user can only enter valid configuration values.

---

Next: [Write custom logic &rsaquo;]({{page.book.next}})
