---
title: Configure a Plugin on a Route
no_version: true
---
Enable, update, disable, or delete a plugin for a route.

You can find a route's overview page through the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub): open any service version, then open a route.

## Enable a plugin

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.

1. From the **Routes** section, select a route.

    {:.note}
    > If you don't see the **Routes** section, create an
    [implementation](/konnect/servicehub/service-implementations) first.

1. From the **Plugins** section of the route page, click **Add plugin**.

1. Find and select a plugin.

1. Enter the plugin configuration details.

    Configuration details are different for every plugin, see the [Plugin Hub](/hub) for parameter descriptions.

1. Click **Save**.

## Update or disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. From a route page, find the **Plugins** section, then select a plugin.

1. From the **Plugin actions** drop-down menu, select **Edit**. On the configuration page:

    * To update, adjust any values, then click **Save**.

    * To disable the plugin, switch the toggle at the top of the page. The
    toggle should now display:

        ```
        This plugin is Disabled.
        ```

        Click **Update** to save changes.

## Update or disable a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

1. From a route page, find the **Plugins** section, then select a plugin.

1. Click the **Plugin actions** drop-down menu and select **Delete**, then confirm deletion in the dialog.
