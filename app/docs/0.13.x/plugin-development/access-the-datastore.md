---
title: Plugin Development - Accessing the datastore
book: plugin_dev
chapter: 5
---

# {{page.title}}

Kong interacts with the model layer through classes we refer to as "DAOs". This chapter will detail the available API to interact with the datastore.

Kong supports two primary datastores: [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) and [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/).

<div class="alert alert-warning">
  <strong>Note:</strong> Currently, Kong is rolling out a new version of the DAO abstraction layer called `singletons.db`, which will gradually replace `singletons.dao`
</div>
---

### `singletons.db` and `singletons.dao`

All entities in Kong are represented by:

- A schema that describes which table the entity relates to in the datastore, constraints on its fields such as foreign keys, non-null constraints etc... This schema is a table described in the [plugin configuration]({{page.book.chapters.plugin-configuration}}) chapter.
- An instance of the `DAO` class mapping to the database currently in use (Cassandra or PostgreSQL). This class' methods consume the schema and expose methods to insert, update, find and delete entities of that type.

The core entities in Kong are: Services, Routes, Consumers and Plugins. Services and Routes are available through the new `singletons.db` variable. The rest of the entities are available through `singletons.dao`. In the future they will be gradually migrated to `singletons.db`.

Each of these entities can be interacted with through their corresponding DAO instance, available through the **DAO Factory** instance. The DAO Factory is responsible for loading these core entities' DAOs as well as any additional entities, provided for example by plugins.

Both the DAO Factory and the new `db` interface are singleton instances in Kong and thus, are accessible through the `singletons` module:

```lua
local singletons = require "kong.singletons"

-- Core DAOs
local services_dao = singletons.db.services
local routes_dao = singletons.db.routes
local consumers_dao = singletons.dao.consumers
local plugins_dao = singletons.dao.plugins
```

---

### The DAO Lua API

The DAO class is responsible for the operations executed on a given table in the datastore, generally mapping to an entity in Kong. All the underlying supported databases (currently Cassandra and PostgreSQL) comply to the same interface, thus making the DAO compatible with all of them.

For example, inserting a Service (with `singletons.db`) and a Plugin (with singletons.dao) is as easy as:

```lua
local singletons = require "kong.singletons"
local db  = singletons.db
local dao = singletons.dao

local inserted_service, err = db.services:insert({
  name = "mockbin",
  url = "http://mockbin.org"
})

local inserted_plugin, err = dao.plugins:insert({
  name = "key-auth",
  service_id = inserted_service.id
})
```

---

Next: [Custom Entities &rsaquo;]({{page.book.next}})
