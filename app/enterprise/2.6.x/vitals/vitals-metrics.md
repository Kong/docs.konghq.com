---
title: Vitals Metrics
---


## Using Vitals Metrics

Vitals metrics fall into two categories:
* Health Metrics — for monitoring the health of a Kong cluster
* Traffic Metrics — for monitoring the usage of upstream services


All metrics are collected at 1-second intervals and aggregated into 1-minute
intervals. The 1-second intervals are retained for one hour. The 1-minute 
intervals are retained for 25 hours.

If longer retention times are needed, the Vitals API can be used to pull metrics
out of Kong and into a data retention tool.

## Health Metrics

Health metrics give insight into the performance of a Kong cluster; for example, 
how many requests the cluster is processing and the latency on those requests.

Health metrics are tracked for each node in a cluster as well as for the cluster
as a whole. In Kong, a node is a running process with a unique identifier, 
configuration, cache layout, and connections to both Kong’s datastores and the 
upstream APIs it proxies. Note that node identifiers are unique to the process, 
and not to the host on which the process runs. In other words, each Kong restart 
results in a new node, and therefore a new node ID.

### Latency

The Vitals API may return null for Latency metrics. This occurs when no API 
requests were proxied during the timeframe. Null latencies are not graphed in 
Kong Manager; periods with null latencies appear as gaps in Vitals charts.

#### Proxy Latency (Request)

The Proxy Latency metrics are the min, max, and average values for the time, in milliseconds, that the Kong proxy spends processing API proxy requests. This includes time to execute plugins that run in the access phase and the DNS lookup time. This does not include time spent in Kong’s load balancer, time spent sending the request to the upstream, or time spent on the response.

These metrics are referenced in the Vitals API with the following labels: `latency_proxy_request_min_ms`, `latency_proxy_request_max_ms`, `latency_proxy_request_avg_ms`.

Latency is not reported when a request is prematurely ended by Kong (e.g., bad auth, rate limited, etc.). Note that this differs from the **Total Requests** metric that does count such requests.

#### Upstream Latency

The Upstream Latency metrics are the min, max, and average values for the time elapsed, in milliseconds, between Kong sending requests upstream and Kong receiving the first bytes of responses from upstream.

These metrics are referenced in the Vitals API with the following labels: `latency_upstream_min_ms`, `latency_upstream_max_ms`, `latency_upstream_avg_ms`.

### Datastore Cache

#### Datastore Cache Hit/Miss

The Datastore Cache Hit/Miss metrics are the count of requests to Kong's node-level datastore cache. When Kong workers need configuration information to respond to a given API proxy request, they first check their worker-specific cache (also known as L1 cache), then if the information isn’t available they check the node-wide datastore cache (also known as L2 cache). If neither cache contains the necessary information, Kong requests it from the datastore.

A `Hit` indicates that an entity was retrieved from the data store cache. A `Miss` indicates that the record had to be fetched from the datastore. Not every API request will result in datastore cache access; some entities will be retrieved from Kong's worker-specific cache memory.

These metrics are referenced in the Vitals API with the following labels: `cache_datastore_hits_total`, `cache_datastore_misses_total`.

#### Datastore Cache Hit Ratio

This metric contains the ratio of datastore cache hits to the total count of datastore cache requests.

> **Note:** Datastore Cache Hit Ratio cannot be calculated for time indices with no hits and no misses.

## Traffic Metrics

Traffic metrics provide insight into which of your services are being used, who is using them, and how they are responding.

### Request Counts

#### Total Requests


This metric is the count of all API proxy requests received. This includes requests that were rejected due to rate-limiting, failed authentication, etc.

This metric is referenced in the Vitals API with the following label: `requests_proxy_total`.

#### Requests Per Consumer

This metric is the count of all API proxy requests received from each specific consumer. Consumers are identified by credentials in their requests (e.g., API key, OAuth token) as required by the Kong Auth plugins in use.

This metric is referenced in the Vitals API with the following label: `requests_consumer_total`.

### Status Codes

#### Total Status Code Classes

This metric is the count of all status codes grouped by status code class (e.g. 4xx, 5xx).

This metric is referenced in the Vitals API with the following label: `status_code_classes_total`.

#### Total Status Codes per Service

This metric is the total count of each specific status code for a given service.

This metric is referenced in the Vitals API with the following label: `status_codes_per_service_total`.

#### Total Status Codes per Route

This metric is the total count of each specific status code for a given route.

This metric is referenced in the Vitals API with the following label: `status_codes_per_route_total`.

#### Total Status Codes per Consumer
This metric is the total count of each specific status code for a given consumer.

This metric is referenced in the Vitals API with the following label: `status_codes_per_consumer_total`.

#### Total Status Codes per Consumer Per Route
This metric is the total count of each specific status code for a given consumer and route.

This metric is referenced in the Vitals API with the following label: `status_codes_per_consumer_route_total`.
