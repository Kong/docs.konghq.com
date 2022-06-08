---
title: Manage Proxy Configuration
no_version: true
---

Through a runtime group, you can configure the following Kong Gateway objects:
* Gateway services
* Routes
* Consumers
* Plugins (global or consumer-scoped only)
* Upstreams
* Certificates
* SNIs

## Configure a Kong Gateway object

1. From the left navigation menu in Konnect, open {% konnect_icon runtimes %}
**Runtime Manager**.

2. Select an object to configure from the menu, then click **+ Add {Object Name}**.

4. Enter the object configuration details.

    See the [Kong Admin API reference](/gateway/latest/admin-api) for all
    configuration field descriptions.

5. Click **Create**.

## Update or delete a Kong Gateway object

1. Open {% konnect_icon runtimes %} **Runtime Manager**, then select an object to
configure from the menu.

2. Open the action menu on the right of a row, and click **Edit** or **Delete**.

    * If editing, adjust any values in the configuration, then click **Save**.
    * If deleting, confirm deletion in the dialog.


## Manage global or consumer-scoped plugins

Plugin configuration is slightly different from other {{site.base_gateway}} objects.
You can also enable or disable a plugin, which leaves the configuration intact
but lets you control whether the plugin is active or not.

### Configure a plugin

1. From the left navigation menu in Konnect, open {% konnect_icon runtimes %}
**Runtime Manager**.

2. Select **Plugins** from the menu, then click **+ Install Plugin**.

3. Find and select the plugin of your choice.

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

1. Open {% konnect_icon runtimes %} **Runtime Manager**, then select **Plugins**
from the menu.

2. Find your plugin in the plugins list and click the toggle in the **Enabled** column.

   If the plugin is applied to a Service or a Route, you can't change its
   settings from here. Click the tag in the **Applied To** column to go to the
   plugin's parent object, and update it there.
