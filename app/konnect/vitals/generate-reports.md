---
title: Export Service and Route analytics from ServiceHub
no_version: true
---
In the ServiceHub, the Service, Service version, and Route graphs provide dynamic
graphs with up to 12 hours of data. To view data beyond this time frame, export
the data into a comma-separated values (CSV) file.

You can generate and export a Vitals report for:

* A Service, including daily requests by status codes for all versions of the
Service.
* A Service version, including a report of daily requests and status codes.

For a Route, you can [view status codes](/konnect/vitals/#view-vitals-performance-for-a-route)
for a specified time frame but you can't export a Route traffic report through
ServiceHub.

If you want to combine multiple Services, Routes, or Applications in one report,
see [custom reports](/konnect/vitals/custom-reports).

## Generate and export a Service report

Generate a Vitals report for a Service, including requests by time or date and
status codes for all versions of the Service.

1. From the left-side menu, open
![](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .no-image-expand}
**Services** and select the Service for which you want to generate a
report.
2. On the **Throughput** graph, click **Export**.
3. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
4. Click **Export**. A CSV file is generated.

## Generate and export a Service version report

Generate a Vitals report for a Service version, including requests by time or
 date and status codes for the selected version.

1. From the left-side menu, open
![](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .no-image-expand}
**Services** and select the Service version for which you want to generate a
report.
2. On the **Traffic by Status Code** graph, click the **Export** button.
3. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
4. Click **Export**. A CSV file is generated.

## See also

For reports comparing multiple Konnect entities, see [custom reports](/konnect/vitals/custom-reports).
