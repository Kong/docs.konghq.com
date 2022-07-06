---
title: Configure a Plugin on a Service
no_version: true
---
Enable, update, disable, or delete a plugin for a service version.

## Enable a plugin

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service version.

1. From the **Plugins** section, click **Add plugin**.

    {:.note}
    > If you don't see the **Plugins** section, create an
    [implementation](/konnect/servicehub/service-implementations) first.

1. Find and select the plugin of your choice.

1. Enter the plugin configuration details. These will differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

1. Click **Save**.

## Disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service version.

1. From the **Plugins** section, click the toggle for the plugin you want to
disable.

## Update a plugin

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service version.

1. From the **Plugins** section, select a plugin.

1. From the **Plugin actions** drop-down menu, select **Edit**.

1. On the configuration page, adjust any values and click **Save**.

## Delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service version.

1. From the **Plugins** section, select a plugin.

1. From the **Plugin actions** drop-down menu, select **Delete**, then confirm deletion in the dialog.
