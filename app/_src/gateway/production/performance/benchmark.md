---
title: Establish a Kong Gateway performance benchmark
content_type: reference
description: This documentation provides a comprehensive guide for optimizing the performance of Kong Gateway by establishing a benchmark.
---

While {{site.base_gateway}} is optimized out-of-the-box, there are still situations where tweaking some configuration 
options for {{site.base_gateway}} can substantially increase its performance. 
You can establish a baseline for performance by running an initial benchmark of {{site.base_gateway}}, optimizing the 
`kong.conf` file using the recommendations in this guide, and then conducting several additional benchmark tests.

This guide explains the following:
* How to establish an initial {{site.base_gateway}} performance benchmark
* How to optimize {{site.base_gateway}} performance before performing additional benchmarks
* How to configure your `kong.conf` for benchmarking

## Prerequisites

{% if_version eq:3.4.x %}
You must have {{site.base_gateway}} 3.4.2.0 or later.
{% endif_version %}

Before you conduct a benchmark test, you must make sure the testbed is configured correctly.
Here are a few general recommendations before you begin the benchmark tests:

* Use fewer nodes of {{site.base_gateway}} with 4 or 8 NGINX workers with corresponding CPU resource 
allocations rather than many smaller {{site.base_gateway}} nodes.
* Run {{site.base_gateway}} in DB-less or hybrid mode. 
In these modes, {{site.base_gateway}}’s proxy nodes aren't connected to a database, which can become another 
variable that might affect performance.

## Perform a baseline {{site.base_gateway}} performance benchmark

Once you have implemented the recommendations in the [prerequisites](#prerequisites), you can begin the benchmark test: 

1. Configure a route with a [Request Termination plugin](/hub/kong-inc/request-termination/) and measure {{site.base_gateway}}'s performance. 
In this case, {{site.base_gateway}} responds to the request and doesn't send any traffic to the upstream server.
1. Run this test a few times to spot unexpected bottlenecks. 
Either {{site.base_gateway}}, the benchmarking client (such as k6 or Apache JMeter), or some other component will likely be an unexpected bottleneck. 
You should not expect higher performance from {{site.base_gateway}} until you solve these bottlenecks. 
Proceed to the next step only after this baseline performance is acceptable to you.
1. Once you have established the baseline, configure a route to send traffic to the upstream server without any plugins. 
This measures {{site.base_gateway}}'s proxy and your upstream server's performance.
1. Verify that no components are unexpectedly causing a bottleneck before proceeding.
1. Run the benchmark multiple times to gain confidence in the data. 
Ensure that the difference between observations isn't high (there's a low standard deviation).
1. Discard the stats collected by the benchmark's first one or two iterations. 
We recommend doing this to ensure that the system is operating at an optimal and stable level.

Only after the previous steps are completed should you proceed with benchmarking {{site.base_gateway}} with 
additional configuration. 
Carefully read the optimization recommendations in the following sections and make any changes to the configuration 
as needed before performing additional benchmarks.

## Optimize {{site.base_gateway}} performance

The subsections in this section detail recommendations to improve your {{site.base_gateway}} performance for 
additional benchmark tests.
Read each section carefully and make any necessary adjustments to your configuration file.

### Check the `ulimit` 

**Action:** Increase the `ulimit` if it's less than `16384`. 

**Explanation:** While {{site.base_gateway}} can use as many resources as it can get from the system, the 
operating system (OS) limits the number of connections {{site.base_gateway}} can open with the upstream 
(or any other) server, or that it can accept from the client. 
The number of open connections in {{site.base_gateway}} defaults to the `ulimit` with an upper bound of 16384. 
This means that if the `ulimit` is unlimited or is a value higher than 16384, {{site.base_gateway}} limits itself to 16384. 

You can shell into {{site.base_gateway}}’s container or VM and run `ulimit -n` to check the system’s `ulimit`. 
If {{site.base_gateway}} is running inside a container on top of a VM, you must shell into the container.
If the value of `ulimit` is less than 16384, increase it. 
Also check and set the appropriate `ulimit` in the client and upstream server, since a connection bottleneck 
in these systems leads to suboptimal performance.

### Increase connection reuse

**Action:** Configure `upstream_keepalive_max_requests = 100000` and `nginx_http_keepalive_requests = 100000`.

**Explanation:** In high throughput scenarios with 10 000 or more RPS, the overhead of setting up TCP and TLS 
connections or insufficient connections can result in under utilization of network bandwidth or the upstream server.
To increase connection re-use, you can increase `upstream_keepalive_max_requests` and `nginx_http_keepalive_requests` 
to `100000`, or all the way up to `500000`.

### Avoid auto-scaling

**Action:** Ensure that {{site.base_gateway}} is not scaled in/out (horizontal) or up/down (vertical).

