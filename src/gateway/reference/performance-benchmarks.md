---
title: Kong Gateway Performance Benchmarking 
badge: enterprise
content_type: reference
---

Performance testing is an essential part of ensuring the reliability and scalability of your API gateway. The Kong engineering team has built extended performance testing into [{{site.base_gateway}}'s](/gateway/latest/) continuous integration (CI) and release systems to ensure validation of the gateway's performance under load. This reference provides details on the methodology used and meaning of the captured performance data. 

## Test Scenarios

A test scenario is a combination of gateway deployment mode, configuration, test case, and test environment. The performance testing framework is designed for flexibility and addition of testing scenarios over time. The current test scenarios include the following:

| Scenario Name | Test Case | Gateway Mode | Gateway Configuration |
| --- | --- | --- | --- |
| _Steady State_ | * DP throughput & latency<br> * 5 minute soak test of DP with 50 Virtual Users<br> * No configuration changes | Hybrid: 1 CP 1 DP | 9,600 entities |
| _Dynamic Configuration State_ | * DP throughput & latency<br> * 15 minute soak of DP * Configuration changes every 30 seconds | Hybrid: 1 CP 1 DP | 12,000 entities |
| _Stability Test_ | * DP throughput & latency<br> * 7 day soak test | Hybrid: 1 CP 1 DP | 9,600 entities |
 
* Hybrid = Kong Hybrid Mode
* CP = Control Plane
* DP = Data Plane

## Captured Metrics

| Metric | Description |
| --- | --- |
| RPS (requests per second or throughput) | The number of requests per second the gateway handled during the test run. Higher is better. |
| Min Latency | The minimum captured round trip milliseconds between the test framework and the gateway. Lower is better. |
| Max Latency | The maximum captured round trip milliseconds between the test framework and the gateway. Lower is better. |
| Avg Latency | The average captured round trip milliseconds between the test framework and the gateway. Lower is better. |
| P99 Latency | Short for "99th latency percentile". This means 99% of requests will be faster than the given latency number. Lower is better. |

## Results

### 3.1.0.0

| Metric | 3.1.0.0 | 3.0.1.0 | 
| ------ | ------- | ------- |
| RPS | 103,173 | +6.32% |
| Min Latency | 0.29ms | -3.34% |
| Avg Latency | 0.90ms | -6.25% |
| Max Latency | 53.5ms | +5.49% |
| P99 | 3.17ms | -8.65% |

![3.1.0.0 Performance Snapshot - Latency](/assets/images/docs/gateway/performance-snapshots/3.1.0.0-to-3.0.0.0-latency.png)

![3.1.0.0 Performance Snapshot - Throughput](/assets/images/docs/gateway/performance-snapshots/3.1.0.0-to-3.0.0.0-throughput.png)

## Technologies

* Gateway instance size - 8 Core, 16 threads, 64GB Memory (In docker, we constrain the usage of cpu to 10, and the memory limit to 16G)
* decK configurations are used to bootstrap the gateway
* Upstream Service
   During test requests are hitting custom Ngnix upstream docker service running in the same Hetzner instance as Gateway
   Nginx instance - 8 Core, 16 threads, 64GB Memory
* [K6](https://k6.io) is an open-source testing framework designed specifically for testing the performance of APIs and microservices. It allows you to define and execute performance tests in a declarative manner, making it easy to create and maintain a comprehensive performance testing suite.
* etc...
* etc...

