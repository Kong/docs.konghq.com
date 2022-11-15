---
title: Summary Dashboard
content_type: reference
badge: plus
---

The Summary Dashboard provides metrics for services cataloged by Service Hub within a selected time interval for the following categories:

* **Traffic**: Total number of HTTP requests.
* **Errors**: Percentage of failed HTTP requests.
* **Latency**: Request latency at P50, P95, and P99 percentiles.

These categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.

You can view a graph for each category by clicking **Traffic**, **Errors**, or **Latency**, and switching between the views.

* **Traffic**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval.
    * Successful requests contain all requests that returned a **1xx-3xx** status code.
    * Failed requests contain all requests that returned a **4xx-5xx** status code.
    * Custom 6xx status codes are not tracked.

    ![traffic analytics graph](/assets/images/docs/konnect/konnect-vitals-traffic.png)
    > _**Figure 1:** Graph showing successful and failed requests over the past three hours._

* **Errors**: This graph displays the total number of failed HTTP requests categorized by error response codes over the specified time interval. Error response codes include any **4xx-5xx** status codes.

    ![errors analytics graph](/assets/images/docs/konnect/konnect-vitals-errors.png)
    > _**Figure 2:** Graph showing errors by 4xx and 5xx error codes received over the past three hours._

* **Latency**: This graph displays request latency, in milliseconds, of the 99th, 95th, and 50th percentiles.
Admins can monitor the latency, investigate where delays are noticed, and optimize performance for APIs.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through runtime instances running {{site.base_gateway}} 3.0.0.0 or later.

   ![latency analytics graph](/assets/images/docs/konnect/konnect-analytics-latency.png)
  > _**Figure 3:** Graph showing latency as a percentage over the past 15 minutes._

Graphs can be interacted with, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**.

You can select a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.

Interval | Description  
------|----------|
Last 15 minutes | Data is aggregated in ten second increments.
Last hour| Data is aggregated in one minute increments.
Last 3 hours | Data is aggregated in one minute increments.
Last 6 hours | Data is aggregated in ten minute increments.
Last 12 hours| Data is aggregated in ten minute increments.
Last 24 hours| Data is aggregated in ten minute increments.
Last 7 days | Data is aggregated in one hour increments.
Last 30 days | Data is aggregated in one hour increments.

{:.important}
> Free tier users can only select intervals up to 24 hours.

## See also

For more information about runtime group metrics, see [Runtime groups dashboard](/konnect/runtime-manager/runtime-groups/dashboard/).
