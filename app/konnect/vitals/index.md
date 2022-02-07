---
title: Monitoring Health with Vitals
no_version: true
---

You can monitor the health and performance of any Service, Service version, or Route
managed by {{site.konnect_saas}}.

Vitals uses visual API analytics to see exactly how your APIs and runtimes are
performing. Quickly access key statistics, monitor vital signs, and pinpoint
anomalies in real time.

Vitals charts are available for:

* Individual Services, Service versions, or Routes for the past 12 hours:
  * From the ServiceHub, access any Service's overview page, which displays
  request count, failed requests by status codes, and includes all versions of
  the Service filtered by time frame.
  * From the ServiceHub, see any Service version or Route page, which displays
  status codes filtered by time frame.

* Multiple Services, Routes, and Applications:
  * Use the Vitals overview to see traffic for all Services in the organization.
  * Create custom reports for any number of Services, Routes, or Applications
  filtered by time frame and grouped by metric.

{:.note}
> **Note:** The activity graphs in the ServiceHub only show the past 12 hours
of activity. To see historical data for a greater range, you can:
* [Export a report in CSV format](/konnect/vitals/generate-reports) for any
individual Service, Service version, or Route.
* [Create a custom report](/konnect/vitals/custom-reports) to group multiple
Services, Routes, or Applications.

## View performance for a Service

View traffic health and performance of a Service, including across all of a
Service's versions:

1. From the left-side menu, open
![](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .no-image-expand}
**Services**, then select a Service.

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

## View performance for a Service version

To view traffic health and performance for a Service version:

1.  From the left-side menu, open
![](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .no-image-expand}
**Services**, then select a Service version.

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

## View performance for a Route

To view traffic health and performance for a Route:

1.  From the left-side menu, open
![](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .no-image-expand}
**Services**, then select a Service version.

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
    ( ![](/assets/images/icons/konnect/icn-vitals-bargraph.svg){:.inline .no-image-expand} )
    for a vertical bar graph, or the second icon
    ( ![](/assets/images/icons/konnect/icn-vitals-horizontal.svg){:.inline .no-image-expand} )
    for a horizontal line chart.

    By default, the graph displays data for the last 6 hours.


## Terms

**Request Count**
: Displays a count of all proxy requests received. This includes requests that
were rejected due to rate limiting, failed authentication, and so on.

**Status Codes**
: Displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx,
  4xx, 5xx). The Status Codes view contains the counts of status code classes
  graphed over time, as well as the ratio of code classes to total requests.

**Time frame selector**
: Controls the timeframe of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or
days resolution data.

**Traffic metrics**
: Provide insight into which of your Services and Service versions are being
used and how they are responding.

## See also

In this topic, you viewed the health and monitoring information for individual
Services, Service versions, and Routes. You can also:

* [Export a report in CSV format](/konnect/vitals/generate-reports) for any
individual Service, Service version, or Route.
* [Create a custom report](/konnect/vitals/custom-reports) to group multiple
Services, Routes, or Applications.
