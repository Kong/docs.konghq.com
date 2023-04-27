---
title: Diagnosing Latency Issues
content_type: tutorial
book: use-cases
chapter: 2
---

Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to a CSV file. 
Let's go through an example situation where you could leverage custom reports.

In this scenario, Ryan is a platform owner who supervises the implementation and maintenance of the API Gateway infrastructure that governs all APIs at ACME. A few minutes ago, he received an email that stated that the response latency seemed to be very high and and causing a bad customer experience. To better understand the source of the delays, Ryan decides to create two reports to compare the **average upstream** and **Kong latency** for all traffic to the production servers in the last hour.

## Build reports 

You can build a custom report by navigating to {% konnect_icon analytics %} **Analytics** in the {{site.konnect_short_name}} menu, then **Reports**. This brings you to a list of all custom reports in the organization. From here, click **New Report** to get started.

### Kong latency

For the Kong latency report, Ryan configures the following:

* **Name**: Production - Kong Latency (last hour)
* **Chart type**: Line chart
* **Date/Time**: Last hour
* **Chart type**: Line chart
* **Select a metric**: Kong Latency (avg)
* **Group by**: Service
* **Choose Granularity**: Minutely

Then, he adds a filter to filter by the individual runtime group:

* **Filter by**: Runtime Group
* **Operator**: In
* **Value**: prod 


![Production - Kong Latency (last hour)](/assets/images/docs/konnect/custom-reports/latency/kong-latency.png){:.image-border}
> _**Figure 2:** Line chart showing the latency over the last hour._


### Upstream latency

For the Upstream latency report, Ryan configures the following:


* **Name**: Production - Upstream Latency (last hour)
* **Chart type**: Line chart
* **Date/Time**: Last Hour
* **Chart type**: Line chart
* **Select a metric**: Upstream Latency (avg)
* **Group by**: Service
* **Choose Granularity**: Minutely

Then he adds a filter to filter by the individual Runtime Group 

* **Filter by**: Runtime Group
* **Operator**: In
* **Value**: prod 


![Production - Upstream Latency (last hour)](/assets/images/docs/konnect/custom-reports/latency/upstream-latency.png){:.image-border}
> _**Figure 1:** Line chart showing the upstream latency over the last hour._


## Conclusion

With the two reports, Ryan realizes that the Account API is having latency spikes that are impacting the overall response time. Because the platform has a latency of around 0.57ms, Ryan can rule out the platform as the source of the problem. In the reports, Ryan sees a small second spike in the last hour. In combination with the Latency API latency spikes, Ryan will be able to use this to investigate the matter further.