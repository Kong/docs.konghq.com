---
title: Custom Plugins
type: explanation
purpose: |
  How to use Custom Plugins with KIC
---

Install a custom plugin in Kong without using a Docker build.

{:.note}
> The recommended way to install custom plugins is with {{ site.kgo_product_name }}.
> See [Kong custom plugin distribution with KongPluginInstallation](/gateway-operator/latest/guides/plugin-distribution/) for more information.

{% include md/custom-plugin.md %}

2. Create a `ConfigMap` or `Secret` with the plugin code. If you're not sure which option is correct, use a `ConfigMap`.

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

### Creating Plugin with Custom Entities and Migration Scripts

If your custom plugin includes definition of your own entities, you need to create a `daos.lua` in your directory, and a `migration` sub-directory containing the scripts to create database tables and migrate data between different versions (if your schema of your entities changed between different versions). In the case, the directory should like this:

```bash
tree myheader
```

```bash
  myheader
  ├── daos.lua
  ├── handler.lua
  ├── migrations
  │   ├── 000_base_my_header.lua
  │   ├── 001_100_to_110.lua
  │   └── init.lua
  └── schema.lua

  1 directories, 6 files
```

Since `ConfigMap` or `Secret` volumes does not support nested directories, you need to create another `ConfigMap` or `Secret` for the `migrations` directory:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab ConfigMap %}
```bash
$ kubectl create configmap kong-plugin-myheader-migrations --from-file=myheader/migrations -n kong
```
{% endnavtab %}

{% navtab Secret %}
```bash
$ kubectl create secret generic -n kong kong-plugin-myheader-migrations --from-file=myheader/migrations
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
configmap/kong-plugin-myheader-migrations created
```
{% endnavtab %}

{% navtab Secret %}
```text
secret/kong-plugin-myheader-migrations created
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


If you need to include the migration scripts to the plugin, you need to configure `userDefinedVolumes` and `userDefinedVolumeMounts` in `values.yaml` to mount the migration scripts to the {{site.base_gateway}} pod:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab ConfigMap %}
```yaml
gateway:
  plugins:
    configMaps:
    - name: kong-plugin-myheader
      pluginName: myheader
  deployment:
    userDefinedVolumes:
    - name: "kong-plugin-myheader-migrations"
      configMap:
        name: "kong-plugin-myheader-migrations"
    userDefinedVolumeMounts:
    - name: "kong-plugin-myheader-migrations"
      mountPath: "/opt/kong/plugins/myheader/migrations" # Should be the path /opt/kong/plugins/<plugin-name>/migrations
```
{% endnavtab %}

{% navtab Secret %}
```yaml
gateway:
  plugins:
    secrets:
    - name: kong-plugin-myheader
      pluginName: myheader
  deployment:
    userDefinedVolumes:
    - name: "kong-plugin-myheader-migrations"
      secret:
        name: "kong-plugin-myheader-migrations"
    userDefinedVolumeMounts:
    - name: "kong-plugin-myheader-migrations"
      mountPath: "/opt/kong/plugins/myheader/migrations" # Should be the path /opt/kong/plugins/<plugin-name>/migrations
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
        - name: kong-plugin-myheader-migrations # Required when you have migration scripts in your plugin
          mountPath: /opt/kong/plugins/myheader/migrations
      volumes:
      - name: kong-plugin-myheader
        configMap:
          name: kong-plugin-myheader
      - name: kong-plugin-myheader-migrations # Required when you have migration scripts in your plugin
        configMap:
          name: kong-plugin-myheader-migrations
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
