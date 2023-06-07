---
nav_title: # Set a title for the navigation menu
---

## How it works

<!--How does your plugin work? -->

## How to install

<!-- If your plugin can be installed via luarocks, change {YOUR_PLUGIN_NAME} to your own plugin, e.g. example-plugin.
If the plugin is an integration in your catalog, or is installed in some other way, replace the following instructions with your own. -->

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the LuaRocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the `rock` in your LuaRocks tree, that is, the directory in which LuaRocks installs Lua modules.

1. Install the {YOUR_PLUGIN_NAME} plugin:

    ```sh
    luarocks install {YOUR_PLUGIN_NAME}
    ```

2. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `{YOUR_PLUGIN_NAME}` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,{YOUR_PLUGIN_NAME}    # Comma-separated list of plugins this node
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

