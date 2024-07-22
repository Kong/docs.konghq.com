---
title: Introduction to Monitoring Health with Analytics
---


You can monitor the health and performance of any API product, route, or application managed by {{site.konnect_product_name}}.

Konnect provides embedded reports at various different levels throughout its user interface. Our embedded reports help to stop switching away from your current page to start investigating or derive insights. For example, in the Gateway Manager, you can see activity graphs for gateway services or routes. For gateway services and routes, the graphs show requests broken down by status codes.

![service graph](/assets/images/products/konnect/analytics/konnect-analytics-gateway-service.png){:.image-border}

## Analyze API usage and performance data

{{site.konnect_short_name}}  Analytics {% konnect_icon analytics %} provides different tools to help you track the performance and behavior of your APIs and data plane nodes. You can use these tools to access key statistics, monitor vitals, and pinpoint anomalies in real time. 

You can use the following table to help you determine which analytics tools are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Quickly understand API usage and performance at a glance, and gain insights across your entire organization. | [Summary dashboard](/konnect/analytics/dashboard/) |
| Browse API usage data to gain access to key performance and health statistics. Visualize, slice, and dice API usage data you’ve stored in only a few clicks. | [Explorer](/konnect/analytics/explorer/) |
| Communicate insights across teams or departments and share important KPIs. | [Custom reports](/konnect/analytics/custom-reports/) |
| Understand user behavior or pin point where issues occur. See detailed information about each individual request made to your APIs. | [Requests](/konnect/analytics/api-requests/)  |
| Manage Analytics cost for individual control planes| [Data ingestion](/konnect/analytics/#data-ingestion) |


### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [custom reports](/konnect/analytics/generate-reports/) to 50. If this limit is exceeded, a warning icon displays at the top of the affected graph or report. 


### Data ingestion

Data ingestion is managed from the **Control Plane Dashboard**, using the analytics toggle, which allows you to turn ingestion and data collection on or off for your API traffic within a given control plane.

This feature provides flexibility in managing your data insights and can help you control costs. There are two states: 

* **On**: When analytics is enabled, both basic and advanced data is collected. This gives you valuable insights into API traffic and allows you to generate detailed custom reports.
* **Off**: When you disable analytics, the collection of advanced data stops. However, basic data continues to be collected. This ensures that you still have essential insights and that contextual features in {{site.konnect_short_name}} remain functional.

When analytics is set to **off**, new analytics data for this control plane will not appear in [custom reports](/konnect/analytics/use-cases/) or [API requests](/konnect/analytics/api-requests/), but you will still have access to basic API usage information within the gateway manager.

It is only possible to toggle analytics for the entity your data planes are connected to. If you are using control plane groups, the toggle will only have an effect on the group, not on member CPs.

{:.note}
> **Transition Time**: When you change the toggle for a control plane, it may take a few minutes for the setting to take effect. During this time, you may see partial data in analytics for your data planes.

### Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This allows you to give certain users access to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).

## More information

See the [network communications FAQ](/konnect/network-resiliency/) to learn how {{site.konnect_short_name}} handles telemetry data, and what happens in the event of a disconnect.