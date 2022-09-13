---
title: Analyze Services and Routes
no_version: true
content_type: how-to
---

In the Service Hub, the service, service version, and route graphs provide dynamic
graphs with up to 30 days of data. To view data beyond this time frame, export
the data into a comma-separated values (CSV) file.

![service graph](/assets/images/docs/konnect/konnect-vitals-service-versions.png)
> _**Figure 1:** Graph showing throughput for a service with interval filter options._

You can generate and export a CSV file for:

* A service, including daily requests by status codes for all versions of the
service.
* A service version, including a report of daily requests and status codes.

For a route, you can [view status codes](#view-performance-for-a-route)
for a specified time frame but you can't export a route traffic report through
Service Hub.

If you want to combine multiple services, routes, or applications in one report,
see [custom reports](/konnect/analytics/generate-reports/).

## Analyze services

### View performance for a service

You can view traffic health and performance of an individual service, including across all of a
service's versions.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service.
On the service's detail page, the **Throughput** graph displays all API calls
that have been made across every version for the given time frame.

From the **Throughput** graph, you can:

* Hover over an area of the graph to view event details, including
version information and time the event occurred.

* Select a time frame to display. By default, the graph displays the last six hours of events.

All time frames on this graph are dynamic.

If you choose 5m, the graph displays all events that occurred in the last five
minutes; if you choose 6h, the graph displays all events from the last six
hours.

### Export service history

Generate a CSV file for a service, including requests by time or date and
status codes for all versions of the service.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, then follow these steps:

1. On the **Throughput** graph, click **Export**.
1. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
1. Click **Export** to generate and download CSV file.

## Analyze service versions

### View performance for a service version

You can view traffic health and performance for a service version.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.
On the service version's detail page, the **Traffic by status code** graph
displays any API calls that have been made against the current version of the
service for the given time frame, grouped by status code.

From the **Traffic by status code** graph, you can:

* Hover over an area of the graph to view details, including status code
class and count.

* Select a time frame to display. By default, the graph displays the last six hours.

All time frames on this graph are dynamic.

If you choose 5m, the graph displays all events that occurred in the last five
minutes. If you choose 6h, the graph displays all events from the last six
hours.

### Export service version history

Generate a CSV file for a service version, including requests by time or
 date and status codes for the selected version.


From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version, then follow these steps:

1. On the **Traffic by Status Code** graph, click the **Export** button.
1. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
1. Click **Export** to generate and download a CSV file.

## Analyze routes

### View performance for a route

You can view traffic health and performance for a route.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version, then choose a route.

On the route's detail page, the **Traffic by Status Code** graph displays any API
calls that have been made using the current route in the given time frame,
grouped by status code.

From the **Traffic by Status Code** graph, you can:

* Hover over an area of the graph to view details, including status code
class and count.

* Customize your graph:
    * **Time frame:** Select a time frame from the dropdown, ranging from the
    last five minutes to the last 30 days.
    * **Time format:** The default time format depends on your local system time.
    Set to UTC for Coordinated Universal Time.
    * **Display type:** Choose the first icon
    ( {% konnect_icon analytics-bargraph %} )
    for a vertical bar graph, or the second icon
    ( {% konnect_icon analytics-horizontal %} )
    for a horizontal line chart.

    By default, the graph displays data for the last six hours.

## See also

In this topic, you viewed the health and monitoring information for individual
services, service versions, and routes.

For reports comparing multiple {{site.konnect_short_name}} entities, see [custom reports](/konnect/analytics/generate-reports/).
