---
title: Establish a Kong Gateway performance benchmark
content_type: reference
description: This documentation provides a comprehensive guide for optimizing the performance of Kong Gateway by establishing a benchmark.
---

While {{site.base_gateway}} is optimized out-of-the-box, there are still situations where tweaking some configuration options for {{site.base_gateway}} can substantially increase its performance. You can establish a baseline for performance by performing an initial benchmark of {{site.base_gateway}}, optimizing the `kong.conf` file using the recommendations in this guide, and then conducting several additional benchmark tests.

This guide explains the following:
* How to establish an initial {{site.base_gateway}} peformance benchmark
* How to optimize {{site.base_gateway}} peformance before performing additional benchmarks
* How to configure your kong.conf for benchmarking

{% if_version eq:3.4.x %}
## Prerequisites
* {{site.base_gateway}} 3.4.2.0 or later
{% endif_version %}

## Perform a baseline {{site.base_gateway}} performance benchmark

Before you conduct a benchmark test, you must make sure the testbed is configured correctly. The following are a few general recommendations before you begin the benchmark tests:

* Use fewer nodes of {{site.base_gateway}} with four or eight NGINX workers with corresponding CPU resource allocations rather than many smaller {{site.base_gateway}} nodes.
* Run {{site.base_gateway}} in DB-less or hybrid mode. In these modes, {{site.base_gateway}}’s proxy nodes aren't connected to a database, which can become another variable that might affect performance.

Once you have implemented those recommendations, you can begin the benchmark test: 

1. Configure a route with a [Request Termination plugin](/hub/kong-inc/request-termination/) and measure {{site.base_gateway}}'s performance. In this case, {{site.base_gateway}} responds to the request and doesn't send any traffic to the upstream server.
1. Run this test a few times to spot unexpected bottlenecks. Either {{site.base_gateway}}, the benchmarking client (such as k6 or jmeter), or some other component will likely be an unexpected bottleneck. You should not expect higher performance from {{site.base_gateway}} until you solve these bottlenecks. Proceed to the next step only after this baseline performance is acceptable to you.
1. Once you have established the baseline, configure a route to send traffic to the upstream server without any plugins. This measures {{site.base_gateway}}'s proxy and your upstream server's performance.
1. Verify that no components are unexpectedly causing a bottleneck before proceeding.
1. Run the benchmark multiple times to gain confidence in the data. Ensure that the difference between observations isn't high (there's a low standard deviation).
1. Discard the stats collected by the benchmark's first one or two iterations. We recommend this to ensure that the system is operating at an optimal and stable level.

Only after the previous steps are completed should you proceed with benchmarking {{site.base_gateway}} with additional configuration. Read the optimization recommendations in the following sections and make any changes to the configuration as needed before performing additional benchmarks.

## Optimize {{site.base_gateway}} peformance

The subsections in this section detail recommendations to improve your {{site.base_gateway}} performance for additional benchmark tests. Read each section carefully and make any adjustments to your configuration file.

### Check the `ulimit` 

**Action:** Increase the `ulimit` if it's less than `16384`. 

While {{site.base_gateway}} can use as many resources as it can get from the system, the Operating System (OS) limits it in the number of connections it can open with the upstream (or any other) server or accept from the client. The number of open connections in {{site.base_gateway}} defaults to the `ulimit` with an upper bound of 16384. This means that if the `ulimit` is unlimited or a value higher than 16384, {{site.base_gateway}} will limit itself to 16384. You can shell into {{site.base_gateway}}’s container or VM and run `ulimit -n` to check the system’s `ulimit`. You must shell into the container if {{site.base_gateway}} is running inside a container on top of a VM. If the value of `ulimit` is less than 16384, increase it. Also check and set the appropriate `ulimit` in the client and upstream server since a connection bottleneck in these systems leads to suboptimal performance. 

### Increase connection re-use 

**Action:** Configure `upstream_keepalive_max_requests = 100000` and `nginx_http_keepalive_requests = 100000`.

In high-throughput scenarios with 10,000 or more RPS, the overhead of setting up TCP and TLS connections or insufficient connections can result in under utilization of network bandwidth or the upstream server.
To increase connection re-use, you can increase `upstream_keepalive_max_requests` and `nginx_http_keepalive_requests` to `100000` or up to `500000`. 

