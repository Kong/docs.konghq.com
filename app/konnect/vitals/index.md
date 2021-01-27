---
title: Monitoring Health with Vitals
no_version: true
---

## Overview
Use Kong Vitals (Vitals) to monitor the health and performance of a Service
managed by {{site.konnect_product_name}} (Konnect). Vitals uses visual API
analytics to see exactly how your APIs and Gateway are performing. Quickly
access key statistics, monitor vital signs, and pinpoint anomalies in real time.

There are a few ways you can view Vitals:
* Services view
* Version view
* Route view

## View Vitals for a Service

To view traffic volume across all of a Service's versions:

1. On the Services page, select a **Service** to view the Service Overview.

2. In the Traffic section, the Vitals graph displays events for all the
versions of your Service. Hover over an area of of the graph to view details,
including version information and time of the event.

    By default, the graphs display data for the past 30 minutes. To see data
    for a longer or shorter period of time, see the
    [Version overview](#view-vitals-for-a-version) or the
    [Route Overview](#view-vitals-for-a-route).

    For more information about Vitals, see [Vitals](/enterprise/2.1.x/vitals/).

![Vitals Status Codes in Konnect Service Version Overview](/assets/images/docs/konnect/konnect-vitals-service-overview.png)


## View Vitals for a Version

To view traffic volume for a Service Version:

1. On the Services page, select a **Service** to view the Service Overview.

2. Click a **Service Version** to view the Version Overview.

3. In the Status Codes section, events display for the selected version and
include:

    1. Visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx,
    5xx).

    2. Counts of status code classes graphed over time, as well as the ratio
    of code classes to total requests.

4. To customize the view, select a timeframe, Coordinated Universal Time (UTC),
list view or graph view.

    By default, the graphs display data for the past five minutes. If you've
    recently made requests to any Route associated with this Service Version
    and can't see any data, switch the timeframe to a longer period.

    For more information about Status Codes, see
    [Vitals Status Codes](/enterprise/2.1.x/vitals/vitals-metrics/#status-codes).

![Vitals graph in Konnect Services Overview](/assets/images/docs/konnect/konnect-vitals-version-status-codes.png)


## View Vitals for a Route

To view traffic volume for a Route:

1. On the Services page, select a **Service** to view the Service overview.

2. In the Versions section, click a **Version** to display the Version overview.

1. In the Routes section, click a **Route** to view the Route overview.

2. In the Status Codes section, events display for the route and include:  

    1. Visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx,
    5xx).

    2. Counts of status code classes graphed over time, as well as the ratio of
    code classes to total requests.

4. To customize the view, select a timeframe, Coordinated Universal Time (UTC),
list view or graph view.

    By default, the graphs display data for the past five minutes. If you've
    recently made accessed the Route and can't see any data, switch the
    timeframe to a longer period.

    For more information about Status Codes, see
    [Vitals Status Codes](/enterprise/2.1.x/vitals/vitals-metrics/#status-codes).

![Vitals graph in Konnect Route Overview](/assets/images/docs/konnect/konnect-vitals-route-status-codes.png)


## Summary and Next Steps

In this topic, you viewed the health and monitoring information for Services,
Service Versions, and Routes.

Next, [upload documentation and a spec](/konnect/getting-started/dev-portal)
for your Service and Service Version, then publish them to the Developer Portal.
