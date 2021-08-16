---
title: Prometheus metrics
---

{{site.kic_product_name}}, as well as Kong Gateway, both expose Prometheus metrics, under certain conditions:

* {{site.kic_product_name}}, since version 2.0, exposes Prometheus metrics for configuration updates.
* Kong Gateway can expose Prometheus metrics for served requests, if the [Prometheus plugin][prom-plugin] is enabled. See the [Using KongPlugin resource guide][kongplugin-guide] for information on how to enable a plugin. Also, we provide a specific [guide for integration with Prometheus and Grafana][grafana-guide] as well.

This document is a reference for the former type.

| Metric name | Description |
|-------------|-------------|
| `send_configuration_count[success=true|false][type=post-config|deck]` | Counts the success/failure events of converting kubernetes resources to a KongState, including conversion. |
| `ingress_parse_count[success=true|false]` | Counts (successful and unsuccessful) events of interpreting ingress configurations in Kubernetes. `success=false` means a configuration error and is a good candidate for an alert. |
| `proxy_configuration_duration_milliseconds` | Duration of the last successful configuration. |

In addition to the above, {{site.kic_product_name}} exposes more low-level performance metrics - these may however change from version to version, as they are provided by underlying frameworks of {{site.kic_product_name}}.

A non-exhaustive list of these low-level metrics is present in the following places:
* [controller-runtime metrics definition](https://github.com/Kong/kubernetes-ingress-controller/blob/main/internal/metrics/prometheus.go)
* [workqueue metrics definition](https://github.com/kubernetes/component-base/blob/release-1.20/metrics/prometheus/workqueue/metrics.go#L29)

[kongplugin-guide]: /kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/
[grafana-guide]: /kubernetes-ingress-controller/{{page.kong_version}}/guides/prometheus-grafana/
[prom-plugin]: /hub/kong-inc/prometheus/k
