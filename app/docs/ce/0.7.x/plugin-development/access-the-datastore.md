---
title: Plugin Development - Accessing the datastore
book: plugin_dev
chapter: 5
---

# {{page.title}}

Kong interacts with the model layer through classes we refer to as "DAOs". This chapter will detail the available API to interact with the datastore.

<div class="alert alert-warning">
  <strong>Note:</strong> Currently, Kong only supports <a href="http://cassandra.apache.org/">Cassandra</a> as its datastore. This guide assumes that you are already familiar with it and sometimes describes concepts only related to Cassandra, such as indexes and clustering keys.
</div>

---

### The DAO Factory

All entities in Kong are represented by:

- A schema that describes which table the entity relates to in the datastore, constraints on its fields such as foreign keys, non-null constraints etc... This schema is a table described in the [plugin configuration]({{page.book.chapters.plugin-configuration}}) chapter.
- A child implementation of the [kong.dao.cassandra.base_dao] module, which consumes the schema exposing methods to insert, update, find and delete entities of that type. See the [children DAOs interface](http://localhost:3000/docs/0.5.x/lua-reference/modules/kong.dao.cassandra.base_dao/#Children_DAOs_interface).

The core entities in Kong are: Apis, Consumers and Plugins. Each of these entities can be interacted with through their corresponding DAO instance, available through the **DAO Factory** instance. The DAO Factory is responsible for loading these core entities' DAOs as well as any additional entities, provided for example by plugins.

The DAO Factory is generally accessible from the `dao` global variable:

```lua
local dao_factory = dao

-- Core DAOs
local apis_dao = dao_factory.apis
local consumers_dao = dao_factory.consumers
local plugins_dao = dao_factory.plugins
```

For [performance](http://lua-users.org/wiki/OptimisingUsingLocalVariables) [reasons](https://github.com/openresty/lua-nginx-module#lua-variable-scope), it is recommended to cache the global variable. In some cases, the DAO Factory is given as a local variable, and should be used over the global variable for the same reasons.

---

### DAOs Lua API

All methods available on DAOs are documented in the [kong.dao.cassandra.base_dao] module in Kong's Public Lua API Reference. See the [public interface] and [children DAOs interface] sections of the base_dao module.

By extending the `base_dao` module, all DAOs have access to an abstraction on top of Cassandra, providing methods for inserting, updating, finding and deleting rows, with validation and pagination features that Cassandra does not provide by itself.

For example, inserting an API is as easy as:

```lua
local inserted_api, err = dao.apis:insert({
  name = "mockbin",
  upstream_url = "http://mockbin.com",
  request_host = "mockbin.com"
})
```

---

### Custom DAOs

Because Kong needs to deal with more than the three core entities, the [kong.dao.cassandra.base_dao][kong.dao.cassandra.base_dao] can be inherited to support any entity. Plugins make heavy use of this feature, and every exising plugin implements their own DAO, loaded by the DAO Factory and made available everywhere the factory is, just like the core entities.

Now, let's see how to create your own DAO for your plugin in the next chapter: [Custom Entities]({{page.book.next}}).

---

Next: [Custom Entities &rsaquo;]({{page.book.next}})

[kong.dao.cassandra.base_dao]: /docs/{{page.kong_version}}/lua-reference/modules/kong.dao.cassandra.base_dao
[children DAOs interface]: /docs/{{page.kong_version}}/lua-reference/modules/kong.dao.cassandra.base_dao/#Children_DAOs_interface
[public interface]: /docs/{{page.kong_version}}/lua-reference/modules/kong.dao.cassandra.base_dao/#Public_interface
