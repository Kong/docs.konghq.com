---
title: Advanced Analytics
---


Konnect Advanced Analytics simplifies access to comprehensive, context-rich API usage and performance data in near real-time for swift issue resolution and insights to drive business strategy. Konnect provides embedded reports at various different levels throughout its user interface. Our embedded reports help to stop switching away from your current page to start investigating or derive insights. For example, in the Gateway Manager, you can see activity graphs for gateway services or routes. For gateway services and routes, the graphs show requests broken down by status codes. You can monitor the health and performance of any API product, route, or application managed by {{site.konnect_product_name}}.



![service graph](/assets/images/products/konnect/analytics/konnect-analytics-gateway-service.png){:.image-border}

## Analytics Overview  
{:.badge .advanced}

Konnect offers two levels of analytics: Basic and Advanced. This allows you to choose the level of insight and control that best fits your needs.

| Feature                          | Basic                                     | Advanced           <span class="badge advanced"></span>                                  |
|----------------------------------|------------------------------------------------------------|------------------------------------------------------------|
| **Data Retention**               | 7 days                                                     | 30 days for common dimensions, 425 days for long-term trend anayltics|
| **Data Granularity**             | 1 minute                                                   | 10 seconds                                                 |
| **Delay**                        | About 1 minute                                             | About 1 minute                                             |
| **Chart Type**                   | Contextual charts                                          | Contextual charts, advanced dimensions (http, method, user, agent)|
| **Analytics Summary dashboard**  | No                                                         | Yes                                                        |
| **Reports**                      | No                                                         | Yes                                                        |
| **Requests**                     | No                                                         | Yes                                                        |
| **Dev Portal Analytics**         | No                                                         | Yes                                                        |

| Feature                                   | Basic Analytics                   | Advanced Analytics          |
|-------------------------------------------|-----------------------------------|-----------------------------|
| **Analytics Retention**                   | 7 days                            | 425 days                    | 
| **Request Retention**                     | 0 days                            | 14 days                     | 
| **Minimum Granularity**                   | Minutely                          | 10 seconds                  | 
| **Arrival Delay**                         | Minutes                           | Milliseconds                | 
| **API Requests**                          | No                                | Yes                         | 
| **Contextual Graphs**                     | Yes                               | Yes                         | 
| **Custom Reporting**                      | No                                | Yes                         | 
| **Advanced Dimensions**                   | No                                | Yes                         | 
| **Consumer Analytics**                    | No                                | Yes                         | 
| **Application Analytics**                 | No                                | Yes                         | 
| **Portal Analytics**                      | No                                | Yes                         | 
| **Tracing**                               | No                                | No                          | 
| **Geo IP**                                | No                                | 425 days                    | 
| **User Agent**                            | No                                | 30 days                     | 
| **HTTP Method**                           | No                                | 30 days                     | 
| **HTTP Path**                             | No                                | 30 days                     | 
| **Developer**                             | No                                | 425 days                    | 
| **Portal**                                | No                                | 30 days                     | 
| **Consumers**                             | No                                | 30 days                     |
| **Applications**                          | No                                | 30 days                     | 
| **Content Type**                          | No                                | 30 days                     |
| **Request Size (avg)**                    | No                                | 425 days                    | 
| **Request Size (p50, p90, p95)**          | No                                | 30 days                     | 
| **Response Size (avg)**                   | No                                | 425 days                    | 
| **Response Size (p50, p90, p95)**         | No                                | 30 days                     | 
| **Upstream Latency (p50, p90, p95, p99)** | No                                | 30 days                     | 
| **Upstream Latency (average)**            | Yes                               | 425 days                    | 
| **Kong Latency (p50, p90, p95, p99)**     | No                                | 30 days                     | 
| **Kong Latency (average)**                | Yes                               | 425 days                    | 
| **Request Latency (p50, p90, p95, p99)**  | No                                | 30 days                     |
| **Request Latency (average)**             | Yes                               | 425 days                    | 

## Analyze API usage and performance data

{{site.konnect_short_name}} Analytics {% konnect_icon analytics %} provides different tools to help you track the performance and behavior of your APIs and data plane nodes. You can use these tools to access key statistics, monitor vitals, and pinpoint anomalies in real-time.

You can use the following table to help you determine which analytics tools are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Quickly understand API usage and performance at a glance, and gain insights across your entire organization. | [Summary dashboard](/konnect/analytics/dashboard/) |
| Browse API usage data to gain access to key performance and health statistics. Visualize, slice, and dice API usage data you’ve stored in only a few clicks. | [Explorer](/konnect/analytics/explorer/) |
| Communicate insights across teams or departments and share important KPIs. | [Custom reports](/konnect/analytics/custom-reports/) |
| Understand user behavior or pinpoint where issues occur. See detailed information about each individual request made to your APIs. | [Requests](/konnect/analytics/api-requests/)  |

### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [custom reports](/konnect/analytics/generate-reports/) to 50. If this limit is exceeded, a warning icon displays at the top of the affected graph or report.

### Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This allows you to give certain users access to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).

## More information

See the [network communications FAQ](/konnect/network-resiliency/) to learn how {{site.konnect_short_name}} handles telemetry data, and what happens in the event of a disconnect.
