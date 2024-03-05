---
title: Analytics dashboard
---

![service graph](/assets/images/products/konnect/analytics/konnect-summary-dashboard.png){:.image-border}


You can access a summary dashboard by navigating to [**Analytics** > **Summary**](https://cloud.konghq.com/analytics). The summary dashboard shows performance and health statistics of all your APIs across your organization on a single page and provides greater insights into your service usage.

From {% konnect_icon analytics %} Analytics, you can view dashboards and access historical data for a range greater than 30 days. You can view the Analytics summary dashboard to track traffic, error rate, and latency across all services in your organization.

These categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.
You can view a graph for the **Requests**, **Error Rate**, and **P99 Latency** categories:

* **Requests**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval.
    * Successful requests contain all requests that returned a **1xx-3xx** status code.
    * Failed requests contain all requests that returned a **4xx-5xx** status code.
    * 6xx status codes are not reported.
* **Error Rate**: This number displays the total number of failed HTTP requests over the specified time interval. Error response codes include any **4xx-5xx** status codes. This number also includes any requests made to incorrect routes.
* **P99 Latency**: This number displays request latency, in milliseconds, of the 99th percentile.
You can monitor the latency, investigate where delays are noticed, and optimize performance for APIs.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through a data plane running {{site.base_gateway}} 3.0.0.0 or later.

You can interact with the graphs, including hovering over chart items to display more details, and selecting a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.