---
title: Vitals Overview
---

## Overview

Use Kong Vitals (Vitals) to monitor {{site.ee_product_name}} health and performance, and to understand the microservice API transactions traversing Kong. Vitals uses visual API analytics to see exactly how your APIs and Gateway are performing. Quickly access key statistics, monitor vital signs, and pinpoint anomalies in real time.

* Use Kong Admin API to access Vitals data via endpoints. Additional visualizations, including dashboarding of Vitals data alongside data from other systems, can be achieved using the Vitals API to integrate with common monitoring systems.

* Use Kong Manager to view visualizations of Vitals data, including the Workspaces Overview Dashboard, Workspace Charts, Vitals tab, and Status Codes, and to generate CSV Reports.


![Vitals Overview](/assets/images/docs/ee/vitals_overview.png)


### Prerequisites
Vitals is enabled by default in {{site.ee_product_name}} and available upon the first login of a Super Admin.

You will need one of the following databases to use Vitals:
* InfluxDB
* PostgresSQL 9.5+
* Cassandra 2.1+

### Guidelines for viewing Vitals
When using Vitals, note:
* Vitals is enabled by default and accessible the first time a Super Admin logs in.
  * To enable or disable Vitals, see [Enable or Disable Vitals](#enable-or-disable-vitals).
* Any authorized user can view Vitals for the entire Kong cluster or for a particular Workspace.
  * If a user does not have access to a Workspace, its Vitals are hidden from view.
  * If a user does not have access to Vitals data, charts will not display.

## Vitals API
Vitals data is available via endpoints on Kong’s Admin API. Access to these endpoints may be controlled via Admin API RBAC. The Vitals API is described in the OAS (Open API Spec, formerly Swagger) file. See a sample here (downloadable file): [`vitalsSpec.yaml`](/enterprise/{{page.kong_version}}/vitals/vitalsSpec.yaml).

## Viewing Vitals in Kong Manager
View Vitals information in Kong Manager using any of the following:
* Overview Dashboard, available from the Workspaces page for an overview of your Kong cluster, or an individual Workspace for an overview of the selected Workspace.
* Workspace charts, which display on the Workspaces page beneath the Overview Dashboard. These charts give a quick overview of the status of an individual Workspace.
* Vitals tab, which provides detailed information about your Kong cluster, including total requests, latency, and cache information.
* Status Codes to view cluster-wide status code classes.

### Overview Dashboard
When you log in to Kong Manager, the Workspaces page displays by default. The top of the page displays the Vitals Overview Dashboard summarizing your Kong cluster, including the health and performance of your APIs and Gateway, total requests, average error rate, total consumers, and total services. This Vitals Overview Dashboard makes it easy for an Admin to quickly identify any issues that need attention.

### Workspace charts
On the Workspaces page, beneath the Overview Dashboard, the Workspaces section displays each Workspace with a chart showing Vitals for the most recently added services, consumers, and plugins for that Workspace. Hover over a coordinate to view the exact number of successes and errors at a given timestamp, or drilldown into the Workspace chart for more details.

### Vitals tab
The Vitals tab, or Vitals view, displays metrics about the health and performance of Kong nodes and Kong-proxied APIs. The Vitals View displays total requests, latency, and cache information. You also can generate reports from the Vitals view.

Options to populate the Vitals view, or areas in the chart, include:

| Option                   | Description                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------------|
| Timeframe Selector       | A timeframe selector controls the timeframe of data visualized, which indirectly controls the granularity of the data. For example, the “Last 5 Minutes” selection displays 1-second resolution data, while longer time frames display 1-minute resolution data.
| View                     | Select to populate the Vitals chart by Hostname, Hostname + ID, or ID.|
| Total Requests           | The Total Requests chart displays a count of all proxy requests received. This includes requests that were rejected due to rate-limiting, failed authentication, and so on.|
| Cluster and Node Data    | Metrics are displayed on Vitals charts at both node and cluster level. Controls are available to show cluster-wide metrics and/or node-specific metrics. Clicking on individual nodes will toggle the display of data from those nodes. Nodes are identified by a unique Kong node identifier, by hostname, or by a combination of the two.|

### Status Codes
The Status Codes view displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx). The Status Codes view contains the counts of status code classes graphed over time, as well as the ratio of code classes to total requests. See [Status Codes](/enterprise/{{page.kong_version}}/vitals/vitals-metrics/#status-code).

>**Note**: The Status Codes view does not include non-standard code classes (6xx, 7xx, etc.). Individual status code data can be viewed in the Consumer, Route, and Service details pages under the Activity tab. Both standard and non-standard status codes are visible in these views.

## Enable or disable Vitals
{{site.ee_product_name}} ships with Vitals enabled by default. To enable or disable Vitals, edit the configuration file or environment variables.

{% navtabs %}
{% navtab Using kong.conf %}

1. Edit the configuration file to enable or disable Vitals:    
    ```bash
    # via your Kong configuration file; e.g., kong.conf
    $ vitals = on  # vitals is enabled
    $ vitals = off # vitals is disabled
    ```
2. Restart Kong.

{% endnavtab %}
{% navtab Using environment variables %}

1. Use environment variables to enable or disable Vitals:
    ```bash
    # or via environment variables
    $ export KONG_VITALS=on
    $ export KONG_VITALS=off
    ```

2. Restart Kong.

{% endnavtab %}
{% endnavtabs %}
