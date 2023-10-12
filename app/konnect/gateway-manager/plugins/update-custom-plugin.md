---
title: Editing or deleting a custom plugin's schema
content_type: how-to
---

The workflow for updating an in-use custom plugin depends on whether you need to update the schema:

* **No change to plugin schema:** Editing a custom plugin's logic **without** altering its
schema won't cause the control plane to go out of sync with the data planes. 

  In this situation, you only need to make sure that each data plane node has the correct logic. 
  The schema on the control plane doesn't need to be updated.

* **Changes to plugin schema:** If there are changes required in the plugin schema, 
you must update both the schema in {{site.konnect_short_name}} and the plugin code itself 
on each data plane node.

* **Deleting a plugin and its schema**: If you need to completely remove the plugin from your
control plane, you must remove all existing plugin configurations of this entity, then remove 
the schema from the control plane and all plugin files from the data plane nodes.

There is no built-in versioning for custom plugins. 
If you need to version a schema (that is, maintain two or more similar copies of a custom plugin), 
upload it as a new custom plugin and add a version identifier to the name.
For example, if your original plugin is named `delay`, you can name the new version `delay-v2`.

## Updating a custom plugin

### How the {{site.konnect_short_name}} platform reads configuration

When a schema file is updated in {{site.konnect_short_name}}, the {{site.konnect_short_name}} 
platform doesn't trigger payload reconciliation automatically.

This means that if you **don't** make any configuration changes in the control plane, such as adding, 
modifying, or deleting a {{site.base_gateway}} entity, the data plane nodes won't receive a
payload update, and won't use the updated schema.

When pushing changes to the control plane, the payload reconciliation only affects 
data plane nodes if an instance of the plugin that uses the updated schema has its 
configuration changed.

Since plugin configurations are stored as JSON blobs, a schema change alone doesn't impact the 
plugin configuration. However, if an instance of this plugin is also updated, the new schema affects how 
any new plugin configuration is represented.

In summary:
* Uploading a custom plugin schema adds a new configurable object to the {{site.konnect_short_name}} Plugin Hub, 
both as a tile in the UI, and an API endpoint.

 * Modifying the schema itself does not trigger payload updates to data plane nodes.

* The new tile or endpoint added by the schema lets you create plugin configurations.
If you create a plugin configuration in this way, it triggers a payload reconciliation with the data plane nodes.

### Custom plugin update path

When you need to make plugin changes, we recommend updating the schema in 
{{site.konnect_short_name}} first, and then on the data plane nodes:

1. Start a migration/maintenance window.
1. Update the plugin schema in {{site.konnect_short_name}}.  
1. (Optional) Update the configuration for existing plugin instances.

    Based on the nature of the schema updates, you might need this optional step 
    after updating the schema in {{site.konnect_short_name}} to make sure that any
    existing plugin entities are updated before the schemas are 
    changed in the data plane nodes.

1. Update the plugin schema on each data plane node.
1. Stop the migration/maintenance window.

{:.important}
> **Important**: In cases where a breaking change is made to the schema, we **do not** 
recommend updating data plane nodes first. 
The change will affect each data plane node as soon as the node receives its first payload. 
This will happen even if there are no changes in the control plane for existing or new plugins 
using the updated schema. 

See the following table for a comparison of possible changes and upgrade paths, in the case of 
a configuration parameter change in a custom plugin's schema.

**Legend:**

Based on the steps defined above and your specific use case, you have to take one of 
the following paths:
* Short path: Follow steps 1 → 2 → 4 → 5, skipping step 3.
* Long path: Follow steps 1 → 2 → 3 → 4 → 5
* CP/DP sync required: 1 → 2 → Optionally 3, if the updated parameter is in use → 4 → 5

| | Required Default | Required Non-default | Non-required Default | Non-required Non-default |
|--|--|--|--|--|
| Configuration parameter added | Short | Long | Short| Short |
| Configuration parameter removed | Long | CP/DP sync required | Long | Long |
| Configuration parameter's data type changed | CP/DP sync required | CP/DP sync required | CP/DP sync required | CP/DP sync required |

{:.note}
> **Note:** If the path requires a sync, that means the change doesn't disrupt existing proxy functionality, 
but does cause temporary `Out of Sync` states until both the configured plugins and the data plane nodes are updated with 
the new schemas.

#### Adding or deleting fields

When new fields are introduced in a schema without default values and aren't marked as required, 
a payload update won't disrupt data plane payload validation. 
This means that even if new plugins are added or existing ones are updated, the data plane will 
stay in sync because null fields are gracefully handled and ignored.

Here's an example of a non-breaking change to a schema. This snippet adds a non-required 
`new_ttl` configuration parameter without a default value, and a response 
header that references an existing `typedef`:

