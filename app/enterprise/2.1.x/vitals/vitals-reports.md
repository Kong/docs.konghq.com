---
title: Vitals Reports
---

## Using Vitals Reports

Browse, filter, and view your data in a Vitals time-series report, and export the data into a comma-separated values (CSV) file.

When generating a Vitals report, you can:
* Generate a report across all Workspaces or a single Workspace.
* Filter report parameters, such as object, metric, metric type, and values.
* Select the time period or interval for the report, such as minutes, hours, or days.
* View a line chart that automatically generates depending on the selected criteria.
* Export your report to a CSV file.


## Prerequisites

InfluxDB database installed and configured. For more information, see
[Vitals with InfluxDB](/enterprise/{{page.kong_version}}/vitals/vitals-influx-strategy/).  

**Important**: The Vitals Reports feature is not compatible with a Postgres or Cassandra database. If using one of these databases, the Reports button will not display on the Vitals view.


## Generate a Vitals Report

To create a time-series report containing Vitals data, complete the steps in this section.

1. On the Vitals view, click the **Reports** button.

2. On the Reports page select the **Timeframe**, up to 12 hours, for which you want to create the report.

3. Select the report criteria for the report:

    | Selection                | Description                                                                                  |
    |--------------------------|----------------------------------------------------------------------------------------------|
    | *Report Type*            | Consumer Requests: This report is for requests made by Consumers.<br>Service Requests: This report is for services with a Service ID and name of the service that is stored in Kong Enterprise database.<br>Cluster Latency: This report is the aggregation of two fields. |
    | *Scope*                  | Drill down and filter for more detailed information. |
    | *Interval*               | Select the time interval to display in the report: weeks, hours, days, minutes. If you select an interval that is out of the available range, the results return zeroes. |


4. A Vitals report generates, starting with a summary of data in your report, including Id, Name, App Name, App Id, and Total. Note that the App Name and App Id are dependent on the Dev Portal App Registration plugin. For more information about status codes (2XX, 4XX, etc), see [_Vitals Metrics_](/enterprise/{{page.kong_version}}/vitals/vitals-metrics/).

5. To download your report, click **Export**. A CSV file containing your Vitals report data downloads to your system.  

## Export Vitals Data to a CSV Report

1. Create a Vitals report, as defined above in [Generate a Vitals Report](#generate-a-vitals-report).

2. Click **Export** to download a CSV file to your system.
