---
title: Plugin Development - Plugin Configuration
book: plugin_dev
chapter: 4
---

## Introduction

Most of the time, it makes sense for your plugin to be configurable to answer
all of your users' needs. Your plugin's configuration is stored in the
datastore for Kong to retrieve it and pass it to your
[handler.lua]({{page.book.chapters.custom-logic}}) methods when the plugin is
being executed.

The configuration consists of a Lua table in Kong that we call a **schema**. It
contains key/value properties that the user will set when enabling the plugin
through the [Admin API]. Kong provides you with a way of validating the user's
configuration for your plugin.

Your plugin's configuration is being verified against your schema when a user
issues a request to the [Admin API] to enable or update a plugin on a given
Service, Route and/or Consumer.

For example, a user performs the following request:

```bash
$ curl -X POST http://kong:8001/services/<service-name-or-id>/plugins \
    -d "name=my-custom-plugin" \
    -d "config.foo=bar"
```

If all properties of the `config` object are valid according to your schema,
then the API would return `201 Created` and the plugin would be stored in the
database along with its configuration:
```lua
{
  foo = "bar"
}
 ```
 
If the configuration is not valid, the Admin API would return `400 Bad Request`
and the appropriate error messages.

## Module

```
kong.plugins.<plugin_name>.schema
```

## schema.lua specifications

This module is to return a Lua table with properties that will define how your
plugins can later be configured by users. Available properties are:

| Property name   | Lua type   | Description
|-----------------|------------|------------
| `name`          | `string`   | Name of the plugin, e.g. `key-auth`.
| `fields`        | `table`    | Array of field definitions.
| `entity_checks` | `function` | Array of conditional entity level validation checks.


All the plugins inherit some default fields which are:

| Field name      | Lua type   | Description
|-----------------|------------|------------
| `id`            | `string`   | Auto-generated plugin id.
| `name`          | `string`   | Name of the plugin, e.g. `key-auth`.
| `created_at`    | `number`   | Creation time of the plugin configuration (seconds from epoch).
| `route`         | `table`    | Route to which plugin is bound, if any.
| `service`       | `table`    | Service to which plugin is bound, if any.
| `consumer`      | `table`    | Consumer to which plugin is bound when possible, if any.
| `run_on`        | `string`   | Determines on which node the plugin should run on service mesh.
| `protocols`     | `table`    | The plugin will run on specified protocol(s).
| `enabled`       | `boolean`  | Whether or not the plugin is enabled.
| `tags`          | `table`    | The tags for the plugin.

In most of the cases you can ignore most of those and use the defaults. Or let the user
specify value when enabling a plugin.

Here is an example of a potential `schema.lua` file (with some overrides applied):

```lua
local typedefs = require "kong.db.schema.typedefs"


return {
  name = "<plugin-name>",
  fields = {
    {
      -- this plugin will only be applied to Services or Routes
      consumer = typedefs.no_consumer
    },
    {
      -- this plugin will only be executed on the first Kong node
      -- if a request comes from a service mesh (when acting as
      -- a non-service mesh gateway, the nodes are always considered
      -- to be "first".
      run_on = typedefs.run_on_first
    },
    {
      -- this plugin will only run within Nginx HTTP module
      protocols = typedefs.protocols_http
    },
    {
      config = {
        type = "record",
        fields = {
          -- Describe your plugin's configuration's schema here.        
        },
      },
    },
  },
  entity_checks = {
    -- Describe your plugin's entity validation rules
  },
}
```

## Describing your configuration schema

The `config.fields` property of your `schema.lua` file describes the schema of your
plugin's configuration. It is a flexible array of field definitions where each field
is a valid configuration property for your plugin, describing the rules for that
property. For example:

```lua
{
  name = "<plugin-name>",
  fields = {
    config = {
      type = "record",
      fields = {
        {
          some_string = {
            type = "string",
            required = false,
          },
        },
        {
          some_boolean = {
            type = "boolean",
            default = false,
          },
        },
        {
          some_array = {
            type = "array",
            elements = {
              type = "string",
              one_of = {
                "GET",
                "POST",
                "PUT",
                "DELETE",
              },
            },
          },
        },
      },
    },
  },
}
```

Here is the list of some common (not all) accepted rules for a property (see the fields table above for examples):

| Rule               | Description
|--------------------|----------------------------
| `type`             | The type of a property.
| `required`         | Whether or not the property is required 
| `default`          | The default value for the property when not specified
| `elements`         | Field definition of `array` or `set` elements.
| `keys`             | Field definition of `map` keys.
| `values`           | Field definition of `map` values.
| `fields`           | Field definition(s) of `record` fields.

There are many more, but the above are commonly used.

You can also add field validators, to mention a few:

