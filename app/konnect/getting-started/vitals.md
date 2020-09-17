---
title: Monitoring Health with Vitals
no_search: true
no_version: true
beta: true
---

## Overview
Use Kong Vitals (Vitals) to monitor the health and performance of Kong Konnect (Konnect). Vitals uses visual API analytics to see exactly how your APIs and Gateway are performing. Quickly access key statistics, monitor vital signs, and pinpoint anomalies in real-time.

There are a few ways you can view Vitals:
* Services view
* Version view
* Route view

### Viewing Vitals from the Services Overview
To view Status Codes for all of your Services, use these steps.
1. On the Services page, select a **Service** to view the Service Overview.
2. In the Traffic section, the Vitals graph displays events for all the versions of your Service. Hover over an area of of the graph to view details including version information and time of the event.
For more information about Vitals, see [Vitals](/enterprise/2.1.x/vitals/).

![Vitals Status Codes in Konnect Service Version Overview](/assets/images/docs/getting-started-guide/konnect-vitals-status-codes.png)

### Viewing Vitals from the Versions View
To view Status Codes for a Service Version, use these steps. 
1. On the Services page, select a **Service** to view the Service Overview.
2. Click a **Service Version** to view the Version Overview.
3. In the Status Codes section, events display for the selected version and include:
  * visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx). 
  * counts of status code classes graphed over time, as well as the ratio of code classes to total requests.
4. To customize the view, select a timeframe, Coordinated Universal Time (UTC), list view or graph view. 
For more information about Status Codes, see [Vitals Status Codes](/enterprise/2.1.x/vitals/vitals-metrics/#status-codes).

![Vitals graph in Konnect Services Overview](/assets/images/docs/getting-started-guide/konnect-vitals-versions-overview.png)


### Viewing Vitals from the Routes View
To view Status Codes for a Route, use these steps. 
1. On the Services page, select a **Service** to view the Service Overview.
2. In the Versions section, click a **Version** to display the Version Overview. 
1. In the Routes section, click a **Route** to view the Route Overview. 
2. In the Status Codes section, events display for the route and include:  
  * visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx). 
  * contains the counts of status code classes graphed over time, as well as the ratio of code classes to total requests.
For more information about Status Codes, see [Vitals Status Codes](/enterprise/2.1.x/vitals/vitals-metrics/#status-codes).

