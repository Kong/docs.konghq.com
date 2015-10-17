---
title: Plugin Development
---

# Plugin Development

As you are probably aware, Kong was built with extensible capabilities in mind from the start. This means that Kong can load and execute plugins at run-time, wether those are bundled with the official releases or custom.

This guide addresses itself to developers willing to create a plugin, wether it is a general purpose plugin to be merged into the official Kong repository, or a custom plugin to anwser some of your infrastructure needs.

---

### Summary

- 1. [What are plugins and how do they integrate with Kong?][1]
- 2. [File structure of a plugin][2]

[1]: #1.-what-are-plugins-and-how-do-they-integrate-with-kong?
[2]: #2.-file-structure-of-a-plugin

---

### 1. What are plugins and how do they integrate with Kong?

Before going further, it is necessary to briefly explain how Kong is built, especially how it integrates with Nginx and what does Lua has to do with it.

[lua-nginx-module] enables Lua scripting capabilities in Nginx. Instead of compiling Nginx with this module, Kong is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module. OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities.

Hence, Kong is a Lua application designed to load and execute Lua scripts (which we more commonly refer to as "*plugins*") and provides an entire development environment for them, including database abstraction, migrations, helpers and more...

Your plugin will consist of Lua scripts which will be loaded and executed by Kong, and it will benefit from two APIs:

- [lua-nginx-module API][lua-nginx-module-docs]: allows interaction with Nginx itself, such as, for example, retrieving the request/response, or accessing Nginx's shared memory zone.
- **Kong's plugin environment**: allows interaction with the datastore holding your configurations (APIs, Consumers, Plugins...) and various helpers allowing the interaction of plugins between each other.

<div class="alert alert-warning">
  <strong>Note:</strong> This guide assumes that you are familiar with Lua and the lua-nginx-module API, and will only describe Kong's plugin environment.
</div>

---

### 2. File structure of a plugin

It its purest form, a plugin consists of two mandatory files:

```
simple-plugin
├── handler.lua
└── schema.lua
```

- `handler.lua`: this file is the core of your plugin. It is an interface to implement, in which each function will be run at the desired moment in the lifecycle of a request.
- `schema.lua`: your plugin probably has to retain some configuration entered by the user. This file holds the *schema* of that configuration and defines rules on it, so that the user can only enter valid configuration values.

Some plugins might have to integrate deeper with Kong: have their own table in the database, expose endpoints in the Admin API, etc... Each of those can be done by adding a new file to your plugin. Here is what the structure of a plugin would look like if it was implementing all the optional files:

```
complete-plugin
├── api.lua
├── daos.lua
├── handler.lua
├── migrations
│   └── cassandra.lua
└── schema.lua
```

Here is list of possible files to implement and a brief description of what their purpose is. This guide will go in details to let you master each of them.

| File               | Required   | Description
|:-------------------|------------|----------
| `handler.lua`      | Yes        | An interface to implement. Each function is to be run by Kong at the desired moment in the lifecycle of a request.
| `schema.lua`       | Yes        | Holds the schema of your plugin's configuration, so that the user can only enter valid configuration values.
| `daos.lua`         | No         | Defines a list of DAOs (Database Access Objects) that are abstractions of custom entities needed by your plugin and stored in the datastore.
| `migrations/*.lua` | No         | Each file in this folder is the corresponding migration for a given datastore. Migrations are only necessary when your plugin has to store custom entities in the database and interact with them through one of the DAOs defined by `daos.lua`.
| `api.lua`          | No         | Defines a list of endpoints to be available in the Admin API to interact with entities custom entities handled by your plugin.

### Hooks into the lifecycle of a request

### Stored configuration

### Accessing the datastore

#### Migrations

### Extending the Admin API

### Writing tests

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[lua-nginx-module-docs]: https://www.nginx.com/resources/wiki/modules/lua/
