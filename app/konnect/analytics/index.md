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

In the [Service Hub](https://cloud.konghq.com/servicehub/), you can see
[activity graphs](/konnect/analytics/services-and-routes/) for services, service versions, or
routes for the past 30 days.
For services, these graphs display request counts. For service versions and
routes, the graphs show requests broken down by status codes.

![service graph](/assets/images/docs/konnect/konnect-vitals-service-versions.png)

> _**Figure 1:** Graph showing throughput for a service with interval filter options._

For greater insights into your service usage, access the dedicated {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics) page <span class="badge plus"></span>.

From Analytics, you can view dashboards, access historical data for a range greater than 30 days, and customize the entities in a report:
* View the [Analytics dashboard](/konnect/analytics/summary-dashboard) to track traffic, errors by error code, and latency across all services in your organization.
* [Export historical data in CSV format](/konnect/analytics/services-and-routes/) for any individual service, service version, or route.
* [Create a custom report](/konnect/analytics/use-cases/) for any number of services, routes, or applications, filtered by time frame and grouped by metric.

![traffic analytics graph](/assets/images/docs/konnect/konnect-vitals-traffic.png)
> _**Figure 2:** Graph showing successful and failed requests over the past three hours._

## Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This gives you the ability to allow certain users to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).
