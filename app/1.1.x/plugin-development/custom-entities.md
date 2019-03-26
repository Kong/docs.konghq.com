---
title: Plugin Development - Storing Custom Entities
book: plugin_dev
chapter: 6
---

## Introduction

While not all plugins need it, your plugin might need to store more than
its configuration in the database. In that case, Kong provides you with
an abstraction on top of its primary datastores which allows you to store
custom entities.

As explained in the [previous chapter]({{page.book.previous}}), Kong interacts
with the model layer through classes we refer to as "DAOs", and available on a
singleton often referred to as the "DAO Factory". This chapter will explain how
to to provide an abstraction for your own entities.

## Modules

```
kong.plugins.<plugin_name>.daos
kong.plugins.<plugin_name>.migrations.init
kong.plugins.<plugin_name>.migrations.000_base
kong.plugins.<plugin_name>.migrations.001_xxx
kong.plugins.<plugin_name>.migrations.002_yyy
```

## Create the migrations folder

Once you have defined your model, you must create your migration modules which
will be executed by Kong to create the table in which your records of your
entity will be stored. A migration file holds an array of migrations, and
returns them.

If you plugin is intended to support both Cassandra and PostgreSQL, then both
migrations must be written.

If your plugin doesn't have it already, you should add a `<plugin_name>/migrations`
folder to it. If there is no `init.lua` file inside already, you should create one.
This is where all the migrations for your plugin will be referenced.

The initial version of your `migrations/init.lua` file will point to a single migration.

In this case we have called it `000_base`.

``` lua
-- `migrations/init.lua`
return {
  "000_base",
}
```

This means that there will be a file in `<plugin_name>/migrations/000_base.lua` containing the
initial migrations. We'll see how this is done in a minute.

## Adding a new migration to an existing plugin

Sometimes it is necessary to introduce changes after a version of a plugin has already been
released. A new functionality might be needed. A database table row might need changing.

When this happens, *you must* create a new migrations file. You *must not*
of modify the existing migration files once they are published.

While there is no strict rule for naming your migration files, there is a convention that the
initial one is prefixed by `000`, the next one by `001`, and so on.

Following with our previous example, if we wanted to release a new version of the plugin with
changes in the database (for example, a table was needed called `foo`) we would insert it by
adding a file called `<plugin_name>/migrations/001_add_foo.lua`, and referencing it on the
migrations init file like so:


``` lua
-- `<plugin_name>/migrations/init.lua`
return {
  "000_base",
  "001_add_foo",
}
```

## Migration File syntax

While Kong's core migrations support both PostgreSQL and Cassandra, custom plugins
can choose to support either both of them or just one.

A migration file is a Lua file which returns a table with the following structure:

``` lua
-- `<plugin_name>/migrations/000_base.lua`
return {
  postgresql = {
    up = [[
      CREATE INDEX IF NOT EXISTS "routes_name_idx" ON "routes" ("name");
    ]],
    teardown = function(connector, helpers)
      assert(connector:connect_migrations())
      assert(connector:query('DROP TABLE IF EXISTS "schema_migrations" CASCADE;'))
    end,
  },

  cassandra = {
    up = [[
      CREATE INDEX IF NOT EXISTS routes_name_idx ON routes(name);
    ]],
    teardown = function(connector, helpers)
      assert(connector:connect_migrations())
      assert(connector:query("DROP TABLE IF EXISTS schema_migrations"))
    end,
  }
}
```

If a plugin only supports PostgreSQL or Cassandra, only the section for one strategy is
needed. Each strategy section has two parts, `up` and `teardown`.

* `up` is an optional string of raw SQL/CQL statements. Those statements will be executed
  when `kong migrations up` is executed.
* `teardown` is an optional Lua function, which takes a `connector` parameter. Such connector
  can invoke the `query` method to execute SQL/CQL queries. Teardown is triggered by
  `kong migrations finish`

It is recommended that all the non-destructive operations, such as creation of new tables and
addition of new records is done on the `up` sections, while destructive operations (such as
removal of data, changing row types, insertion of new data) is done on the `teardown` sections.

In both cases, it is recommended that all the SQL/CQL statements are written so that they are
as reentrant as possible. `DROP TABLE IF EXISTS` instead of `DROP TABLE`,
`CREATE INDEX IF NOT EXIST` instead of `CREATE INDEX`, etc. If a migration fails for some
reason it is expected that the first attempt at fixing the problem will be simply
re-running the migrations.

While PostgreSQL does, Cassandra does not support constraints such as "NOT
NULL", "UNIQUE" or "FOREIGN KEY", but Kong provides you with such features when
you define your model's schema. Bear in mind that this schema will be the same
for both PostgreSQL and Cassandra, hence, you might trade-off a pure SQL schema
for one that works with Cassandra too.

