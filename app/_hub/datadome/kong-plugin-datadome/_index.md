The DataDome plugin is developed in Lua and integrates smoothly with Kong.

This plugin relies on the DataDome Bot & Fraud Protection Platform to validate if any incoming API request is legitimate or coming from a bot.
The only requirement to configure it is your DataDome server-side key.


## How it works

The DataDome plugin will hook into every API request from a client, and it will run before they are proxied to the upstream on the access phase (see details [here](https://openresty-reference.readthedocs.io/en/latest/Directives/)).

## How to install

Custom plugins can be installed via LuaRocks. A Lua plugin is distributed in `.rock` format, which is
a self-contained package that can be installed locally or from a remote server.

If you used one of the official {{site.base_gateway}} installation packages, the LuaRocks utility
should already be installed in your system.
Install the `.rock` in your LuaRocks tree, that is, the directory in which LuaRocks
installs Lua modules.

1. Install the DataDome plugin:

    ```sh
    luarocks install kong-plugin-datadome
    ```

2. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `datadome` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,datadome              # Comma-separated list of plugins this node
                                            # should load. By default, only plugins
                                            # bundled in official distributions are
                                            # loaded via the `bundled` keyword.
    ```

3. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

## Using the plugin

First of all, make sure you have your DataDome server-side key. It is available inside your dashboard in the [Integrations](https://app.datadome.co/dashboard/management/integrations) section.

### {{site.base_gateway}}

If you already configured an API, execute the command below after replacing `<YOUR_API>` with the name of your API and `<server_side_key>` with your DataDome server-side key.

```shell
curl -i -X POST http://localhost:8001/services/<YOUR_API>/plugins \
     -F "name=datadome" \
     -F "config.datadome_server_side_key=<server_side_key>"
```

### {{site.konnect_product_name}}

- Depending on where you want to enable DataDome, select `Plugins`
- Click on `+ New Plugin`
- On `Custom Plugins`, select `DataDome`
- Fill the *DataDome Server Side Key* field
- Hit `Save`

For further information, please check our [DataDome Kong documentation page](https://docs.datadome.co/docs/kong-plugin).
