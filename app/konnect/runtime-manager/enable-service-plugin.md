---
title: Configure a Plugin on a Service
---
Enable, update, disable, or delete a plugin for a service.

You can find any Gateway service through the {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/runtime-manager) by selecting **Gateway Services**.

## Enable a plugin

From a Gateway service dashboard, enable a plugin:

1. From the **Plugins** section, click **New Plugin**.

1. Find and select the plugin of your choice.

1. Enter the plugin configuration details.

    Configuration details are different for every plugin, see the [Plugin Hub](/hub/) for parameter descriptions.

1. Click **Save**.

{:.note}
> If you don't see the **Plugins** section, create an implementation first.


## Disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

From a Gateway Service page, find the **Plugins** section, then select a plugin.
From this page, you can update or disable a plugin:

* From the **Plugin actions** drop-down menu, select **Edit**.

  * To update, adjust any values, then click **Save**.

  * To disable the plugin, switch the toggle to `This plugin is Disabled`, then click **Save**.

## Delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

From a Gateway service page, find the **Plugins** section, then select a plugin.
From this page, you can delete the plugin:

* From the **Plugin actions** drop-down menu, select **Delete**, then confirm deletion in the dialog.
