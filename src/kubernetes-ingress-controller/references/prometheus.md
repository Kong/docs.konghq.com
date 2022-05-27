---
title: Prometheus metrics
---

{{site.kic_product_name}}, as well as Kong Gateway, both expose Prometheus metrics, under certain conditions:

* {{site.kic_product_name}}, since version 2.0, exposes Prometheus metrics for configuration updates.
* Kong Gateway can expose Prometheus metrics for served requests, if the [Prometheus plugin][prom-plugin] is enabled. See the [Using KongPlugin resource guide][kongplugin-guide] for information on how to enable a plugin. Also, we provide a specific [guide for integration with Prometheus and Grafana][grafana-guide] as well.

This document is a reference for the former type.

| Metric name | Description |
|-------------|-------------|
| `ingress_controller_configuration_push_count[success=true|false][protocol=db-less|deck]` | Count of successful or failed configuration pushes to Kong. <br><br> `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`. <br><br> `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the push succeeded with no errors.  |
| `ingress_controller_translation_count[success=true|false]` | Count of translations from Kubernetes state to Kong state. <br><br> `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the translation succeeded with no errors. |
| `ingress_controller_configuration_push_duration_milliseconds[success=true|false][protocol=db-less|deck]` | The amount of time, in milliseconds, that it takes to push the configuration to Kong. <br><br> `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`. <br><br> `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the push succeeded with no errors. |

In addition to the above, {{site.kic_product_name}} exposes more low-level performance metrics - these may however change from version to version, as they are provided by underlying frameworks of {{site.kic_product_name}}.

A non-exhaustive list of these low-level metrics is present in the following places:
* [controller-runtime metrics definition](https://github.com/kubernetes-sigs/controller-runtime/blob/master/pkg/internal/controller/metrics/metrics.go)
* [workqueue metrics definition](https://github.com/kubernetes/component-base/blob/release-1.20/metrics/prometheus/workqueue/metrics.go#L29)

[kongplugin-guide]: /kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/
[grafana-guide]: /kubernetes-ingress-controller/{{page.kong_version}}/guides/prometheus-grafana/
[prom-plugin]: /hub/kong-inc/prometheus/
