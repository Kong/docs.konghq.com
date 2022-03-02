---
title: Resource Sizing Guidelines
---

This document discusses the performance characteristics of
{{site.base_gateway}}, and offers recommendations on sizing for
resource allocation based on expected {{site.base_gateway}} configuration and
traffic patterns.

These recommendations are a baseline guide only. Specific tuning or
benchmarking efforts should be undertaken for performance-critical environments.

## General resource guidelines

### Kong Gateway resources

{{site.base_gateway}} is designed to operate in a variety of deployment
environments. It has no minimum system requirements to operate.

Resource requirements vary substantially based on configuration. The following
high-level matricies offer a guideline for determining system requirements
based on overall configuration and performance requirements.

Consider the following simplified examples, where latency and throughput requirements are considered on a per-node basis. This table has rough usage requirement estimates:

| Size | Number of Configured Entities | Latency Requirements | Throughput Requirements | Usage Pattern |
|---|---|---|---|---|
| Small  | < 100   | < 100 ms | < 500 RPS   | Dev/test environments; latency-insensitive gateways |
| Medium | < 1000  | < 20 ms  | < 2500 RPS  | Production clusters; greenfield traffic deployments |
| Large  | < 10000 | < 10 ms  | < 10000 RPS | Mission-critical clusters; legacy & greenfield traffic; central enterprise-grade gateways |

### Database resources

We do not provide any hard numbers for database sizing (DB sizing), as it
depends on your particular setup. Sizing varies based on:
* Traffic
* Number of nodes
* Enabled features: for example, Vitals, or if rate limiting uses a
database or Redis
* Number and rate of change of configured entities
* The rate at which {{site.base_gateway}} processes are started and restarted within the cluster
* The size of {{site.base_gateway}}'s [in-memory cache](#in-memory-caching)

{{site.base_gateway}} intentionally relies on the database as little as
possible. To access configuration, {{site.base_gateway}} executes a spiky
access pattern to its backing database. This means that {{site.base_gateway}}
only reads configuration from the database when a node first starts, or
configuration for a given entity changes.

Everything in the database is meant to be read infrequently and held in memory
as long as possible. Therefore, database resource requirements are lower than
those of compute environments running {{site.base_gateway}}.

Query patterns are typically simple and follow schema indexes. Provision
sufficient database resources in order to handle spiky query patterns.

