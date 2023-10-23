---
title: Custom Plugins
type: explanation
purpose: |
  How to use Custom Plugins with KIC
---

Install a custom plugin in Kong without using a Docker build.

## Create a custom plugin

1. Create a directory with test plugin code.

   {:.note}
   > If you already have a real plugin, you can skip this step.

    ```bash
    $ mkdir myheader
    $ echo 'local MyHeader = {}

    MyHeader.PRIORITY = 1000
    MyHeader.VERSION = "1.0.0"

    function MyHeader:header_filter(conf)
      -- do custom logic here
      kong.response.set_header("myheader", conf.header_value)
    end

    return MyHeader
    ' > myheader/handler.lua
    
    $ echo 'return {
      name = "myheader",
      fields = {
        { config = {
            type = "record",
            fields = {
              { header_value = { type = "string", default = "roar", }, },
            },
        }, },
      }
    }
    ' > myheader/schema.lua
    ```

   After your plugin code available in a directory, the directory should look like this:

    ```bash
    $ tree myheader
    myheader
    ├── handler.lua
    └── schema.lua

    0 directories, 2 files
    ```

1. Create a ConfigMap or Secret with the plugin code. If you're not sure which option is correct, use a `ConfigMap`.

    If you would like to install a plugin which is available as a rock from Luarocks, then you need to download it, unzip it and create a ConfigMap or secret from all the Lua files of the plugin.

{% capture the_code %}
{% navtabs codeblock %}
{% navtab ConfigMap %}
```bash
$ kubectl create configmap kong-plugin-myheader --from-file=myheader -n kong
```
{% endnavtab %}

{% navtab Secret %}
```bash
$ kubectl create secret generic -n kong kong-plugin-myheader --from-file=myheader
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:
{% capture the_code %}
{% navtabs codeblock %}
{% navtab ConfigMap %}
```text
configmap/kong-plugin-myheader created
```
{% endnavtab %}

{% navtab Secret %}
```text
secret/kong-plugin-myheader created
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

## Deploying custom plugins

### Helm

The easiest way to use custom plugins with Kong is via the Helm chart. The chart automatically configures all the environment variables based on the plugins you inject.

1. Create a `values.yaml` file with the following contents. Ensure that you add in other configuration values you might need for your installation to be successful.

{% capture the_code %}
{% navtabs codeblock %}
{% navtab ConfigMap %}
```yaml
gateway:
  plugins:
    configMaps:
    - name: kong-plugin-myheader
      pluginName: myheader
```
{% endnavtab %}

{% navtab Secret %}
```yaml
gateway:
  plugins:
    secrets:
    - name: kong-plugin-myheader
      pluginName: myheader
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

2. Install {{site.kic_product_name}}.
    ```
    helm repo add kong https://charts.konghq.com
    helm repo update
    helm install kong kong/ingress -n kong --create-namespace --values values.yaml
    ```

### Non-Helm

{:.note}
> The following examples assume that you have a deployment named `proxy-kong`. Change this to the name of your deployment as needed.

1. Modify configuration to update Kong's Deployment to load the custom plugin.

   The following patch is necessary to load the plugin.
   - The plugin code is mounted into the pod via `volumeMounts` and `volumes` configuration property.
   - `KONG_PLUGINS` environment variable is set to include the custom plugin along with all the plugins that come in Kong by default.
   - `KONG_LUA_PACKAGE_PATH` environment variable directs Kong to look for plugins in the directory where we are mounting them.

   If you have multiple plugins, mount multiple ConfigMaps and include the plugin name in the `KONG_PLUGINS` environment variable.

  {:.important}
   > Note that if your plugin code involves database migration then you need to include the following patch to pod definition of your migration Job as well.
   This is not a complete definition of the Deployment but a strategic patch which can be applied to an existing Deployment.

   ```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: proxy-kong
  namespace: kong
spec:
  template:
    spec:
      containers:
      - name: proxy
        env:
        - name: KONG_PLUGINS
          value: bundled,myheader
        - name: KONG_LUA_PACKAGE_PATH
          value: "/opt/?.lua;;"
        volumeMounts:
        - name: kong-plugin-myheader
          mountPath: /opt/kong/plugins/myheader
      volumes:
      - name: kong-plugin-myheader
        configMap:
          name: kong-plugin-myheader
```

## Using custom plugins

1. After you have setup Kong with the custom plugin installed, you can use it like any other plugin. Create a KongPlugin custom resource:

    ```yaml
   echo '
   apiVersion: configuration.konghq.com/v1
   kind: KongPlugin
   metadata:
     name: my-custom-plugin
   config:
     header_value: "my first plugin"
   plugin: myheader
   ' | kubectl apply -f -
   ```

1. Add the `konghq.com/plugins` annotation to your Service, Ingress or Gateway API route to instruct Kong to execute the plugin:

   ```yaml
   konghq.com/plugins: my-custom-plugin
   ```

## Plugins in other languages

When deploying custom plugins in other languages, especially Golang, the built binary is larger than
the size limit of ConfigMap. In such cases, consider using an init container to pull large binaries from
remotes like S3 buckets, or build a custom image that includes plugin runtimes and the plugin itself.

To read more about building a custom image, see
[use external plugins in container and Kubernetes](/gateway/latest/reference/external-plugins/#use-external-plugins-in-container-and-kubernetes).
