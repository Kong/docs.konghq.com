---
title: Plugin Development - Extending the Admin API
book: plugin_dev
chapter: 8
---

{:.note}
> **Notes:**
> * This chapter assumes that you have a relative
  knowledge of [Lapis](http://leafo.net/lapis/).
> * The Admin API extensions are available only
  for HTTP plugins, not Stream plugins.

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

## Add endpoints to the Admin API

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
  via `kong.db.<entity>.schema`. The schema is used to parse certain fields according to their
  types; for example if a field is marked as an integer, it will be parsed as such when it is
  passed to a function (by default form fields are all strings).
- The `methods` subtable contains functions, indexed by a string.
  - The `before` key is optional and can hold a function. If present, the function will be executed
    on every request that hits `path`, before any other function is invoked.
  - One or more functions can be indexed with HTTP method names, like `GET` or `PUT`. These functions
    will be executed when the appropriate HTTP method and `path` is matched. If a `before` function is
    present on the `path`, it will be executed first. Keep in mind that `before` functions can
    use `kong.response.exit` to finish early, effectively cancelling the "regular" http method function.
  - The `on_error` key is optional and can hold a function. If present, the function will be executed
    when the code from other functions (either from a `before` or a "http method") throws an error. If
    not present, then Kong will use a default error handler to return the errors.

For example:

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
obtain (`GET`) and create (`POST`) credentials associated to a given consumer. On this example
the functions are provided by the `kong.api.endpoints` library.

The `endpoints` module currently contains the default implementation for the most usual CRUD
operations used in Kong. This module provides you with helpers for any insert, retrieve,
update or delete operations and performs the necessary DAO operations and replies with
the appropriate HTTP status codes. It also provides you with functions to retrieve parameters from
the path, such as an Service's name or id, or a Consumer's username or id.

If `endpoints`-provided are functions not enough, a regular Lua function can be used instead. From there you can use:

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

---

Next: [Write tests for your plugin]({{page.book.next}})

[Admin API]: /gateway/{{page.kong_version}}/admin-api/
