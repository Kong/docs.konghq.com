---
title: Add Plugin Configuration
book: plugin_dev_getstarted
chapter: 4
---

The following is a step by step guide for adding configuration to custom plugins on {{site.base_gateway}}.

## Prerequisites

This page is the third chapter in the [Getting Started](/gateway/{{page.release}}/plugin-development/get-started/index) 
guide for developing custom plugins. These instructions refer to the previous chapters in the guide and require the same
developer tool prerequisites.

## Step by Step

Now that you have a basic plugin project with testing, the following steps guide you through adding
configuration capabilities to the plugin code.

### Add configuration fields to the schema 

Let's add some configuration fields to our `schema.lua` file allowing us to 
make the plugin behavior configurable without having to redeploy or restart.

{{site.base_gateway}} provides a module of 
base [type definitions](https://github.com/Kong/kong/blob/master/kong/db/schema/typedefs.lua) that can
help us with common types related to API gateway plugins. 

At the top of the `schema.lua` file we include the {{site.base_gateway}} 
`typedefs` module with the statement:

```lua
local typedefs = require "kong.db.schema.typedefs"
```

Below is a Lua snippet showing a typical 
[configuration field](/gateway/{{page.release}}/plugin-development/configuration/#describing-your-configuration-schema)
that defines a field named `response_header_name`. 

Here we use the `header_name` type definition which defines the field to be a string that cannot be null and 
conforms to the gateway rules for header names.

```lua
 { response_header_name = typedefs.header_name {
     required = false,
     default = "X-MyPlugin" } },
```

The definition also indicates that the configuration value is *not* required, which means
it's optional for the user when configuring the plugin. We also specify a 
default value that will be used when a user does not specify a value.

Place this definition in the `schema.lua` file within the `fields` array we defined earlier. 

The full `schema.lua` now looks like the following:

```lua
local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "my-plugin"

local schema = {
  name = PLUGIN_NAME,
  fields = {
    { config = {
        type = "record",
        fields = {
          { response_header_name = typedefs.header_name {
            required = false,
            default = "X-MyPlugin" } },
        },
      },
    },
  },
}

return schema
```

Now the plugin can accept a configuration value, let's see how to read it from the
plugin logic code.

### Read configuration values from plugin code 

Modify the `handler.lua` file `response` function to read the configuration value from the incoming
`conf` parameter instead of the current hardcoded value.

The function now looks like the following:

```lua
function MyPluginHandler:response(conf)
    kong.response.set_header(conf.response_header_name, "response")
end
```

That's all that's required, the plugin can now be dynamically configured at runtime. Next, 
let's validate our changes work as expected with manual and automated tests.

### Manually validate configuration

In the [previous chapter on testing](/gateway/{{page.release}}/plugin-development/get-started/testing#3-manually-test-plugin)
we showed how to use Pongo to run a shell and manually validate the plugins behavior. Repeat that process here 
to validate the plugins new configurable behavior.

Launch the gateway and open a shell:

```sh
pongo shell
```

From within the shell, run the database migrations and start {{site.base_gateway}}:

```sh
kms
```

Add a test service:

```sh
curl -i -s -X POST http://localhost:8001/services \
   --data name=example_service \
   --data url='https://httpbin.konghq.com'
```

And create our plugin instance, but this time provide the configuration value
as data in the `POST` request to the Admin API:


```sh
curl -is -X POST http://localhost:8001/services/example_service/plugins \
    --data 'name=my-plugin' --data 'config.response_header_name=X-CustomHeaderName'
```

Add a route so we can send test requests:

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
   --data 'paths[]=/mock' \
   --data name=example_route
```

And proxy a request through our test route:
```sh
curl -i http://localhost:8000/mock/anything
```

This time we should see our configured header in the response:

```sh
...
[X-CustomHeaderName] = 'response'
...
```

Now that `my-plugin` is configurable and we've validate the behavior, let's look at how we can 
build an automated approach to validate our changes.

### Add automated configuration testing

Without changing anything we can re-run the tests we already have with `pongo run`:

```sh
pongo run
```

Our tests should continue to report successful:

```sh
[  PASSED  ] 2 tests.
```

Our test is still valid because the default value in our configurable field matches the value
in our test case. Let's see how we can validate a different value for the `response_header_name` field.

Modify the `setup` function inside the `spec/01-integration_spec.lua` module so that the `my-plugin` that is
added to the database is configured with a different value for the `response_header_name` field.

Here is the code:

```lua
-- Add the custom plugin to the test route
blue_print.plugins:insert {
  name = PLUGIN_NAME,
  route = { id = test_route.id },
  config = {
    response_header_name = "X-CustomHeaderName",
  },
}
```

Use Pongo to re-run the test:

```sh
pongo run
```

If we've changed everything properly, our tests should fail and produce a report similar to the following:

```sh
/kong-plugin/spec/my-plugin/01-integration_spec.lua:75: Expected header:
(string) 'X-MyPlugin'
But it was not found in:
(table: 0x484c9942b180) {
  [Connection] = 'keep-alive'
  [Content-Length] = '1016'
  [Content-Type] = 'application/json'
  [Date] = 'Mon, 18 Mar 2024 13:49:06 GMT'
  [Server] = 'mock-upstream/1.0.0'
  [Via] = 'kong/{{page.release}}'
  [X-CustomHeaderName] = 'response'
  [X-Kong-Proxy-Latency] = '1'
  [X-Kong-Request-Id] = '92dfcf56b12b0d29f54ed9295aed6356'
  [X-Kong-Upstream-Latency] = '2'
  [X-Powered-By] = 'mock_upstream' }
stack traceback:
        /kong-plugin/spec/my-plugin/01-integration_spec.lua:75: in function </kong-plugin/spec/my-plugin/01-integration_spec.lua:66>
[  FAILED  ] /kong-plugin/spec/my-plugin/01-integration_spec.lua:66: my-plugin: [#postgres] The response gets a 'X-MyPlugin' header (4.58 ms)
```

The tests fail because while we updated the plugin configuration, we did not update the expected header name in the test case. To fix 
the tests, modify the test assertion to match our configured header name.

Change this line:

```lua
local header_value = assert.response(r).has.header("X-MyPlugin")
```

To expect the new configured header name:

```lua
local header_value = assert.response(r).has.header("X-CustomHeaderName")
```

When you re-run the tests:

```sh
pongo run
```

Pongo should report a successful test run:

```sh
[  PASSED  ] 2 tests.
```

## What's next?

You now have a complete development environment and a framework for adding capabilities to your custom
plugin. Next we'll show you how to connect to external services from within your plugin code and
later show you how to deploy your plugin onto your {{site.base_gateway}} dataplanes so you can
put your business logic into production.
