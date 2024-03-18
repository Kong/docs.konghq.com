---
title: Create Consumer Groups in Kong Manager
content_type: tutorial
badge: free
---
With consumer groups, you can define any number of rate limiting tiers and
apply them to subsets of consumers, instead of managing each consumer
individually.

For example, you could define three consumer groups:
* A "gold tier" with 1000 requests per minute
* A "silver tier" with 10 requests per second
* A "bronze tier" with 6 requests per 30 seconds

The `consumer_groups` endpoint works together with the following plugins:

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
{% if_version gte:3.4.x -%}
* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
* [Response transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
* [Request Transformer](/hub/kong-inc/request-transformer)
* [Response Transformer](/hub/kong-inc/response-transformer)
{% endif_version %}

Consumers that are not in a consumer group default to the Rate Limiting advanced
plugin’s configuration, so you can define tier groups for some users and
have a default behavior for consumers without groups.

To use consumer groups for rate limiting, you need to:
* Create one or more consumer groups
* Create consumers
* Assign consumers to groups
* Configure the Rate Limiting Advanced plugin globally with the `enforce_consumer_groups`
and `consumer_groups` parameters, setting up the list of consumer groups that
the plugin accepts
* Configure a rate limiting policy for each consumer group, overriding the 
plugin's global configuration

For all possible requests, see the
[Consumer Groups reference](/gateway/api/admin-ee/3.3.0.x/#/consumer_groups/get-consumer_groups).

## Set up a consumer group with consumers

In this section, you will create the Bronze tier consumer group with a consumer assigned to the group.

1. Open the **default** workspace.
1. From the menu, open **Consumers**, then click the **Groups** tab.
1. Click **New Consumer Groups**.
1. Enter `Bronze` for the consumer group name and click **Create**.
1. From the menu, click **Consumers**, then click **New Consumer**.
1. Enter a **Username** and **Custom ID**. For this example, you can use `Amal` for each field.
1. Click **Create**.
1. From the menu, click the **Groups** tab.
1. Click the `Bronze` consumer group you just created.
1. Click **Consumers** and **Add consumers** to add the `Amal` consumer you created to the `Bronze` consumer group.

## Configure the Rate Limiting Advanced plugin for all consumers

In this section, you will configure the Rate Limiting Advanced plugin to set the rate limit to 5 requests every 30 seconds for all consumers.

1. Open the **default** workspace.
1. From the menu, open **Plugins**, then click **Install Plugin**.
1. Find the **Rate Limiting** plugin, then click **Enable**.
1. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every service and route in the workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one service, route, or consumer.

    By default, the plugin is automatically enabled when the form is submitted.
    You can also toggle the **This plugin is Enabled** button to configure the plugin without enabling it.
    For this example, keep the plugin enabled.
1. Complete only the following fields with the following parameters.
    1. config.limit: `5`
    1. config.window_size: `30`
    1. config.window_type: `sliding`
    1. config.retry_after_jitter_max: `0`
    1. config.enforce_consumer_groups: `true` 
    1. config.consumer_groups: `Bronze`
   

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.
1. Click **Install**.

## Configure rate limiting for consumer groups

In this section, you will configure the Rate Limiting Advanced plugin to set the rate limit to 6 requests every 30 seconds only for consumers in the Bronze tier.

1. Open the **default** workspace.
1. From the menu, open **Consumers**, then click the **Groups** tab.
1. Click the `Bronze` consumer group you just created.
1. Click the **Policy** tab.
1. Complete only the following fields with the following parameters.
    1. config.limit: `6`
    1. config.window_size: `30`
    1. config.window_type: `sliding`
    1. config.retry_after_jitter_max: `0`
1. Click **Save**.

