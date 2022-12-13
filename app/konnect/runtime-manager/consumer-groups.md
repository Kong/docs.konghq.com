---
title: Create Consumer Groups in Konnect
content_type: tutorial
badge: enterprise
---
With consumer groups, you can define any number of rate limiting tiers and
apply them to subsets of consumers, instead of managing each consumer
individually.

For example, you could define three consumer groups:
* **gold tier** with 1000 requests per minute
* **silver tier** with 10 requests per second
* **bronze tier** with 6 requests per 30 seconds

The `consumer_groups` endpoint works together with the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced).

Consumers that are not in a consumer group default to the Rate Limiting advanced
plugin’s configuration, so you can define tier groups for some users and
have a default behavior for consumers without groups.

To use consumer groups for rate limiting, you must:
* Create one or more consumer groups
* Create consumers
* Assign consumers to groups
* Configure the Rate Limiting Advanced plugin globally with the `enforce_consumer_groups`
and `consumer_groups` parameters, setting up the list of consumer groups that
the plugin accepts
* Configure a rate limiting policy for each consumer group, overriding the 
plugin's global configuration

## Set up a consumer group with consumers

In this section, you will create the Bronze tier consumer group with a consumer assigned to the group.

1. From the {{site.konnect_short_name}} sidebar, open the **Runtime Manager** section.
1. Select the **default** runtime group.
1. From the menu, click **Consumers**, then click **Add consumer**.
1. Enter a **Username** and **Custom ID**. For this example, you can use "Amal" for each field.
1. Click the **Consumer Groups** tab.
1. Click **Add Consumer Group**.
1. Enter "Bronze" for the consumer group name and select the "Amal" consumer you just created from the drop-down. 
1. Click **Create**.

## Configure the Rate Limiting Advanced plugin for all consumers

In this section, you will configure the Rate Limiting Advanced plugin to set the rate limit to 5 requests every 30 seconds for all consumers.

1. In {{site.konnect_short_name}}, click **Runtime Manager** in the sidebar.
1. Click the **default** runtime group.
1. From the menu, open **Plugins**, then click **Add plugin**.
1. Find the **Rate Limiting** plugin, then click **Select**.
1. Apply the plugin as **Global**
    This means the rate-limiting applies to all requests, including every service and route in the workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one service, route, or consumer.

    By default, the plugin is automatically enabled when the form is submitted.
    You can also toggle the **This plugin is Enabled** button to configure the plugin without enabling it.
    For this example, keep the plugin enabled.
1. Complete only the following fields with the following parameters:
    1. Config.limit: `5`
    1. Config.window_size: `30`
    1. Config.window_type: `Sliding`
    1. Config.retry_after_jitter_max: `0`
    1. Config.enforce_consumer_groups: `true` 
    1. Config.consumer_groups: `Bronze`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.
1. Click **Save**.

## Configure rate limiting for consumer groups

In this section, you will configure the Rate Limiting Advanced plugin to set the rate limit to 6 requests every 30 seconds only for consumers in the Bronze tier.

1. In {{site.konnect_short_name}}, click **Runtime Manager** in the sidebar.
1. Select the **default** runtime group.
1. From the menu, open **Consumers**, then click the **Consumer Groups** tab.
1. Click the **Bronze** consumer group you just created.
1. Click **Add Configuration**.
1. In the dialog, complete only the following fields with the following parameters:
    1. Window Size: 30
    1. Window Type: Sliding
    1. Limit: 6
    1. Retry After Jitter Max: 0
1. Click **Save**.

