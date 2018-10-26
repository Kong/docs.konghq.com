---
title: Plugin Development - Storing Custom Entities
book: plugin_dev
chapter: 6
---

## Introduction

Your plugin might need to store more than its configuration in the database. In
that case, Kong provides you with an abstraction on top of its primary
datastores which allows you to store custom entities.

As explained in the [previous chapter]({{page.book.previous}}), Kong interacts
with the model layer through classes we refer to as "DAOs", and available on a
singleton often referred to as the "DAO Factory". This chapter will explain how
to to provide an abstraction for your own entities.

## Modules

```
kong.plugins.<plugin_name>.schema.migrations
kong.plugins.<plugin_name>.daos
```
[Back to TOC](#table-of-contents)

---

## Create a migration file

Once you have defined your model, you must create your migration modules which
will be executed by Kong to create the table in which your records of your
entity will be stored. A migration file holds an array of migrations, and
returns them.

If you plugin is intended to support both Cassandra and PostgreSQL, then both
migrations must be written.

Each migration must bear a unique name, and `up` and `down` fields. Such fields
can either be strings of SQL/CQL queries for simple migrations, or actual Lua
code to execute for complex ones. The `up` field will be executed when Kong
migrates **forward**. It must bring your database's schema to the latest state
required by your plugin. The `down` field must execute the necessary actions to
revert your schema to its previous state, before `up` was ran.

One of the main benefits of this approach is should you need to release a new
version of your plugin that modifies a model, you can add new migrations to the
array before releasing your plugin. Another benefit is that it is also possible
to revert such migrations.

As described in the [file structure]({{page.book.chapters.file-structure}})
chapter, your migrations modules must be named:

```
"kong.plugins.<plugin_name>.migrations.cassandra"
"kong.plugins.<plugin_name>.migrations.postgres"
```

Here is an example of how one would define a migration file to store API keys:

```lua
-- cassandra.lua
return {
  {
    name = "2015-07-31-172400_init_keyauth",
    up =  [[
      CREATE TABLE IF NOT EXISTS keyauth_credentials(
        id uuid,
        consumer_id uuid,
        key text,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON keyauth_credentials(key);
      CREATE INDEX IF NOT EXISTS keyauth_consumer_id ON keyauth_credentials(consumer_id);
    ]],
    down = [[
      DROP TABLE keyauth_credentials;
    ]]
  }
}
```

```lua
-- postgres.lua
return {
  {
    name = "2015-07-31-172400_init_keyauth",
    up = [[
      CREATE TABLE IF NOT EXISTS keyauth_credentials(
        id uuid,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        key text UNIQUE,
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        IF (SELECT to_regclass('public.keyauth_key_idx')) IS NULL THEN
          CREATE INDEX keyauth_key_idx ON keyauth_credentials(key);
        END IF;
        IF (SELECT to_regclass('public.keyauth_consumer_idx')) IS NULL THEN
          CREATE INDEX keyauth_consumer_idx ON keyauth_credentials(consumer_id);
        END IF;
      END$$;
    ]],
    down = [[
      DROP TABLE keyauth_credentials;
    ]]
  }
}
```

- `name`: Must be a unique string. The format does not matter but can help you
  debug issues while developing your plugin, so make sure to name it in a
  relevant way.
- `up`: Executed when Kong migrates **forward**.
- `down`: Executed when Kong migrates **backward**.

While PostgreSQL does, Cassandra does not support constraints such as "NOT
NULL", "UNIQUE" or "FOREIGN KEY", but Kong provides you with such features when
you define your model's schema. Bear in mind that this schema will be the same
for both PostgreSQL and Cassandra, hence, you might trade-off a pure SQL schema
for one that works with Cassandra too.

**IMPORTANT**: if your `schema` uses a `unique` constraint, then Kong will
enforce it for Cassandra, but for PostgreSQL you must set this constraint in
the `migrations` file.

To see a real-life example, give a look at the [Key-Auth plugin migrations](https://github.com/Kong/kong/tree/master/kong/plugins/key-auth/migrations)

[Back to TOC](#table-of-contents)

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

[Back to TOC](#table-of-contents)

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

[Back to TOC](#table-of-contents)

---

Next: [Caching custom entities &rsaquo;]({{page.book.next}})

[Admin API]: /{{page.kong_version}}/admin-api/
[Plugin Development Kit]: /{{page.kong_version}}/pdk