**Explanation:** During a benchmarking run, ensure that {{site.base_gateway}} is not scaled in/out (horizontal) 
or up/down (vertical). 
In Kubernetes, this is commonly done using a Horizontal or Vertical Pod autoscaler. 
Autoscalers interfere with statistics in a benchmark and introduce unnecessary noise.

Scale {{site.base_gateway}} out before testing the benchmark to avoid auto-scaling during the benchmark. 
Monitor the number of {{site.base_gateway}} nodes to ensure new nodes are spawned during the benchmark and 
existing nodes are not replaced.

### Use multiple cores effectively

**Action:** On most VM setups, set `nginx_worker_processes` to `auto`. On Kubernetes, set `nginx_worker_processes` 
to one or two less than the worker node CPUs. 

**Explanation:** Make sure `nginx_worker_processes` is configured correctly:

* On most VM setups, set this to `auto`. This is the default setting. This ensures that NGINX spawns one 
worker process for each CPU core, which is desired.
* We recommend setting this explicitly in Kubernetes. Ensure CPU requests and limits for {{site.base_gateway}} 
match the number of workers configured in {{site.base_gateway}}. For example, if you configure `nginx_worker_processes=4`,
you must request 4 CPUs in your pod spec.
  
  If you run {{site.base_gateway}} pods on Kubernetes worker nodes with n CPUs, allocate n-2 or n-1 to 
  {{site.base_gateway}}, and configure a worker process count equal to this number. 
  This ensures that any configured daemons and Kubernetes processes, like kubelet, don't contend 
  for resources with {{site.base_gateway}}.  
  
  Each additional worker uses additional memory, so you must ensure that {{site.base_gateway}} isn't triggering 
  the Linux Out-of-Memory Killer.

### Resource contention

**Action:** Make sure the client (like Apache JMeter or k6), {{site.base_gateway}}, and upstream servers are on different 
machines (VM or bare metal) and run on the same local network with low latencies.

**Explanation:**
* Ensure that the client (like Apache JMeter or k6), {{site.base_gateway}}, and the upstream servers run on different 
machines (VM or bare-metal). If these are all running in a Kubernetes cluster, ensure that the pods for these three systems 
are scheduled on dedicated nodes. 
Resource contention (usually CPU and network) between these can lead to suboptimal performance of any system. 
* Ensure the client, {{site.base_gateway}}, and upstream servers run on the same local network with low latencies. 
If requests between the client and {{site.base_gateway}} or {{site.base_gateway}} and the upstream server traverse the internet,
then the results will contain unnecessary noise. 

### Upstream servers maxing out

**Action:** Verify that the upstream server isn't maxing out.

**Explanation:** You can verify that the upstream server isn't maxing out by checking the CPU and memory 
usage of the upstream server.
If you deploy additional {{site.base_gateway}} nodes and the throughput or error rate remains the same,
the upstream server or a system other than {{site.base_gateway}} is likely the bottleneck.

You must also ensure that upstream servers are not autoscaled.

### Client maxing out

**Action:** The client must use keep-alive connections.

**Explanation:** Sometimes, the clients (such as k6 and Apache JMeter) max themselves out. 
To tune them, you need to understand the client. Increasing the CPU, threads, and connections on clients results in 
higher resource utilization and throughput.

