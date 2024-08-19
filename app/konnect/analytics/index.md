---
title: Konnect Advanced Analytics
---


## What is {{site.konnect_short_name}} Advanced Analytics?

{{site.konnect_short_name}} Advanced Analytics is a real-time, highly contextual analytics platform that offers deep insights into API health, performance, and usage. It has been designed to help businesses optimize their API strategies and improve operational efficiency and is offered as a premium service within {{site.konnect_short_name}}.

![Summary dashboard](/assets/images/products/konnect/analytics/konnect-api-usage-summary.png){:.image-border}

Konnect Advanced Analytics offers:

* **Centralized visibility**: Delivers comprehensive, centralized insights across your entire API landscape for all APIs, services and data planes.
* **Contextual API analytics**: {{site.konnect_short_name}} Advanced Analytics offers information about each API request, including the specific routes, consumers involved, and the services accessed.
* **Democratized data insights**: {{site.konnect_short_name}} empowers both business and platform teams to generate reports for any service, route, or consumer based on their specific requirements.
* **Fastest time to insight**: Provide application and platform teams with critical API metrics for each service in less than a second for reduced time to resolution.
* **Reduced cost of ownership**: Advanced Analytics is a turn-key analytics solution that removes the need to build, maintain or integrate with third-party products.


## Advanced Analytics capabilities

{{site.konnect_short_name}} Advanced Analytics {% konnect_icon analytics %} provides different tools to help you track the performance and behavior of your APIs and data plane nodes. You can use these tools to access key statistics, monitor vitals, and pinpoint anomalies in real-time.

The primary goal of {{site.konnect_short_name}} Advanced Analytics is to make important API usage and performance data easily accessible for both business users and platform and application teams. The interface is designed to be user-friendly and intuitive, ensuring that users can quickly find the information they need and derive valuable insights effortlessly.

You can use the following table to help you determine which analytics tools are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Quickly understand API usage and performance at a glance, and gain insights across your entire organization. | [Summary dashboard](/konnect/analytics/dashboard/) |
| Browse API usage data to gain access to key performance and health statistics. Visualize, slice, and dice API usage data you’ve stored in only a few clicks. | [Explorer](/konnect/analytics/explorer/) |
| Communicate insights across teams or departments and share important KPIs. | [Custom reports](/konnect/analytics/custom-reports/) |
| Understand user behavior or pin point where issues occur. See detailed information about each individual request made to your APIs. | [Requests](/konnect/analytics/api-requests/)  |
| Manage Analytics cost for individual control planes| [Data ingestion](/konnect/analytics/#data-ingestion) |


### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [custom reports](/konnect/analytics/use-cases/) to 50. If this limit is exceeded, a warning icon displays at the top of the affected graph or report.

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


### Data ingestion

Data ingestion is managed from the **Control Plane Dashboard**, using the Advanced Analytics toggle, which allows you to turn ingestion and data collection on or off for your API traffic within a given control plane.

This feature provides flexibility in managing your data insights and can help you control costs. There are two states: 

* **On**: When Advanced Analytics is enabled, both basic and advanced data is collected. This gives you valuable insights into API traffic and allows you to generate detailed custom reports.
* **Off**: When you disable Advanced Analytics, the collection of advanced data stops. However, basic data continues to be collected. This ensures that you still have essential insights and that contextual features in {{site.konnect_short_name}} remain functional.

When Advanced Analytics is set to **off**, new analytics data for this control plane will not appear in [custom reports](/konnect/analytics/use-cases/) or [API requests](/konnect/analytics/api-requests/), but you will still have access to basic API usage information within the gateway manager.

It is only possible to toggle Advanced Analytics for the entity your data planes are connected to. If you are using control plane groups, the toggle will only have an effect on the group, not on member CPs.

{:.note}
> **Transition Time**: When you change the toggle for a control plane, it may take a few minutes for the setting to take effect. During this time, you may see partial data in Advanced Analytics for your data planes.

## More information

See the [network communications FAQ](/konnect/network-resiliency/) to learn how {{site.konnect_short_name}} handles telemetry data, and what happens in the event of a disconnect.
