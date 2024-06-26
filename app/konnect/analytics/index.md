---
title: Advanced Analytics
---


## What is {{site.konnect_short_name}} Advanced Analytics

{{site.konnect_short_name}} Advanced Analytics  is a real-time, highly contextual analytics platform that offers deep insights into API health, performance, and usage. It has been designed to help businesses optimize their API strategies and improve operational efficiency and is now offered as a premium (paid) service within Kong Konnect.

![Summary dashboard](/assets/images/products/konnect/analytics/konnect-summary-dashboard.png){:.image-border}

Konnect Advanced Analytics offers:
* Cost-savings: {{site.konnect_short_name}} Advanced Analytics provides a cost-effective analytics solution without the need for significant infrastructure investments, additional staffing or unnecessary 3rd party expenses.
* Centralized visibility: Delivers comprehensive, centralized insights across your entire API landscape for all APIs, services and data planes.
* Contextual API Analytics: {{site.konnect_short_name}} Advanced Analytics offers information about each API request, including the specific routes, consumers involved, and the services accessed
* Data insights: {{site.konnect_short_name}} Advanced Analytics provides data in as fast as 10 second increments, delivering comprehensive contextual insights, including links directly to Gateway configurations. 



## Advanced Analytics capabilities

{{site.konnect_short_name}} Analytics {% konnect_icon analytics %} provides different tools to help you track the performance and behavior of your APIs and data plane nodes. You can use these tools to access key statistics, monitor vitals, and pinpoint anomalies in real-time.

You can use the following table to help you determine which analytics tools are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Quickly understand API usage and performance at a glance, and gain insights across your entire organization. | [Summary dashboard](/konnect/analytics/dashboard/) |
| Browse API usage data to gain access to key performance and health statistics. Visualize, slice, and dice API usage data you’ve stored in only a few clicks. | [Explorer](/konnect/analytics/explorer/) |
| Communicate contextual insights across teams or departments and share important KPIs. | [Custom reports](/konnect/analytics/custom-reports/) |
| Understand user behavior or pinpoint where issues occur. See detailed information about each individual request made to your APIs. | [Requests](/konnect/analytics/api-requests/)  |
| Manage Advanced Analytics costs.| [Scoping control planes](/konnect/analytics/#control-plane-scoping) |

### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [custom reports](/konnect/analytics/generate-reports/) to 50. If this limit is exceeded, a warning icon displays at the top of the affected graph or report.

### Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This allows you to give certain users access to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).


### Control plane scoping

You can scope Advanced Analytics to specific control planes. This allows you to generate analytics for individual control planes and manage costs effectively.

## More information

See the [network communications FAQ](/konnect/network-resiliency/) to learn how {{site.konnect_short_name}} handles telemetry data, and what happens in the event of a disconnect.
