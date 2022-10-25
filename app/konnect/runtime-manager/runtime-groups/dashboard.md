---
title: Runtime Groups Dashboard
content_type: reference
---

The runtime group dashboard provides metrics for runtime instances within a selected time interval for the following categories:

* **Number of requests**: Total number of HTTP requests.
* **Average error rate**: Percentage of failed HTTP requests.
* **P99 latency**: The latency, in milliseconds, of the 99th percentile of requests.
* **Active gateway services**: Total number of active services.

All categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.

Each category also displays the trend, whether increasing or decreasing, over the selected time period.
For example, the dashboard might display that latency has decreased by 11.55% over the past 24 hours, or that the number of active services has increased by 25% over that same time span.

You can also view these metrics for each individual runtime instance by clicking on **Analytics** in the runtime instances table.

The following describes the different metrics that display for a runtime group or runtime instance:

* **Number of requests**: This displays the total number of HTTP requests split into two categories:
    * Successful: All requests that returned a **1xx-3xx** status code during the specified time interval.
    * Failed: All requests that returned a **4xx-5xx** status code during the specified time interval.

    Custom 6xx status codes are not tracked.

* **Average error rate**: This displays the percentage of HTTP requests with response codes between **4xx-5xx** during the specified time interval, out of all requests proxied through this runtime group.

* **P99 latency**: This displays the latency, in milliseconds, of the 99th percentile of requests proxied through this runtime group or instance.

    {:.note}
    > **Note**: Latency data is only available for requests proxied through runtime instances running {{site.base_gateway}} 3.0.0.0 or later.

* **Active gateway services**: This displays the total number of active services associated with the runtime group. Active services are services that have received at least one request during the defined time period.

    This metric is not available for individual runtime instances.

Graphs are interactive, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**.

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
