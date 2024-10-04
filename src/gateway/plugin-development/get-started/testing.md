---
title: Add Plugin Testing
book: plugin_dev_getstarted
chapter: 3
---

The following is a guide for setting up a testing environment for {{site.base_gateway}} 
custom plugins. 

## Prerequisites

This page is the second chapter in the [Getting Started](/gateway/{{page.release}}/plugin-development/get-started/index)
guide for developing custom plugins. These instructions refer to the previous chapter in the guide and require the same
developer tool prerequisites.

## Step by step

Now that you have a basic plugin project, you can build testing automations for it.

### Install Pongo

[Pongo](https://github.com/Kong/kong-pongo) is a tool that helps you validate and 
distribute custom plugins for {{site.base_gateway}}. Pongo uses Docker to
bootstrap a {{site.base_gateway}} environment allowing you to quickly load your plugin, 
run automated testing, and manually validate the plugin's behavior against
various {{site.base_gateway}} versions.

The following script can automate the installation of Pongo for you. 
If you prefer, you can follow the [manual installation instructions](https://github.com/Kong/kong-pongo?tab=readme-ov-file#installation)
instead.

If you already have Pongo installed, you can skip to the [next step](#initialize-the-plugin-environment) or run the install script
to update Pongo to the latest version.

Run the following to install or update Pongo:

```sh
curl -Ls https://get.konghq.com/pongo | bash
```

For the remainder of this guide to work properly, the `pongo` command must be present in your system
path. The script and manual installation instructions above both include hints for
putting `pongo` on your path. 

Ensure that the `pongo` command is 
available in your `PATH` by running the command within your project directory:

```sh
pongo help
```

With Pongo installed, you can now set up a test environment for your new plugin.

### Initialize the test environment

Pongo lets you validate a plugin's behavior by giving you tools to quickly run a 
{{site.base_gateway}} with the plugin installed and available. 

Let's validate the plugin 
manually first, and then you will add automated tests in subsequent steps of this guide. 

{:.note}
> **Note**: {{site.base_gateway}} runs in a variety of
> [deployment topologies](/gateway/{{page.release}}/production/deployment-topologies). 
> By default, Pongo runs {{site.base_gateway}} in _traditional mode_, which uses a database 
> to store configured entities such as routes, services, and plugins. 
> {{site.base_gateway}} and the database are run in separate containers,
> letting you cycle the gateway independently of the database. This enables a quick and 
> iterative approach to validating the plugin's logical behavior while keeping the gateway
> state independent in the database.

Pongo provides an optional command that initializes the project directory with some
default configuration files. You can run it to start a new project.

{:.important}
> **Important:** These commands must be run inside the `my-plugin` project root directory so that Pongo properly 
> packages and includes the plugin code in the running {{site.base_gateway}}.

Initialize the project folder:

```sh
pongo init
```

Now you can start dependency containers for {{site.base_gateway}}. 
By default, this only includes the Postgres database used in traditional mode.

Start the dependencies: 

```sh
pongo up
```

Once the dependencies are running successfully, you can run a {{site.base_gateway}} container and open a 
shell within it to interact with the gateway. Pongo runs a {{site.base_gateway}}
container with various CLI tools pre-installed to help with testing.

Launch the gateway and open a shell with:

```sh
pongo shell
```

Your terminal is now running a shell _inside_ the {{site.base_gateway}} container. Your 
shell prompt should change, showing you the gateway version, the host plugin directory, 
and current path inside the container. For example, your prompt may look like the following:

```sh
[Kong-3.6.1:my-plugin:/kong]$
```

Pongo provides some aliases to assist with the lifecycle of {{site.base_gateway}} 
and the database. On its first run, you need to initialize the database and start
{{site.base_gateway}}. Pongo provides the `kms` alias to perform this common task.

Run the database migrations and start {{site.base_gateway}}:

```sh
kms
```

You should see a success message that {{site.base_gateway}} has started:

```sh
...
64 migrations processed
64 executed
Database is up-to-date

Kong started
```

As mentioned previously, Pongo installs some development tools to help us test your plugin.
You can now validate that the plugin is installed by querying the [Admin API](/gateway/{{page.release}}/admin-api/)
using `curl` and filtering the response with `jq`:

```sh
curl -s localhost:8001 | \
  jq '.plugins.available_on_server."my-plugin"'
```

You should see a response that matches the information in the plugin's table:

```json
{
  "priority": 1000,
  "version": "0.0.1"
}
```

With the test environment initialized, you can now manually run the plugin code. 

### Manually test plugin

With the plugin installed, you can now configure {{site.base_gateway}} entities to invoke and validate the plugin's behavior.

{:.note}
> **Note**: For each of the following `POST` requests to the Admin API, you should receive
> a `HTTP/1.1 201 Created` response from {{site.base_gateway}} indicating the successful creation of the entity.

Still within the {{site.base_gateway}} container's shell, add a new service with the following:

```sh
curl -i -s -X POST http://localhost:8001/services \
    --data name=example_service \
    --data url='https://httpbin.konghq.com'
```

Associate the custom plugin with the `example_service` service:

```sh
curl -is -X POST http://localhost:8001/services/example_service/plugins \
    --data 'name=my-plugin'
```
    
Add a new route for sending requests through the `example_service`:

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
    --data 'paths[]=/mock' \
    --data name=example_route
```

The plugin is now configured and will be invoked when {{site.base_gateway}} proxies
requests via the `example_service`. 
Prior to forwarding the response from the 
upstream, the plugin should append the `X-MyPlugin` header to the list of response headers.

Test the behavior by proxying a request and asking `curl` to show the 
response headers with the `-i` flag:

```sh
curl -i http://localhost:8000/mock/anything
```

`curl` should report `HTTP/1.1 200 OK` and show the response headers from the gateway. 
You should see `X-MyPlugin: response` in the set of headers, indicating that the plugin's logic has been invoked.

For example: 

```sh
HTTP/1.1 200 OK
Content-Type: application/json
Connection: keep-alive
Content-Length: 529
Access-Control-Allow-Credentials: true
Date: Tue, 12 Mar 2024 14:44:22 GMT
Access-Control-Allow-Origin: *
Server: gunicorn/19.9.0
X-MyPlugin: response
X-Kong-Upstream-Latency: 97
X-Kong-Proxy-Latency: 1
Via: kong/3.6.1
X-Kong-Request-Id: 8ab8c32c4782536592994514b6dadf55
```

Exit the {{site.base_gateway}} shell before proceeding:

```sh
exit
```

For quickly getting started, manually validating a plugin using the Pongo shell works
nicely. For production scenarios, you will likely want to deploy automated testing 
and maybe a test-driven development (TDD) methodology. 
Let's see how Pongo can help with this as well.

### Write a test

Pongo supports running automated tests using the 
[Busted](https://lunarmodules.github.io/busted/) Lua test framework. In plugin
projects, the test files reside under the `spec/<plugin-name>` directory. 
For this project, this is the `spec/my-plugin` folder you created earlier.  
 
The following is a code listing for a test that validates the plugin's current behavior. 
Copy this code and place it into a new file located at `spec/my-plugin/01-integration_spec.lua`. 
See the code comments for details on the design of the test and the test helpers provided by 
{{site.base_gateway}}.

```lua
-- Helper functions provided by Kong Gateway, see https://github.com/Kong/kong/blob/master/spec/helpers.lua
local helpers = require "spec.helpers"

-- matches our plugin name defined in the plugins's schema.lua
local PLUGIN_NAME = "my-plugin"

-- Run the tests for each strategy. Strategies include "postgres" and "off"
--   which represent the deployment topologies for Kong Gateway
for _, strategy in helpers.all_strategies() do

  describe(PLUGIN_NAME .. ": [#" .. strategy .. "]", function()
    -- Will be initialized before_each nested test
    local client

    setup(function()

      -- A BluePrint gives us a helpful database wrapper to
      --    manage Kong Gateway entities directly.
      -- This function also truncates any existing data in an existing db.
      -- The custom plugin name is provided to this function so it mark as loaded
      local blue_print = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })

      -- Using the BluePrint to create a test route, automatically attaches it
      --    to the default "echo" service that will be created by the test framework
      local test_route = blue_print.routes:insert({
        paths = { "/mock" },
      })

      -- Add the custom plugin to the test route
      blue_print.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = test_route.id },
      }

      -- start kong
      assert(helpers.start_kong({
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,
      }))

    end)

    -- teardown runs after its parent describe block
    teardown(function()
      helpers.stop_kong(nil, true)
    end)

    -- before_each runs before each child describe
    before_each(function()
      client = helpers.proxy_client()
    end)

    -- after_each runs after each child describe
    after_each(function()
      if client then client:close() end
    end)

    -- a nested describe defines an actual test on the plugin behavior
    describe("The response", function()

      it("gets the expected header", function()

        -- invoke a test request
        local r = client:get("/mock/anything", {})

        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)

        -- now validate and retrieve the expected response header 
        local header_value = assert.response(r).has.header("X-MyPlugin")

        -- validate the value of that header
        assert.equal("response", header_value)

      end)
    end)
  end)
