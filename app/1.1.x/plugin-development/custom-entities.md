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

To see a real-life example, give a look at the [Key-Auth plugin migrations](https://github.com/Kong/kong/tree/{{page.kong_version}}/kong/plugins/key-auth/migrations)

---

## Defining a Schema

The first step to using custom entities in a custom plugin is defining one
or more *schemas*.

A schema is a Lua table which describes entities. There's structural information
like how are the different fields of the entity named and what are their types,
which is similar to the fields describing your [plugin
configuration]({{page.book.chapters.plugin-configuration}})).
Compared to plugin configuration schemas, custom entity schemas require
additional metadata (e.g. which field, or fields, constitute the entities'
primary key).

Schemas are to be defined in a module named:

```
kong.plugins.<plugin_name>.daos
```

Meaning that there should be a file called `<plugin_name>/daos.lua` inside your
plugin folder. The `daos.lua` file should return a table containing one or more
schemas. For example:

```lua
-- <plugin_name>/daos.lua
local typedefs = require "kong.db.schema.typedefs"

local credentials = {
  primary_key = { "id" },
  name = "keyauth_credentials",
  endpoint_key = "key",
  cache_key = { "key" },
  fields = {
    { id = typedefs.uuid },
    { created_at = typedefs.auto_timestamp_s },
    { consumer = { type = "foreign", reference = "consumers", default = ngx.null, on_delete = "cascade" } },
    { key = { type = "string", required = false, unique = true, auto = true } },
  }
}

return { credentials }
```

This example `daos.lua` file introduces a single schema called `keyauth_credentials`.

Here is a description of some top-level properties:

<table>
<tbody>
<tr><th>Name</th><th>Type</th><th>Description</th></tr>
<tr>
  <td><code>name</code></td>
  <td>String (mandatory)</td>
  <td>It will be used to determine the DAO name (<code>kong.db.[name]</code>).</td>
</tr>
<tr>
  <td><code>primary_key</code></td>
  <td>Array of strings (mandatory)</td>
  <td>Field names forming the entity's primary key.
    Schemas support composite keys, even if most Kong core entities currently use an UUID named
    <code>id</code>. If you are using Cassandra and need a composite key, it should have the same
    fields as the partition key.
  </td>
</tr>
<tr>
<td><code>endpoint_key</code></td>
  <td>String (optional)</td>
  <td>The name of the field used as an alternative identifier on the Admin API.
    On the example above, <code>key</code> is the endpoint_key. This means that a credential with
    <code>id = 123</code> and <code>key = "foo"</code> could be referenced as both
    <code>/keyauth_credentials/123</code> and <code>/keyauth_credentials/foo</code>.
  </td>
</tr>
<tr>
  <td><code>cache_key</code></td>
  <td>Array of strings (optional)</td>
  <td>Contains the name of the fields used for generating the <code>cache_key</code>, a string which must
    unequivocally identify the entity inside Kong's cache. A unique field, like <code>key</code> in your example,
    is usually good candidate. In other cases a combination of several fields is preferable.
  </td>
</tr>
<tr>
  <td><code>fields</code></td>
  <td>Array of field definitions</td>
  <td>Each field definition is a table with a single key, which is the field's name. The table value is
    a subtable containing the field's <em>attributes</em>, some of which will be explained below.
  </td>
</tr>
</tbody>
</table>

Many field attributes encode *validation rules*. When attempting to insert or update entities using
the DAO, these validations will be checked, and an error returned if the provided input doesn't conform
to them.

The `typedefs` variable (obtained by requiring `kong.db.schema.typedefs`) is a table containing
a lot of useful type definitions and aliases, including `typedefs.uuid`, the most usual type for the primary key,
and `typedefs.auto_timestamp_s`, for `created_at` fields. It is used extensively when defining fields.

Here's a non-exhaustive explanation of some of the field attributes available:

<table>
<tbody>
<tr><th>Attribute name</th><th>type</th><th>Description</th></tr>
<tr>
  <td><code>type</code></td>
  <td>String</td>
  <td>
  <p>Schemas support the following scalar types: <code>"string"</code>, <code>"integer"</code>, <code>"number"</code> and
  <code>"boolean"</code>. Compound types like <code>"array"</code>, <code>"record"</code>, or <code>"set"</code> are
  also supported.</p>

  <p>In additon to these values, the <code>type</code> attribute can also take the special <code>"foreign"</code> value,
  which denotes a foreign relationship.</p>

  <p>Each field will need to be backed by database fields of appropriately similar types, created via migrations.</p>

  <p><code>type</code> is the only required attribute for all field definitions.</p>
  </td>
