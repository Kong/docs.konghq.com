---
title: Plugin Development - Extending the Admin API
book: plugin_dev
chapter: 8
---

# {{page.title}}

#### Module

```
"kong.plugins.<plugin_name>.api"
```

---

The [Admin API] is the interface through which users will configure Kong. If your plugin has custom entities or management requirements, then you will need to extend the Admin API. This allows you to expose your own endpoints and implement your own management logic. A typical example of this is the creation, retrieval and deletion (commonly referred to as "CRUD operations") of API keys.

The Admin API is a [Lapis](http://leafo.net/lapis/) application, and Kong's level of abstraction makes it easy for you to add endpoints.

<div class="alert alert-warning">
  <strong>Note:</strong> This chapter assumes that you have a relative knowledge of <a href="http://leafo.net/lapis/">Lapis</a>.
</div>

---

### Adding endpoints to the Admin API

Kong will detect and load your endpoints if they are defined in a module named:

```
"kong.plugins.<plugin_name>.api"
```

This module is bound to return a table containing strings describing your routes (See [Lapis routes & URL Patterns](http://leafo.net/lapis/reference/actions.html#routes--url-patterns)) and HTTP verbs they support. Routes are then assigned a simple handler function.

This table is then fed to Lapis (See Lapis' [handling HTTP verbs documentation](http://leafo.net/lapis/reference/actions.html#handling-http-verbs)). Example:

```lua
return {
  ["/my-plugin/new/get/endpoint"] = {
    GET = function(self, dao_factory, helpers)
      -- ...
    end
  }
}
```

The handler function takes three arguments, which are, in order:

- `self`: The request object. See [Lapis request object](http://leafo.net/lapis/reference/actions.html#request-object)
- `dao_factory`: The DAO Factory. See the [datastore]({{page.book.chapters.access-the-datastore}}) chapter of this guide.
- `helpers`: A table containing a few helpers, described below.

In addition to the HTTPS verbs it supports, a route table can also contain two other keys:

- **before**: as in [Lapis](http://leafo.net/lapis/reference/actions.html#handling-http-verbs), a before_filter that runs before the executed verb action.
- **on_error**: a custom error handler function that overrides the one provided by Kong. See Lapis' [capturing recoverable errors](http://leafo.net/lapis/reference/exception_handling.html#capturing-recoverable-errors) documentation.

---

### Helpers

When handling a request on the Admin API, there are times when you want to send back responses and handle errors, to help you do so the third parameter `helpers` is a table with the following properties:

- `responses`: a module with helper functions to send HTTP responses. See [kong.tools.responses](/docs/{{page.kong_version}}/lua-reference/modules/kong.tools.responses).
- `yield_error`: the [yield_error](http://leafo.net/lapis/reference/exception_handling.html#capturing-recoverable-errors) function from Lapis. To call when your handler encounters an error (from a DAO, for example). Since all Kong errors are tables with context, it can send the appropriate response code depending on the error (Internal Server Error, Bad Request, etc...).

#### crud_helpers

Since most of the operations you will perform in your endpoints will be CRUD operations, you can also use the `kong.api.crud_helpers` module. This module provides you with helpers for any insert, retrieve, update or delete operations and performs the necessary DAO operations and replies with the appropriate HTTP status codes. It also provides you with functions to retrieve parameters from the path, such as an API's name or id, or a Consumer's username or id.

Example:

```lua
local crud = require "kong.api.crud_helpers"

return = {
  ["/consumers/:username_or_id/key-auth/"] = {
    before = function(self, dao_factory, helpers)
      crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
      self.params.consumer_id = self.consumer.id
    end,

    GET = function(self, dao_factory, helpers)
      crud.paginated_set(self, dao_factory.keyauth_credentials)
    end,

    PUT = function(self, dao_factory)
      crud.put(self.params, dao_factory.keyauth_credentials)
    end,

    POST = function(self, dao_factory)
      crud.post(self.params, dao_factory.keyauth_credentials)
    end
  }
}
```

---

Next: [Write tests for your plugin]({{page.book.next}})

[Admin API]: /docs/{{page.kong_version}}/admin-api/
