---
title: Diagnosing Latency Issues
content_type: tutorial
book: use-cases
chapter: 2
---

Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to a CSV file. 
Let's go through an example situation where you could leverage custom reports.

## Build reports

You can build custom reports by navigating to {% konnect_icon analytics %} **Analytics** in the {{site.konnect_short_name}} menu, then **Reports**. This brings you to a list of all custom reports in the organization. From here, click **New Report** to get started.


* **Name**: Production - Kong vs Upstream Latency (last hour)
* **Chart type**: Line chart
* **Date/Time**: Last One Hour
* **Metrics**: Kong Latency (avg), Upstream Latency (avg)
* **Choose Granularity**: Minutely

{:.note}
> You can select more than one metric by clicking on **Select Multiple** next to the Metrics dropdown list.

Then, they add a filter to filter by the control plane

* **Filter by**: Control Plane
* **Operator**: In
* **Value**: prod

![Production - Kong vs Upstream Latency (last hour)](/assets/images/products/konnect/analytics/custom-reports/kong-vs-upstream-latency.png){:.image-border}
> _**Figure 1:** Line chart showing average upstream and Kong latency over the last hour. ._

## Conclusion

With this type of report,  you can start exploring which upstream service might cause the latency spike.
