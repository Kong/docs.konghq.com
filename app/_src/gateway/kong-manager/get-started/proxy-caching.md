---
title: Proxy Caching
badge: free
---

This tutorial walks you through setting up proxy caching in Kong Manager.

Use proxy caching so that upstream services are not bogged down with repeated requests. With proxy caching, {{site.base_gateway}} can respond with cached results for better performance.

If you prefer to use the Admin API, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/proxy-caching/).

## Prerequisites

You need a {{site.base_gateway}} instance with Kong Manager [enabled](/gateway/{{page.release}}/kong-manager/enable/).

## Set up the Proxy Caching plugin

From the **Workspaces** tab in Kong Manager:

1. Open the **default** workspace.
2. From the menu, open **Plugins**, then click **Install Plugin**.
3. Find the **Proxy Caching** plugin, then click **Enable**.
4. Select to apply the plugin as **Global**. This means that proxy caching applies to all requests.
5. Scroll down and complete only the following fields with the parameters listed.
    1. config.cache_ttl: `30`
    2. config.content_type: `application/json` and `charset=utf-8`
    3. config.strategy: `memory`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.
6. Click **Install**.

<!-- ## Validate Proxy Caching

figure out how to validate in the browser -->

## Next Steps

Next, you’ll learn about [securing services](/gateway/{{page.release}}/kong-manager/get-started/consumers/) through Kong Manager.
