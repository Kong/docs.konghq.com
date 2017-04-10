---
title: Plugin Development - Store Configuration
book: plugin_dev
chapter: 4
---

# {{page.title}}

#### Module

```
"kong.plugins.<plugin_name>.schema"
```

---

Most of the time, it makes sense for your plugin to be configurable to answer all of your user's needs. Your plugin's configuration is stored in the datastore for Kong to retrieve it and pass it to your [handler.lua]({{page.book.chapters.custom-logic}}) methods when the plugin is being executed.

The configuration consists of a Lua table in Kong that we call a **schema**. It contains key/value properties that the user will set when enabling the plugin through the [Admin API]. Kong provides you with a way of validating the user's configuration for your plugin.

Your plugin's configuration is being verified against your schema when a user issues a request to the [Admin API] to enable or update a plugin on a given API and/or Consumer.

For example, a user performs the following request:

```bash
$ curl -X POST http://kong:8001/apis/<api name>/plugins \
    -d "name=my-custom-plugin" \
    -d "config.foo=bar"
```

If all properties of the `config` object are valid according to your schema, then the API would return `201 Created` and the plugin would be stored in the database along with its configuration (`{foo = "bar"}` in this case). If the configuration is not valid, the Admin API would return `400 Bad Request` and the appropriate error messages.

---

### schema.lua specifications

This module is to return a Lua table with properties that will define how your plugins can later be configured by users. Available properties are:

| Property name                 | Lua type    | Default          | Description
|-------------------------------|-------------|------------------|-------------
| `no_consumer`                 | Boolean     | `false`          | If true, it will not be possible to apply this plugin to a specific Consumer. This plugin must be API-wide only. For example: authentication plugins.
| `no_api`                      | Boolean     | `false`          | If true, it will not be possible to apply this plugin to a specific API. This plugin must be global only for every API.
| `fields`                      | Table       | `{}`             | Your plugin's **schema**. A key/value table of available properties and their rules.
| `self_check`                  | Function    | `nil`            | A function to implement if you want to perform any custom validation before accepting the plugin's configuration.

The `self_check` function must be implemented as follows:

```lua
-- @param `schema` A table describing the schema (rules) of your plugin configuration.
-- @param `config` A key/value table of the current plugin's configuration.
-- @param `dao` An instance of the DAO (see DAO chapter).
-- @param `is_updating` A boolean indicating wether or not this check is performed in the context of an update.
-- @return `valid` A boolean indicating if the plugin's configuration is valid or not.
-- @return `error` A DAO error (see DAO chapter)
```

Here is an example of a potential `schema.lua` file:

```lua
return {
  no_consumer = true, -- this plugin will only be API-wide,
  no_api = false, -- this plugin can be applied to one or more APIs
  fields = {
    -- Describe your plugin's configuration's schema here.
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- perform any custom verification
    return true
  end
}
```

### Describing your configuration schema

The `fields` property of your `schema.lua` file described the schema of your plugin's configuration. It is a flexible key/value table where each key will be a valid configuration property for your plugin, and each value a table describing the rules for that property. For example:

```lua
  fields = {
    some_string = {type = "string", required = true},
    some_boolean = {type = "boolean", default = false},
    some_array = {type = "array", enum = {"GET", "POST", "PUT", "DELETE"}}
  }
```

Here is the list of accepted rules for a property:

| Rule          | Lua type(s)              | Accepted values                                 | Description
|---------------|--------------------------|-------------------------------------------------|----------------------------
| `type`        | string                   | "id", "number", "boolean", "string", "table", "array", "url", "timestamp" | Validates the type of a property.
| `required`    | boolean                  |                                                 | **Default**: false. If true, the property must be present in the configuration.
| `unique`      | boolean                  |                                                 | **Default**: false. If true, the value must be unique (see remark below).
| `default`     | any                      |                                                 | If the property is not specified in the configuration, will set the property to the given value.
| `immutable`   | boolean                  |                                                 | **Default**: false. If true, the property will not be allowed to be updated once the plugin configuration has been created.
| `enum`        | table                    | Integer indexed table                           | A list of accepted values for a property. Any value not included in this list will not be accepted.
| `regex`       | string                   | A valid PCRE regular expression                 | A regex against which to validate the property's value.
| `schema`      | table                    | A nested schema definition                      | If the property's `type` is table, defines a schema against which to validate those sub-properties.
| `func`        | function                 |                                                 | A function to perform any custom validation on a property. See later examples for its parameters and return values.

> - **type**: will cast the value retrieved from the request parameters. If the type is not one of the native Lua types, custom verification is performed against it:
>   - id: must be a string
>   - timestamp: must be a number
>   - url: must be a valid URL
>   - array: must be an integer-indexed table (equivalent of arrays in Lua). In the Admin API, such an array can either be sent by having several times the property's key with different values in the request's body, or comma-delimited through a single body parameter.
> - **unique**: This property does not make sense for a plugin configuration, but is used when a plugin needs to store custom entities in the datastore.
> - **schema**: if you need to perform deepened validation of nested properties, this field allows you to create a nested schema. Schema verification is **recursive**. Any level of nesting is valid, but bear in mind that this will affect the usability of your plugin.
> - **Any property attached to a configuration object but not present in your schema will also invalidate the said configuration.**

---

#### Examples:

This `schema.lua` file for the [key-auth](/plugins/key-authentication/) plugin defines a default list of accepted parameter names for an API key, and a boolean whose default is set to `false`:

```lua
-- schema.lua
return {
  no_consumer = true,
  fields = {
    key_names = {type = "array", required = true, default = {"apikey"}},
    hide_credentials = {type = "boolean", default = false}
  }
}
```

Hence, when implementing the `access()` function of your plugin in [handler.lua]({{page.book.chapters.custom-logic}}) and given that the user enabled the plugin with the default values, you'd have access to:

```lua
-- handler.lua
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()

function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end

function CustomHandler:access(config)
  CustomHandler.super.access(self)

  print(config.key_names) -- {"apikey"}
  print(config.hide_credentials) -- false
end

return CustomHandler
```

---

A more complex example, which could be used for an eventual logging plugin:

```lua
-- schema.lua

local function server_port(given_value, given_config)
  -- Custom validation
  if given_value > 65534 then
    return false, "port value too high"
  end

  -- If environment is "development", 8080 will be the default port
  if given_config.environment == "development" then
    return true, nil, {port = 8080}
  end
end

return {
  fields = {
    environment = {type = "string", required = true, enum = {"production", "development"}}
    server = {
      type = "table",
      schema = {
        host = {type = "url", default = "http://example.com"},
        port = {type = "number", func = server_port, default = 80}
      }
    }
  }
}
```

Such a configuration will allow a user to post the configuration to your plugin as follows:

```bash
$ curl -X POST http://kong:8001/apis/<api name>/plugins \
    -d "name=<my-custom-plugin>" \
    -d "config.environment=development" \
    -d "config.server.host=http://localhost"
```

And the following will be available in [handler.lua]({{page.book.chapters.custom-logic}}):

```lua
-- handler.lua
local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()

function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end

function CustomHandler:access(config)
  CustomHandler.super.access(self)

  print(config.environment) -- "development"
  print(config.server.host) -- "http://localhost"
  print(config.server.port) -- 8080
end

return CustomHandler
```

---

Next: [Store custom entities &rsaquo;]({{page.book.next}})

[Admin API]: /docs/{{page.kong_version}}/admin-api
