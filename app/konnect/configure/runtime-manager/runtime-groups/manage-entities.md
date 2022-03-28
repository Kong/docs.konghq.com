---
title: Manage Global Entities
no_version: true
---

You can manage global and consumer-scoped entities from within a runtime group.

**Global entities** are configurations that apply to, or can be used by,
all services, routes, and consumers in the cluster, as applicable.

A **global** entity is a set of configurations that apply to, or can be used
by, all objects in a runtime group. For example, if you set up a Proxy Caching
plugin in the default runtime group and set it to `Global`,
the plugin configuration will apply to all Service versions in the group.


[_TO DO: Add info on consumers, upstreams, certificates, and SNIs to this topic, and try to genericize the config instructions_]

## Plugins

The **Plugins** page shows all plugins in the cluster. However, you can
only edit **global** or **consumer-scoped** plugins here.
[Service](/konnect/configure/manage-plugins/enable-service-plugin) and
[route](/konnect/configure/manage-plugins/enable-route-plugin) plugins must be managed
through the ServiceHub.

### Configure a new plugin

1. From the left navigation menu in Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**.

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

1. Open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**, then select **Plugins** from the menu.

2. Find your plugin in the plugins list and click the toggle in the **Enabled** column.

   If the plugin is applied to a Service or a Route, you can't change its
   settings from here. Click the tag in the **Applied To** column to go to the
   plugin's parent object, and update it there.


### Update or delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

1. Open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**, then select **Plugins** from the menu.

2. Find your plugin in the plugins list, open the action menu on the right of the row, and click **Edit** or **Delete**.

    * If editing, adjust any values in the configuration, then click **Save**.
    * If deleting, confirm deletion in the dialog.
