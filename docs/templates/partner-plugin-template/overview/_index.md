---
nav_title: Overview
title: Overview
---

<!-- 
Introduce your plugin with a long description. What does it do, and why would someone want to use it? 

For example: 

    Use the Mocking plugin to provide mock endpoints to test your APIs in development against your services.
    The plugin leverages standards based on the Open API Specification (OAS)
    for sending out mock responses to APIs. Mocking supports both Swagger 2.0 and OpenAPI 3.0.

    Benefits of service mocking with the Kong Mocking plugin:

    - Conforms to a design-first approach since mock responses are within OAS.
    - Accelerates development of services and APIs.
-->

## How it works

<!--How does your plugin work? -->

## How to install

<!-- If your plugin can be installed via luarocks, change {YOUR_PLUGIN_NAME} to your own plugin, e.g. example-plugin.
If the plugin is an integration in your catalog, or is installed in some other way, replace the following instructions with your own. -->

Custom plugins can be installed via LuaRocks. A Lua plugin is distributed in `.rock` format, which is 
a self-contained package that can be installed locally or from a remote server.

If you used one of the official {{site.base_gateway}} installation packages, the LuaRocks utility 
should already be installed in your system.
Install the `.rock` in your LuaRocks tree, that is, the directory in which LuaRocks 
installs Lua modules. 

1. Install the <REPLACE_ME_WITH_PLUGIN_NAME> plugin:

    ```sh
    luarocks install <REPLACE_ME_WITH_PLUGIN_NAME>
    ```

2. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `<REPLACE_ME_WITH_PLUGIN_NAME>` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,<REPLACE_ME_WITH_PLUGIN_NAME>    # Comma-separated list of plugins this node
                                            # should load. By default, only plugins
                                            # bundled in official distributions are
                                            # loaded via the `bundled` keyword.
    ```

3. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

## Using the plugin

<!-- Describe how to configure and use your plugin -->

