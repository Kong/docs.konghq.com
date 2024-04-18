---
title: Rate Limiting
badge: free
---

This tutorial walks you through setting up rate limiting for a service in Kong Manager.

If you prefer to use the Admin API, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/rate-limiting/).

## Prerequisites

You need a {{site.base_gateway}} instance with Kong Manager [enabled](/gateway/{{page.release}}/kong-manager/enable/).

## Set up the Rate Limiting plugin

On the Workspaces tab in Kong Manager:

1. Open the **default** workspace.
2. From the menu, open **Plugins**, then click **Install Plugin**.
3. Find the **Rate Limiting** plugin, then click **Enable**.
4. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every service and route in the workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one service, route, or consumer.

    By default, the plugin is automatically enabled when the form is submitted.
    You can also toggle the **This plugin is Enabled** button to configure the plugin without enabling it.
    For this example, keep the plugin enabled.
5. Complete only the following fields with the following parameters.
    1. config.limit: `5`
    2. config.sync_rate: `-1`
    3. config.window_size: `30`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.
6. Click **Install**.

## Validate rate limiting

1. Enter `https://localhost:8000/mock` in your browser address bar, then refresh your browser six times.
    After the 6th request, you’ll receive an error message.

2. Wait at least 30 seconds and try again.
    The service will be accessible until the sixth (6th) access attempt within a 30-second window.

Next, head on to learn about [proxy caching](/gateway/{{page.release}}/kong-manager/get-started/proxy-caching/).
