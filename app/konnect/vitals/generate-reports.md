---
title: Generate Reports
no_version: true
alpha: true
---

Create custom reports to track API calls based on Services, Routes, or
Applications.

{:.note}
> **Note:** If you select multiple Service versions in a report, the report
shows the sum of requests for all selected versions broken down by Service.
It does not show data points for individual Service versions.

## Prerequisites
You have the [**Organization Admin**](/konnect/org-management/users-and-roles/) role.

## View custom reports

To access all custom reports, open {% konnect_icon vitals %}
**Vitals** from the left side menu in Konnect, then **Reports**.
This brings you to a list of all custom reports in the organization.

Click on any report in the table to view it. From the report's details page, you
can [export](#export-a-custom-report), [edit](#edit-a-custom-report), or [delete](#delete-a-custom-report) the report.

## Create a custom report

1. From the left-side menu in Konnect, open {% konnect_icon vitals %}
**Vitals**, then **Reports**.
1. Click the button to **Add New Report**.
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
    2022-01-27T21:30:58Z to 2022-02-03T21:30:58Z
    ```


1. Choose a report type.

   * **Service report**: Generate a report based on Services.
   * **Route report**: Generate a report based on Routes.
   * **Application report**: Generate a report based on API consumers.

   Depending on the report type you choose, the available metrics and entities
   will change.

1. Choose a [metric](#metrics) to group the data by.
1. Choose the entities to focus on in your report.
1. Click **Create**.

The report details page opens. Here you can:

* **View details**: Hover over a bar on the graph to see details about the data.
* **Filter the graph**: Click on an item in the legend to temporarily hide it from view,
and click it again to show the item. The graph resets on a refresh.

## Export a custom report

You can export any custom report in CSV format.

1. From the left-side menu in Konnect, open {% konnect_icon vitals %}
**Vitals**, then **Reports**.
1. Click on a report row to open the report's page.
1. Click the **Actions** dropdown and select **Export Report**.

  Konnect generates a CSV file download with all the data in the report.

## Edit a custom report

You can edit a report in one of the following ways:

1. From the left-side menu in Konnect, open {% konnect_icon vitals %}
**Vitals**, then **Reports**.
1. Either:
   * Click the ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
   settings icon for a report row and select **Edit**.
   * Click on a report row to open the report. In the **Actions** dropdown menu,
   select **Edit Report**.
1. Make your changes and click **Update**.

  The report page opens. You may have to refresh the page to see the updated
  report.

## Delete a custom report

You can delete a report in one of the following ways:

1. From the left-side menu in Konnect, open {% konnect_icon vitals %}
**Vitals**, then **Reports**.
1. Either:
   * Click the ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
   settings icon for a report row and select **Delete**.
   * Click on a report row to open the report. In the **Actions** dropdown menu,
   select **Delete Report**.
1. Confirm deletion in the dialog.

## Metrics

Each metric depends on a time frame and a primary entity (report type).

Metric | Report type | Description
-------|------------|------------
Total traffic | Service, Route, Application | Total number of API calls within the selected time frame.
Total traffic by status code | Service, Route, Application | Number of API calls grouped by status code.
Total traffic by service | Route, Application | Number of API calls filted by Service(s) or Service versions, and grouped by Service.
Total traffic by route | Service, Application | Number of API calls grouped by Route.
Total traffic by application | Service, Route | Number of API calls grouped by Application.

## See also
[Export historical data in CSV format](/konnect/vitals/analyze/) through the
ServiceHub for any individual Service, Service version, or Route.
