---
title: Kong Vitals
---

### Introduction

Vitals is a feature within Kong's Admin API and Kong Manager that provides
metrics about the health and performance of Kong nodes and Kong-proxied APIs.

## Requirements

- PostgresSQL 9.5+ or Cassandra 2.1+

## How to Enable and Disable Vitals

Kong Enterprise ships with Vitals enabled by default.

Vitals can be disabled (or re-enabled) in the configuration file (e.g kong.conf):

```bash
# via your Kong configuration file; e.g., kong.conf
vitals = on  # vitals is enabled
vitals = off # vitals is disabled
```

or by environment variables:

```bash
# or via environment variables
$ export KONG_VITALS=on
$ export KONG_VITALS=off
```

Kong must be restarted for these changes to take effect. 

## Vitals Metrics

Vitals metrics fall into two categories:
* Health Metrics - for monitoring the health of a Kong cluster
* Traffic Metrics — for monitoring the usage of upstream services

Within these categories, Vitals collects the following metrics:

- [Health Metrics](#health-metrics)
  - [Latency](#latency)
    - [Proxy Latency (Request)](#proxy-latency-request)
    - [Upstream Latency](#upstream-latency)
  - [Datastore Cache](#datastore-cache)
    - [Datastore Cache Hit/Miss](#datastore-cache-hit-miss)
    - [Datastore Cache Hit Ratio](#datastore-cache-hit-ratio)
- [Traffic Metrics](#traffic-metrics)
  - [Request Counts](#request-counts)
    - [Total Requests](#total-requests)
    - [Requests per Consumer](#request-per-consumer)
  - [Status Codes](#status-code)
    - [Total Status Code Classes](#total-status-code-classes)
    - [Total Status Codes per Service](#total-status-codes-per-service)
    - [Total Status Codes per Route](#total-status-codes-per-route)
    - [Total Status Codes per Consumer](#total-status-codes-per-consumer)
    - [Total Status Codes per Consumer per Route](#total-status-codes-per-consumer-per-route)

All metrics are collected at 1-second intervals and aggregated into 1-minute
intervals. The 1-second intervals are retained for one hour. The 1-minute 
intervals are retained for 25 hours.

If longer retention times are needed, the Vitals API can be used to pull metrics
out of Kong and into a data retention tool.

### Health Metrics

Health metrics give insight into the performance of a Kong cluster; for example, 
how many requests it is processing and the latency on those requests.

Health metrics are tracked for each node in a cluster as well as for the cluster
as a whole. In Kong, a node is a running process with a unique identifier, 
configuration, cache layout, and connections to both Kong’s datastores and the 
upstream APIs it proxies. Note that node identifiers are unique to the process, 
and not to the host on which the process runs. In other words, each Kong restart 
results in a new node, and therefore a new node ID.

#### Latency

The Vitals API may return null for Latency metrics—this occurs when no API 
requests were proxied during the timeframe. Null latencies are not graphed in 
Kong Manager—periods with null latencies appear as gaps in Vitals charts.

##### Proxy Latency (Request)

The Proxy Latency metrics are the min, max, and average values for the time, in milliseconds, that the Kong proxy spends processing API proxy requests. This includes time to execute plugins that run in the access phase as well as DNS lookup time. This does not include time spent in Kong’s load balancer, time spent sending the request to the upstream, or time spent on the response.

These metrics are referenced in the Vitals API with the following labels: `latency_proxy_request_min_ms`, `latency_proxy_request_max_ms`, `latency_proxy_request_avg_ms`

Latency is not reported when a request is prematurely ended by Kong (e.g., bad auth, rate limited, etc.)—note that this differs from the “Total Requests” metric that does count such requests.

##### Upstream Latency

The Upstream Latency metrics are the min, max, and average values for the time elapsed, in milliseconds, between Kong sending requests upstream and Kong receiving the first bytes of responses from upstream.

These metrics are referenced in the Vitals API with the following labels: `latency_upstream_min_ms`, `latency_upstream_max_ms`, `latency_upstream_avg_ms`

#### Datastore Cache

##### Datastore Cache Hit/Miss

The Datastore Cache Hit/Miss metrics are the count of requests to Kong's node-level datastore cache. When Kong workers need configuration information to respond to a given API proxy request, they first check their worker-specific cache (also known as L1 cache), then if the information isn’t available they check the node-wide datastore cache (also known as L2 cache). If neither cache contains the necessary information, Kong requests it from the datastore.

A “Hit” indicates that an entity was retrieved from the data store cache. A “Miss” indicates that the record had to be fetched from the datastore. Not every API request will result in datastore cache access—some entities will be retrieved from Kong's worker-specific cache memory.

These metrics are referenced in the Vitals API with the following labels: `cache_datastore_hits_total`, `cache_datastore_misses_total`

##### Datastore Cache Hit Ratio

This metric contains the ratio of datastore cache hits to the total count of datastore cache requests.

> Note: Datastore Cache Hit Ratio cannot be calculated for time indices with no hits and no misses.

### Traffic Metrics

Traffic metrics provide insight into which of your services are being used, and by whom, and how they are responding.

#### Request Counts

##### Total Requests


This metric is the count of all API proxy requests received. This includes requests that were rejected due to rate-limiting, failed authentication, etc.

This metric is referenced in the Vitals API with the following label: `requests_proxy_total`

##### Requests Per Consumer

This metric is the count of all API proxy requests received from each specific consumer. Consumers are identified by credentials in their requests (e.g., API key, OAuth token, etc) as required by the Kong Auth plugin(s) in use.

This metric is referenced in the Vitals API with the following label: `requests_consumer_total`

#### Status Codes

##### Total Status Code Classes

This metric is the count of all status codes grouped by status code class (e.g. 4xx, 5xx).

This metric is referenced in the Vitals API with the following label: `status_code_classes_total`

##### Total Status Codes per Service

This metric is the total count of each specific status code for a given service.

This metric is referenced in the Vitals API with the following label: `status_codes_per_service_total`

##### Total Status Codes per Route

This metric is the total count of each specific status code for a given route.

This metric is referenced in the Vitals API with the following label: `status_codes_per_route_total`

##### Total Status Codes per Consumer
This metric is the total count of each specific status code for a given consumer.

This metric is referenced in the Vitals API with the following label: `status_codes_per_consumer_total`

##### Total Status Codes per Consumer Per Route
This metric is the total count of each specific status code for a given consumer and route.

This metric is referenced in the Vitals API with the following label: `status_codes_per_consumer_route_total`

## Vitals API
Vitals data is available via endpoints on Kong’s Admin API. Access to these endpoints may be controlled via Admin API RBAC. The Vitals API is described in the attached OAS (Open API Spec, formerly Swagger) file [vitalsSpec.yaml][vitals_spec]

## Vitals Data Visualization in Kong Manager

Kong Manager includes visualization of Vitals data. Additional visualizations, dashboarding of Vitals data alongside data from other systems, etc., can be achieved using the Vitals API to integrate with common monitoring systems.

### Time Frame Control

A timeframe selector adjacent to Vitals charts in Kong Manager controls the timeframe of data visualized, which indirectly controls the granularity of the data. For example, the “Last 5 Minutes” choice will display 1-second resolution data, while longer time frames will show 1-minute resolution data.

Timestamps on the x-axis of Vitals charts are displayed either in the browser's local time zone, or in UTC, depending on the UTC option that appears adjacent to Vitals charts.

### Cluster and Node Data
Metrics can be displayed on Vitals charts at both node and cluster level. Controls are available to show cluster-wide metrics and/or node-specific metrics. Clicking on individual nodes will toggle the display of data from those nodes. Nodes can be identified by a unique Kong node identifier, by hostname, or by a combination of the two.

### Status Code Data

Visualizations of cluster-wide status code classes (1xx, 2xx, 3xx, 4xx, 5xx) can be found in the Status Codes page of Kong Manager. This page contains the counts of status code classes graphed over time, as well as the ratio of code classes to total requests. Note: this page does not include non-standard code classes (6xx, 7xx, etc.) Individual status code data can be viewed in the Consumer, Route, and Service details pages under the Activity tab. Both standard and non-standard status codes are visible in these views.

## Known Issues

Vitals data does not appear in Kong Manager or the Admin API.
First, make sure Vitals is enabled. (`vitals = on` in your Kong configuration).

Then, check your log files. If you see `[vitals] kong_vitals_requests_consumers cache is full` or `[vitals] error attempting to push to list: no memory`, then Vitals is no longer able to track requests because its cache is full.  This condition may resolve itself if traffic to the node subsides long enough for it to work down the cache. Regardless, the node will continue to proxy requests as usual.

### Limitations in Cassandra 2.x

Vitals data is purged regularly: 1-second data is purged after one hour, and 1-minute data is purged after 25 hours. Due to limitations in Cassandra 2.x query options, the counter table vitals_consumers is not purged. If it becomes necessary to prune this table, you will need to do so manually.

[vitals_spec]: /enterprise/{{page.kong_version}}/admin-api/vitals/vitalsSpec.yaml
