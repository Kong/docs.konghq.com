---
title: Reports Reference
content_type: reference
badge: plus
---

## Metrics

Metric | Description
-------|------------
Request count | Total number of API calls within the selected time frame.
Requests per minute | Number of API calls per minute within the selected time frame.
Response latency | The amount of time, in milliseconds, that it takes to process an API request. The time starts when {{site.base_gateway}} receives a request and ends when it forwards the response back to the original caller. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response latency of 10 milliseconds means that every 1 in 100 requests took at least 10 milliseconds from request received until response returned. 
Request size | The size of the request payload received from the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile request size of 100 bytes means that the payload size for every 1 in 100 requests was at least 100 bytes.
Response size | The size of the response payload returned to the client, in bytes. Users can select between different percentiles (p99, p95, and p50). For example, a 99th percentile response size of 100 bytes means that the payload size for every 1 in 100 response back to the original caller was at least 100 bytes.

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
Status Code | Group or filter the data by individual response status code.
Status Code (grouped) | Group or filter the data by response status code category: 1XX, 2XX, 3XX, 4XX, and 5XX.

### Route entity format

In custom reports, the route entity name is composed of the following elements:

```
KONNECT_SERVICE_NAME.VERSION.ROUTE_NAME|FIRST_FIVE_UUID_CHARS (RUNTIME GROUP)
```

For example, for a route entity named `example_service.v1.example_route` with the badge `default`:
* `example_service` is the {{site.konnect_short_name}} service name
* `v1` is the service version
* `example_route` is the route name
* `default` is the runtime group name

Or, if your route doesn't have a name, it might look like this:
`example_service.v1.DA58B`

Where `DA58B` are the first five characters of its UUID.

## Time intervals

Interval | Description  
------|----------|
Last 15 minutes | Data is aggregated in ten second increments.
Last hour| Data is aggregated in one minute increments.
Last three hours | Data is aggregated in one minute increments.
Last six hours | Data is aggregated in ten minute increments.
Last 12 hours| Data is aggregated in ten minute increments.
Last 24 hours| Data is aggregated in ten minute increments.
Last seven days | Data is aggregated in one hour increments.
Last 30 days | Data is aggregated in one hour increments.

{:.important}
> Free tier users can only select intervals up to 24 hours.

## Terms

**Request Count**
: Displays a count of all proxy requests received. This includes requests that
were rejected due to rate limiting, failed authentication, and so on.

**Status Codes**
: Displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx,
  4xx, 5xx). The Status Codes view contains the counts of status code classes
  graphed over time, as well as the ratio of code classes to total requests.

**Time frame selector**
: Controls the time frame of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or
days resolution data.

**Traffic metrics**
: Provide insight into which of your services and service versions are being
used and how they are responding.

