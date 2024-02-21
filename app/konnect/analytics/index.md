---
title: Introduction to Monitoring Health with Analytics
---


You can monitor the health and performance of any API product, route, or application managed by {{site.konnect_product_name}}.

Konnect provides embedded reports at various different levels throughout its user interface. Our embedded reports help to stop switching away from your current page to start investigating or derive insights. For example, in the Gateway Manager, you can see activity graphs for gateway services or routes. For gateway services and routes, the graphs show requests broken down by status codes.

![service graph](/assets/images/products/konnect/analytics/konnect-analytics-gateway-service.png){:.image-border}

## Analyze API usage and performance data

{{site.konnect_short_name}}  Analytics {% konnect_icon analytics %} Analytics provides different tools to help you track the performance and behavior of your APIs and data plane nodes. You can use these tools to access key statistics, monitor vitals and pinpoint anomalies in real time. 

### Analytics tool guide
When navigating API analytics certain goals require different tools
* To quickly understand API usage and performance at a glance.
    * [Summary Dashboard](#dashboards) - Offers a comprehensive view of insights across your entire organization.
* In-depth Analysis
    * [Explorer](#explorer) — Allows for in-depth visualization and analysis of API data with the ability to segment and filter information efficiently.


### Charts and limitations

{{site.konnect_short_name}} charts offer interactive features such as the ability to hover over elements to reveal additional details, and to filter data by selecting items with the chart. {{site.konnect_short_name}} caps the number of entities showing in any activity graph or [use custom reports](/konnect/analytics/generate-reports/) to 50. If this limit is exceeded, a warning icon will appear at the top of the affected graph, or report. 


### Team permissions

You can assign {{site.konnect_short_name}} users to specific, predefined Analytic teams. This gives you the ability to allow certain users to only view or manage the Analytics area of your {{site.konnect_short_name}} instance. For more information about the Analytics Admin and Analytics Viewer teams, see the [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).


## Dashboards

![service graph](/assets/images/products/konnect/analytics/konnect-summary-dashboard.png){:.image-border}


You can access a summary dashboard by navigating to Analytics -> Summary. The summary dashboard shows performance and health statistics of all your APIs across your organization on a single page.
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

## API Requests

API Requests in {{site.konnect_short_name}} Analytics provides a fully integrated and intuitive web experience that allows you to view detailed records for requests made to your API, in near real-time.

Here are a couple of benefits of using API Requests:
* **Understand usage behavior:** By analyzing API requests, organizations can derive insights about consumer behavior, popular endpoints, peak usage times, and more. This information can be crucial for making informed decisions about product development and marketing strategies.
* **Built-in troubleshooting:** API requests can provide valuable insights into the sequence of events leading up to a problem. They can help identify what went wrong and where, making it easier to diagnose and fix issues. All that, out of the box within Konnect.

![api requests](/assets/images/products/konnect/analytics/konnect-analytics-api-requests.png)
> _**Figure 1:** Example API Requests list filtered by error codes and a single request selected._

## Inspect and filter API requests

Each API request on the **Requests** page shows the following information:
* Timestamp when the API request was made.
* Status code returned for the API request.
* HTTP method of the API request.
* Path that was requested.
* Latency numbers for:
  * Response: how long it took to return the request
  * Kong: how long it took for Kong to process the request
  * Upstream: how long it took for your upstream service to return the request back to Kong.

By clicking on a single API request, you can further inspect that request and see, for example, which API Product, Application, Consumer, or Control Plane is associated with this request. You can now continue to investigate each associated entity to see its configuration and adjust it if necessary.

You can filter API requests by specific properties such as a certain Gateway service or only a particular route of interest. You can also filter API requests for up to seven days.


## Troubleshooting

### The latency graph on the analytics dashboard is empty

You may run into an issue where requests are being proxied through services, but the latency tab on the Analytics page displays the message **No data to display**.

This issue may be happening for one of the following reasons:

* The {{site.base_gateway}} version is incompatible.

  Latency data is available starting with {{site.base_gateway}} 3.0.0.0. To collect latency information, [upgrade a data plane node](/konnect/gateway-manager/data-plane-nodes/upgrade/) to the latest version.

* No requests were proxied in the requested time period.

  Select another time period to see requests.
