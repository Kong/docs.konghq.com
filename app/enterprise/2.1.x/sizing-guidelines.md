---
title: Resource Sizing Guidelines
---

## Introduction

This document discusses the performance characteristics of Kong, and offers
recommendations on sizing with respect to resource allocation based on expected
Kong configuration and traffic patterns. We present these recommendations as
a baseline guide; specific tuning or benchmarking efforts should be undertaken
for performance-critical environments.

## General Resource Guidelines

### Kong Resources

Kong is designed to operate in a variety of deployment environments. In general
it has no minimum system requirements to operate. Resource requirements will
vary substantially based on configuration; the following high-level matricies
offer a guideline for determining system requirements based overall
configuration and performance requirements. Consider the following simplified
examples, where latency and throughput requirements are considered on a per-node
basis:

| Size | Number of Configured Entities | Latency Requirements | Throughput Requirements | Usage Pattern |
|---|---|---|---|---|
| Small  | < 100   | < 100 ms | < 500 RPS   | Dev/test environments; latency-insensitive gateways |
| Medium | < 1000  | < 20 ms  | < 2500 RPS  | Production clusters; greenfield traffic deployments |
| Large  | < 10000 | < 10 ms  | < 10000 RPS | Mission-critical clusters; legacy & greenfield traffic; central enterprise-grade gateways |

The above provides a path to determine a rough outlook on the usage
requirements. Based on the expected size and demand of the cluster, we recommend
the following resource allocations as a starting point:

| Size  | CPU  | RAM  | Typical Cloud Instance Sizes |
|---|---|---|---|---|
| Small  | 1-2 cores  | 2-4 GB   | **AWS**: t3.medium<br/>**GCP**: n1-standard-1<br/>**Azure**: Standard A1 v2  |
| Medium | 2-4 cores  | 4-8 GB   | **AWS**: m5.large<br/>**GCP**: n1-standard-4<br/>**Azure**: Standard A1 v4  |
| Large  | 8-16 cores | 16-32 GB | **AWS**: c5.xlarge<br/>**GCP**: n1-highcpu-16<br/>**Azure**: F8s v2  |

We strongly discourage the use of throttled cloud instance types (such as the
AWS `t2` or `t3` series of machines) in large clusters, as CPU throttling would
be detrimental to Kong's performance. We also recommend testing and verifying
the bandwidth availability for a given instance class. Bandwidth requirements
for Kong will depend on the shape and volume of traffic flowing through the
cluster.

We recommend defining the `mem_cache_size` configuration as large as possible,
while still providing adequate resources to the operating system and any other
processes running adjacent to Kong. This configuration allows Kong to take
maximum advantage of in-memory cache, and reduce the number of trips to the
database. Additionally, each Kong worker process maintains its own memory
allocations, and must be accounted for when provisioning memory. By default one
worker process runs per number of available CPU cores. In general, we recommend
allowing for ~ 500MB of memory allocated per worker process. Thus, on a machine
with 4 CPU cores and 8 GB of RAM available, we recommend allocating between 4-6
GB to cache via the `mem_cache_size` directive, depending on what other
processes are running alongside Kong.

### Database Resources

Kong is intentionally relies on the database as little as possible during
high-traffic operations. Configuration data for a Kong cluster is meant to be
read as infrequently, and held in memory as long as possible. As such, database
resource requirements are generally lower than those of compute environments
running Kong.

Kong generally executes a spikey access pattern to its backing database. When a
node first starts, or configuration for a given entity changes, Kong reads the
relevant configuration from the database. Query patterns are typically simple
and follow schema indexes. It's important to provision sufficient database
resources in order to handle spikey query patterns. Specific resource
requirements vary widely based on the number and rate of change of configured
entities, the rate at which Kong processes are (re)started within the cluster,
and the size of Kong's in-memory cache.

## Scaling Dimensions

Kong's is designed to be highly-performant, handling a large volume of request
traffic and proxying requests with minimal latency. Understanding how various
configuration scenarios impacts request traffic, and the Kong cluster itself, is
a crucial step in successfully deploying Kong.