### Avoid auto-scaling

**Action:** Ensure that {{site.base_gateway}} is not scaled in/out (horizontal) or up/down (vertical).

During a benchmarking run, ensure that {{site.base_gateway}} is not scaled in/out (horizontal) or up/down (vertical). In Kubernetes, this is commonly done using a Horizontal or Vertical Pod autoscaler. Autoscalers interfere with statistics in a benchmark and introduce unnecessary noise.
Scale {{site.base_gateway}} out before testing the benchmark to avoid auto-scaling during the benchmark. Monitor the number of {{site.base_gateway}} nodes to ensure new nodes are spawned during the benchmark and existing nodes are not replaced.

### Use multiple cores effectively

**Action:** On most VM setups, set `nginx_worker_processes` to `auto`. On Kubernetes, set `nginx_worker_processes` to one or two less than the worker node CPUs. 

Make sure `nginx_worker_processes` is configured correctly:

* Setting this to 'auto' (default) is appropriate for most VM setups. This ensures that Nginx spawns one worker process for each CPU core (desired).
* Setting this explicitly in k8s is recommended. Ensure CPU requests and limits for {{site.base_gateway}} match the number of workers configured in {{site.base_gateway}}. For example, if configuring nginx_worker_processes=4, you must request 4 CPUs in your pod spec.
    If you run {{site.base_gateway}} pods on k8s worker nodes with n CPUs, allocate n-2 or n-1 to {{site.base_gateway}} (and configure worker process count equal to this number). This ensures that any daemon set and k8s processes (such as kubelet) do not contend for resources with {{site.base_gateway}}.  
    Please note that each additional worker uses additional memory, so you must ensure that {{site.base_gateway}} is not getting OOM killed.

### Resource contention

**Action:** Make sure the client (like JMeter or k6), {{site.base_gateway}}, and upstream servers on on different machinces (VM or bare metal) and run within the same local network with low latencies.

1. Ensure that the Client (such as JMeter, k6), {{site.base_gateway}}, and the Upstream servers run on different machines (VM or bare-metal). If these are all running in a k8s cluster, ensure that the pods for these three systems are scheduled on dedicated nodes. Resource contention (of CPU and network usually) between these can lead to sub-optimal performance of any system. 
1. Ensure the Client, {{site.base_gateway}}, and Upstream run within the same local network with low latencies. If requests between the Client and {{site.base_gateway}} or {{site.base_gateway}} and the Upstream server traverse the Internet, then the results will contain unnecessary noise. 

### Upstream servers maxing out

**Action:** Verify that the upstream server is not maxing out.

This can be verified by checking the CPU and memory usage of the upstream server.
If you deploy additional {{site.base_gateway}} nodes and the throughput or error rate remains the same, the Upstream server or a system other than {{site.base_gateway}} is likely bottlenecked.
You also must ensure that Upstream servers are not autoscaled.

### Client maxing out

**Action:** The client must use keep-alive connections.

