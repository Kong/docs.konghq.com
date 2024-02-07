---
title: Conduct performance testing
content_type: reference
description: This documentation provides a comprehensive guide for conducting Kong Gateway performance testing using Kong's test suite, including Kong's own benchmark for the current version.
---

As of {{site.base_gateway}} 3.6.x, Kong will start to publish performance results on {{site.base_gateway}}, along with the test methodology and details. Kong will conduct and publish {{site.base_gateway}} performance results for each minor release.

In addition to publishing performance test results, you can use [our public test suite](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main) to conduct your own performance tests with {{site.base_gateway}}.

## {{site.base_gateway}} peformance testing method and results for {{page.release}}

Kong tests performance results for {{site.base_gateway}} using the [our public test suite](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main). The following sections explain the test methodology, results, and configuration.  

### Test method

These performance tests cover a number of baseline configurations and common use cases of {{site.base_gateway}}. 

| Decription              | Method  |
| ----------------------- | --------------------------- |
| **Environment**        | Kubernetes environment on AWS infrastructure       |
| **Test use cases**        | The following use cases were tested:<br><ul><li>Basic {{site.base_gateway}} proxy</li><li>[Rate limiting](/hub/kong-inc/rate-limiting/) a request with no authentication</li><li>Authentication using the [basic auth plugin](/hub/kong-inc/basic-auth/) and Rate Limiting</li><li>Authentication using the [key auth plugin](/hub/kong-inc/key-auth/) and rate limiting</li></ul>       |
| **Routes and consumers**        | Each case was tested with two different options, one with one route and one consumer, and one with 100 routes and 100 consumers, for a total of eight test cases. For test cases that didn't require authentication, no consumers were used.       |
| **Traffic distribution**       | Normal distribution across both routes and consumers       |
| **Protocol**        | HTTPS       |
| **Sample size**        | Each test case was run five times, each for a duration of 15 minutes. The results are an average across the five different test runs.        |

### {{site.base_gateway}} performance benchmark results

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

### Test environment

Kong runs these tests in AWS using EC2 machines. We used [Kubernetes taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to ensure that {{site.base_gateway}} is on its own node while the load testing and observability tools are on their own separate nodes in the same cluster.

The {{site.base_gateway}} runs on a single dedicated instance of c5.4xlarge, and the two nodes for the observability stack and K6 ran on dedicated c5.metal instances. We used the metal instances for the observability load generation toolchain to ensure they are not resource constrained in any way. Since [K6 is very resource demanding](https://k6.io/docs/testing-guides/running-large-tests/#hardware-considerations) when generating a high amount of traffic during tests, we observed that using smaller or less powerful instances for the toolchain caused the observability load generation tools to be a bottleneck for {{site.base_gateway}} performance.

### Test configuration

For these tests, we changed the number of worker processes to match the number of available cores to the node running {{site.base_gateway}}, which was 16 vCPU. Accordingly, we set the number of processes to 16. This follows [Kong’s overall performance guidance](/gateway/latest/production/sizing-guidelines/). Outside of this change, no other tuning was made.

## Conduct your own performance test using Kong's test suite

Kong has published a public repo with our test suite [here](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main). The repo will help you spin up an EKS cluster with Kong, Redis, Prometheus, and Grafana installed. Additionally, it will configure [K6](https://k6.io/), a popular open source load testing tool.

Once the cluster is generated, you can apply the provided yaml to configure the Gateway for the included test cases and the observability plugins for metrics scraping by the prometheus instance already provisioned in the cluster.

If you’d rather define your own test scenarios, now would be the time to define the {{site.base_gateway}} configuration you want to test and apply it to the cluster!

From there you can use the included bash scripts to run K6 tests. After the tests have completed, you can port-forward your way into the cluster and view the grafana dashboard we created with the results.



