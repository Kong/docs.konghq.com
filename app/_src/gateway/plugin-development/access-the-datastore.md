---
title: Accessing the Datastore
book: plugin_dev
chapter: 6
---

Kong interacts with the model layer through classes we refer to as "DAOs". This
chapter will detail the available API to interact with the datastore.

{% if_version lte:3.3.x %}
Kong supports two primary data stores: [PostgreSQL
{{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra
{{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/).

{% include_cached /md/enterprise/cassandra-deprecation.md length='short' release=page.release %}
{% endif_version %}

{% if_version gte:3.4.x %}
Kong supports [PostgreSQL
{{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) as a data store.

{% endif_version %}

## kong.db

All entities in Kong are represented by:

- A schema that describes which table the entity relates to in the datastore,
  constraints on its fields such as foreign keys, non-null constraints etc.
  This schema is a table described in the [plugin configuration]({{page.book.chapters.plugin-configuration}})
  chapter.
- An instance of the `DAO` class mapping to the database currently in use.
  This class' methods consume the schema and expose
  methods to insert, update, select and delete entities of that type.

The core entities in Kong are: Services, Routes, Consumers and Plugins.
All of them are accessible as Data Access Objects (DAOs),
through the `kong.db` global singleton:


```lua
-- Core DAOs
local services  = kong.db.services
local routes    = kong.db.routes
local consumers = kong.db.consumers
local plugins   = kong.db.plugins
```

Both core entities from Kong and custom entities from plugins are
available through `kong.db.*`.

## The DAO Lua API

The DAO class is responsible for the operations executed on a given table in
the datastore, generally mapping to an entity in Kong. All the underlying
supported databases comply to the same
interface, thus making the DAO compatible with all of them.

For example, inserting a Service and a Plugin is as easy as:

```lua
local inserted_service, err = kong.db.services:insert({
  name = "httpbin",
  url  = "http://httpbin.org",
})

local inserted_plugin, err = kong.db.plugins:insert({
  name    = "key-auth",
  service = inserted_service,
})
```

For a real-life example of the DAO being used in a plugin, see the
[Key-Auth plugin source code](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua).

[plugin development kit]: /gateway/{{page.release}}/plugin-development/pdk
