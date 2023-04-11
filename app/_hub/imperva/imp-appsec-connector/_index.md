## How it works
The plugin sends a copy of API call requests/responses to the Imperva API receiver. The receiver service destination address and port are specified as config parameters. Additional parameters are used to control how the API captures are sent. 

## How to install

{:.note}
> If you are using Kong's [Kubernetes Ingress Controller](https://github.com/Kong/kubernetes-ingress-controller), the installation is slightly different. Review the [docs for Kubernetes Ingress](/kubernetes-ingress-controller/latest/guides/setting-up-custom-plugins/).

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the LuaRocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the `rock` in your LuaRocks tree, that is, the directory in which LuaRocks installs Lua modules.

### Install the Imperva Plugin

```shell
 luarocks install imp-appsec-connector
```

### Update your loaded plugins list
In your `kong.conf`, append `imp-appsec-connector` to the `plugins` field. Make sure the field is not commented out.

```yaml
plugins = bundled,imp-appsec-connector         # Comma-separated list of plugins this node
                                	       # should load. By default, only plugins
                                               # bundled in official distributions are
                                               # loaded via the `bundled` keyword.
```


### Restart Kong

After LuaRocks is installed, restart Kong before enabling the plugin:

```shell
kong restart
```

## Changelog

**imp-appsec-connector 0.1.1**

* Introduced the Imperva API Security plugin. 
This plugin is compatible with {{site.base_gateway}} 3.0.x and 3.2.x at release time.