end
```

With this test code, Pongo can help automate testing.

### Run the test

Pongo can run automated tests with the `pongo run` command. When this is executed,
Pongo determines if dependency containers are already running and will use them
if they are. The test library handles truncating existing data in between test runs for us.

Execute a test run:

```sh
pongo run
```

You should see a successful report that looks similar to the following:

```sh
[pongo-INFO] auto-starting the test environment, use the 'pongo down' action to stop it
Kong version: 3.6.1

[==========] Running tests from scanned files.
[----------] Global test environment setup.
[----------] Running tests from /kong-plugin/spec/my-plugin/01-integration_spec.lua
[----------] Running tests from /kong-plugin/spec/my-plugin/01-integration_spec.lua
[ RUN      ] /kong-plugin/spec/my-plugin/01-integration_spec.lua:63: my-plugin: [#postgres] The response gets a 'X-MyPlugin' header
[       OK ] /kong-plugin/spec/my-plugin/01-integration_spec.lua:63: my-plugin: [#postgres] The response gets a 'X-MyPlugin' header (6.59 ms)
[ RUN      ] /kong-plugin/spec/my-plugin/01-integration_spec.lua:63: my-plugin: [#off] The response gets a 'X-MyPlugin' header
[       OK ] /kong-plugin/spec/my-plugin/01-integration_spec.lua:63: my-plugin: [#off] The response gets a 'X-MyPlugin' header (4.76 ms)
[----------] 2 tests from /kong-plugin/spec/my-plugin/01-integration_spec.lua (23022.12 ms total)

[----------] Global test environment teardown.
[==========] 2 tests from 1 test file ran. (23022.80 ms total)
[  PASSED  ] 2 tests.
```

Pongo can also run as part of a Continuous Integration (CI) system. See the 
[repository documentation](https://github.com/Kong/kong-pongo?tab=readme-ov-file#setting-up-ci) for more details. 

## What's next?

With the project setup and automated testing in place, the next chapter will walk you through adding 
configurable values to the plugin.
