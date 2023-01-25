---
title: Custom Reports Reference
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

## Route entity format

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
