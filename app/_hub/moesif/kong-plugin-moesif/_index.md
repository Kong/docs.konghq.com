### How it works

When enabled, this plugin captures API traffic and logs it to
[Moesif API Analytics](https://www.moesif.com/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong). 
This plugin logs to Moesif with an [asynchronous design](https://www.moesif.com/enterprise/api-analytics-infrastructure?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong) and doesn't add any latency to your API calls.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

Moesif natively supports REST, GraphQL, Web3, SOAP, JSON-RPC, and more.

## How to install

> If you are using Kong's [Kubernetes Ingress Controller](https://github.com/Kong/kubernetes-ingress-controller), the installation is slightly different. Review the [docs for Kubernetes Ingress](https://www.moesif.com/docs/server-integration/kong-ingress-controller/).

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the LuaRocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

### Install the Moesif plugin

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```

### Update your loaded plugins list
In your `kong.conf`, append `moesif` to the `plugins` field (or `custom_plugins` if old version of Kong). Make sure the field is not commented out.

```yaml
plugins = bundled,moesif         # Comma-separated list of plugins this node
                                 # should load. By default, only plugins
                                 # bundled in official distributions are
                                 # loaded via the `bundled` keyword.
```

If you don't have a `kong.conf`, create one from the default using the following command: 
`cp /etc/kong/kong.conf.default /etc/kong/kong.conf`

### Restart Kong

After LuaRocks is installed, restart Kong before enabling the plugin

```shell
kong restart
```

### Enable the Moesif plugin

```shell
curl -i -X POST --url http://localhost:8001/plugins/ --data "name=moesif" --data "config.application_id=YOUR_APPLICATION_ID";
```

### Restart Kong again

If you don't see any logs in Moesif, you may need to restart Kong again. 

```shell
kong restart
```
