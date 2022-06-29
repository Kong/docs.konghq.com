---
title: Configure a Plugin on a Route
no_version: true
---
Enable, update, disable, or delete a plugin for a route.

## Enable a plugin

1. From the left navigation menu, open the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub).

1. Select a service version.

1. Find the **Routes** section and select a route.

    {:.note}
    > If you don't see the **Routes** section, create an
    [implementation](/konnect/servicehub/service-implementations) first.

1. From the **Plugins** section, click **Add plugin**.

1. Find and select a plugin.

1. Enter the plugin configuration details. These will differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

1. Click **Create** to save.

## Update or disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. From the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub), return to the overview page for your route.

1. Find the **Plugins** section and select a plugin.

1. Click **Plugin actions** > **Edit**. On the configuration page:

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

1. From the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub), return to the overview page for your route.

1. Find the **Plugins** section and select a plugin.

1. Click **Plugin actions** > **Delete**, then confirm deletion in the dialog.
