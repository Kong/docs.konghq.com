---
title: Introduction to Monitoring Health with Analytics
no_version: true
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

In the [Service Hub](https://cloud.konghq.com/servicehub/), you can see
[activity graphs](/konnect/analytics/services-and-routes/) for services, service versions, or
routes for the past 30 days.
For services, these graphs display request counts. For service versions and
routes, the graphs show requests broken down by status codes.

![service graph](/assets/images/docs/konnect/konnect-vitals-service-versions.png)

> _**Figure 1:** Graph showing throughput for a service with interval filter options._

For greater insights into your service usage, access the dedicated {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics) page <span class="badge plus"></span>.

From Analytics, you can view dashboards, access historical data for a range greater than 30 days, and customize the entities in a report:
* View the [Analytics dashboard](/konnect/analytics/overview-dashboard) to track traffic and errors by error code across all services in your organization.
* [Export historical data in CSV format](/konnect/analytics/services-and-routes/) for any individual service, service version, or route.
* [Create a custom report](/konnect/analytics/generate-reports/) for any number of services, routes, or applications, filtered by time frame and grouped by metric.

![traffic analytics graph](/assets/images/docs/konnect/konnect-vitals-traffic.png)
> _**Figure 2:** Graph showing successful and failed requests over the past three hours._

 ![errors analytics graph](/assets/images/docs/konnect/konnect-vitals-errors.png)
> _**Figure 3:** Graph showing errors by 4xx and 5xx error codes received over the past three hours._

## Time intervals

Interval | Description  
------|----------|
Last 15 minutes | Data is aggregated in ten second increments.
Last hour| Data is aggregated in one minute increments.
Last three hours | Data is aggregated in one minute increments.
Last six hours | Data is aggregated in ten minute increments.
Last 12 hours| Data is aggregated in ten minute increments.
Last 24 hours| Data is aggregated in ten minute increments.
Last seven days | Data is aggregated in one hour increments.
Last 30 days | Data is aggregated in one hour increments.

{:.important}
> Free tier users can only select intervals up to 24 hours.

## Terms

**Request Count**
: Displays a count of all proxy requests received. This includes requests that
were rejected due to rate limiting, failed authentication, and so on.

**Status Codes**
: Displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx,
  4xx, 5xx). The Status Codes view contains the counts of status code classes
  graphed over time, as well as the ratio of code classes to total requests.

**Time frame selector**
: Controls the time frame of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or
days resolution data.

**Traffic metrics**
: Provide insight into which of your services and service versions are being
used and how they are responding.
