---
title: Analytics dashboard
---

![service graph](/assets/images/products/konnect/analytics/konnect-summary-dashboard.png){:.image-border}


You can access a summary dashboard by navigating to **Analytics** > **Summary**. The summary dashboard shows performance and health statistics of all your APIs across your organization on a single page.
For greater insights into your service usage, access the dedicated {% konnect_icon analytics %} [Analytics](https://cloud.konghq.com/analytics) page.

From {% konnect_icon analytics %} Analytics, you can view dashboards, access historical data for a range greater than 30 days, and customize the entities in a report:
* View the Analytics summary dashboard to track traffic, errors by error code, and latency across all services in your organization.
* [Export historical data in CSV format](#export-analytics-data) for any individual service.
* [Create a custom report](/konnect/analytics/generate-reports/) for any number of services, routes, or applications, filtered by time frame and grouped by metric.

These categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.
You can view a graph for each category by clicking **Traffic**, **Errors**, or **Latency**, and switching between the views.

* **Traffic**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval.
    * Successful requests contain all requests that returned a **1xx-3xx** status code.
    * Failed requests contain all requests that returned a **4xx-5xx** status code.
    * 6xx status codes are not reported.

    ![traffic analytics graph](/assets/images/products/konnect/analytics/konnect-vitals-traffic.png){:.image-border}
    > _**Figure 2:** Graph showing successful and failed requests over the past three hours._

* **Errors**: This graph displays the total number of failed HTTP requests categorized by error response codes over the specified time interval. Error response codes include any **4xx-5xx** status codes.

    ![errors analytics graph](/assets/images/products/konnect/analytics/konnect-vitals-errors.png){:.image-border}
    > _**Figure 3:** Graph showing errors by 4xx and 5xx error codes received over the past three hours._

* **Latency**: This graph displays request latency, in milliseconds, of the 99th, 95th, and 50th percentiles.
Admins can monitor the latency, investigate where delays are noticed, and optimize performance for APIs.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through a data plane running {{site.base_gateway}} 3.0.0.0 or later.

   ![latency analytics graph](/assets/images/products/konnect/analytics/konnect-analytics-latency.png){:.image-border}
  > _**Figure 4:** Graph showing latency as a percentage over the past 15 minutes._

Graphs can be interacted with, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**.

You can select a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.

## Troubleshooting

### The latency graph on the analytics dashboard is empty

You may run into an issue where requests are being proxied through services, but the latency tab on the Analytics page displays the message **No data to display**.

This issue may be happening for one of the following reasons:

* The {{site.base_gateway}} version is incompatible.

  Latency data is available starting with {{site.base_gateway}} 3.0.0.0. To collect latency information, [upgrade a data plane node](/konnect/gateway-manager/data-plane-nodes/upgrade/) to the latest version.

* No requests were proxied in the requested time period.

  Select another time period to see requests.