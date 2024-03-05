---
title: Analytics dashboard
---

![service graph](/assets/images/products/konnect/analytics/konnect-summary-dashboard.png){:.image-border}

> *Figure 1: Image of the summary dashboard. The dashboard displays data for total number of requests, error rate, p99 latency, as well as graphs for total traffic over time, latency breakdown over time, and Kong vs upstream latency over time.*

The summary dashboard shows performance and health statistics of all your APIs across your organization on a single page and provides greater insights into your service usage. You can access the summary dashboard by navigating to [**Analytics** > **Summary**](https://cloud.konghq.com/analytics). 

You can view the Analytics summary dashboard to track requests, error rate, and p99 latency across all services in your organization. These categories measure high-level data as well as trends across fixed comparable time intervals. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.

The following describes more details about what data is displayed for each category:

* **Requests**: This displays the total number of HTTP requests made to the gateway over the specified time interval. This number also includes any requests that didn't match any route.
* **Error Rate**: This displays the total number of failed HTTP requests over the specified time interval. Error response codes include any **4xx-5xx** status codes. This number also includes any requests made to incorrect routes.
* **P99 Latency**: This displays request latency, in milliseconds, of the 99th percentile.
You can monitor the latency, investigate where delays are noticed, and optimize performance for APIs.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through a data plane running {{site.base_gateway}} 3.0.0.0 or later.

You can interact with the traffic and latency graphs, including hovering over chart items to display more details, and selecting a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.