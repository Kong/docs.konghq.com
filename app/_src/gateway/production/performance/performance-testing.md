---
title: Conduct performance testing
content_type: reference
description: This documentation provides a comprehensive guide for conducting Kong Gateway performance testing using Kong's test suite, including Kong's own benchmark for the current version.
---

As of {{site.base_gateway}} 3.6.x, Kong will start to publish performance results on {{site.base_gateway}}, along with the test methodology and details. 

In the future, we will do this for each minor release. 

Test Overview:

These performance tests cover a number of baseline configurations and common use cases of the {{site.base_gateway}}. We chose to run these tests in a Kubernetes environment, on AWS infrastructure.

We test rate limiting and multiple authentication use cases with up to 100 consumers.

## Test suite repository

Kong has published a public repo with our test suite here. The repo will help you spin up an EKS cluster with Kong, Redis, Prometheus, and Grafana installed. Additionally, it will configure K6, a popular open source load testing tool.

Once the cluster is generated, you can apply the provided yaml to configure the Gateway for the included test cases and the observability plugins for metrics scraping by the prometheus instance already provisioned in the cluster.

If you’d rather define your own test scenarios, now would be the time to define the {{site.base_gateway}} configuration you want to test and apply it to the cluster!

From there you can use the included bash scripts to run K6 tests. After the tests have completed, you can port-forward your way into the cluster and view the grafana dashboard we created with the results.


## Test environment used in the {{site.base_gateway}} performance benchmark

We ran these tests in AWS using EC2 machines. We used Kubernetes taints to ensure that {{site.base_gateway}} gets on its own node while the load testing and observability tools were on their own, separate nodes within the same cluster..

The Gateway ran on a single dedicated instance of c5.4xlarge and the two nodes for the observability stack and K6 ran on dedicated c5.metal instances. We used the metal instances for the observability load generation toolchain to ensure they are not resource constrained in any way. Since K6 is very resource demanding when generating a high amount of traffic during tests, we observed using smaller/less powerful instances for the toolchain caused the observability load generation tools to be a bottleneck to measure the {{site.base_gateway}} performance.

## Configuration used in the {{site.base_gateway}} performance benchmark

For these tests, we changed the number of worker processes to match the number of available cores to the node running Kong, which was 16 vCPU. Accordingly, we set the number of processes to 16. This is inline with Kong’s overall performance guidance. Outside of this change, no other tuning took place.

## Methods tested in the {{site.base_gateway}} performance benchmark
 
Four primary test cases were defined:
* Basic {{site.base_gateway}} proxy 
* Rate Limiting a request with no authentication
* Authentication using the basic-auth plugin and Rate Limiting
* Authentication using the Kong key-auth plugin and Rate Limiting

Each test case had two different flavors, one with one route and one consumer, and one with 100 routes and 100 consumers, for a total of eight test cases. For test cases that did not require authentication, there were zero consumers used.

In the case with multiple routes and consumers, traffic was normally distributed across both the routes and consumers.

All test cases were run over https only.

Each test case was run five times, each for a duration of 15 minutes. The results published below are averaged across the five different test runs. 

## {{site.base_gateway}} performance benchmark for the current version

{% if_version eq:3.6.x %}

| Test type               | Number of routes/consumers  | Requests per second (RPS) | P99 (ms) | P95 (ms) |
| ----------------------- | --------------------------- | ------------------------- | -------- | -------- |
| Basic Kong Proxy        | 1 Route, No Consumers       | 137850.4                  | 6.25     | 3.82     |
| Basic Kong Proxy        | 100 Routes, No Consumers    | 132302.8                  | 6.55     | 3.99     |
| Rate Limit + No Auth    | 1 Route, No Consumers       | 116413.8                  | 7.59     | 4.56     |
| Rate Limit + No Auth    | 100 Routes, No Consumers    | 111615.8                  | 7.62     | 4.54     |
| Rate Limit + Key Auth   | 1 Route, 1 Consumer         | 102261.6                  | 8.47     | 5.05     |
| Rate Limit + Key Auth   | 100 Routes, 100 Consumers   | 96289.6                   | 8.82     | 5.25     |
| Rate Limit + Basic Auth | 1 Route, 1 Consumer         | 95297.8                   | 8.75     | 5.66     |
| Rate Limit + Basic Auth | 100 Routes, 100 Consumers   | 89777.4                   | 9.34     | 5.89     |
{% endif_version %}





