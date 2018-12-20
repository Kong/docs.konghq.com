---
title: Plugin Development - Custom Entities
book: plugin_dev
chapter: 6
---

## Modules

```
"kong.plugins.<plugin_name>.migrations.cassandra"
"kong.plugins.<plugin_name>.daos"
```

---

Your plugin might need to store more than its configuration in the database. In that case, Kong provides you with an abstraction on top of Cassandra (and future supported datastores) which allows you to store custom entities.

As explained in the [previous chapter]({{page.book.previous}}), Kong interacts with the model layer through classes we refer to as "DAOs", and available on a global variable called the "DAO Factory". This chapter will explain how to inherit from the Kong [kong.dao.cassandra.base_dao] module to provide an abstraction for your own entities.

<div class="alert alert-warning">
  <strong>Note:</strong> Currently, Kong only supports <a href="http://cassandra.apache.org/">Cassandra</a> as its datastore. This guide assumes that you are already familiar with it and sometimes describes concepts only related to Cassandra, such as indexes and clustering keys.
</div>

---

## Create a migration file

Once you have defined your model, you must create a migration file which will be executed by Kong to create your column family. A migration file simply holds an array of migrations, and returns them.

Each migration has a unique name, and two strings consisting of [CQL](https://cassandra.apache.org/doc/cql/CQL.html) statements: `up` and `down`. All up queries are executed when Kong migrates your database (when starting or using the [kong migrations](/{{page.kong_version}}/cli#migrations) command).

One of the main benefits of this approach is should you need to release a new version that modifies a model, you can simply add new migrations to the array before releasing your plugin. Another benefit is that it is also possible to revert such migrations.

As described in the [file structure]({{page.book.chapters.file-structure}}) chapter, your file must be a module named:

```
"kong.plugins.<plugin_name>.migrations.cassandra"
```

Here is an example of how one would define a migration file to store API keys:

```lua
local Migrations = {
  {
    name = "2015-07-31-172400_init_keyauth",
    up = function(options)
      return [[
        CREATE TABLE IF NOT EXISTS keyauth_credentials(
          id uuid,
          consumer_id uuid,
          key text,
          created_at timestamp,
          PRIMARY KEY (id)
        );

        CREATE INDEX IF NOT EXISTS ON keyauth_credentials(key);
        CREATE INDEX IF NOT EXISTS keyauth_consumer_id ON keyauth_credentials(consumer_id);
      ]]
    end,
    down = function(options)
      return [[
        DROP TABLE keyauth_credentials;
      ]]
    end
  }
}

return Migrations
```

- `name`: Must be a unique string. The format does not matter but can help you debug issues while developing your plugin, so make sure to name it in a relevant way.
- `up`: Function returning a string of semi-colon separated CQL statements. Used when Kong migrates **forward**. The first parameter, `options`, is a table containing the Cassandra properties defined in your configuration file.
- `down`: Function returning a string of semi-colon separated CQL statements. Used when Kong migrates **backward**. The first parameter, `options`, is a table containing the Cassandra properties defined in your configuration file.

Cassandra does not support constraints such as "must be unique" or "is a foreign key to that table's primary key", but Kong provides you with such features when you extend the Base DAO and define your model's schema.

---

## Extending the Base DAO

To make the DAO Factory load your custom DAO(s), you will need:

- A schema (just like the schemas describing your [plugin configuration]({{page.book.chapters.plugin-configuration}})) that describes which table the entity relates to in the datastore, constraints on its fields such as foreign keys, non-null constraints and such.
- A child implementation of [kong.dao.cassandra.base_dao], which consumes the schema and exposes methods to create, update, find and delete entities of that type. See the [children DAOs interface].

This DAO is to be implemented in a module named:

```
"kong.plugins.<plugin_name>.daos.lua"
```

Here is an example of how one would define a schema to inherit from the base_dao module and store API keys in a new table ("column family" in Cassandra):

<div class="alert alert-warning">
  <strong>Note:</strong> Kong uses the <a href="https://github.com/rxi/classic">rxi/classic</a> module to simulate classes in Lua and ease the inheritance pattern.
</div>

```lua
-- daos.lua

local BaseDao = require "kong.dao.cassandra.base_dao"

local SCHEMA = {
  primary_key = {"id"},
  -- clustering_key = {}, -- none for this entity
  fields = {
    id = {type = "id", dao_insert_value = true},
    created_at = {type = "timestamp", dao_insert_value = true},
    consumer_id = {type = "id", required = true, queryable = true, foreign = "consumers:id"},
    key = {type = "string", required = false, unique = true, queryable = true}
  }
}

-- Inherit from the Base DAO
local KeyAuth = BaseDao:extend()

function KeyAuth:new(cassandra_properties)
  self._table = "keyauth_credentials" -- same as the column family created in the migration file
  self._schema = SCHEMA

  KeyAuth.super.new(self, cassandra_properties)
end

return {keyauth_credentials = KeyAuth} -- this plugin only defines one custom DAO, named `keyauth_credentials`
```

Once you have defined your schema, overriding the :new() method provides the Base DAO the schema and the name of the associated column family in your Cassandra instance (according to your own migration file).

Since your plugin might have to deal with multiple custom DAOs (in the case when you want to store several entities), this module is bound to return a key/value table where keys are the name on which the custom DAO will be available in the DAO Factory.

You will have noticed a few new properties in the schema definition (compared to your [schema.lua]({{page.book.chapters.plugin-configuration}}) file):

| Property name         | Lua type                  | Description
|-----------------------|---------------------------|-------------
| `primary_key`         | Integer indexed table     | An array of each part of your column family's primary key. It also supports **composite keys**, even if all Kong entities currently use a simple `id` for usability of the Admin API. If your primary key is composite, only include what makes your **partition key**.
| `clustering_key`      | Integer indexed table     | In the case when your primary key is composite, an array of each field determining your **clustering key**.
| `fields.*.dao_insert_value` | Boolean              | If true, specifies that this field is to be automatically populated by the DAO (in the base_dao implementation) depending on it's type. A property of type `id` will be a generated uuid, and `timestamp` a timestamp with second-precision.
| `fields.*.queryable`  | Boolean                   | If true, specifies that Cassandra maintains an index on the specified column. This allows for querying the column family filtered by this column.
| `fields.*.foreign`    | String                    | Specifies that this column is a foreign key to another entity's column. The format is: `dao_name:column_name`. This makes it up for Cassandra not supporting foreign keys. When the parent row will be deleted, Kong will also delete rows containing the parent's column value. This is a

Your DAO will now be loaded by the DAO Factory and available as one of its properties:

```lua
local dao_factory = dao
local keys_dao = dao_factory.keyauth_credentials
```

The property name depends on the key with which you exported your DAO in the returned table of `daos.lua`.

---

## Extending the Admin API

As you are probably aware, the [Admin API] is where Kong users communicate with Kong to setup their APIs and plugins. It is likely that they also need to be able to interact with the custom entities you implemented for your plugin (for example, creating and deleting API keys). The way you would do this is by extending the Admin API, which we will detail in the next chapter: [Extending the Admin API]({{page.book.next}}).

---

Next: [Extending the Admin API &rsaquo;]({{page.book.next}})

[kong.dao.cassandra.base_dao]: /{{page.kong_version}}/lua-reference/modules/kong.dao.cassandra.base_dao
[Admin API]: /{{page.kong_version}}/admin-api/
[children DAOs interface]: /{{page.kong_version}}/lua-reference/modules/kong.dao.cassandra.base_dao/#Children_DAOs_interface
