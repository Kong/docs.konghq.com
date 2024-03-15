---
title: Quick Start
book: plugin_dev
chapter: 2
---

The following instructions are written to help you quickly build, test, and run your first 
{{site.base_gateway}} custom plugin with [Lua](http://www.lua.org/). The remaining pages in 
this section will provide details on other advanced topics related to 
plugin development and best practices.

### Prerequisites

* [Docker](https://docs.docker.com/get-docker/) (or Docker equivalent) is used to run {{site.base_gateway}} and test code
* [curl](https://curl.se/) is used to download web resources. `curl` is pre-installed on most systems.
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is used to install and update software on the host machine.

1. **Initialize a new plugin repository**

    Start by opening a terminal and changing directories to a location where you store source code. 
    
    Create a new folder for the plugin and navigate into it:

    ```sh
    mkdir -p my-plugin && \
      cd my-plugin
    ```

    Next, create the plugin folder structure:

    {:.note}
    > **Important:** The specific tree structure and filenames shown in this guide are important to ensuring 
    > the development and execution of your plugin works properly with {{site.base_gateway}}. Do not
    > deviate from these names for this guide.

    ```sh
    mkdir -p kong/plugins/my-plugin && \
      mkdir -p spec/my-plugin
    ```

    Plugins are made up of [Lua modules](http://www.lua.org/manual/5.1/manual.html#5.3) defined in 
    individual files. 

    Start by creating empty `handler.lua` and `schema.lua` files, which are the minimum required modules
    for a functioning plugin:

    ```sh
    touch kong/plugins/my-plugin/handler.lua
    touch kong/plugins/my-plugin/schema.lua
    ```

    We now have the base structure for a new plugin, let's look at how to author code for these modules.

1. **Initialize the Schema module**

    The `schema.lua` file defines your plugins configuration data model. The following is the minimum structure 
    required for a valid plugin.

    Add the following code to the `schema.lua` file:

    ```lua
    local PLUGIN_NAME = "my-plugin"

    local schema = {
      name = PLUGIN_NAME,
      fields = {
        { config = {
            type = "record",
            fields = {
            },
          },
        },
      },
    }
    
    return schema
    ```
    
    This creates a base table for our plugin's configuration (which is empty).  Later in this guide we will add 
    configurable values to the table and show how to configure the plugin at runtime.

1. **Initialize the Handler module**
  
    The `handler.lua` module contains the core logic of your new plugin.
    Start by putting the following Lua code into the `handler.lua` file:

    ```lua
    local MyPluginHandler = {
        PRIORITY = 1000,
        VERSION = "0.0.1",
    }

    return MyPluginHandler
    ```

    This code defines a [Lua table](https://www.lua.org/pil/2.5.html) specifying a set of required 
    fields for a valid plugin:

    * The `PRIORITY` field sets the static 
    [execution order](/gateway/{{page.release}}/plugin-development/custom-logic/#plugins-execution-order) 
    of the plugin, which determines when this plugin is executed relative to other loaded plugins.
    * The `VERSION` field sets the version for this plugin and should follow the `major.minor.revision` format.
    
    At this point, we have a valid plugin (which does nothing). Next We will add logic to the plugin
    and then see how to validate it.

1. **Add handler logic**

    Plugin logic is defined to be executed at several key points in the lifecycle of
    HTTP requests, tcp streams, and {{site.base_gateway}} itself.

    Inside the `handler.lua` module, you will add 
    [functions](/gateway/{{page.release}}/plugin-development/custom-logic/#available-contexts)
    with well known names to the plugin table, indicating at what points the plugin logic should 
    be executed. 

    In this example we will add an `response` function, which is executed after a response has been
    received from an upstream service but before returning it to the client. 

    Let's add a header to the response prior to returning it to the client. Add the following 
    function implementation to the `handler.lua` file before the `return MyPluginHandler` statement:

    ```lua
    function MyPluginHandler:response(conf)
        kong.response.set_header("X-MyPlugin", "response")
    end
    ```

    The `kong.response` module provided in the 
    [Kong PDK](/gateway/{{page.release}}/plugin-development/pdk/), provides
    functions for manipulating the response sent back to the client. The code above sets 
    a new header on all responses with the name `X-MyPlugin` and value of `response`. 

    The full `handler.lua` file listing now looks like this:

    ```lua
    local MyPluginHandler = {
      PRIORITY = 1000,
      VERSION = "0.0.1",
    }

    function MyPluginHandler:response(conf)
        kong.response.set_header("X-MyPlugin", "response")
    end
 
    return MyPluginHandler
    ```

1. **Install Pongo**

    [Pongo](https://github.com/Kong/kong-pongo) is a tool to help you validate and 
    distribute custom plugins for {{site.base_gateway}}. Pongo uses Docker to
    bootstrap a {{site.base_gateway}} environment allowing you to quickly load your plugin, 
    run automated testing, and manually validate the plugin's behavior against
    various {{site.base_gateway}} versions.

    The following script can automate the installation of Pongo for you, however, if you prefer 
    you can follow the [manual installation instructions](https://github.com/Kong/kong-pongo?tab=readme-ov-file#installation)
    instead.
    
    If you already have Pongo intalled, you can skip to the next step or run the install script
    to update Pongo to the latest version.
   
    Run the following to install / update Pongo:

    ```sh
    curl -Ls https://get.konghq.com/pongo | bash
    ```

    For the remainder of this guide to work properly the `pongo` command must be present on your system
    path. The script and manual installation instructions above both include hints for
    putting `pongo` on your path. Ensure that the `pongo` command is 
    available on your `PATH` by running the command within our project directory:

    ```sh
    pongo help
    ```

    With Pongo installed, let's proceed to setup a test environment for our new plugin.

1. **Initialize the test environment**

    Pongo allows us to validate a plugin's behavior by giving us tools to quickly run a 
    {{site.base_gateway}} with our plugin installed and available. Let's validate the plugin 
    manually first then we will add automated tests in subsequent steps of this guide. 

    {:.note}
    > **Note**: {{site.base_gateway}} runs in a variety of
    > [deployment topologies](/gateway{{page.release}}/production/deployment-topologies). 
    > By default, Pongo runs {{site.base_gateway}} in _traditional mode_ which uses a database 
    > to store configured entities such as routes, services, and plugins. 
    > {{site.base_gateway}} and the database are ran in separate containers allowing us
    > to cycle the gateway independently of the database. This enables a quick
    > iterative approach to validating the plugin's logical behavior while keeping the gateway
    > state independent in the database.

    {:.important}
    > **Important:** These commands must be ran from the base `my-plugin` directory so Pongo properly 
    > packages and includes the plugin code in the running {{site.base_gateway}}.
   
    Pongo provides an optional command that will initialize the project directory with some
    default configuration files which can be ran one time when starting a new project.

    Initialize the project folder:

    ```sh
    pongo init
    ```

    Now we are ready to start dependency containers for {{site.base_gateway}}. By default
    this only includes the Postgres database used in traditional mode.

    Start the dependencies: 

    ```sh
    pongo up
    ```

    Once the dependencies are running successfully, we run a {{site.base_gateway}} container and open a 
    shell within it so we can interact with the gateway. Pongo runs a {{site.base_gateway}}
    container with various CLI tools pre-installed to help with testing.

    Launch the gateway and open shell with:

    ```sh
    pongo shell
    ```

    Your terminal is now running a shell _inside_ the {{site.base_gateway}} container. Your 
    shell prompt should change, showing you the gateway version, the host plugin directory, 
    and current path inside the container. An example prompt may look like the following.

    ```sh
    [Kong-3.6.1:my-plugin:/kong]$
    ```

    Pongo provides some aliases to assist with the lifecycle of {{site.base_gateway}} 
    and the database. On our first run, we need to initialize the database and start
    {{site.base_gateway}}. Pongo provides the `kms` alias to perform this common task for us.

    Run the database migrations and start {{site.base_gateway}}:

    ```sh
    kms
    ```

    You should see a success message that {{site.base_gateway}} has started, for example:

    ```sh
    ...
    64 migrations processed
    64 executed
    Database is up-to-date
    
    Kong started
    ```

    As mentioned previously, Pongo installs some development tools to help us test our plugin. 
    We can now validate our plugin is installed by querying the [Admin API](gateway/{{page.release}}/admin-api/)
    using `curl` and filtering the response with `jq`:

    ```sh
    curl -s localhost:8001 | \
      jq '.plugins.available_on_server."my-plugin"'
    ```

    You should see a response that matches the information we put in our plugin's table:

    ```sh
    {
      "priority": 1000,
      "version": "0.0.1"
    }
    ```

    With the test environment initialized lets see how to manually run our plugin code. 

1. **Manually test plugin**

    Our plugin is installed, let's configure {{site.base_gateway}} entities so we can invoke and validate 
    our plugins behavior.

    {:.note}
    > **Note**: For each of the following `POST` requests to the Admin API, you should receive
    > a `HTTP/1.1 201 Created` response from {{site.base_gateway}} indicating successful creation of the entity.

    Still within the {{site.base_gateway}} container's shell, add a new service with the following:

    ```sh
    curl -i -s -X POST http://localhost:8001/services \
        --data name=example_service \
        --data url='http://httpbin.org'
    ```

    Associate our custom plugin with the `example_service` service:

    ```sh
    curl -is -X POST http://localhost:8001/services/example_service/plugins \
        --data 'name=my-plugin'
    ```

    Add a new route so we can send requests through the `example_service`:

    ```sh
    curl -i -X POST http://localhost:8001/services/example_service/routes \
        --data 'paths[]=/mock' \
        --data name=example_route
    ```

    Our plugin is now configured to be invoked when {{site.base_gateway}} proxies
    requests via the `example_service`. Prior to forwarding the response from the 
    upstream, our plugin should append the `X-MyPlugin` header to the list of response headers.

    Let's test the behavior by proxying a request and asking `curl` to show the 
    response headers with the `-i` flag:

    ```sh
    curl -i http://localhost:8000/mock/anything
    ```

    `curl` should report `HTTP/1.1 200 OK` and show us the response headers from the gateway. Included
    in the set of headers, should be `X-MyPlugin: response`, indicating that our plugin logic has been invoked.

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
    nicely. However, you will prefer to deploy automated testing and maybe a Test-driven development 
    (TDD) methodology. Let's see how Pongo can help with this as well.

1. **Write a test**

    Pongo supports running automated tests using the 
    [Busted](https://lunarmodules.github.io/busted/) Lua test framework. In plugin
    projects, the test files reside under the `spec/<plugin-name>` directory. For this project
    we created the `spec/my-plugin` folder earlier.  
     
    The following is a code listing for a test that validates our plugin's current behavior. 
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

          it("gets a 'X-MyPlugin' header", function()

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

    We now have test code, let's see how Pongo can help us automate testing.

1. **Run the test**

    Pongo can run automated tests for us with the `pongo run` command. When this is executed,
    Pongo will determine if dependency containers are already running and use them
    if so. The test library will handle truncating existing data in between test runs for us.

    Once the test file from the previous step is saved in the `spec/my-plugin/01-integration_spec.lua` file, 
    execute a test run:

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

    Pongo can also run as part of a Continuous Integration (CI) system, the 
    [repository documentation](https://github.com/Kong/kong-pongo?tab=readme-ov-file#setting-up-ci) has more details. 

    Next, let's see how we can modify the behavior of our plugin with configuration data.


1. **Make `my-plugin` configurable**

    Plugins are not typically as simplistic as our current example. You will likley wish
    to control the behavior of your plugin using configurable values. Plugin
    configuration is controlled by the `schema.lua` file.  Let's add some configuration values to our
    plugin and use them to make the plugin behavior configurable.

    Update the schema.lua file, include defaults

    Here is what a typical field definition in a plugin configuraiton schema looks like:

    ```lua
     { request_header = typedefs.header_name {
              required = true,
              default = "Hello-World" } },
    ```

    https://docs.konghq.com/gateway/latest/plugin-development/configuration/#schemalua-specifications

<!-- 
# 1. **
# 
# 1. Package the plugin
# 
#     blah
# 
# 1. Deploy the plugin
# 
#     blah
-->
