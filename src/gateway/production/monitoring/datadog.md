---
title: Collect Metrics with Datadog
content_type: how-to
---

You can use {{site.base_gateway}} and [the Prometheus plugin](/hub/kong-inc/prometheus/) to collect metrics in Datadog. 

## Prerequisites

* [Datadog Agent v6 or later](https://docs.datadoghq.com/agent/)
* [Enable the Prometheus plugin in {{site.base_gateway}}](/hub/kong-inc/prometheus/#example-config)

## Connect the Prometheus plugin to Datadog

Using Datadog Agent 6, you can connect Datadog to the Prometheus endpoint to start collecting metrics.

After enabling the Prometheus plugin for {{site.base_gateway}}, create a [Datadog Agent openmetrics.d](https://docs.datadoghq.com/integrations/openmetrics/) configuration at `/etc/datadog-agent/conf.d/openmetrics.d/conf.yaml`. This tells the agent to begin scraping metrics from {{site.base_gateway}}.

The following is an example configuration for pulling all the `kong_` prefixed metrics:

```
instances:
  - prometheus_url: http://localhost:8001/metrics
    namespace: "kong"
    metrics:
      - kong_*
```

For more information about collecting metrics using Prometheus and the Datadog Agent, see [Prometheus and OpenMetrics metrics collection from a host](https://docs.datadoghq.com/integrations/guide/prometheus-host-collection/#pagetitle).
