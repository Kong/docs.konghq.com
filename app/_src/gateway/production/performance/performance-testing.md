---
title: Performance testing benchmarks
content_type: reference
description: This documentation provides a comprehensive guide for conducting Kong Gateway performance testing using Kong's test suite, including Kong's own benchmark for the current version.
---

As of {{site.base_gateway}} 3.6.x, Kong now publishes performance results on {{site.base_gateway}}, along with the test methodology and details. <!--Kong will conduct and publish {{site.base_gateway}} performance results for each subsequent minor release.-->

In addition to viewing our performance test results, you can use [our public test suite](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main) to conduct your own performance tests with {{site.base_gateway}}.

## {{site.base_gateway}} performance testing method and results for {{page.release}}

Kong tests performance results for {{site.base_gateway}} using [our public test suite](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main).

The following sections explain the test methodology, results, and configuration.  

### Test method

The performance tests cover a number of baseline configurations and common use cases of {{site.base_gateway}}. The following describes the test cases used and the configuration methodology: 

* **Environment**: Kubernetes environment on AWS infrastructure.
* **Test use cases**: 
    * Basic {{site.base_gateway}} proxy.
    * [Rate limiting](/hub/kong-inc/rate-limiting/) a request with no authentication.
    * Authentication using the [Basic Auth plugin](/hub/kong-inc/basic-auth/) and rate limiting.
    * Authentication using the [Key Auth plugin](/hub/kong-inc/key-auth/) and rate limiting.
* **Routes and consumers**: Each case was tested with two different options: one with one route and one consumer, and one with 100 routes and 100 consumers, for a total of eight test cases. For test cases that didn't require authentication, no consumers were used.
* **Traffic distribution**: Normal distribution across both routes and consumers.
* **Protocol**: HTTPS only.
* **Sample size**: Each test case was run five times, each for a duration of 15 minutes. The results are an average of the five different test runs.

### {{site.base_gateway}} performance benchmark results

{% if_version eq:3.6.x %}

| Test type                   | Number of routes/consumers  | Requests per second (RPS) | P99 (ms) | P95 (ms) |
| --------------------------- | --------------------------- | ------------------------- | -------- | -------- |
| Kong proxy with no plugins  | 1 route, 0 consumers       | 137850.4                  | 6.25     | 3.82     |
| Kong proxy with no plugins  | 100 routes, 0 consumers    | 132302.8                  | 6.55     | 3.99     |
| Rate limit and no auth      | 1 route, 0 consumers       | 116413.8                  | 7.59     | 4.56     |
| Rate limit and no auth      | 100 routes, 0 consumers    | 111615.8                  | 7.62     | 4.54     |
| Rate limit and key auth     | 1 route, 1 consumer         | 102261.6                  | 8.47     | 5.05     |
| Rate limit and key auth     | 100 routes, 100 consumers   | 96289.6                   | 8.82     | 5.25     |
| Rate limit and basic auth   | 1 route, 1 consumer         | 95297.8                   | 8.75     | 5.66     |
| Rate limit and basic auth   | 100 routes, 100 consumers   | 89777.4                   | 9.34     | 5.89     |
{% endif_version %}


### Test environment

Kong ran these tests in AWS using EC2 machines. We used [Kubernetes taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to ensure that {{site.base_gateway}} is on its own node while the load testing and observability tools are on their own separate nodes in the same cluster.

The {{site.base_gateway}} ran on a single dedicated instance of c5.4xlarge, and the two nodes for the observability stack and K6 ran on dedicated c5.metal instances. We used the metal instances for the observability load generation toolchain to ensure they aren't resource constrained in any way. Since [K6 is very resource demanding](https://k6.io/docs/testing-guides/running-large-tests/#hardware-considerations) when generating a high amount of traffic during tests, we observed that using smaller or less powerful instances for the toolchain caused the observability load generation tools to be a bottleneck for {{site.base_gateway}} performance.

### Test configuration

For these tests, we changed the number of worker processes to match the number of available cores to the node running {{site.base_gateway}}, which was 16 vCPU. Accordingly, we set the number of processes to 16. This follows [Kong’s overall performance guidance](/gateway/latest/production/sizing-guidelines/). Outside of this change, no other tuning was made.

## Conduct your own performance test using Kong's test suite

You can use [Kong's public test suite repo](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main) to help you spin up an EKS cluster with {{site.base_gateway}}, Redis, Prometheus, and Grafana installed. Additionally, it will configure [K6](https://k6.io/), a popular open source load testing tool. You can use this test suite to conduct your own performance tests.

Once the cluster is generated, you can apply the [provided `yaml`](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main/deploy-k8s-resources/kong_helm) to configure the {{site.base_gateway}} for the included test cases and the observability plugins for metrics scraping by the Prometheus instance already provisioned in the cluster. If you’d rather define your own test scenarios, you can also define the {{site.base_gateway}} configuration you want to test and apply it to the cluster.

From there, you can use the [included bash scripts to run K6 tests](https://github.com/Kong/kong-gateway-performance-benchmark/tree/main/deploy-k8s-resources/k6_tests). After the tests complete, you can `port-forward` into the cluster and view the Grafana dashboard with the performance results.

## More information
* [Establish a {{site.base_gateway}} performance benchmark](/gateway/{{page.release}}/production/performance/benchmark): Learn how to optimize {{site.base_gateway}} for performance.