The client must also use keep-alive connections. For example, [k6](https://k6.io/docs/using-k6/k6-options/reference/#no-connection-reuse) 
and the [HTTPClient4](https://hc.apache.org/httpcomponents-client-4.5.x/index.html) implementation in Apache JMeter both enable keep-alive by default. 
Verify that this is set up appropriately for your test setup.

### Custom plugins

**Action:** Ensure custom plugins aren't interfering with performance.  

**Explanation:** Custom plugins can sometimes cause issues with performance. 
First, you should determine if custom plugins are the source of the performance issues. 
You can do this by measuring three configuration variations:

1. Measure {{site.base_gateway}}’s performance without enabling any plugins. This provides a baseline for {{site.base_gateway}}’s performance.
1. Enable necessary bundled plugins (plugins that come with the product), and then measure {{site.base_gateway}}’s performance.
1. Next, enable custom plugins (in addition to bundled plugins), and then measure {{site.base_gateway}}’s performance once again.

If {{site.base_gateway}}’s baseline performance is poor, then it's likely that either {{site.base_gateway}}’s configuration needs 
tuning or external factors are affecting it. For external factors, see the other sections in this guide.
A large difference between the performance in the second and third steps indicates that performance problems could be due to custom plugins.

### Cloud-provider performance issues

**Action:** Ensure you aren't using burstable instances or hitting bandwidth, TCP connection per unit time, or PPS limits. 

**Explanation:** While AWS is mentioned in the following, the same recommendations apply to most cloud providers:

* Ensure that you are not using burstable instances, like T type instances, in AWS. 
In this case, the CPU available to applications is variable, which leads to noise in the stats. 
For more information, see the [Burstable performance instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html) AWS documentation.
* Ensure you are not hitting bandwidth limits, TCP connections per unit time limits, or Packet Per Second (PPS) limits. 
For more information, see the [Amazon EC2 instance network bandwidth](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-network-bandwidth.html) AWS documentation.

### Configuration changes during benchmark tests

**Action:** Don't change the {{site.base_gateway}} configuration during a benchmark test.

**Explanation:** If you change the configuration during a test, {{site.base_gateway}}'s tail latencies can increase sharply. 
Avoid doing this unless you are measuring {{site.base_gateway}}'s performance under a configuration change.

### Large request and response bodies

**Action:** Keep request bodies below 8 KB and response bodies below 32 KB.

**Explanation:** Most benchmarking setups generally consist of an HTTP request with a small HTTP body and a corresponding 
HTTP response with a JSON or HTML response body. 
A request body of less than 8 KB and a response body of less than 32 KB is considered small. 
If your request or response bodies are larger, {{site.base_gateway}} will buffer the request and response using the disk, 
which significantly impacts {{site.base_gateway}}'s performance.

### Bottlenecks in third-party systems

**Explanation:** More often than not, the bottlenecks in {{site.base_gateway}} are caused by bottlenecks in third-party 
systems used by {{site.base_gateway}}. 
The following sections explain common third-party bottlenecks and how to fix them.

#### Redis

**Action:** If you use Redis and any plugin is enabled, the CPU can cause a bottleneck. Scale Redis vertically by giving 
it an additional CPU.

**Explanation:** If you use Redis and any plugin is enabled, ensure Redis is not a bottleneck.
The CPU generally creates a bottleneck for Redis, so check CPU usage first.
If this is the case, scale Redis vertically by giving it an additional CPU.

#### DNS

**Action:** Increase `dns_stale_ttl` to `300` or up to `86400`.

**Explanation:** DNS servers can bottleneck {{site.base_gateway}} since {{site.base_gateway}} depends on DNS to determine 
where to send the request.

In the case of Kubernetes, DNS TTLs are 5 seconds long and can cause problems.
You can increase `dns_stale_ttl` to `300` or up to `86400` to rule out DNS as the issue.

If DNS servers are the root cause, you will see `coredns` pods creating a bottleneck on the CPU.

### Blocking I/O for access logs

**Action:** Disable access logs for high throughput benchmarking tests by setting the `proxy_access_log` 
configuration parameter to `off`.

**Explanation:** {{site.base_gateway}} and the underlying NGINX are programmed for non-blocking network I/O and they 
avoid blocking disk I/O as much as possible. 
However, access logs are enabled by default, and if the disk powering a {{site.base_gateway}} node is slow for any reason,
it can result in performance loss.
Disable access logs for high throughput benchmarking tests by setting the `proxy_access_log` configuration parameter to `off`.

### Internal errors in {{site.base_gateway}}

**Action:** Make sure that there are no errors in {{site.base_gateway}}’s [error log](/gateway/{{page.release}}/reference/configuration/#log_level).

**Explanation:** Check {{site.base_gateway}}’s error log for internal errors. 
Internal errors can highlight issues within {{site.base_gateway}} or a third-party system that {{site.base_gateway}} relies on to proxy traffic.

## Example kong.conf for benchmarking

The following `kong.conf` file examples contain all the recommended parameters from the previous sections:

{% navtabs %}
{% navtab kong.conf %}

If applying configuration by directly editing `kong.conf`, use the following:

```bash
# For a Kubernetes setup, change nginx_worker_processes to a number matching the CPU limit. We recommend 4 or 8.
nginx_worker_processes=auto

upstream_keepalive_max_requests=100000
nginx_http_keepalive_requests=100000

proxy_access_log=off

dns_stale_ttl=3600
```
{% endnavtab %}
{% navtab Environment variable format %}

If applying configuration through environment variables, use the following:

```bash
# For a Kubernetes setup, change nginx_worker_processes to a number matching the CPU limit. We recommend 4 or 8.
KONG_NGINX_WORKER_PROCESSES="auto"
KONG_UPSTREAM_KEEPALIVE_MAX_REQUESTS="100000"
KONG_NGINX_HTTP_KEEPALIVE_REQUESTS="100000"

KONG_PROXY_ACCESS_LOG="off"

KONG_DNS_STALE_TTL="3600"
```
{% endnavtab %}
{% navtab Helm chart values.yaml %}

If applying configuration through a Helm chart, use the following:

```yaml
# The value of 4 for nginx_worker_processes is a suggested value. You can use 8 as well.
# Allocate the same amount of CPU and appropriate memory to avoid OOM killer.
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
{% endnavtab %}
{% endnavtabs %}

## Next steps

Now that you've optimized the performance of {{site.base_gateway}}, you can perform additional benchmarks. 
Always measure, make some changes, and measure again. 
Maintain a log of changes to help you figure out the next steps when you get stuck or trace back to another approach.

