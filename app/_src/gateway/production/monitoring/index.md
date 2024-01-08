---
title: Monitoring Overview
content-type: reference
---

API gateways isolate your applications from the outside world and provide critical path
protection for your upstream services. Understanding the state of your API gateway
system is critical to providing reliable API-based systems.

There are many monitoring and alerting systems available, and {{site.base_gateway}} integrates with 
multiple solutions:

* [Prometheus](https://prometheus.io/) is an open-source systems monitoring and alerting toolkit.
   Prometheus provides a multi-demensional time series data model and query language.
   The [Monitoring with Prometheus](/gateway/latest/production/monitoring/prometheus/) guide
   shows how to install and configure the {{site.base_gateway}} [Prometheus plugin](/hub/kong-inc/prometheus/).
* [Datadog](https://www.datadoghq.com/) is a popular cloud based infrastructure and application monitoring service.
   See the [Collect Metrics with Datadog guide](/gateway/latest/production/monitoring/datadog/) for information on 
   integrating {{site.base_gateway}} with Datadog. You can also integrate the [Datadog plugin](/hub/kong-inc/datadog/) with {{site.base_gateway}} for additional insights.
* [StatsD](https://github.com/statsd/statsd) is a lightweight network daemon that listens for application metrics on
   UDP or TCP and sends aggregated values to one or more backend services. {{site.base_gateway}} directly supports StatsD
   with the [StatsD plugin](/hub/kong-inc/statsd/). [Monitoring with StatsD](/gateway/latest/production/monitoring/statsd/) provides a 
   step-by-step guide to enabling StatsD.
* Use the built-in [Node Readiness endpoint](/gateway/latest/production/monitoring/healthcheck-probes/) for monitoring when {{site.base_gateway}} is ready to accept requests.

Closely related to monitoring is tracing. See the {{site.base_gateway}} [Tracing Reference](/gateway/latest/production/tracing/)
for details about instrumenting your API gateway.

## What is health checking?

Health checking is an activity performed by infrastructure components (that is, load balancers) to monitor the health of a {{site.base_gateway}} node.
This helps determine if a {{site.base_gateway}} node is operational and ready to process incoming requests. 
You can learn more about health checks (also known as "probes") in the [Readiness Check](/gateway/latest/production/monitoring/healthcheck-probes/) guide.

## Best practices

While every environment is unique and can have its own set of circumstances, we encourage you to follow these general recommendations:

* Enable the [`status_listen`](/gateway/latest/reference/configuration/#status_listen) configuration parameter.
* Always health check {{site.base_gateway}} and track the health in monitoring dashboards such as Datadog, Grafana, AppDynamics, and so on.
* Configure the load balancer or other components immediately fronting {{site.base_gateway}} to use the [readiness probe](/gateway/latest/production/monitoring/healthcheck-probes/).
* In the case of Kubernetes, configure both [liveness and readiness probes](/gateway/latest/production/monitoring/healthcheck-probes/) for {{site.base_gateway}}, ensuring a load balancer uses the correct [Kubernetes endpoints](https://kubernetes.io/docs/concepts/services-networking/service/#endpoints) to forward traffic to {{site.base_gateway}} pods. 
Don't expect the {{site.base_gateway}} readiness endpoint to respond with a `200 OK` immediately after startup, as it always takes a short time for {{site.base_gateway}} to load the first configuration and build all the necessary data structures before it can successfully proxy traffic.
* Set up alerting based on responses to the health checks to be proactive in case of an incident.
* Don't use the `kong health` CLI command to validate the overall health of the {{site.base_gateway}}, as this command only ensures that the Kong process is running and doesn't ensure the ability or validity of the configuration.
* Ensure that all nodes in a cluster are monitored. For example, checking only one data plane node in a cluster can't offer reliable insight into the health of other data plane nodes in the same cluster.