```lua
{ 
    new_ttl = {
        type = "integer",
        gt = 0,
    }
},
{ 
    new_response_header = typedefs.header_name
},
```

Similar to adding fields, when not-required fields are deleted, it doesn't break the data plane - 
even when a plugin is created or updated.
The data plane will only raise an error when a required field is removed and a payload update 
is triggered:

```sh
2023/09/01 07:14:26 [error] 2308#0: *160 [lua] data_plane.lua:244: [clustering] unable to update running config: bad config received from control plane in 'plugins':
  - in entry 1 of 'plugins':
    in 'config':
      in 'ttl': required field missing, context: ngx.timer
```

### Make changes to custom plugin schemas in {{site.konnect_short_name}}

To make any changes to a custom plugin schema, you need to access the **Add Plugin** page in 
Gateway Manager, or use the API:

{% navtabs %}
{% navtab Konnect UI %}

1. From the **Gateway Manager**, open a control plane.
1. Open **Plugins** from the side navigation, then click **Add Plugin**.
1. Open the **Custom Plugins** tab.
1. On the tile for your custom plugin, click the action menu in the corner,
then select **Edit**. Make your changes and save.

{% endnavtab %}
{% navtab Konnect API %}

To update a schema, use a `PUT` request with the [`/plugin-schemas`](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas/) endpoint:

```sh
curl -i -X PUT \
  https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugin-schemas/{customPluginName} \
  --header 'Content-Type: application/json' \
  --data "{\"lua_schema\": "<your escaped Lua schema>"}"
```

{:.note}
> **Tip**: You can use jq to pass your schema directly from the file instead of manually escaping it:
```sh
--data "{\"lua_schema\": $(jq -Rs '.' < REPLACE-PATH-TO-SCHEMA-FILE)}"
```
{% endnavtab %}
{% endnavtabs %}

Then, upload the updated schema file to each data plane node.

## Delete custom plugin schemas from {{site.konnect_short_name}}

To delete a custom plugin schema, you must delete all of its existing configuration entities first:

{% navtabs %}
{% navtab Konnect UI %}

1. From the **Gateway Manager**, open a control plane.
1. Open **Plugins** from the side navigation.
1. Find any instances of the custom plugin that you want to delete, click on its action menu, then select **Delete**.
1. Click **Add Plugin** from the **Plugins** page.
1. Open the **Custom Plugins** tab.
1. On the tile for your custom plugin, click the action menu in the corner, then select **Delete**.

{% endnavtab %}
{% navtab Konnect API %}

1. Find any existing plugin configs:

    ```sh
    curl -i -X GET \
      https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugins/
    ```

    You will get an `HTTP 200` response listing all of your plugins:

    ```json
    ...
    {
      "config": {
        "request_header": "Hello",
        "response_header": "Bye",
        "ttl": 600
      },
      "created_at": 1695837042,
      "enabled": true,
      "id": "1227e7d6-f615-4928-a7c4-dcaadff4b95b",
      "name": "example-plugin",
      "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
      ],
      "updated_at": 1695837042
    },
    {
      "config": {
        "anonymous": null,
        "hide_credentials": true
      },
      "created_at": 1692806129,
      "enabled": true,
      "id": "266409a3-3dbe-4d72-b1dd-2d0cf85c60db",
      "name": "basic-auth",
      "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https",
        "ws",
        "wss"
      ],
      "route": {
        "id": "449fea21-ed2c-4010-9ea1-1c07d068f078"
      },
      "updated_at": 1692806129
    },
    ...
    ```

2. Find any instances of the plugin that you're removing, copy their IDs, then delete them:

    ```sh
    curl -i -X DELETE \
      https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugins/{pluginID}
    ```

    You will get an `HTTP 204` response for each successfully deleted plugin.

3. Once all instances of the plugin are deleted from the control plane, you can delete its schema 
using the [`/plugin-schemas`](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas/) endpoint:

    ```sh
    curl -i -X DELETE \
      https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugin-schemas/{customPluginName}
    ```

    If the request fails and the plugin is still in use in your control plane, you will see the following response:

    ```json
    {
      "code": 3,
      "message": "plugin schema is currently in use, please delete existing plugins using the schema and try again"
    }
    ```

    If successful, you should see an `HTTP 204` response.

{% endnavtab %}
{% endnavtabs %}

Finally, delete the plugin from each data plane node by going into each node's filesystem and removing the plugin's files.

## More information

* [Add a custom plugin in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/add-custom-plugin/)
* [Custom plugin schema endpoints (Control Plane Config API)](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas)
* [Custom plugin template](https://github.com/Kong/kong-plugin)
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)