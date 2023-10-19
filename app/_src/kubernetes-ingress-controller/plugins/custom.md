---
title: Custom Plugins
type: explanation
purpose: |
  How to use Custom Plugins with KIC
---

Install a custom plugin in Kong without using a Docker build.

## Install and configure custom plugin

1. Create a directory with test plugin code.
   {:.note}
   > If you already have a real plugin, you can skip this step.

   Create either a ConfigMap or a Secret with the plugin code inside it. If you would like to install a plugin which is available as a rock from Luarocks, then you need to download it, unzip it and create a ConfigMap from all the Lua files of the plugin.

    ```bash
    $ mkdir myheader && cd myheader
    $ echo 'local MyHeader = {}

    MyHeader.PRIORITY = 1000
    MyHeader.VERSION = "1.0.0"

    function MyHeader:header_filter(conf)
      -- do custom logic here
      kong.response.set_header("myheader", conf.header_value)
    end

    return MyHeader
    ' > handler.lua
    
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
    ' > schema.lua
    ```

   After your plugin code available in a directory, the directory should look like this:

    ```bash
    $ tree myheader
    myheader
    ├── handler.lua
    └── schema.lua

    0 directories, 2 files
    ```
1. Install {{site.kic_product_name}}.

   If you plan to deploy using  Helm, add these values to your `values.yaml` file. The chart automatically configures all the environment variables based on the plugins you inject. Ensure that you add in other configuration values you might need for your installation to be successful.
   ```yaml
   gateway:
     plugins:
       configMaps:
       - name: kong-plugin-myheader
         pluginName: myheader
   ```
    {% capture the_code %}
{% navtabs codeblock %}
{% navtab YAML manifests %}
```bash
$ kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.release }}/deploy/single/all-in-one-dbless.yaml
```
{% endnavtab %}
{% navtab Helm %}
```
helm repo add kong https://charts.konghq.com
helm repo update
helm install kong kong/ingress -n kong --create-namespace --set ingressController.installCRDs=false --values values.yaml
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Create a ConfigMap or Secret with the plugin code
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

1. Modify configuration to update Kong's Deployment to load the custom plugin.

   The following patch is necessary to load the plugin.
   - The plugin code is mounted into the pod via `volumeMounts` and `volumes` configuration property.
   - `KONG_PLUGINS` environment variable is set to include the custom plugin along with all the plugins that come in Kong by default.
   - `KONG_LUA_PACKAGE_PATH` environment variable directs Kong to look for plugins in the directory where we are mounting them.

    If you have multiple plugins, simply mount multiple ConfigMaps and include the plugin name in the `KONG_PLUGINS` environment variable.

    > Note that if your plugin code involves database migration then you need to include the below patch to pod definition of your migration Job as well.
   This is not a complete definition of the Deployment but merely a strategic patch which can be applied to an existing Deployment.

   If you plan to deploy using  Helm, add these values to your `values.yaml` file. The chart automatically configures all the environment variables based on the plugins you inject. Ensure that you add in other configuration values you might need for your installation to be successful. Ensure that you replace the name of the deployment with `kong-gateway` if you installed using Helm.

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

1. After you have setup Kong with the custom plugin installed, you can use it like any other plugin. Create a KongPlugin custom resource:

    ```yaml
   echo "
   apiVersion: configuration.konghq.com/v1
   kind: KongPlugin
   metadata:
     name: my-custom-plugin
   config:
     header_value: "my first plugin"
   plugin: myheader
   " | kubectl apply -f -
   ```

1. Annotate an Ingress or Service resource to instruct Kong on when to execute the plugin:

```yaml
konghq.com/plugins: my-custom-plugin
```

Once you have got Kong up and running, configure your
custom plugin via [KongPlugin resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/).


### Plugins in other languages

When deploying custom plugins in other languages, especially Golang, the built binary is larger than
the size limit of ConfigMap. In such cases, consider using an init container to pull large binaries from
remotes like S3 buckets, or build a custom image that includes plugin runtimes and the plugin itself.

To read more about building a custom image, see
[use external plugins in container and Kubernetes](/gateway/latest/reference/external-plugins/#use-external-plugins-in-container-and-kubernetes).
