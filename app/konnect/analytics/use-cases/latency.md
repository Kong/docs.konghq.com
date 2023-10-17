---
title: Diagnosing Latency Issues
content_type: tutorial
book: use-cases
chapter: 2
---

Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to a CSV file. 
Let's go through an example situation where you could leverage custom reports.

In this scenario, Tal is a platform owner who supervises the implementation and maintenance of the API Gateway infrastructure that governs all APIs at ACME. A few minutes ago, they received an email that stated that the response latency seemed to be very high and causing a bad customer experience. To better understand the source of the delays, Tal decides to create a report to compare the average **upstream latency** against the **Kong latency** for all traffic to the production servers in the last hour to pin point where the problem occurs.

## Build reports

You can build ustom reports by navigating to {% konnect_icon analytics %} **Analytics** in the {{site.konnect_short_name}} menu, then **Reports**. This brings you to a list of all custom reports in the organization. From here, click **New Report** to get started.

For the this report, Tal configures the following:

* **Name**: Production - Kong vs Upstream Latency (last hour)
* **Chart type**: Line chart
* **Date/Time**: Last hour
* **Metrics**: Kong Latency (avg), Upstream Latency (avg)
* **Group by**: API Product
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

With this report, Tal can rule out the platform as the source of the problem and start exploring which upstream service might cause the latency spike.
