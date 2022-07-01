---
title: Configure a Plugin on a Service
no_version: true
---
Enable, update, disable, or delete a plugin for a service version.

## Enable a plugin

1. From the left navigation menu, open the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub).

2. Open a service version.

2. From the **Plugins** section, click **Add plugin**.

    {:.note}
    > If you don't see the **Plugins** section, create an
    [implementation](/konnect/servicehub/service-implementations) first.

3. Find and select the plugin of your choice.

4. Enter the plugin configuration details. These will differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

5. Click **Save**.

## Disable a plugin

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. From the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub), open a service version, then find the **Plugins** section.

2. In the **Enabled** column, click the toggle for the plugin you want to
disable.

## Update a plugin

1. From the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub), open a service version, then find the **Plugins**
section.

2. Select a plugin.

3. Click the **Plugin actions** drop-down menu and select **Edit**. On the configuration page,
adjust any values and click **Save**.

## Delete a plugin

Deleting a plugin completely removes it and its configuration from
{{site.konnect_short_name}}.

1. From the {% konnect_icon servicehub %}
[**Service Hub**](https://cloud.konghq.com/servicehub), open a service version, then find the **Plugins**
section.

2. Select a plugin.

3. Click the **Plugin actions** drop-down menu and select **Delete**, then confirm deletion in the dialog.
