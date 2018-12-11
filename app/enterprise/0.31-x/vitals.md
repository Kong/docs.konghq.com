---
title: Kong Vitals
---

# Introduction

## What is Vitals?
The Vitals feature in Kong's Admin API and GUI provides useful metrics about the health and performance of your Kong nodes, as well as metrics about the usage of your Kong-proxied APIs.

## Requirements

- Vitals requires PostgreSQL 9.5+ or Cassandra 2.1+.
- Vitals must also be enabled in Kong configuration. See below for details.

## Enabling and Disabling Vitals
Kong Enterprise Edition ships with Vitals turned off. You can change this in your configuration:

```bash
# via your Kong configuration file; e.g., kong.conf
vitals = on  # vitals is enabled
vitals = off # vitals is disabled
```

```bash
# or via environment variables
$ export KONG_VITALS=on
$ export KONG_VITALS=off
```

As with other Kong configurations, your changes take effect on kong reload or kong restart.

## Vitals Metrics
Below is a list of metrics that Vitals currently collects. More metrics and dimensions will be added over time. To request additional metrics and dimensions, please contact Kong Support.

All metrics are collected at 1-second intervals and aggregated into 1-minute intervals. The 1-second intervals are retained for one hour. The 1-minute intervals are retained for 25 hours. If you require access to this data for long periods of time, you can use the Vitals API to pull it out of Kong and into the data retention tool of your choice.

Metrics are tracked for each node in a cluster as well as for the cluster as a whole. In Kong, a node is a running process with a unique identifier, configuration, cache layout, and connections to both Kong’s datastores and the upstream APIs it proxies. Note that node identifiers are unique to the process, and not to the host on which the process runs. In other words, each Kong restart results in a new node, and therefore a new node ID.

### Request Counts
#### Total Requests
This metric is the count of all API proxy requests received. This includes requests that were rejected due to rate-limiting, failed authentication, etc.

#### Requests Per Consumer
This metric is the count of all API proxy requests received from each specific consumer. Consumers are identified by credentials in their requests (e.g., API key, OAuth token, etc) as required by the Kong Auth plugin(s) in use.

### Latency
Note: The Vitals API may return null for Latency metrics - this occurs when no API requests were proxied during the timeframe. Null latencies are not graphed in Kong’s Admin GUI - periods with null latencies will appear as a gap in Vitals charts.

#### Proxy Latency (Request)
These metrics are the min, max, and average values for the time, in milliseconds, that the Kong proxy spends processing API proxy requests. This includes time to execute plugins that run in the access phase as well as DNS lookup time. This does not include time spent in Kong’s load balancer, time spent sending the request to the upstream, or time spent on the response.

Latency is not reported when a request is a prematurely ended by Kong (e.g., bad auth, rate limited, etc.) - note that this differs from the “Total Requests” metric that does count such requests.

#### Upstream Latency
These metrics are the min, max, and average values for the time elapsed, in milliseconds, between Kong sending requests upstream and Kong receiving the first bytes of responses from upstream.

### Datastore Cache
Datastore Cache Hit/Miss
These metrics are the count of requests to Kong's node-level datastore cache. When Kong workers need configuration information to respond to a given API proxy request, they first check their worker-specific cache (also known as L1 cache), then if the information isn’t available they check the node-wide datastore cache (also known as L2 cache). If neither cache contains the necessary information, Kong requests it from the datastore.

A “Hit” indicates that an entity was retrieved from the data store cache. A “Miss” indicates that the record had to be fetched from the datastore. Not every API request will result in datastore cache access - some entities will be retrieved from Kong's worker-specific cache memory.

#### Datastore Cache Hit Ratio
This metric contains the ratio of datastore cache hits to the total count of datastore cache requests.

> Note: Datastore Cache Hit Ratio cannot be calculated for time indices with no hits and no misses.

## Vitals API
Vitals data is available via endpoints on Kong’s Admin API. Access to these endpoints may be controlled via Admin API RBAC. The Vitals API is described in the attached OAS (Open API Spec, formerly Swagger) file [vitalsSpec_v0.31.yaml][vitals_spec]

## Vitals Data Visualization in Kong Admin GUI
Kong’s Admin GUI includes visualization of Vitals data. Additional visualizations, dashboarding of Vitals data alongside data from other systems, etc., can be achieved using the Vitals API to integrate with common monitoring systems.

### Time Frame Control
A time frame selector adjacent to Vitals charts in Kong’s Admin GUI controls the time frame of data visualized, which indirectly controls the granularity of the data. For example, the “Last 5 Minutes” choice will display 1-second resolution data, while longer time frames will show 1-minute resolution data.

Timestamps on the x-axis of Vitals charts are displayed either in the browser's local time zone, or in UTC, depending on the UTC option that appears adjacent to Vitals charts.

### Cluster and Node Data
Metrics can be displayed on Vitals charts at both node and cluster level. Controls are available to show cluster-wide metrics and/or node-specific metrics. Clicking on individual nodes will toggle the display of data from those nodes. Nodes can be identified by a unique Kong node identifier, by hostname, or by a combination of the two.

## Known Issues

### Vitals data does not appear in the Admin UI or the API

First, make sure Vitals is enabled. (`vitals=on` in your Kong configuration). Next, check your log files:

`[vitals] kong_vitals_requests_consumers cache is full` or `[vitals] error attempting to push to list: no memory`

This means that Vitals is no longer able to track requests because its cache is full.  This condition may resolve itself if traffic to the node subsides long enough for it to work down the cache. Regardless, the node will continue to proxy requests as usual.

### Postgres - Warning Logs after upgrading to 0.31

`[vitals-strategy] failed to insert seconds: ERROR: column "plat_count"`
`of relation "vitals_stats_seconds_[timestamp]"`

This warning can occur when using Postgres after upgrading to 0.31. To resolve this issue, manually drop the offending table(s) `vitals_stats_seconds_[timestamp]` **Note:** replace `timestamp` in the table name with the timestamp of table name seen in the warning logs. Finally, restart Kong. Additionally, this issue will resolve itself in a maximum of two hours as Vitals periodically rotates new tables.

### Limitations in Cassandra 2.x

Vitals data is purged regularly: 1-second data is purged after one hour, and 1-minute data is purged after 25 hours. Due to limitations in Cassandra 2.x query options, the counter table vitals_consumers is not purged. If it becomes necessary to prune this table, you will need to do so manually.

[vitals_spec]: /enterprise/0.31-x/vitalsSpec_v0.31.yaml
