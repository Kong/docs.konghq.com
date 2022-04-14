---
title: Analyze Services and Routes
no_version: true
---

In the ServiceHub, the Service, Service version, and Route graphs provide dynamic
graphs with up to 12 hours of data. To view data beyond this time frame, export
the data into a comma-separated values (CSV) file.

You can generate and export a CSV file for:

* A Service, including daily requests by status codes for all versions of the
Service.
* A Service version, including a report of daily requests and status codes.

For a Route, you can [view status codes](#view-performance-for-a-route)
for a specified time frame but you can't export a Route traffic report through
ServiceHub.

If you want to combine multiple Services, Routes, or Applications in one report,
see [custom reports](/konnect/vitals/generate-reports/).

## Prerequisites
You have any [**Service** role or the **Organization Admin**](/konnect/org-management/users-and-roles/)
role.

## Analyze Services

### View performance for a Service

View traffic health and performance of a Service, including across all of a
Service's versions:

1. From the left-side menu, open {% konnect_icon servicehub %} **Services**, then
select a Service.

1. On the Service's detail page, the **Throughput** graph displays any API calls
that have been made against any versions of the Service for the given time frame.

    Hover over an area of the graph to view details of an event, including
    version information and time the event occurred.

1. Select a time frame to display. By default, the graph displays the last
6 hours of events.

    All time frames on this graph are dynamic.

    If you choose 5m, the graph displays all events that occured in the last five
    minutes; if you choose 6h, the graph displays all events from the last six
    hours, and so on.


### Export Service history

Generate a CSV file for a Service, including requests by time or date and
status codes for all versions of the Service.

1. From the left-side menu, open {% konnect_icon servicehub %} **Services** and
select the Service for which you want to generate a
report.
2. On the **Throughput** graph, click **Export**.
3. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
4. Click **Export**. A CSV file is generated.

## Analyze Service versions

### View performance for a Service version

To view traffic health and performance for a Service version:

1.  From the left-side menu, open {% konnect_icon servicehub %} **Services**,
then select a Service version.

    You can click on the the version number from the ServiceHub overview, or
    you can select a Service and choose your version from the Service detail page.

1. On the Service version's detail page, the **Traffic by status code** graph
displays any API calls that have been made against the current version of the
Service for the given time frame, grouped by status code.

    Hover over an area of the graph to view details, including status code
    class and count.

1. Select a time frame to display. By default, the graph displays the last 6
hours.

    All time frames on this graph are dynamic.

    If you choose 5m, the graph displays all events that occured in the last five
    minutes; if you choose 6h, the graph displays all events from the last six
    hours, and so on.

### Export Service version history

Generate a CSV file for a Service version, including requests by time or
 date and status codes for the selected version.

1. From the left-side menu, open {% konnect_icon servicehub %}
**Services** and select the Service version for which you want to generate a
report.
2. On the **Traffic by Status Code** graph, click the **Export** button.
3. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
4. Click **Export**. A CSV file is generated.

## Analyze Routes

### View performance for a Route

To view traffic health and performance for a Route:

1.  From the left-side menu, open
{% konnect_icon servicehub %} **Services**, then select a Service version.

    You can click on the the version number from the ServiceHub overview, or
    you can select a Service and choose your version from the Service detail page.

1. In the **Routes** section, click on a Route.

1. On the Route's detail page, The **Status Codes** graph displays any API
calls that have been made using the current Route in the given time frame,
grouped by status code.

    Hover over an area of the graph to view details, including status code
    class and count.

1. Customize your graph:
    * **Time frame:** Select a time frame from the dropdown, ranging from the
    last 5 minutes to the last 12 hours.
    * **Time format:** The default time format depends on your local system time.
    Set to UTC for Coordinated Universal Time.
    * **Display type:** Choose the first icon
    ( {% konnect_icon vitals-bargraph %} )
    for a vertical bar graph, or the second icon
    ( {% konnect_icon vitals-horizontal %} )
    for a horizontal line chart.

    By default, the graph displays data for the last 6 hours.

## See also

In this topic, you viewed the health and monitoring information for individual
Services, Service versions, and Routes.

For reports comparing multiple Konnect entities, see [custom reports](/konnect/vitals/generate-reports/).
