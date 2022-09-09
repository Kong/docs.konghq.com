---
title: Generate Reports
no_version: true
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

    You can choose a preset time frame ranging from 1 day to 1 year, or
    select **Custom** to set any date range.

    All time frames are static. The report will capture a snapshot of data
    in whichever time frame you choose, but the range always stops at the time
    that the report was created. You can see a preview of the exact range below
    the time frame selector. For example:

    ```
    Sunday, Jun 12, 9:57:45 AM (CEST) to Monday, Jun 13, 9:57:45 AM (CEST)
    ```


1. Choose a report type.

   * **Service Report**: Generate a report based on services cataloged in Service Hub.
   * **Route Report**: Generate a report based on routes.
   * **Application Report**: Generate a report based on applications registered on your Dev Portal.

   Depending on the report type you choose, the available metrics and entities
   will change.

1. Choose a [metric](#metrics) to group the data by.
1. Choose the entities to focus on in your report.

    Route entity names are composed of multiple elements.
    See [route entity format](#route-entity-format) for the breakdown.

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

Each metric depends on a time frame and a primary entity (report type).

Metric | Report type | Description
-------|------------|------------
Total traffic | Service, route, application | Total number of API calls within the selected time frame.
Total traffic by status code | Service, route, application | Number of API calls grouped by status code.
Total traffic by service | Route, application | Number of API calls filtered by services or service versions and grouped by service.
Total traffic by route | Service, application | Number of API calls grouped by route.
Total traffic by application | Service, route | Number of API calls grouped by application.

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