Sometimes, the clients (such as k6 and Jmeter) max themselves out. Tuning them requires knowledge of the Client itself. Increasing the CPU, threads, and connections on these clients results in higher resource utilization and throughput.
The Client must also use keep-alive connections. For example, [k6](https://k6.io/docs/using-k6/k6-options/reference/#no-connection-reuse) enables keep-alive by default, and [HTTPClient4](https://hc.apache.org/httpcomponents-client-4.5.x/index.html) implementation in Jmeter enables keep-alive by default. Please verify that this is set up appropriately for your test setup.

### Custom plugins

**Action:** Ensure custom plugins aren't interfering with performance.  

Writing performant custom plugins requires care, attention, and some knowledge of {{site.base_gateway}} internals.

Ruling out custom plugins should be your first order of business. You can do so by measuring three configuration variations:

* Keep the necessary bundled plugins enabled and disable all custom plugins
* And then configure appropriate custom plugins

Sometimes, measuring {{site.base_gateway}}'s baseline performance (no plugins) can help spot issues outside {{site.base_gateway}}.

### Cloud-provider gotchas

**Action:** Ensure you aren't using burstable instances or hitting bandwidth, TCP connection per unit time, or PPS limits. 

While AWS is mentioned in the following recommendations, the same applies to most cloud providers:

* Ensure that you are not using burstable instances like T instances in AWS. In this case, the CPU available to applications is variable, leading to noise in the stats. See [Burstable performance instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html).
* Ensure you are not hitting bandwidth limits, TCP connections per unit time limits, or Packet Per Second (PPS) limits. See [Amazon EC2 instance network bandwidth](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-network-bandwidth.html).

### Configuration changes during benchmarking

**Action:** Don't change {{site.base_gateway}} configuration during a test.

If you change the configuration during a test, {{site.base_gateway}}'s tail latencies can increase sharply. Avoid doing this unless you are measuring {{site.base_gateway}}'s performance under configuration change.

### Large request and response bodies

**Action:** Keep request bodies less than eight KB and response bodies less than 32 KB.

Most benchmarking setups generally consist of an HTTP request with a small HTTP body and a corresponding HTTP response with a JSON or HTML response body. What is small? A request body of less than 8 kilobytes and a response body of less than 32 kilobytes. If your request or response bodies are larger, {{site.base_gateway}} will buffer the request/response using the disk, which significantly impacts {{site.base_gateway}}'s performance.

### Bottlenecks in third-party systems

**Action:**

More often than not, the bottlenecks in {{site.base_gateway}} arise due to bottlenecks in third-party systems used in {{site.base_gateway}}. The following sub sections explain common third-party bottlenecks and how to fix them.

#### Redis

If any plugin is enabled and Redis is used, ensure Redis is not bottlenecked.
Redis generally gets bottlenecked by the CPU first, so check CPU utilization first.
Scale Redis vertically by giving it an additional CPU.

#### DNS

DNS servers can bottleneck {{site.base_gateway}} since {{site.base_gateway}} depends on DNS to determine where to send the request.

In the case of k8s, DNS TTLs are 5 seconds long and are known to cause problems.
Increasing `dns_stale_ttl` to `300` or even up to `86400` can help rule out DNS as the issue.

If DNS servers are the root cause, you will see `coredns` pods bottlenecking on the CPU.

### Blocking I/O for access logs

**Action:**

{{site.base_gateway}} (and underlying Nginx) are programmed for non-blocking network I/O and avoid blocking disk I/O as much as possible. However, access logs are turned on by default, and if the disk powering a {{site.base_gateway}} node is slow for any reason, it can result in performance loss.
Disable access logs for high throughput benchmarking tests by setting the `proxy_access_log` configuration parameter to `off`.

### Internal errors in {{site.base_gateway}}

**Action:**

Make sure that there are no errors in {{site.base_gateway}}’s error log. Internal errors can highlight issues within {{site.base_gateway}} or a third-party system that {{site.base_gateway}} relies on to proxy traffic.

## Example kong.conf for benchmarking

All parameters referenced above are listed below

```bash
# kong.conf values

# change this for k8s setup to a number matching CPU limit. Suggested value is 4 or 8
nginx_worker_processes=auto

upstream_keepalive_max_requests=100000
nginx_http_keepalive_requests=100000

proxy_access_log=off

dns_stale_ttl=3600

# kong.conf but in environment variable form

# change this for k8s setup to a number matching CPU limit. Suggested value is 4 or 8
KONG_NGINX_WORKER_PROCESSES="auto"
KONG_UPSTREAM_KEEPALIVE_MAX_REQUESTS="100000"
KONG_NGINX_HTTP_KEEPALIVE_REQUESTS="100000"

KONG_PROXY_ACCESS_LOG="off"

KONG_DNS_STALE_TTL="3600"

# kong.conf for Kong Gateway's official Helm chart values.yaml

# The value of 4 for worker process is a suggest value. You can use 8 as well.
# Please make sure to allocate the same amount of CPU and appropriate memory to avoid OOM killing.
env:
  nginx_worker_processes: "4"
  upstream_keepalive_max_requests: "100000"
  nginx_http_keepalive_requests: "100000"
  proxy_access_log: "off"
  dns_stale_ttl: "3600"

resources:
  requests:
    cpu: 4
    memory: ""
  limits:
    cpu: 4
    memory: ""
```

## Conclusion

Macro/micro benchmarking is not scientific, given it is not usually a good proxy for real-world scenarios. But, it is the best tool that our customers have today. As with performance, always measure, make some changes, and measure again. Maintaining a log of changes will help you figure out the following steps when you get stuck or trace back another approach.

