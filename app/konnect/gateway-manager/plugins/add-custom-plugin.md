---
title: Adding custom plugins in Konnect
content_type: how-to
---

You can manage schemas for custom plugins via the {{site.konnect_short_name}} UI or 
the {{site.konnect_short_name}} Control Planes Config API. 

After uploading a schema to {{site.konnect_short_name}}, upload your 
custom plugin to each data plane node, then {{site.konnect_short_name}} can manage the 
configuration for your plugin like any other Kong entity.

If you need to update a schema for a plugin that was already uploaded
to {{site.konnect_short_name}}, there are a few considerations based on the type 
of update. 
See [Editing or deleting a custom plugin's schema](/konnect/gateway-manager/plugins/update-custom-plugin/) 
for more information.

{:.note}
> **Note**: For adding custom plugins to a Dedicated Cloud Gateway, see 
[Custom plugins in Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/custom-plugins/).

## Prerequisites

* Your custom plugin meets {{site.konnect_short_name}}'s [requirements](/konnect/gateway-manager/plugins/#custom-plugins)
for {{site.konnect_short_name}}.

* The schema file must be in Lua, even if the custom plugin is written in another supported language.
For help with developing plugins, see the [plugin development resources](#more-information).
  
    If you have a custom plugin written in a language other than Lua, convert the schema 
into a `schema.lua` file before uploading it to {{site.konnect_short_name}}.

* When using the `/plugin-schemas` API, authenticate your requests with either a personal access token or a system account token by including it in the authentication header:

    ```
    --header 'Authorization: Bearer kpat_xgfT'
    ```

## Add a custom plugin to a control plane

{{site.konnect_short_name}} only requires the custom plugin's `schema.lua` file. 
Using that file, it creates a plugin entry in the plugin catalog for your control plane.

Upload a custom plugin schema to create a configurable entity in {{site.konnect_short_name}}:

{% navtabs %}
{% navtab Konnect UI %}

{:.note}
> **Note**: The UI is not available when using KIC in Konnect. Please use the Konnect API instead.

1. From the **Gateway Manager**, open a control plane.
1. Open **Plugins** from the side navigation, then click **Add Plugin**.
1. Open the **Custom Plugins** tab, then click **Create** on the Custom Plugin tile.
1. Upload the `schema.lua` file for your plugin.
1. Check that your file displays correctly in the preview, then click **Save**.

{% endnavtab %}
{% navtab Konnect API %}

Upload the `schema.lua` file for your plugin using the [`/plugin-schemas`](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas/) endpoint:

```sh
curl -i -X POST \
  https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugin-schemas \
  --header 'Content-Type: application/json' \
  --data "{\"lua_schema\": <your escaped Lua schema>}"
```

{:.note}
> **Tip**: You can use jq to pass your schema directly from the file instead of manually escaping it:
```sh
--data "{\"lua_schema\": $(jq -Rs '.' < REPLACE-PATH-TO-SCHEMA-FILE)}"
```

You should get an `HTTP 201` response. 

You can check that your schema was uploaded using the following request:

```sh
curl -i -X GET \
  https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugin-schemas
```

This request returns an `HTTP 200` response with the schema for your plugin as a JSON object.

{% endnavtab %}
{% endnavtabs %}

Uploading a custom plugin schema adds the plugin to a specific control plane. 
If you need it to be available in multiple control planes, add the schema individually to each one.

## Upload files to data plane nodes

After uploading a schema to {{site.konnect_short_name}}, 
upload the `schema.lua` and `handler.lua` for your plugin to **each** 
{{site.base_gateway}} data plane node.

If a data plane node doesn't have these files, the plugin won't be able to run on that node.

{:.note}
> {{site.konnect_short_name}} does not support plugins with `api.lua`, `daos.lua`, or `migration.lua`.

{% navtabs %}
{% navtab Universal %}

Follow the {{site.base_gateway}} [plugin deployment and installation instructions](/gateway/latest/plugin-development/distribution/) 
to get your plugin set up on each node.

{% endnavtab %}
{% navtab Docker %}

If you are running {{site.base_gateway}} on Docker,
the plugin needs to be installed inside the {{site.base_gateway}} container 
for each node.
Copy or mount the plugin’s source code into the container.

Let’s consider this sample custom plugin. This is composed of a 
`schema.lua` and a `handler.lua` file. On your filesystem, let’s create a 
similar path structure to the following:

```sh
.
└── kong
    └── plugins
        └── example-plugin
            ├── handler.lua
            └── schema.lua
```

You can do this in one of two ways: mounting the files with `docker run`, or 
using a Dockerfile.

To mount and enable this custom plugin on a data plane node:

1. In your control plane, go to **Data Plane Nodes**, then click **New Data Plane Node**.
1. Choose **Linux (Docker)** and **Generate a certificate**.
1. Copy the generated `docker run` command and add the following snippet to it:

    ```sh
    -v "/tmp/plugins/kong:/tmp/custom_plugins/kong" \
    -e "KONG_PLUGINS=bundled,example-plugin" \
    -e "KONG_LUA_PACKAGE_PATH=/tmp/custom_plugins/?.lua;;" \
    ```

    Substitute your own source and target paths, as well as the plugin name.

    A sample quickstart command would look something like this:

    ```sh
    docker run -d \
      -v "/tmp/plugins/kong:/tmp/custom_plugins/kong" \
      -e  "KONG_PLUGINS=bundled,example-plugin" \
      -e "KONG_LUA_PACKAGE_PATH=/tmp/custom_plugins/?.lua;;" \
      -e "KONG_ROLE=data_plane" \
      -e "KONG_DATABASE=off" \
      -e "KONG_VITALS=off" \
      -e "KONG_NGINX_WORKER_PROCESSES=1" \
      -e "KONG_CLUSTER_MTLS=pki" \
      -e "KONG_CLUSTER_CONTROL_PLANE=<example>.cp0.konghq.com:443" \
      -e "KONG_CLUSTER_SERVER_NAME=<example>.cp0.konghq.com" \
      -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=<example>.tp0.konghq.com:443" \
      -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=<example>.tp0.konghq.com" \
      -e "KONG_CLUSTER_CERT=<cert>" \
      -e "KONG_CLUSTER_CERT_KEY=<key>" \
      -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system" \
      -e "KONG_KONNECT_MODE=on" \
      -p 8000:8000 \
      -p 8443:8443 \
      kong/kong-gateway:<version>
    ```
1. Run the command to start a data plane node with your custom plugin loaded in.

To copy the plugin using a Dockerfile instead, see the [{{site.base_gateway}} custom plugin docs](/gateway/latest/plugin-development/distribution/).

{% endnavtab %}
{% endnavtabs %}

You can now configure this custom plugin like any other plugin in {{site.konnect_short_name}}.

{:.important}
> **Caution**: Carefully test the operation of any custom plugins before using them in production. Kong is not responsible for the operation or support of any 
custom plugins, including any performance impacts on your {{site.konnect_short_name}}
or {{site.base_gateway}} deployments. 

## More information

* [Edit or delete custom plugins in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/update-custom-plugin/)
* [Custom plugins in Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/custom-plugins/)
* [Custom plugin schema endpoints (Control Plane Config API)](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas)
* [Custom plugin template](https://github.com/Kong/kong-plugin)
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)
