---
title: Manage Plugins through Shared Config
no_version: true
---

You can manage global and consumer-scoped plugins from the Shared Config page.

**Global plugins** are plugins that apply to all services, routes, and consumers
in the cluster, as applicable.

The Shared Config page shows all plugins in the cluster. However, you can
only edit **global** or **consumer-scoped** plugins here.
[Service](/konnect/manage-plugins/enable-service-plugin) and
[route](/konnect/manage-plugins/enable-route-plugin) plugins must be managed
through the ServiceHub.

## Configure a new plugin

1. From the left navigation menu, open the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
**Shared Config** page.

2. Select **Plugins** from the menu, then click **New Plugin**.

3. Find and select the plugin of your choice.

3. Choose whether to make this plugin **Global** or **Scoped** to a consumer.

    For some plugins, there is only one option:
    * If that option is **Global**, you don't need to do anything else with it.
    * If the option is **Scoped**, select a consumer to scope it to.

4. Enter the plugin configuration details. These differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

5. Click **Create**.

## Disable or enable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. Open the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
Shared Config page, then select **View All** for the plugins
list, or open **Plugins** from the menu.

2. Find your plugin in the plugins list and click **Edit**.

3. Switch the toggle at the top of the configuration to your preferred state,
then scroll down and click **Update**.

## Update or delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

1. Open the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
Shared Config page, then select **View All** for the plugins
list, or open **Plugins** from the menu.

2. Find your plugin in the plugins list and click **Edit**.

3. Click **Edit Plugin** in the top right. On the configuration page:

    * To update, adjust any values, then click **Update**.

    * To delete, scroll to the bottom and click **Delete**.
