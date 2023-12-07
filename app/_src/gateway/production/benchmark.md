---
title: Establish a Kong Gateway performance benchmark
content_type: reference
description: This documentation provides a comprehensive guide for optimizing the performance of Kong Gateway by establishing a benchmark.
---

While {{site.base_gateway}} is optimized out-of-the-box, there are still situations where tweaking some configuration options for {{site.base_gateway}} can substantially increase its performance. You can establish a baseline for performance by optimizing {{site.base_gateway}} using the recommendations in this guide and then conducting several benchmark tests.

This guide explains the following:
* How to optimize {{site.base_gateway}} peformance before performing a benchmark
* How to configure your kong.conf for benchmarking
* How to establish a {{site.base_gateway}} peformance benchmark

{% if_version eq:3.4.x %}
## Prerequisites
* {{site.base_gateway}} 3.4.2.0 or later
{% endif_version %}

## Perform a baseline {{site.base_gateway}} performance benchmark

Before you conduct a benchmark test, you must make sure the testbed is configured correctly.

1. Use fewer nodes of {{site.base_gateway}} with four or eight NGINX workers with corresponding CPU resource allocations rather than many smaller {{site.base_gateway}} nodes.
1. Run {{site.base_gateway}} in DB-less or hybrid mode. In these modes, {{site.base_gateway}}’s proxy nodes aren't connected to a database, which can become another variable that might affect performance.
1. Configure a route with a request-termination plugin and measure {{site.base_gateway}}'s performance. In this case, {{site.base_gateway}} responds to the request and doesn't send any traffic to the Upstream server.
1. Run this test a few times to spot unexpected bottlenecks. Either {{site.base_gateway}}, the benchmarking Client (such as k6 or jmeter), or some other component will likely be an (unexpected) bottleneck, and you should not expect higher performance from {{site.base_gateway}} unless you solve these bottlenecks. Proceed only after this baseline performance is acceptable to you.
1. Once you have established the baseline, configure a route to send traffic to the upstream server without any plugins. This measures {{site.base_gateway}}'s performance to proxy and your Upstream server's performance.
1. Verify that no components are unexpectedly bottlenecked before proceeding.
1. Run the benchmark multiple times to gain confidence in the data. Ensure that the difference between observations is not high (low standard deviation).
1. Only after the previous steps are completed should you proceed with benchmarking {{site.base_gateway}} with additional configuration.
1. Discarding the stats collected by the benchmark's first one or two iterations is recommended. This ensures that the system is operating at an optimal and stable level.

## Optimize {{site.base_gateway}} peformance

### Check the `ulimit` 

**Action:** Increase the `ulimit` if it is less than `16384`. 

While Kong can use as many resources as it can get from the system, one place it gets limited by the Operating System (OS) is the number of connections it can open with the Upstream (or any other) server or accept from the Client. The number of open connections in Kong defaults to ulimit with an upper bound of 16384 (meaning if the ulimit is unlimited or a value higher than 16384, Kong will limit itself to 16384). You can shell into Kong’s container or VM (you must shell into the container if Kong is running inside a container on top of a VM) and run ulimit -n to check the system’s ulimit. If the value is less than 16384, please bump it up. Please also check and set the appropriate ulimit in the Client and Upstream server since a connection bottleneck in these systems will lead to suboptimal performance. 

### Increase connection re-use 

**Action:** Configure `upstream_keepalive_max_requests = 100000` and `nginx_http_keepalive_requests = 100000` 

In high-throughput (10k RPS+) scenarios, the overhead of setting up TCP and TLS connections or insufficient connections can result in underutilization of network bandwidth or the upstream server.
To increase connection re-use, you can increase `upstream_keepalive_max_requests` and `nginx_http_keepalive_requests` to `100000` or up to `500000`. 

### Avoid auto-scaling

**Action:** Ensure that Kong is not scaled in/out (horizontal) or up/down (vertical).

During a benchmarking run, ensure that Kong is not scaled in/out (horizontal) or up/down (vertical). This is commonly done in k8s using a Horizontal or Vertical Pod autoscaler. Autoscalers interfere with statistics in benchmarking and introduce unnecessary noise.
Scale out Kong before the benchmarking run to avoid auto-scaling during the benchmark. Monitor the number of Kong nodes to ensure new nodes are spawned during the benchmark and existing nodes are not replaced.

### Use multiple cores effectively

**Action:** On most VM setups, set `nginx_worker_processes` to `auto`. On Kubernetes, set `nginx_worker_processes` to one or two less than the worker node CPUs. 

Make sure `nginx_worker_processes` is configured correctly:

* Setting this to 'auto' (default) is appropriate for most VM setups. This ensures that Nginx spawns one worker process for each CPU core (desired).
* Setting this explicitly in k8s is recommended. Ensure CPU requests and limits for Kong match the number of workers configured in Kong. For example, if configuring nginx_worker_processes=4, you must request 4 CPUs in your pod spec.
    If you run Kong pods on k8s worker nodes with n CPUs, allocate n-2 or n-1 to Kong (and configure worker process count equal to this number). This ensures that any daemon set and k8s processes (such as kubelet) do not contend for resources with Kong.  
    Please note that each additional worker uses additional memory, so you must ensure that Kong is not getting OOM killed.

### Resource contention

**Action:** Make sure the client (like JMeter or k6), {{site.base_gateway}}, and upstream servers on on different machinces (VM or bare metal) and run within the same local network with low latencies.

1. Ensure that the Client (such as JMeter, k6), Kong, and the Upstream servers run on different machines (VM or bare-metal). If these are all running in a k8s cluster, ensure that the pods for these three systems are scheduled on dedicated nodes. Resource contention (of CPU and network usually) between these can lead to sub-optimal performance of any system. 
1. Ensure the Client, Kong, and Upstream run within the same local network with low latencies. If requests between the Client and Kong or Kong and the Upstream server traverse the Internet, then the results will contain unnecessary noise. 

### Upstream servers maxing out

**Action:** Verify that the upstream server is not maxing out.

This can be verified by checking the CPU and memory usage of the upstream server.
If you deploy additional Kong nodes and the throughput or error rate remains the same, the Upstream server or a system other than Kong is likely bottlenecked.
You also must ensure that Upstream servers are not autoscaled.

## Example kong.conf for benchmarking