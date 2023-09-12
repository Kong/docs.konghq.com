---
title: Configure a Plugin on a Route
---
Enable, update, disable, or delete a plugin for a route.

You can find any route through the {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/) by selecting **Routes**.

## Enable a plugin

1. From the {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/), select a control plane.

1. From the **Routes** section, select a route.

1. From the **Plugins** section of the route page, click **Add plugin**.

1. Find and select a plugin.

1. Enter the plugin configuration details.

    Configuration details are different for every plugin, see the [Plugin Hub](/hub/) for parameter descriptions.

1. Click **Save**.

{:.note}
> If you don't see the **Routes** section, create an implementation.

## Update or disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

From a route page, find the **Plugins** section, then select a plugin.
From this page, you can update or disable a plugin:

* From the **Plugin actions** drop-down menu, select **Edit**.

  * To update, adjust any values, then click **Save**.

  * To disable the plugin, switch the toggle to `This plugin is Disabled`, then click **Save**.

## Delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

From a route page, find the **Plugins** section, then select a plugin.
From this page, you can delete the plugin:

* From the **Plugin actions** drop-down menu, select **Delete**, then confirm deletion in the dialog.
