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

Closely related to monitoring is tracing. See the {{site.base_gateway}} [Tracing Reference](/gateway/latest/production/tracing/)
for details about instrumenting your API gateway.
