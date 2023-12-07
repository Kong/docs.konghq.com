---
title: Introduction to Monitoring Health with Analytics
---


You can monitor the health and performance of any API product, route, or application managed by {{site.konnect_saas}}.

Analytics provides traffic reports to help you track the performance and
behavior of your APIs and data plane nodes. Use these reports to quickly access key
statistics, monitor vital signs, and pinpoint anomalies in real time.

With **Konnect Plus** Analytics retains historical data for up to 3 months. If you need a longer storage period, [contact a sales representative](https://konghq.com/contact-sales) about upgrading to {{site.konnect_product_name}} Enterprise.


{:.note}
> **Note**:
Member control planes in a control plane group have no individual analytics reporting. This means that:
* In the Gateway Manager, contextual analytics are logged in the control plane group only.
* When creating custom reports, control planes won't show up as individual entities. 
Reports will only show the control plane group.




### Export analytics data

Export API traffic data into a CSV file for any graph in Konnect.

Follow these steps: 

1. On the graph, click the **Export** button on the top right.
1. Select the time frame to include in the report. To customize the time frame,
click **Custom** and select a date range.
1. Click **Export** to generate and download a CSV file.

## Limits

Konnect Analytics limits the number of entities returned and displayed in any activity graph or custom report to only 50 to provide a smooth experience. A warning icon at the top of a graph or report indicates that. Please [use custom reports](/konnect/analytics/generate-reports/) to filter and decrease the number of entities if required.  

## Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This gives you the ability to allow certain users to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).
