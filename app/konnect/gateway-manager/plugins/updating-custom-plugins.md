---
title: Editing or deleting a custom plugin's schema
content_type: how-to
---

_[to do: big edit]_

You can edit a custom plugin's schema at any time. However, {{site.konnect_short_name}} can't maintain versions of the same schema. There is no versioning for custom plugins. 
If you need to version a schema, upload it as a new custom plugin.

The workflow for updating a plugin depends on whether you need to update the schema:
* Editing a custom plugin's logic **without** any change in schema doesn't cause the control plane to go out of sync with the data planes. In that situation, you just need to make sure that each data plane node has the correct logic, but the schema on the control plane doesn't need to be updated.
* If the schema needs to change, then you must update both the schema in {{site.konnect_short_name}} and the plugin code itself on each data plane node.

{:note}
> **Note**: In cases where a breaking change is made to the schema, we **do not** recommend updating a data plane node first. It will affect the data plane as soon as the node receives its first payload. This will happen even if there are no changes in the control plane for existing or new plugins using the updated schema. 

## Updating a plugin's schema

When a schema is updated in Konnect, it's essential to be aware of how Koko handles these changes. One key point to note is that Koko does not trigger a payload reconciliation automatically upon schema updates. This means that if a user does not make any "real" configuration changes, such as adding, modifying, or deleting a Kong entity, the DP will not receive a payload update.

Even when changes are pushed to the control plane, the payload reconciliation will only affect the DP if a plugin that uses the updated schema is being changed. Since plugin configurations are stored as JSON blobs, a schema change alone will not impact the plugin configuration. However, if the plugin itself is updated, the new schema will affect how the new plugin configuration is represented.

### Adding new fields

If new fields do not have default values and are not required, a payload update will not break DP payload validation. This means that even if new plugins are added or existing ones are updated, the DP will remain in sync because null fields are ignored.

Sample non-breaking additions:
```
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

### Deleting existing fields

Similar to adding fields, when not-required fields are deleted, it will not break the DP, even when a plugin creation or update is performed. However, when a required field is removed, the DP will raise an error (again, when a payload update is triggered):

```sh
2023/09/01 07:14:26 [error] 2308#0: *160 [lua] data_plane.lua:244: [clustering] unable to update running config: bad config received from control plane in 'plugins':
  - in entry 1 of 'plugins':
    in 'config':
      in 'ttl': required field missing, context: ngx.timer
```

### Migration path

When you need to make plugin changes, we recommend first updating the schema in Konnect and 
then on the data plane nodes:
1. Start migration window 
1. Update plugin schema in Konnect
1. (optional) Update existing plugins
1. Update plugin schema on the data plane nodes
1. Stop migration window

Based on the nature of the schema updates, an additional step between (2) and (4) may be required to make sure the existing plugin entities are updated before the schemas are changed in the data plane nodes.

The following table describes all the various permutations of changes we can do plus how the migration process would look like:

| | Required Default | Required Non-default | Non-required Default | Non-required Non-default |
|--|--|--|--|--|
| Add | ✅ | ⏸️ | ✅ | ✅ |
| Remove | ⏸️ | ❌ | ⏸️ | ⏸️ |
| Type Change | ❌ | ❌ | ❌ | ❌ |

{:.note .no-icon}
> **Legend:**
* ✅ happy path (1 →  2 →  3 →  4)
* ⏸️ semi-happy path (1 →  2 → 2.a →  3 →  4)
* ❌ unhappy path (1 →  2 → DP Error →  3 →  4)


{:.note}
Note: Unhappy paths don’t break existing proxy functionality, but they would just cause temporary Out of Sync states until both the configured plugins and the runtimes are updated with the new schemas 

<!-- 
## Deleting custom plugins

You can delete a custom plugin schema from {{site.konnect_short_name}} without deleting the custom plugin modules from the data plane nodes. This won't cause any sync issues, however, you won't be able to manage the plugin's configuration anymore. -->

## Make changes to custom plugin schemas
To make any changes to a custom plugin schema, you need to access the **Add Plugin** dialog, or use the API:

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
  https://{region}.api.konghq.com/v2/control_planes/{controlPlaneId}/core-entities/plugin-schemas/{customPluginName|Id} \
  --data "lua_schema=@example-schema.lua"
```
or?
```
$ http put https://us.api.konghq.tech/v2/runtime-groups/$RGID/core-entities/plugins/$ID name=myplugin -A bearer -a $TOKEN_DEV
HTTP/1.1 200 OK
```


{% endnavtab %}
{% endnavtabs %}