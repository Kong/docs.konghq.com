---
title: Editing or deleting a custom plugin's schema
content_type: how-to
---

The workflow for updating an in-use custom plugin depends on whether you need to update the schema:

* **No change to plugin schema:** Editing a custom plugin's logic **without** any change in 
schema doesn't cause the control plane to go out of sync with the data planes. 
In that situation, you only need to make sure that each data plane node has the correct logic. 
The schema on the control plane doesn't need to be updated.

* **Changes to plugin schema:** If the schema needs to change, you must update both the schema in 
{{site.konnect_short_name}} and the plugin code itself on each data plane node.

There is no versioning for custom plugins. If you need to version a schema 
(that is, maintain two or more similar copies of a custom plugin), upload it as a new custom plugin.

{:note}
> **Note**: In cases where a breaking change is made to the schema, we **do not** recommend updating
a data plane node first. 
It will affect the data plane as soon as the node receives its first payload. 
This will happen even if there are no changes in the control plane for existing or new plugins 
using the updated schema. 

## Updating a custom plugin

### How the {{site.konnect_short_name}} platform reads configuration

When a schema is updated in {{site.konnect_short_name}}, the {{site.konnect_short_name}} 
platform doesn't trigger a payload reconciliation automatically.
This means that if a user doesn't make any configuration changes, such as adding, 
modifying, or deleting a {{site.base_gateway}} entity, the data plane nodes won't receive a
payload update.

When changes are pushed to the control plane, the payload reconciliation only affects the 
data plane nodes if an instance of the plugin that uses the updated schema has its configuration 
changed. 

Since plugin configurations are stored as JSON blobs, a schema change alone will not impact the 
plugin configuration. However, if the plugin itself is updated, the new schema will affect how 
the new plugin configuration is represented.

## Custom plugin update path

When you need to make plugin changes, we recommend first updating the schema in 
{{site.konnect_short_name}} and then on the data plane nodes:
1. Start a migration window.
1. Update plugin schema in {{site.konnect_short_name}}.
  1. (Optional) Update configuration for existing plugin instances.
1. Update plugin schema on each data plane node.
1. Stop the migration window.

Based on the nature of the schema updates, you might need an optional step after updating 
the schema in {{site.konnect_short_name}} to make sure the existing plugin entities are 
updated before the schemas are changed in the data plane nodes.

See the following table for a comparison of possible changes and upgrade paths, in the case of 
a configuration parameter change in a custom plugin's schema:

| | Required Default | Required Non-default | Non-required Default | Non-required Non-default |
|--|--|--|--|--|
| Add | ✅ | ⏸️ | ✅ | ✅ |
| Remove | ⏸️ | ❌ | ⏸️ | ⏸️ |
| Type Change | ❌ | ❌ | ❌ | ❌ |

{:.note .no-icon}
> **Legend:**
* ✅ Happy path (1 → 2 → 3 → 4)
* ⏸️ Semi-happy path (1 → 2 → 2.a → 3 → 4)
* ❌ Unhappy path (1 → 2 → DP Error → 3 → 4)
>
> **Note:** Unhappy paths don’t break existing proxy functionality, but they do cause temporary 
`Out of Sync` states until both the configured plugins and the data plane nodes are updated with 
the new schemas.

### Adding or deleting fields

If new fields in a schema don't have default values and aren't required, a payload update won't break data plane payload validation. This means that even if new plugins are added or existing ones are updated, the data plane remains in sync because null fields are ignored.

Here's an example of a non-breaking change to a schema:

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

Similar to adding fields, when not-required fields are deleted, it won't break the data plane -- even when a plugin creation or update is performed. The data plane will only raise an error when a required field is removed and a payload update is triggered:

```sh
2023/09/01 07:14:26 [error] 2308#0: *160 [lua] data_plane.lua:244: [clustering] unable to update running config: bad config received from control plane in 'plugins':
  - in entry 1 of 'plugins':
    in 'config':
      in 'ttl': required field missing, context: ngx.timer
```


## Make changes to custom plugin schemas
To make any changes to a custom plugin schema, you need to access the **Add Plugin** page in 
Gateway Manager, or use the API:

{% navtabs %}
{% navtab Konnect UI %}

1. From the **Gateway Manager**, open a control plane.
1. Open **Plugins** from the side navigation, then click **Add Plugin**.
1. Open the **Custom Plugins** tab.
1. On the tile for your custom plugin click the action menu in the top right corner of the tile, then select **Edit** or **Delete**. Make your changes and save.

{% endnavtab %}
{% navtab Konnect API %}

```sh
curl -i -X PUT \
  https://{region}.api.konghq.com/v2/control_planes/{controlPlaneId}/core-entities/plugin-schemas/{customPluginName} \
  --data "lua_schema=@example-schema.lua"
```
{% endnavtab %}
{% endnavtabs %}

## More information

* [Add a custom plugin in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/add-custom-plugin/)
* [Custom Plugins endpoints](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas) (Control Plane Config API): Manage the lifecycle of a custom plugin in {{site.konnect_short_name}}
* [Custom plugin template](https://github.com/Kong/kong-plugin)
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)