---
title: Monitoring Health with Vitals
no_search: true
no_version: true
beta: true
---

## Overview
Use Kong Vitals (Vitals) to monitor the health and performance of Kong Konnect. Vitals uses visual API analytics to see exactly how your APIs and Gateway are performing. Quickly access key statistics, monitor vital signs, and pinpoint anomalies in real-time.

There are a few ways you can view Vitals:
* Service package view
* Version view
* Route view

### Viewing Vitals from the Service Package View

1. On the Services page, click a **Service**.
2. In the Traffic section, you can see the Vitals for all the versions of your Service.

### Viewing Vitals from the Version view

1. On the Versions View, click a version to view details.
2. Status Codes display for the selected version. The Status Codes display visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx). The Status Codes view contains the counts of status code classes graphed over time, as well as the ratio of code classes to total requests.

### Viewing Vitals from the Route view

1. On the example_service view, in the Versions section click the **v1** to view details.
2. On the v1 overview, click the Route to display details.
3. On the **mockbin** Route view, the Status Codes section displays. Status Codes display visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx). The Status Codes view contains the counts of status code classes graphed over time, as well as the ratio of code classes to total requests.