There are [settings](/gateway/{{page.kong_version}}/reference/configuration/#datastore-section/)
that you can adjust to keep database access minimal (also see [in-memory caching](#in-memory-caching)), or
[keep {{site.base_gateway}} operational](https://support.konghq.com/support/s/article/Keeping-Kong-Functional-During-DB-Down-Times)
if the DB is down for maintenance. If you choose to keep the database
operational during downtimes, vitals data is not written to the
database during this time.

### Cluster resource allocations

Based on the expected size and demand of the cluster, we recommend
the following resource allocations as a starting point:

| Size  | CPU  | RAM  | Typical Cloud Instance Sizes |
|---|---|---|---|---|
| Small  | 1-2 cores  | 2-4 GB   | **AWS**: t3.medium<br/>**GCP**: n1-standard-1<br/>**Azure**: Standard A1 v2  |
| Medium | 2-4 cores  | 4-8 GB   | **AWS**: m5.large<br/>**GCP**: n1-standard-4<br/>**Azure**: Standard A1 v4  |
| Large  | 8-16 cores | 16-32 GB | **AWS**: c5.xlarge<br/>**GCP**: n1-highcpu-16<br/>**Azure**: F8s v2  |

We strongly discourage the use of throttled cloud instance types (such as the
AWS `t2` or `t3` series of machines) in large clusters, as CPU throttling would
be detrimental to {{site.base_gateway}}'s performance. We also recommend
testing and verifying the bandwidth availability for a given instance class.
Bandwidth requirements for {{site.base_gateway}} depend on the shape and volume
of traffic flowing through the cluster.

### In-memory caching
We recommend defining the `mem_cache_size` configuration as large as possible,
while still providing adequate resources to the operating system and any other
processes running adjacent to {{site.base_gateway}}. This configuration allows
{{site.base_gateway}} to take maximum advantage of the in-memory cache, and
reduce the number of trips to the database.

Each {{site.base_gateway}} worker process maintains its own memory allocations,
and must be accounted for when provisioning memory. By default, one worker
process runs per number of available CPU cores. We recommend allowing for
around **500MB** of memory allocated per worker process.

For example, on a machine with 4 CPU cores and 8 GB of RAM available, we recommend allocating between 4-6 GB to cache via the `mem_cache_size` directive, depending on what other processes are running alongside {{site.base_gateway}}.

## Scaling dimensions

{{site.base_gateway}} is designed to handle large volumes of request
traffic and proxying requests with minimal latency. Understanding how various
configuration scenarios impacts request traffic, and the {{site.base_gateway}}
cluster itself, is a crucial step in successfully deploying
{{site.base_gateway}}.

{{site.base_gateway}} measures performance in the following dimensions:

* **Latency** refers to the delay between the downstream client
sending a request and receiving a response. {{site.base_gateway}} measures
latency introduced into the request in terms of microseconds or milliseconds.
Increasing the number of Routes and Plugins in a {{site.base_gateway}} cluster
increases the amount of latency that's added to each request.
* **Throughput** refers to the number of
requests that {{site.base_gateway}} can process in a given time span, typically
measured in seconds or minutes.

These dimensions have an inversely proportional relationship
when all other factors remain the same: decreasing the latency introduced into
each request allows the maximum throughput in {{site.base_gateway}} to
increase, as there is less CPU time spent handling each request, and more
CPU available for processing traffic as a whole. {{site.base_gateway}} is
designed to scale horizontally to be able to add more overall compute power for
configurations that add substantial latency into requests, while needing to
meet specific throughput requirements.

{{site.base_gateway}}'s maximum throughput is a CPU-bound dimension, and minimum
latency is memory-bound.
* **Latency-sensitive workload**: making more memory available for database caching
is more beneficial than adding more compute power to the cluster.
* **Throughput-sensitive workload**: these workloads are dependant on both adequate
memory and CPU resources, but adding more
compute power by scaling {{site.base_gateway}} vertically or horizontally is
the better choice, as it provides near-unlimited throughput capacity. In this
scenario, adding more cache memory would not increase maximum throughput by
much.

Performance benchmarking and optimization as a whole is a complex exercise that
must account for a variety of factors, including those external to
{{site.base_gateway}}, such as the behavior of upstream services, or the health
of the underlying hardware on which {{site.base_gateway}} is running.

## Performance characteristics

There are a number of factors that impact {{site.base_gateway}}'s performance,
including:

* **Number of configured Routes and Services**: Increasing the count of Routes
and Services on the cluster requires more CPU to evaluate the request.
However, {{site.base_gateway}}'s request router can handle running at large
scale. We've seen clusters of {{site.base_gateway}} nodes serving tens of
thousands of Routes with minimal impact to latency as a result of request route
evaluation.

* **Number of configured Consumers and Credentials**: Consumer and credential
data is stored in {{site.base_gateway}}'s datastore.  {{site.base_gateway}} 
caches this data in memory to reduce database load and
latency during request processing. Increasing the count of Consumers and
Credentials requires more memory available for {{site.base_gateway}} to hold
data in cache. If there is not enough memory available to cache all requested
database entities, request latency increases as {{site.base_gateway}} needs to
query the database more frequently to satisfy requests.

* **Number of configured Plugins**: Increasing the count of Plugins on the
cluster requires more CPU to iterate through plugins during request
processing. Executing plugins comes with a varying cost depending on the nature
of the plugin. For example, a lightweight authentication plugin like `key-auth`
requires less resource availability than a plugin that performs complex
transformations of an HTTP request or response.

* **Cardinality of configured Plugins**: _Cardinality_ is the number
of distinct plugin types that are configured on the cluster. For example, a
cluster with one each of `ip-restriction`, `key-auth`, `bot-detection`,
`rate-limiting`, and `http-log` plugins has a higher plugin cardinality than a
cluster with one thousand `rate-limiting` plugins applied at the route level.
With each additional plugin type added to the cluster, {{site.base_gateway}}
spends more time evaluating whether to execute a given plugin for a given
request. Increasing the cardinality of configured plugins requires more CPU
power, as the process to evaluate plugins is a CPU-constrained task.

* **Request and response size**: Requests with large HTTP bodies, either in the
request or response, take longer to process, as {{site.base_gateway}} must
buffer the request to disk before proxying it. This allows
{{site.base_gateway}} to handle a large volume of traffic without running out
of memory, but the nature of buffered requests can result in increased latency.

* **Number of configured Workspaces**: Increasing the count of Workspaces on the
cluster requires more CPU to evaluate each request, and more memory
available for the cache to hold Workspace configuration and metadata. The
impact of increasing the number of Workspaces on the cluster is also affected
by the cardinality of configured plugins on the cluster. There is an
exponential impact on request throughput capacity within the cluster
as the cardinality of plugins _and_ the number of Workspaces increases.
