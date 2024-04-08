---
title: Setup a Plugin Project
book: plugin_dev_getstarted
chapter: 2
---

The following instructions are written to help you quickly build, test, and run your first 
{{site.base_gateway}} custom plugin with [Lua](http://www.lua.org/). The remaining pages in 
this section will provide details on other advanced topics related to 
plugin development and best practices.

## Prerequisites

The following development tools are required to complete this guide. 

* [Docker](https://docs.docker.com/get-docker/) (or Docker equivalent) is used to run {{site.base_gateway}} and test code
* [curl](https://curl.se/) is used to download web resources. `curl` is pre-installed on most systems.
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is used to install and update software on the host machine.

## Step by Step

In this chapter we start by creating a bare-bones {{site.base_gateway}} custom plugin project. You'll
create the necessary folders and files and then author a short amount of Lua code to create a 
basic functioning plugin.

### 1. Initialize a new plugin repository

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

### 2. Initialize the Schema module

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
 configurable values to the table and show how to configure the plugin at runtime. Next, let's begin to 
 add the handler code for the plugin.

### 3. Initialize the Handler module

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

### 4. Add handler logic

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

## What's next?

At this stage, you now have a functional plugin for {{site.base_gateway}}. 
However, a development project is incomplete without testing. In the following chapter, 
we will guide you on how to install testing tools and create automated testing routines.
