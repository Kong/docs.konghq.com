---
title: Plugin Development - Accessing the datastore
book: plugin_dev
chapter: 5
---

## Introduction

Kong interacts with the model layer through classes we refer to as "DAOs". This chapter will detail the available API to interact with the datastore.

As of `0.8.0`, Kong supports two primary datastores: [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) and [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/).

---

## The DAO Factory

All entities in Kong are represented by:

- A schema that describes which table the entity relates to in the datastore, constraints on its fields such as foreign keys, non-null constraints etc... This schema is a table described in the [plugin configuration]({{page.book.chapters.plugin-configuration}}) chapter.
- An instance of the `DAO` class mapping to the database currently in use (Cassandra or PostgreSQL). This class' methods consume the schema and expose methods to insert, update, find and delete entities of that type.

The core entities in Kong are: Apis, Consumers and Plugins. Each of these entities can be interacted with through their corresponding DAO instance, available through the **DAO Factory** instance. The DAO Factory is responsible for loading these core entities' DAOs as well as any additional entities, provided for example by plugins.

The DAO Factory is a singleton instance in Kong and thus, is accessible through the `singletons` module:

```lua
local singletons = require "kong.singletons"

-- Core DAOs
local apis_dao = singletons.dao.apis
local consumers_dao = singletons.dao.consumers
local plugins_dao = singletons.dao.plugins
```

---

## The DAO Lua API

The DAO class is responsible for the operations executed on a given table in the datastore, generally mapping to an entity in Kong. All the underlying supported databases (currently Cassandra and PostgreSQL) comply to the same interface, thus making the DAO compatible with all of them.

For example, inserting an API is as easy as:

```lua
local singletons = require "kong.singletons"
local dao = singletons.dao

local inserted_api, err = dao.apis:insert({
  name = "mockbin",
  hosts = { "mockbin.com" },
  upstream_url = "http://mockbin.com"
})
```

---

Next: [Custom Entities &rsaquo;]({{page.book.next}})
