---
title: Introduction to Monitoring Health with Analytics
---

You can monitor the health and performance of any service, service version,
route, or application managed by {{site.konnect_saas}}.

Analytics provides traffic reports to help you track the performance and
behavior of your APIs and runtimes. Use these reports to quickly access key
statistics, monitor vital signs, and pinpoint anomalies in real time.

Depending on your {{site.konnect_saas}} subscription tier, Analytics retains
historical data for the following lengths of time:
* **Free:** 24 hours
* **Plus:** 6 months
* **Enterprise:** 1 year

## Contextual analytics for services and routes

In the [Service Hub](https://cloud.konghq.com/servicehub/), you can see
[activity graphs](/konnect/analytics/services-and-routes/) for services, service versions, or
routes for the past 30 days.
For services, these graphs display request counts. For service versions and
routes, the graphs show requests broken down by status codes.

![service graph](/assets/images/docs/konnect/konnect-vitals-service-versions.png){:.image-border}

> _**Figure 1:** Graph showing throughput for a service with interval filter options._

You can also [export this historical data in CSV format](/konnect/analytics/services-and-routes/) for any individual service, service version, or route.


## Summary dashboard and custom reports

For greater insights into your service usage, access the dedicated {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics) page.

From {% konnect_icon analytics %} Analytics, you can view dashboards, access historical data for a range greater than 30 days, and customize the entities in a report:
* View the Analytics summary dashboard to track traffic, errors by error code, and latency across all services in your organization.
* [Export historical data in CSV format](/konnect/analytics/services-and-routes/) for any individual service, service version, or route.
* [Create a custom report](/konnect/analytics/generate-reports/) for any number of services, routes, or applications, filtered by time frame and grouped by metric.

The summary dashboard provides metrics for services cataloged by Service Hub within a selected time interval for the following categories:

* **Traffic**
* **Errors**
* **Latency**

These categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.
You can view a graph for each category by clicking **Traffic**, **Errors**, or **Latency**, and switching between the views.

* **Traffic**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval.
    * Successful requests contain all requests that returned a **1xx-3xx** status code.
    * Failed requests contain all requests that returned a **4xx-5xx** status code.
    * 6xx status codes are not reported.

    ![traffic analytics graph](/assets/images/docs/konnect/konnect-vitals-traffic.png){:.image-border}
    > _**Figure 2:** Graph showing successful and failed requests over the past three hours._

* **Errors**: This graph displays the total number of failed HTTP requests categorized by error response codes over the specified time interval. Error response codes include any **4xx-5xx** status codes.

    ![errors analytics graph](/assets/images/docs/konnect/konnect-vitals-errors.png){:.image-border}
    > _**Figure 3:** Graph showing errors by 4xx and 5xx error codes received over the past three hours._

* **Latency**: This graph displays request latency, in milliseconds, of the 99th, 95th, and 50th percentiles.
Admins can monitor the latency, investigate where delays are noticed, and optimize performance for APIs.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through runtime instances running {{site.base_gateway}} 3.0.0.0 or later.

   ![latency analytics graph](/assets/images/docs/konnect/konnect-analytics-latency.png){:.image-border}
  > _**Figure 4:** Graph showing latency as a percentage over the past 15 minutes._

Graphs can be interacted with, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**.

You can select a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.

## Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This gives you the ability to allow certain users to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).