</tr>
<tr>
  <td><code>default</code></td>
  <td>Any Lua value matching the <code>type</code> attribute</td>
  <td>Specifies the value the field will have when attempting to insert it, if no value was provided.
  Devalut values are always set via Lua, never by the underlying database. It is thus not recommended to set
  any default values on fields in migrations.</td>
</tr>
<tr>
  <td><code>required</code></td>
  <td>Boolean</td>
  <td>When set to <code>true</code> on a field, an error will be thrown when attempting to insert an entity lacking a value
    for said field (unless the field in question has a default value).</td>
</tr>
<tr>
  <td><code>unique</code></td>
  <td>Boolean</td>
  <td>
  <p>When set to <code>true</code> on a field, an error will be thrown when attempting to insert an entity on the database,
    but another entity already has the given value on said field.</p>

  <p>This attribute <em>must</em> be backed up by declaring fields as <code>UNIQUE</code> in migrations when using
    PostgreSQL. The Cassandra strategy does a check in Lua before attempting inserts, so it doesn't require any special treatment.
  </p>
  </td>
</tr>
<tr>
  <td><code>auto</code></td>
  <td>Boolean</td>
  <td>
  <p>When attempting to insert an entity without providing a value for this a field where <code>auto</code> is set to <code>true</code>, </p>
  <ul>
    <li>If <code>type == "uuid"</code>, the field will take a random UUID as value.</li>
    <li>If <code>type == "string"</code>, the field will take a random string.</li>
    <li>If the field name is <code>created_at</code> or <code>updated_at</code>, the field will take the current time when
    inserting / updating, as appropriate.</li>
  </ul>
  </td>
</tr>
<tr>
  <td><code>reference</code></td>
  <td>String</td>
  <td>Required for fields of type <code>foreign</code>. The given string <em>must</em> be the name of an existing schema,
    to which the foreign key will "point to". This means that if a schema B has a foreign key pointing to schema A,
    then A needs to be loaded before B.
  </td>
</tr>
<tr>
  <td><code>on_delete</code></td>
  <td>String</td>
  <td>
  <p>Optional and exclusive for fields of type <code>foreign</code>. It dictates what must happen
  with entities linked by a foreign key when the entity being referenced is deleted. It can have three possible
  values:</p>

  <ul>
    <li><code>"cascade"</code>: When the linked entity is deleted, all the dependent entities must also be deleted.</li>
    <li><code>"null"</code>: When the linked entity is deleted, all the dependent entities will have their foreign key
    field set to <code>null</code>.</li>
    <li><code>"restrict"</code>: Attempting to delete an entity with linked entities will result in an error.</li>
  </ul>

  <p>In Cassandra this is handled with pure Lua code, but in PostgreSQL it will be necessary to declare the references
    as <code>ON DELETE CASCADE/NULL/RESTRICT</code> in a migration.</p>
  </td>
</tr>
</tbody>
</table>


To learn more about schemas, see:

