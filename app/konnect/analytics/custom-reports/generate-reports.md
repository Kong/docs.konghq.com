---
title: Generate Reports
content_type: how-to
badge: plus
---

<!-- TO DO: Pull out any relevant info from this topic into new custom reports topics before deleting it -->

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

    You can choose **Relative** or **Custom** to set any date range.

    **Relative** time frames are dynamic and the report captures a snapshot of data
    relative to when a user views the report.

    **Custom** time frames are static and the report captures a snapshot of data
    during the specified time frame. You can see a preview of the exact range below
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