Kong measures performance in two dimensions: _latency_ and _throughput_.
_Latency_, in this context, refers to the delay between the downstream client
sending a request and receiving a response. Kong measures latency introduced
into the request in terms of microseconds or milliseconds. Increasing the number
of Routes and/or Plugins in a Kong cluster will increase the amount of latency
that is added into each request. _Throughput_ refers to number of simultaneous
requests that Kong can process in a given time span, typically measured in
seconds or minutes.

In general, these two dimensions have an inversely proportional relationship
when all other factors remain the same: decreasing the latency introduced into
each request allows the maximum throughput in Kong to increase, as there is less
CPU time spent handling each request, and thus more CPU available for processing
traffic as a whole. Kong is designed to scale horizontally to be able to add
more overall compute power for configurations that add substantial latency into
requests, while needing to meet specific throughput requirements.

In general, Kong's maximum throughput is a CPU-bound dimension, and minumim
latency is memory-bound. That is, adding more available compute power to the
cluster to a latency-sensitive workload would be less beneficial than making
available more memory for database caching. Likewise, throughput-sensitive
workloads are dependant on both adequate memory and CPU resources, but adding
more cache memory will do little to increase maximum throughput; adding more
compute power by scaling Kong vertically and/or horizontally provides
near-unlimited throughput capacity.

Performance benchmarking and optimization as a whole is a complex exercise that
must account for a variety of factors, including those external to Kong, such as
the behavior of upstream services, or the health of the underlying hardware on
which Kong is running.

## Performance Characteristics

There are a number of factors that impact Kong's behavior with respect to
performance, including:

* **Number of configured Routes and Services**. Increasing the count of Routes
and Services on the cluster will require more CPU to evaluate the request.
Kong's request router is designed to be highly performant; we have seen clusters
of Kong nodes in the wild serving tens of thousands of Routes with minimal
impact to latency as a result of request route evaluation.

* **Number of configured Consumers and Credentials**. Consumer and credential
data is stored in Kong's datastore (either PostgreSQL or Cassandra, or the
`kong.yml` file in DB-less environments). Kong caches this data in memory to
reduce database load and latency during request processing. Increasing the count
of Consumers and Credentials will require more memory available for Kong to hold
data in cache; if there is not enough memory available to cache all requested
database entities, request latency will increase as Kong will need to query the
database more frequently to satisfy requests.

* **Number of configured Plugins**.  Increasing the count of Plugins on the
cluster will require more CPU to iterate through plugins during request
processing. Executing plugins comes with a varying cost depending on the nature
of the plugin; for example, a lightweight authentication plugin like `key-auth`
requires less resource availability than a plugin that performs complex
transformations of an HTTP request or response.

* **Cardinality of configured Plugins**. _Cardinality_ here refers to the number
of distinct plugin types that are configured on the cluster. For example, a
cluster with one each of `ip-restriction`, `key-auth`, `bot-detection`,
`rate-limiting`, and `http-log` plugins has a higher plugin cardinality than a
cluster with one thousand `rate-limiting` plugins applied at the route level.
With each additional plugin type added to the cluster, Kong spends more time
evaluating whether to execute a given plugin for a given request. Increasing the
cardinality of configured plugins requires more CPU power, as the process to
evaluate plugins is a CPU-constrained task.

* **Request and response size**. Requests with large HTTP bodies, either in the
request or response, will take longer to process, as Kong must buffer the
request to disk before proxying it. This allows Kong to handle a large volume of
simultaneous traffic without running out of memory, but the nature of buffered
requests can result in increased latency.

* **Number of configured Workspaces**. Increasing the count of Workspaces on the
cluster will require more CPU to evaluate each request, and require more memory
available for cache to hold Workspace configuration and metadata. The impact of
increasing the number of Workspaces on the cluster is also impacted by the
cardinality of configured plugins on the cluster (see above); roughly speaking,
there is an exponential impact on request throughput capacity within the cluster
as the cardinality of plugins _and_ the number of Workspaces increases.
