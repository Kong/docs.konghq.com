---
title: Monitoring Health with Vitals
no_version: true
---

Use {{site.konnect_short_name}} Vitals (Vitals) to monitor the health and
performance of a Service managed by {{site.konnect_product_name}}
({{site.konnect_short_name}}). Vitals uses visual API analytics to see exactly
how your APIs and runtimes are performing. Quickly access key statistics,
monitor vital signs, and pinpoint anomalies in real time.

Vitals charts are available from:
* Any Service's overview page, which displays request count, failed requests by
status codes, and includes all versions of the Service filtered by timeframe.
You can also export a report of a Service's
performance data.
* Any Service version or Route page, which display status codes filtered by
timeframe. You can also export a report of version peformance data.

<div class="alert alert-ee blue">
<b>Note:</b> The activity graphs in the ServiceHub only show the past 12 hours
of activity. To see historical data for a greater range,
<a href="/konnect/legacy/vitals/generate-reports">generate a report</a>.
</div>

{{site.konnect_saas}} has Vitals enabled by default.

## View Vitals performance for a Service

To view traffic health and performance of a Service, including across all of a
Service's versions:

1. From the ServiceHub, select a **Service**.

2. In the **Traffic** section, the Vitals graph displays any events that have
occurred for all of the versions of the Service. Hover over an area of the
graph to view details of an event, including version information and time the
event occurred.

3. Select a timeframe to display. By default, the graph displays the last
6 hours of events.

![Konnect Vitals Services View](/assets/images/docs/konnect/konnect-vitals-services.png)


## View Vitals performance for a Service version

To view traffic health and performance for a Service version:

1. From the ServiceHub, select a **Service version**.

2. In the **Status Codes** section, events display in a graph for the selected
version. Hover over an area of the graph to view details, including status code
class and count.

3. Select a timeframe to display. By default, the graph displays the last 6
hours of events.

![Konnect Vitals Service Version Status Codes](/assets/images/docs/konnect/konnect-vitals-status-codes.png)

For more information about status codes, see
[Vitals Status Codes](/gateway/latest/vitals/vitals-metrics/#status-codes).


## View Vitals performance for a Route

To view traffic health and performance for a Route:

1. From the ServiceHub, select a **Service version**.

2. In the **Routes** section, click on a Route.

4. In the **Status Codes** section, events display in a graph for the selected
route. Hover over an area of the graph to view details, including status code
class and count.

5. To customize the view, select a timeframe, Coordinated Universal Time (UTC),
and list view or graph view. By default, the graphs display data for the last 6
hours.

For more information about status codes, see
[Vitals Status Codes](/gateway/latest/vitals/vitals-metrics/#status-codes).


## Vitals terms

**Request Count**
: Displays a count of all proxy requests received. This includes requests that
were rejected due to rate limiting, failed authentication, and so on.

**Status Codes**
: Displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx,
  4xx, 5xx). The Status Codes view contains the counts of status code classes
  graphed over time, as well as the ratio of code classes to total requests.

**Timeframe selector**
: Controls the timeframe of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or
days resolution data.

**Traffic metrics**
: Provide insight into which of your Services and Service versions are being
used and how they are responding.


## Summary and Next Steps

In this topic, you viewed the health and monitoring information for
Services, Service versions, and Routes.

Next, learn how to [export a report](/konnect/legacy/vitals/generate-reports) of Vitals performance information.
