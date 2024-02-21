---
title: Explorer
---

The Explorer is an intuitive web-based interface that enables easy access to API usage data gathered by {{site.konnect_short_name}} Analytics from your data plane nodes. It's an efficient tool for promptly diagnosing performance issues or capturing essential usage metrics. The Explorer also provides the option to save your views as custom reports.

![Explorer Dashboard](/assets/images/products/konnect/analytics/konnect-explorer-dashboard.png){:.image-border}

To begin using Explorer, simply go to the **Analytics** {% konnect_icon analytics %} section and select **Explorer**. 
{% navtabs %}
{% navtab Grouping and Filtering %}
### Grouping and filtering

This is an overview of the different grouping and filtering categories available: 

Category | Description
---------|------------
None | Aggregate all of the data in the organization without any grouping.
API Product | Group or filter the data by {{site.konnect_short_name}} API product.
API Product Version | Group or filter the data by {{site.konnect_short_name}} API product version.
Route | Group or filter the data by route.
Application | Group or filter the data by application.
Status Code | Group or filter the data by individual response status code. Individual status codes can range from 100 to 599.
Status Code (grouped) | Group or filter the data by response status code category: 1XX, 2XX, 3XX, 4XX, and 5XX.
Control Plane | Group or filter the data by control plane.
Gateway Services | Group or filter the data by gateway services.
Consumer | Group or filter the data by consumer.
{% endnavtab %}
{% navtab Metrics %}

### Metrics

Traffic metrics provide insight into which of your services are being used and how they are responding. Within a single report, you have the flexibility to choose one or multiple metrics from the same category.

Metric | Category | Description
-------|------------
Request Count | Count | Total number of API calls within the selected time frame. This includes requests that were rejected due to rate limiting, failed authentication, and so on.
Requests per Minute | Rate | Number of API calls per minute within the selected time frame.
Response Latency | Latency | The amount of time, in milliseconds, that it takes to process an API request. Users can select between average (avg) or different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from request received until response returned. 
Upstream Latency | Latency | The amount of time, in milliseconds, that {{site.base_gateway}} was waiting for the first byte of the upstream service response. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from sending the request to the upstream service until the response returned.
Kong latency | Latency | The amount of time, in milliseconds, that {{site.base_gateway}} was waiting for the first byte of the upstream service response. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from the time the {{site.base_gateway}} received the request up to when it sends it back to the upstream service.
Request Size | Size | The size of the request payload received from the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile request size of 100 bytes means that the payload size for every 1 in 100 requests was at least 100 bytes.
Response Size | Size | The size of the response payload returned to the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response size of 100 bytes means that the payload size for every 1 in 100 response back to the original caller was at least 100 bytes.

{% endnavtab %}
{% navtab Time intervals %}
### Time intervals

The time frame selector controls the time frame of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or days resolution data.

All time interval presets are **relative**. 
For custom reports, you can also choose a **custom** date range.

* **Relative** time frames are dynamic and the report captures a snapshot of data
relative to when a user views the report.
* **Custom** time frames are static and the report captures a snapshot of data
during the specified time frame. You can see the exact range below
the time frame selector. For example:

    ```
    Jan 26, 2023 12:00 AM - Feb 01, 2023 12:00 AM (PST)
    ```

Interval | Description  
---------|-------------
Last 15 minutes | Data is aggregated in one minute increments.
Last hour| Data is aggregated in one minute increments.
Last 6 hours | Data is aggregated in one minute increments.
Last 12 hours| Data is aggregated in one hour increments.
Last 24 hours| Data is aggregated in one hour increments.
Last 7 days | Data is aggregated in one hour increments.
Last 30 days | Data is aggregated in daily increments.
Current week | Data is aggregated in one hour increments. Logs any traffic in the current calendar week. 
Current month | Data is aggregated in one hour increments. Logs any traffic in the current calendar month. 
Previous week | Data is aggregated in one hour increments. Logs any traffic in the previous calendar week.
Previous month | Data is aggregated in daily increments. Logs any traffic in the previous calendar month. 

{% endnavtab %}
{% endnavtabs %}
### Actions

After customizing a view using Explorer's metrics and filters, there are several actions that can be performed:

**Save as a Report**: This function creates a new custom report based on your current view, allowing you to revisit these specific insights at a later time.
**Export as CSV**: If you prefer to analyze your data using other tools, you can download the current view as a CSV file, making it portable and ready for further analysis elsewhere.

You can see this example of [diagnosing latency issues](/konnect/analytics/use-cases/latency)