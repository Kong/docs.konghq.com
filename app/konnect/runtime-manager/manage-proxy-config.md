---
title: Runtime Configuration
content_type: how-to
---

Through a runtime group, you can configure the following [{{site.base_gateway}} objects](/konnect/runtime-manager/gateway-config):
* Gateway services
* Routes
* Consumers
* Plugins (global or consumer-scoped only)
* Upstreams
* Certificates
* SNIs
* Vaults

## Configure a {{site.base_gateway}} object

1. Open the {% konnect_icon runtimes %}
**Runtime Manager**, and select a runtime group.

2. Select an object to configure from the menu.

3. Within the object configuration page, click **Add**

4. Enter the configuration details.

    See the [Kong Admin API reference](/gateway/latest/admin-api) for all
    configuration field descriptions.

5. Click **Create**.

## Update or delete a {{site.base_gateway}} object

1. Open the {% konnect_icon runtimes %}
**Runtime Manager**, and select a runtime group.

2. Select an object to configure from the menu.

3. Click the object that you want to update or delete.

4. Select **Actions** > **Delete** or **Actions** > **Edit**

    * If editing, adjust any values in the configuration, then click **Save**.
    * If deleting, confirm deletion in the dialog.

If you do not select a specific object to edit or delete, the runtime group will be selected by default.

## Manage global or consumer-scoped plugins

Plugin configuration is slightly different from other {{site.base_gateway}} objects, because you can enable or disable a plugin, which leaves the configuration intact
but lets you control whether the plugin is active or not.

### Configure a plugin

1. Open the {% konnect_icon runtimes %}
**Runtime Manager**, and select a runtime group.

2. Select the **Plugins** object from the menu, then click **+ Install Plugin**.

3. Optional: If a plugin is already installed click **Add Plugin**.

3. Find and select a plugin.

3. Choose whether to make this plugin **Global** or **Scoped** to a consumer.

    For some plugins, there is only one option:
    * If that option is **Global**, you don't need to do anything else with it.
    * If the option is **Scoped**, select a consumer to scope it to.

4. Enter the plugin configuration details. These differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

5. Click **Create**.

### Disable or enable a plugin

Disable a global plugin from the Runtime Manager.

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. Open the {% konnect_icon runtimes %}
**Runtime Manager**, and select a runtime group.

2. Select the **Plugins** object from the menu.

2. Find your plugin in the plugins list and click the toggle in the **Status** column.

   If the plugin is applied to a service or a route, you can't change its
   settings from here. Click the tag in the **Applied To** column to go to the
   plugin's parent object, and update it there.
