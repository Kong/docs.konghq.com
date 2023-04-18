---
title: Reports Reference
content_type: reference
---

## Metrics

Traffic metrics provide insight into which of your services and service versions are being used and how they are responding.

Metric | Description
-------|------------
Request Count | Total number of API calls within the selected time frame. This includes requests that were rejected due to rate limiting, failed authentication, and so on.
Requests per Minute | Number of API calls per minute within the selected time frame.
Response Latency | The amount of time, in milliseconds, that it takes to process an API request. The time starts when {{site.base_gateway}} receives a request and ends when it forwards the response back to the original caller. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from request received until response returned. 
Request Size | The size of the request payload received from the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile request size of 100 bytes means that the payload size for every 1 in 100 requests was at least 100 bytes.
Response Size | The size of the response payload returned to the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response size of 100 bytes means that the payload size for every 1 in 100 response back to the original caller was at least 100 bytes.

{:.note}
> **Note:** {{site.konnect_saas}} Analytics uses percentiles to enable you to understand the real performance characteristics of your APIs. Percentiles depict a more accurate picture of what most end users experience using your API instead of hiding critical experiences by displaying averages.

## Grouping and filtering

When selecting a category to filter or group by, you have the following options:

Category | Description
---------|------------
None | Aggregate all of the data in the organization without any grouping.
Service | Group or filter the data by {{site.konnect_short_name}} service.
Service Version | Group or filter the data by {{site.konnect_short_name}} service version. <br><br>If you select multiple service versions in a report, the report shows the sum of requests for all selected versions broken down by service. It **does not** show data points for individual service versions.
Route | Group or filter the data by route. Route names are composed of elements referencing their related service, service version, and runtime group. See [Route entity format](#route-entity-format) for details.
Application | Group or filter the data by application.
Status Code | Group or filter the data by individual response status code. Individual status codes can range from 100 to 599.
Status Code (grouped) | Group or filter the data by response status code category: 1XX, 2XX, 3XX, 4XX, and 5XX.
Runtime Group | Group or filter the data by runtime groups.
Gateway Services | Group or filter the data by gateway services.

### Route entity format

In custom reports, the route entity name is composed of the following elements:

```
KONNECT_SERVICE_NAME.VERSION.ROUTE_NAME|FIRST_FIVE_UUID_CHARS (RUNTIME GROUP)
```

For example, for a route entity named `example_service.v1.example_route (default)`:
* `example_service` is the {{site.konnect_short_name}} service name
* `v1` is the service version
* `example_route` is the route name
* `default` is the runtime group name

Or, if your route doesn't have a name, it might look like this:
`example_service.v1.DA58B`

Where `DA58B` are the first five characters of its UUID.

{:.note}
> **Note**: If you see a route with `*` and the last five digits of the UUID, like `*DA58B`, this represents the data of a deleted route.

### Service version entity format

The service version name isn't unique across an organization. To identify the entity you need, the service version entity name is composed of the following elements:

```
KONNECT_SERVICE_NAME - VERSION (RUNTIME GROUP)
```

For example, for a service version entity named `Account - v1 (dev)`:
* `Account` is the {{site.konnect_short_name}} service name
* `v1` is the service version
* `dev` is the runtime group name


## Time intervals

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

{:.important}
> Free tier users can only select intervals up to 24 hours.

