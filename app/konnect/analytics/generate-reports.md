---
title: Generate Reports
content_type: how-to
badge: plus
---

Create custom reports to track API calls based on services, routes, or
applications.

{:.note}
> **Note:** If you select multiple service versions in a report, the report
shows the sum of requests for all selected versions broken down by service.
It does not show data points for individual service versions.

## View custom reports

To access all custom reports, open {% konnect_icon analytics %}
**Analytics** from the left-side menu in {{site.konnect_short_name}}, then **Reports**.
This brings you to a list of all custom reports in the organization.

Click on any report in the table to view it. From the report's details page, you
can [export](#export-a-custom-report), [edit](#edit-a-custom-report), or [delete](#delete-a-custom-report) the report.

## Create a custom report

To set up a new report, open {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics), click **Reports**, then follow these steps:

1. Click the **New Report** button.
1. Name the report and optionally add a description.

    The name and description fields each have a 255 character limit.

1. Choose a time frame to display.

    Select between **Relative** or **Custom** to set any date range.

    **Relative** time frames are dynamic and the report will capture a snapshot of data
    relatively from the time a user views the report.

    **Custom** time frames are static and the report will capture a snapshot of data
    in whichever time frame you choose. You can see a preview of the exact range below
    the time frame selector. For example:

    ```
    Sunday, Jun 12, 9:57:45 AM (CEST) to Monday, Jun 13, 9:57:45 AM (CEST)
    ```


1. Choose an entity type.

   * **Service**: Generate a report based on services cataloged in Service Hub.
   * **Route**: Generate a report based on routes.
   * **Application**: Generate a report based on applications registered on your Dev Portal.

   Depending on the report type you choose, the available metrics and entities
   will change.

1. Choose the entities to focus on in your report.

    Route entity names are composed of multiple elements.
    See [route entity format](#route-entity-format) for the breakdown.

1. Choose a [metric](#metrics) to group the data by.

1. Click **Create** to open the report details page.

From the report details page you can:

* **View details**: Hover over a bar on the graph to see details about the data.
* **Filter the graph**: Click on an item in the legend to temporarily hide it from view,
and click it again to show the item. The graph resets on a refresh.

## Export a custom report

You can export any custom report in CSV format.

To export a report, open {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics), click **Reports**, then follow these steps:

1. Click on a report row to open the report's page.
1. From the **Actions** dropdown, select **Export Report**.

  {{site.konnect_short_name}} generates a CSV file download with all the data in the report.

## Edit a custom report

To edit a report, open {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics), click **Reports**, then choose one of following options:

* Click the ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
settings icon for a report row and select **Edit**.
* Click on a report row to open the report. In the **Actions** dropdown menu,
select **Edit Report**.

Make your changes and click **Update**.

You may have to refresh the page to see the updated report.

## Delete a custom report

To delete a report, open {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics), click **Reports**, then choose one of following options:

* Click the ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
settings icon for a report row, select **Delete**, then confirm deletion in the dialog.
* Click on a report row to open the report. From the **Actions** dropdown menu,
select **Delete Report**, then confirm deletion in the dialog.

## Metrics

Metric | Description
-------|------------
Request count | Total number of API calls within the selected time frame.
Requests per minute | Number of API calls per minute within the selected time frame.
Response latency | The amount of time, in milliseconds, that it takes to process an API request. The time starts when the Kong Gateway receives a request and ends when it forwards the response back to the original caller. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from request received until response returned. 
Request size | The size of the request payload received from the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile request size of 100 bytes means that the payload size for every 1 in 100 requests was at least 100 bytes.
Response size | The size of the response payload returned to the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response size of 100 bytes means that the payload size for every 1 in 100 response back to the original caller was at least 100 bytes.

{{site.konnect_saas}} Analytics Analytics is using percentiles to enable users to understand the real performance characteristics of their APIs. They have the advantage of distinguishing users who have a good experience from those that have a bad experience. Percentiles can show you a more accurate picture of what most users experience using your API as opposed to hiding critical experiences in an average.

## Route entity format

In custom reports, the route entity name is composed of the following elements:

```
KONNECT_SERVICE_NAME.VERSION.ROUTE_NAME|FIRST_FIVE_UUID_CHARS (RUNTIME GROUP)
```

For example, for a route entity named `example_service.v1.example_route` with the badge `default`:
* `example_service` is the {{site.konnect_short_name}} service name
* `v1` is the service version
* `example_route` is the route name
* `default` is the runtime group name

Or, if your route doesn't have a name, it might look like this:
`example_service.v1.DA58B`

Where `DA58B` are the first five characters of its UUID.

## See also
[Export historical data in CSV format](/konnect/analytics/services-and-routes/) through the
Service Hub for any individual service, service version, or route.