**IMPORTANT**: if your `schema` uses a `unique` constraint, then Kong will
enforce it for Cassandra, but for PostgreSQL you must set this constraint in
the migrations.

To see a real-life example, give a look at the [Key-Auth plugin migrations](https://github.com/Kong/kong/tree/master/kong/plugins/key-auth/migrations)

---

## Retrieve your custom DAO from the DAO Factory

To make the DAO Factory load your custom DAO(s), you will need to define your
entity's schema (just like the schemas describing your [plugin
configuration]({{page.book.chapters.plugin-configuration}})). This schema
contains a few more values since it must describes which table the entity
relates to in the datastore, constraints on its fields such as foreign keys,
non-null constraints and such.

This schema is to be defined in a module named:

```
"kong.plugins.<plugin_name>.daos"
```

Once that module returns your entity's schema, and assuming your plugin is
loaded by Kong (see the `plugins` property in `kong.conf`), the DAO Factory
will use it to instantiate a DAO object.

Here is an example of how one would define a schema to store API keys in a his
or her database:

```lua
-- daos.lua
local SCHEMA = {
  primary_key = {"id"},
  table = "keyauth_credentials", -- the actual table in the database
  fields = {
    id = {type = "id", dao_insert_value = true}, -- a value to be inserted by the DAO itself (think of serial ID and the uniqueness of such required here)
    created_at = {type = "timestamp", immutable = true, dao_insert_value = true}, -- also interted by the DAO itself
    consumer_id = {type = "id", required = true, foreign = "consumers:id"}, -- a foreign key to a Consumer's id
    key = {type = "string", required = false, unique = true} -- a unique API key
  }
}

return {keyauth_credentials = SCHEMA} -- this plugin only results in one custom DAO, named `keyauth_credentials`
```

Since your plugin might have to deal with multiple custom DAOs (in the case
when you want to store several entities), this module is bound to return a
key/value table where keys are the name on which the custom DAO will be
available in the DAO Factory.

You will have noticed a few new properties in the schema definition (compared
to your [schema.lua]({{page.book.chapters.plugin-configuration}}) file):

| Property name         | Lua type                  | Description
|-----------------------|---------------------------|-------------
| `primary_key`         | Integer indexed table     | An array of each part of your column family's primary key. It also supports **composite keys**, even if all Kong entities currently use a simple `id` for usability of the [Admin API]. If your primary key is composite, only include what makes your **partition key**.
| `fields.*.dao_insert_value` | Boolean              | If true, specifies that this field is to be automatically populated by the DAO (in the base_dao implementation) depending on it's type. A property of type `id` will be a generated uuid, and `timestamp` a timestamp with second-precision.
| `fields.*.queryable`  | Boolean                   | If true, specifies that Cassandra maintains an index on the specified column. This allows for querying the column family filtered by this column.
| `fields.*.foreign`    | String                    | Specifies that this column is a foreign key to another entity's column. The format is: `dao_name:column_name`. This makes it up for Cassandra not supporting foreign keys. When the parent row will be deleted, Kong will also delete rows containing the parent's column value.

Your DAO will now be loaded by the DAO Factory and available as one of its
properties. Since the DAO Factory is exposed by the [Plugin Development Kit]'s
`kong` global (see [kong.dao](/{{page.kong_version}}/pdk/#kong-dao), you can
retrieve it like so:

```lua
local key_credential, err = kong.dao.key_credentials:insert({
  consumer_id = consumer.id,
  key = "abcd"
})
```

The DAO name (`keyauth_credentials`) with which it is accessible from the DAO
Factory depends on the key with which you exported your DAO in the returned
table of `daos.lua`.

You can see an example of this in the [Key-Auth `daos.lua` file](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/daos.lua).

---

## Caching custom entities

Sometimes custom entities are required on every request/response, which in turn
triggers a query on the datastore every time. This is very inefficient because
querying the datastore adds latency and slows the request/response down, and
the resulting increased load on the datastore could affect the datastore
performance itself and, in turn, other Kong nodes.

When a custom entity is required on every request/response it is good practice
to cache it in-memory by leveraging the in-memory cache API provided by Kong.

The next chapter will focus on caching custom entities, and invalidating them
when they change in the datastore: [Caching custom
entities]({{page.book.next}}).

---

Next: [Caching custom entities &rsaquo;]({{page.book.next}})

[Admin API]: /{{page.kong_version}}/admin-api/
[Plugin Development Kit]: /{{page.kong_version}}/pdk