* The source code of [typedefs.lua](https://github.com/Kong/kong/blob/{{page.kong_version | replace: "x", "0"}}/kong/db/schema/typedefs.lua)
  to get an idea of what's provided there by default.
* [The Core Schemas](https://github.com/Kong/kong/tree/{{page.kong_version | replace: "x", "0"}}/kong/db/schema/entities)
  to see examples of some other field attributes not discussed here.
* [All the `daos.lua` files for embedded plugins](https://github.com/search?utf8=%E2%9C%93&q=repo%3Akong%2Fkong+path%3A%2Fkong%2Fplugins+filename%3Adaos.lua),
  especially [the key-auth one](https://github.com/Kong/kong/blob/{{page.kong_version | replace: "x", "0"}}/kong/plugins/key-auth/daos.lua),
  which was used for this guide as an example.

---

## The custom DAO

The schemas are not used directly to interact with the database. Instead, a DAO
is built for each valid schema. A DAO takes the name of the schema it wraps, and is
accessible through the `kong.db` interface.

For the example schema above, the DAO generated would be available for plugins
via `kong.db.keyauth_credentials`.

### Selecting an entity

``` lua
local entity, err, err_t = kong.db.<name>:select(primary_key)
```

Attempts to find an entity in the database and return it. Three things can happen:

* The entity was found. In this case, it is returned as a regular Lua table.
* An error occurred - for example the connection with the database was lost. In that
  case the first returned value will be `nil`, the second one will be a string
  describing the error, and the last one will be the same error in table form.
* An error does not occur but the entity is not found. Then the function will
  just return `nil`, with no error.

Example of usage:

``` lua
local entity, err = kong.db.keyauth_credentials:select({
  id = "c77c50d2-5947-4904-9f37-fa36182a71a9"
})

if err then
  kong.log.err("Error when inserting keyauth credential: " .. err)
  return nil
end

if not entity then
  kong.log.err("Could not find credential.")
  return nil
end
```

### Iterating over all the entities

``` lua
for entity, err on kong.db.<name>:each(entities_per_page) do
  if err then
    ...
  end
  ...
end
```

This method efficiently iterates over all the entities in the database by making paginated
requests. The `entities_per_page` parameter, which defaults to `100`, controls how many
entities per page are returned.

On each iteration, a new `entity` will be returned or, if there is any error, the `err`
variable will be filled up with an error. The recommended way to iterate is checking `err` first,
and otherwise assume that `entity` is present.

Example of usage:

``` lua
for credential, err on kong.db.keyauth_credentials:each(1000) do
  if err then
    kong.log.err("Error when iterating over keyauth credentials: " .. err)
    return nil
  end

  kong.log("id: " .. credential.id)
end
```

This example iterates over the credentials in pages of 1000 items, logging their ids unless
an error happens.

### Inserting an entity

``` lua
local entity, err, err_t = kong.db.<name>:insert(<values>)
```

Inserts an entity in the database, and returns a copy of the inserted entity, or
`nil`, an error message (a string) and a table describing the error in table form.

When the insert is successful, the returned entity contains the extra values produced by
`default` and `auto`.

The following example uses the `keyauth_credentials` DAO to insert a credential for a given
Consumer, setting its `key` to `"secret"`. Notice the syntax for referencing foreign keys.

``` lua
local entity, err = kong.db.keyauth_credentials:insert({
  consumer = { id = "c77c50d2-5947-4904-9f37-fa36182a71a9" },
  key = "secret",
})

if not entity then
  kong.log.err("Error when inserting keyauth credential: " .. err)
  return nil
end
```

The returned entity, assuming no error happened will have `auto`-filled fields, like `id` and `created_at`.

### Updating an entity

``` lua
local entity, err, err_t = kong.db.<name>:update(primary_key, <values>)
```

Updates an existing entity, provided it can be found using the provided primary key and a set of values.

The returned entity will be the entity after the update takes place, or `nil` + an error message + an error table.

The following example modifies the `key` field of an existing credential given the credential's id:

``` lua
local entity, err = kong.db.keyauth_credentials:update({
  { id = "2b6a2022-770a-49df-874d-11e2bf2634f5" },
  { key = "updated_secret" },
})

if not entity then
  kong.log.err("Error when updating keyauth credential: " .. err)
  return nil
end
```

Notice how the syntax for specifying a primary key is similar to the one used to specify a foreign key.

### Upserting an entity

``` lua
local entity, err, err_t = kong.db.<name>:upsert(primary_key, <values>)
```

`upsert` is a mixture of `insert` and `update`:

* When the provided `primary_key` identifies an existing entity, it works like `update`.
* When the provided `primary_key` does not identify an existing entity, it works like `insert`

Given this code:

``` lua
local entity, err = kong.db.keyauth_credentials:upsert({
  { id = "2b6a2022-770a-49df-874d-11e2bf2634f5" },
  { consumer = { id = "a96145fb-d71e-4c88-8a5a-2c8b1947534c" } },
})

if not entity then
  kong.log.err("Error when upserting keyauth credential: " .. err)
  return nil
end
```

Two things can happen:

* If a credential with id `2b6a2022-770a-49df-874d-11e2bf2634f5` exists,
  then this code will attempt to set its Consumer to the provided one.
* If the credential does not exist, then this code is attempting to create
  a new credential, with the given id and Consumer.

### Deleting an entity

``` lua
local ok, err, err_t = kong.db.<name>:delete(primary_key)
```

Attempts to delete the entity identified by `primary_key`. It returns `true`
if the entity *doesn't exist* after calling this method, or `nil` + error +
error table if an error is detected.

Notice that calling `delete` will succeed if the entity didn't exist *before
calling it*. This is for performance reasons - we want to avoid doing a
read-before-delete if we can avoid it. If you want to do this check, you
must do it manually, by checking with `select` before invoking `delete`.

Example:

``` lua
local ok, err = kong.db.keyauth_credentials:delete({
  { id = "2b6a2022-770a-49df-874d-11e2bf2634f5" }
})

if not ok then
  kong.log.err("Error when deleting keyauth credential: " .. err)
  return nil
end
```

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
