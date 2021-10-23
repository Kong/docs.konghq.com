---
title: Plugin Development - Extending the Admin API
book: plugin_dev
chapter: 8
---

<div class="alert alert-warning">
  <strong>Note:</strong> This chapter assumes that you have a relative
  knowledge of <a href="http://leafo.net/lapis/">Lapis</a>.
</div>

## Introduction

Kong can be configured using a REST interface referred to as the [Admin API].
Plugins can extend it by adding their own endpoints to accommodate custom
entities or other personalized management needs. A typical example of this is
the creation, retrieval, and deletion (commonly referred to as "CRUD
operations") of API keys.

The Admin API is a [Lapis](http://leafo.net/lapis/) application, and Kong's
level of abstraction makes it easy for you to add endpoints.

## Module

```
kong.plugins.<plugin_name>.api
```

## Adding endpoints to the Admin API

Kong will detect and load your endpoints if they are defined in a module named:

```
"kong.plugins.<plugin_name>.api"
```

This module is bound to return a table with one or more entries with the following structure:

``` lua
{
  ["<path>"] = {
     schema = <schema>,
     methods = {
       before = function(self) ... end,
       on_error = function(self) ... end,
       GET = function(self) ... end,
       PUT = function(self) ... end,
       ...
     }
  },
  ...
}
```

Where:

- `<path>` should be a string representing a route like `/users` (See [Lapis routes & URL
  Patterns](http://leafo.net/lapis/reference/actions.html#routes--url-patterns)) for details.
  Notice that the path can contain interpolation parameters, like `/users/:users/new`.
- `<schema>` is a schema definition. Schemas for core and custom plugin entities are available
  with `kong.db.<entity>.schema`. The schema is used to parse certain fields according to their
  types; for example if a field is marked as an integer, it will be parsed as such when it is
  passed to a function (by default form fields are all strings). Usually you should be able to get
  an entity's schema with `kong.db.<entity_name>.schema`.
- The `methods` subtable contains functions, indexed by a string.
  - The `before` key is an optional function. If present, the function will be executed
    on every request that hits `path`, before any other function is invoked.
  - One or more functions can be indexed with HTTP method names, like `GET` or `PUT`. These functions
    will be executed when the appropriate HTTP method and `path` is matched. If a `before` function is
    present on the `path`, it will be executed first. Keep in mind that `before` functions can
    use `kong.response.exit` to finish early, effectively cancelling the "regular" http method function.
  - The `on_error` key is optional and can hold a function. If present, the function will be executed
    when the code from other functions (either from a `before` or a "http method") throws an error. If
    not present, then Kong will use a default error handler to return the errors.

The `endpoints` module currently contains the default implementation for the most usual CRUD
operations used in Kong. This module provides you with helpers for any insert, retrieve,
update, or delete operations and performs the necessary DAO operations and replies with
the appropriate HTTP status codes. It also provides you with functions to retrieve parameters from
the path, such as a Service's name or ID, or a Consumer's username or ID.

### Collection endpoint generators

* `endpoints.get_collection_endpoint` produces a list of entities with pagination, like `GET /routes`.
  It can also generate a list of entities nested inside a "parent entity", like `GET /services/my_service/routes`.
* `endpoints.post_collection_endpoint` produces a "create new entity" endpoint (like `POST /routes`).
  It can also be nested inside a parent entity (`POST /services/my_service/routes`).

Both collection generators take the same 4 parameters:

1. `schema`: The schema of the entity being listed/created.
2. `foreign_schema`: An optional schema for the "parent entity".
3. `foreign_field_name`: The name of the attribute which points to the "parent" in the "child" entity.
   For the Routes and Services relationship, `foreign_field_name` would be `"service"`. It's not required if
   `foreign_schema` isn't present.
4. `method` allows overriding which method to do to perform the action at the DAO level. This method is
   useful on custom DAOs where `select` is called something different, like `index`.

The following example shows both collection endpoint generators in action:

``` lua
local endpoints = require "kong.api.endpoints"

local credentials_schema = kong.db.keyauth_credentials.schema
local consumers_schema = kong.db.consumers.schema

return {
  ["/consumers/:consumers/key-auth"] = {
    schema = credentials_schema,
    methods = {
      GET = endpoints.get_collection_endpoint(
              credentials_schema, consumers_schema, "consumer"),

      POST = endpoints.post_collection_endpoint(
              credentials_schema, consumers_schema, "consumer"),
    },
  },
}
```

This code will create two Admin API endpoints in `/consumers/:consumers/key-auth`, to
obtain (`GET`) and create (`POST`) credentials associated to a given consumer.

### Individual entity endpoint generators

* `endpoints.get_entity_endpoint` implements an endpoint which returns a single entity, like `GET /routes/my_route`.
* `endpoints.put_entity_endpoint` allows inserting/creating a single entity with a `PUT` request, for example `PUT /routes/my_route`.
* `endpoints.patch_entity_endpoint` modifies an existing single entity, for example `PATCH /routes/my_route`.
* `endpoints.delete_entity_endpoint` deletes an entity, for example `DELETE /routes/my_route`.

Like the collection endpoints, entity endpoints allow 1 level of nesting inside a parent entity, allowing things
like `GET /services/my_service/routes/my_route`.

The four generators take the following parameters:

1. `schema`: The schema of the entity.
2. `foreign_schema`: An optional schema for the "parent entity".
3. `foreign_field_name`: The name of the attribute which points to the "parent" in the "child" entity.
   For the Routes and Services relationship, `foreign_field_name` would be `"service"`. It's not required if
   `foreign_schema` isn't present.
4. `method`: Allows overriding which method to do to perform the action at the DAO level. This method is
   useful on custom DAOs where `select` is called something different, like `index`.
5. `is_foreign_entity_endpoint`: Boolean optional flag. When active, it switches the "parent" and "child" entities
  around. So instead of generating a function for `/services/my_service/routes/my_route`, it generates one for
  `/routes/my_route/service`. In other words, "get the parent starting from the child entity".

See the next section for an example.

### Custom functions

If `endpoints`-provided generators are not enough, a regular Lua function can be used instead. From there you can use:

- Several functions provided by the `endpoints` module.
- All the functionality provided by the [PDK](../../pdk)
- The `self` parameter, which is the [Lapis request object](http://leafo.net/lapis/reference/actions.html#request-object).
- And of course you can `require` any Lua modules if needed. Make sure they are compatible with OpenResty if you choose this route.

``` lua
local endpoints = require "kong.api.endpoints"

local credentials_schema = kong.db.keyauth_credentials.schema
local consumers_schema = kong.db.consumers.schema

return {
  ["/consumers/:consumers/key-auth/:keyauth_credentials"] = {
    schema = credentials_schema,
    methods = {
      before = function(self, db, helpers)
        local consumer, _, err_t = endpoints.select_entity(self, db, consumers_schema)
        if err_t then
          return endpoints.handle_error(err_t)
        end
        if not consumer then
          return kong.response.exit(404, { message = "Not found" })
        end

        self.consumer = consumer

        if self.req.method ~= "PUT" then
          local cred, _, err_t = endpoints.select_entity(self, db, credentials_schema)
          if err_t then
            return endpoints.handle_error(err_t)
          end

          if not cred or cred.consumer.id ~= consumer.id then
            return kong.response.exit(404, { message = "Not found" })
          end
          self.keyauth_credential = cred
          self.params.keyauth_credentials = cred.id
        end
      end,
      GET  = endpoints.get_entity_endpoint(credentials_schema),
      PUT  = function(self, db, helpers)
        self.args.post.consumer = { id = self.consumer.id }
        return endpoints.put_entity_endpoint(credentials_schema)(self, db, helpers)
      end,
    },
  },
}
```

On the previous example, the `/consumers/:consumers/key-auth/:keyauth_credentials` path gets
three functions:
- The `before` function is a custom Lua function which uses several `endpoints`-provided utilities
  (`endpoints.handle_error`) as well as PDK functions (`kong.response.exit`). It also populates
  `self.consumer` for the subsequent functions to use.
- The `GET` function is built entirely using `endpoints`. This is possible because the `before` has
  "prepared" things in advance, like `self.consumer`.
- The `PUT` function populates `self.args.post.consumer` before calling the `endpoints`-provided
  `put_entity_endpoint` function.


If you want to see a more complete example, with custom code in functions, see
[the `api.lua` file from the key-auth plugin](https://github.com/Kong/kong/blob/72cf66ad8db0e104b775f3b5e913a08b9d02e3b1/kong/plugins/key-auth/api.lua).

### Deactivating existing paths with `endpoints.disable`

The `before` endpoint can be used to deactivate existing paths by using the built-in `endpoints.disable` function.

For example, here's how a plugin could deactivate the `/services` Admin API endpoint.

``` lua
local endpoints = require "kong.api.endpoints"

return {
  -- deactivate the /services endpoint
  ["/services"] = endpoints.disable,
}
```

This code will make all requests to the `/services` endpoint return a `404 not found` response.

---

Next: [Write tests for your plugin]({{page.book.next}})

[Admin API]: /enterprise/{{page.kong_version}}/admin-api/
