---
title: Prometheus metrics
---

{{site.kic_product_name}}, as well as {{site.base_gateway}}, both expose Prometheus metrics, under certain conditions:

* {{site.kic_product_name}}, since version 2.0, exposes Prometheus metrics for configuration updates.
* {{site.base_gateway}} can expose Prometheus metrics for served requests, if the [Prometheus plugin][prom-plugin] is enabled. See the [Using KongPlugin resource guide][kongplugin-guide] for information about how to enable a plugin. Also, you can find a specific [guide for integration with Prometheus and Grafana][grafana-guide] as well.

This document is a reference for the former type.

## Prometheus metrics for configuration updates

### ingress_controller_configuration_push_count

`ingress_controller_configuration_push_count` (type: `counter`) provides the number of successful or failed configuration pushes to {{site.base_gateway}}.

This metric provides the following labels:

* `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`.
{% if_version gte:2.9.x -%}
* `dataplane` describes the data plane that was the target of configuration push.
{% endif_version -%}
* `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the push succeeded with no errors.
{% if_version gte:2.7.x -%}
* `failure_reason` is populated if `success="false"`. It describes the reason for the failure:
    * `conflict`: A configuration conflict that must be manually fixed.
    * `network`: A network related issues, such as {{site.base_gateway}} is offline.
    * `other`: Other issues, such as {{site.base_gateway}} reporting a non-conflict error.
{% endif_version %}

### ingress_controller_translation_count

`ingress_controller_translation_count` (type: `counter`) provides the number of translations from the Kubernetes state to the {{site.base_gateway}} state.

This metric provides the `success` label. `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.
If `success` is `true`, the translation succeeded with no errors.

### ingress_controller_configuration_push_duration_milliseconds

`ingress_controller_configuration_push_duration_milliseconds` (type: `histogram`) is the amount of time, in milliseconds, that it takes to push the configuration to {{site.base_gateway}}.

This metric provides the following labels:

* `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`.
{% if_version gte:2.9.x -%}
* `dataplane` describes the data plane that was the target of configuration push.
{% endif_version -%}
* `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the push succeeded with no errors.

{% if_version gte:2.11.x %}
### ingress_controller_configuration_push_broken_resource_count

`ingress_controller_configuration_push_broken_resource_count` (type: `counter`) provides the number of resources not accepted by {{site.base_gateway}} when attempting to push configuration.

This metric provides the following labels:

* `dataplane` describes the data plane that was the target of the configuration push

### ingress_controller_configuration_push_last_successful

`ingress_controller_configuration_push_last_successful` (type: `gauge`) provides the time of the last successful configuration push.

This metric provides the following labels:

* `dataplane` describes the data plane that was the target of the configuration push

### ingress_controller_translation_broken_resource_count

`ingress_controller_translation_broken_resource_count` (type: `gauge`) provides the number of resources that the controller cannot successfully translate to {{site.base_gateway}} configuration.

{% endif_version %}

## Low-level performance metrics

In addition to the above, {{site.kic_product_name}} exposes more low-level performance metrics, but these may change from version to version because they are provided by underlying frameworks of {{site.kic_product_name}}.

A non-exhaustive list of these low-level metrics is described in the following:
* [Controller-runtime metrics](https://github.com/kubernetes-sigs/controller-runtime/blob/master/pkg/internal/controller/metrics/metrics.go)
* [Workqueue metrics](https://github.com/kubernetes/component-base/blob/release-1.20/metrics/prometheus/workqueue/metrics.go#L29)

[kongplugin-guide]: /kubernetes-ingress-controller/{{page.release}}/guides/using-kongplugin-resource/
[grafana-guide]: /kubernetes-ingress-controller/{{page.release}}/guides/prometheus-grafana/
[prom-plugin]: /hub/kong-inc/prometheus/
