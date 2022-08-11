---
title: Collect Metrics with Datadog
content_type: how-to
---

# Datadog Agent v6 and Kong Prometheus-plugin

Using Datadog Agent 6, customers of Kong can connect Datadog straight to our Prometheus endpoint.

After enabling Prometheus metrics on Kong, create a Datadog Agent openmetrics.d configuration at `/etc/datadog-agent/conf.d/openmetrics.d/conf.yaml`. This should be enough to tell the agent to begin scraping metrics from Kong.

Below is an example configuration for pulling all of our `kong_` prefixed metrics.

```
instances:
  - prometheus_url: http://localhost:8001/metrics
    namespace: "kong"
    metrics:
      - kong_*
```

Find more details regarding the Datadog Agent from the [Datadog Official Docs](https://www.datadoghq.com/blog/monitor-prometheus-metrics/).
