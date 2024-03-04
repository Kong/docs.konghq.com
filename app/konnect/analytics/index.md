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


### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [custom reports](/konnect/analytics/generate-reports/) to 50. If this limit is exceeded, a warning icon displays at the top of the affected graph or report. 


### Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This allows you to give certain users access to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).
