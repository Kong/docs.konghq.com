---
title: Plugin Development - Accessing the datastore
book: plugin_dev
chapter: 5
---

## Introduction

Kong interacts with the model layer through classes we refer to as "DAOs". This
chapter will detail the available API to interact with the datastore.

Kong supports two primary datastores: [Cassandra
{{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/)
and [PostgreSQL
{{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/).

<div class="alert alert-warning">
  <strong>Note:</strong> As of 0.13.0, Kong is rolling out a new version of
  the DAO abstraction layer called `kong.db`, which will gradually
  replace `kong.dao`
</div>
---

## kong.db and kong.dao

All entities in Kong are represented by:

- A schema that describes which table the entity relates to in the datastore,
  constraints on its fields such as foreign keys, non-null constraints etc...
  This schema is a table described in the [plugin
  configuration]({{page.book.chapters.plugin-configuration}}) chapter.
- An instance of the `DAO` class mapping to the database currently in use
  (Cassandra or PostgreSQL). This class' methods consume the schema and expose
  methods to insert, update, find and delete entities of that type.

The core entities in Kong are: Services, Routes, Consumers and Plugins.
Services, Routes, and Consumers are available through the new `kong.db`
singleton. The rest of the entities are available through `kong.dao`. In the
future, all entities will be gradually migrated to `kong.db`, including custom
plugins entities (currently relying on `kong.dao`).

Both the DAO Factory and the new `db` interface are singleton instances in Kong
and thus, are accessible through the `kong` global:

```lua
-- Core DAOs
local services_dao = kong.db.services
local routes_dao = kong.db.routes
local consumers_dao = kong.db.consumers
local plugins_dao = kong.dao.plugins
```

The `kong` global exposes the [Plugin Development Kit], and its `kong.dao` and
`kong.db` properties are instances of the DAO and DB singletons.

---

## The DAO Lua API

The DAO class is responsible for the operations executed on a given table in
the datastore, generally mapping to an entity in Kong. All the underlying
supported databases (currently Cassandra and PostgreSQL) comply to the same
interface, thus making the DAO compatible with all of them.

For example, inserting a Service (with `kong.db`) and a Plugin (with
`kong.dao`) is as easy as:

```lua
local inserted_service, err = kong.db.services:insert({
  name = "mockbin",
  url = "http://mockbin.org"
})

local inserted_plugin, err = kong.dao.plugins:insert({
  name = "key-auth",
  service_id = inserted_service.id
})
```

For a real-life example of the DAO being used in a plugin, see the
[Key-Auth plugin source code](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua).

---

Next: [Custom Entities &rsaquo;]({{page.book.next}})

[Plugin Development Kit]: /{{page.kong_version}}/pdk