| Rule               | Description
|--------------------|----------------------------
| `between`          | Checks that the input number is between allowed values.
| `eq`               | Checks the equality of the input to allowed value.
| `ne`               | Checks the inequality of the input to allowed value.
| `gt`               | Checks that the number is greater than given value. 
| `len_eq`           | Checks that the input string length is equal to the given value. 
| `len_min`          | Checks that the input string length is at least the given value.
| `len_max`          | Checks that the input string length is at most the given value.
| `match`            | Checks that the input string matches the given Lua pattern.
| `not_match`        | Checks that the input string doesn't match the given Lua pattern.
| `match_all`        | Checks that the input string matches all the given Lua patterns.
| `match_none`       | Checks that the input string doesn't match any of the given Lua patterns.
| `match_any`        | Checks that the input string matches any of the given Lua patterns.
| `starts_with`      | Checks that the input string starts with a given value.
| `one_of`           | Checks that the input string is one of the accepted values.
| `contains`         | Checks that the input array contains the given value.
| `is_regex`         | Checks that the input string is a valid regex pattern.  
| `custom_validator` | A custom validation function written in Lua.

There are some additional validators, but you get a good idea how you can specify validation
rules on fields from the above table.

---

### Examples

This `schema.lua` file is for the [key-auth](/hub/kong-inc/key-auth/) plugin:

```lua
-- schema.lua
local typedefs = require "kong.db.schema.typedefs"


return {
  name = "key-auth",
  fields = {
    {
      consumer = typedefs.no_consumer
    },
    {
      run_on = typedefs.run_on_first
    },
    {
      protocols = typedefs.protocols_http
    },
    {
      config = {
        type = "record",
        fields = {
          {
            key_names = {
              type = "array",
              required = true,
              elements = typedefs.header_name,
              default = {
                "apikey",
              },
            },
          },
          {
            hide_credentials = {
              type = "boolean",
              default = false,
            },
          },
          {
            anonymous = {
              type = "string",
              uuid = true,
              legacy = true,
            },
          },
          {
            key_in_body = {
              type = "boolean",
              default = false,
            },
          },
          {
            run_on_preflight = {
              type = "boolean",
              default = true,
            },
          },
        },
      },
    },
  },
}
```

Hence, when implementing the `access()` function of your plugin in
[handler.lua]({{page.book.chapters.custom-logic}}) and given that the user
enabled the plugin with the default values, you'd have access to:

```lua
-- handler.lua
local BasePlugin = require "kong.plugins.base_plugin"


local kong = kong


local CustomHandler = BasePlugin:extend()


CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 10


function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end


function CustomHandler:access(config)
  CustomHandler.super.access(self)

  kong.log.inspect(config.key_names)        -- { "apikey" }
  kong.log.inspect(config.hide_credentials) -- false
end


return CustomHandler
```

Note that the above example uses the
[kong.log.inspect](/enterprise/{{page.kong_version}}/pdk/kong.log/#kong_log_inspect)
function of the [Plugin Development Kit] to print out those values to the Kong
logs.

---

A more complex example, which could be used for an eventual logging plugin:

```lua
-- schema.lua
local typedefs = require "kong.db.schema.typedefs"


return {
  name = "my-custom-plugin",
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            environment = {
              type = "string",
              required = true,
              one_of = {
                "production",
                "development",
              },
            },
          },
          {
            server = {
              type = "record",
              fields = {
                {
                  host = typedefs.host {
                    default = "example.com",
                  },
                },
                {
                  port = {
                    type = "number",
                    default = 80,
                    between = {
                      0,
                      65534
                    },
                  },
                },  
              },
            },
          },
        },
      },
    },
  },
}
```

Such a configuration will allow a user to post the configuration to your plugin
as follows:

```bash
$ curl -X POST http://kong:8001/services/<service-name-or-id>/plugins \
    -d "name=my-custom-plugin" \
    -d "config.environment=development" \
    -d "config.server.host=http://localhost"
```

And the following will be available in
[handler.lua]({{page.book.chapters.custom-logic}}):

```lua
-- handler.lua
local BasePlugin = require "kong.plugins.base_plugin"


local kong = kong


local CustomHandler = BasePlugin:extend()


CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 10


function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end

function CustomHandler:access(config)
  CustomHandler.super.access(self)

  kong.log.inspect(config.environment) -- "development"
  kong.log.inspect(config.server.host) -- "http://localhost"
  kong.log.inspect(config.server.port) -- 80
end


return CustomHandler
```

You can also see a real-world example of schema in [the Key-Auth plugin source code].

---

Next: [Accessing the Datastore &rsaquo;]({{page.book.next}})

[Admin API]: /enterprise/{{page.kong_version}}/admin-api
[Plugin Development Kit]: /enterprise/{{page.kong_version}}/pdk
[the Key-Auth plugin source code]: https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/schema.lua
