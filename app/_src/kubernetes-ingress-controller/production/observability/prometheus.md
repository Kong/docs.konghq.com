---
title: Prometheus Metrics
type: explanation
purpose: |
  What metrics are available? What port does it listen on?
---

{{site.kic_product_name}}, as well as {{site.base_gateway}}, both expose Prometheus metrics, under certain conditions:

* {{site.kic_product_name}} version 2.0 and later, exposes Prometheus metrics for configuration updates.
* {{site.base_gateway}} can expose Prometheus metrics for the requests that are served, if the [Prometheus plugin][prom-plugin] is enabled. For more information about enabling plugin, see [Using KongPlugin resource guide][kongplugin-guide]. You can also learn about specific integration details in the [Integration with Prometheus and Grafana][grafana-guide] guide.

This is a reference for [Integration with Prometheus and Grafana][grafana-guide] guide.

## Prometheus metrics for configuration updates

### ingress_controller_configuration_push_count

`ingress_controller_configuration_push_count` (type: `counter`) provides the number of successful or failed configuration pushes to {{site.base_gateway}}.

This metric provides these labels:

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

{% if_version gte:3.3.x %}

### ingress_controller_translation_duration_milliseconds

`ingress_controller_translation_duration_milliseconds` (type: `histogram`) is the amount of time, in milliseconds, that
it takes to translate the Kubernetes state to the {{site.base_gateway}} state.

This metric provides the `success` label:

* `success` logs the status of the translation. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the translation succeeded without errors.

{% endif_version %}

### ingress_controller_configuration_push_duration_milliseconds

`ingress_controller_configuration_push_duration_milliseconds` (type: `histogram`) is the amount of time, in milliseconds, that it takes to push the configuration to {{site.base_gateway}}.

This metric provides these labels:

* `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`.
{% if_version gte:2.9.x -%}
* `dataplane` describes the data plane that was the target of configuration push.
{% endif_version -%}
* `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurred.  If `success` is `true`, the push succeeded with no errors.

{% if_version gte:3.4.x %}

### ingress_controller_configuration_push_size

`ingress_controller_configuration_push_size` (type: `gauge`) is the size of the configuration pushed to Kong, in bytes.

This metric provides these labels:

* `dataplane` describes the dataplane that was the target of the configuration push.
* `protocol` describes the configuration protocol (metric is presented for `db-less`, for `deck` it doesn't exist) in use.
* `success` describes whether there were unrecoverable errors (`false`) or not (`true`).

{% endif_version -%}

{% if_version gte:2.11.x %}
### ingress_controller_configuration_push_broken_resource_count

`ingress_controller_configuration_push_broken_resource_count` (type: `counter`) provides the number of resources not accepted by {{site.base_gateway}} when attempting to push configuration.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push

### ingress_controller_configuration_push_last_successful

`ingress_controller_configuration_push_last_successful` (type: `gauge`) provides the time of the last successful configuration push.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push

### ingress_controller_translation_broken_resource_count

`ingress_controller_translation_broken_resource_count` (type: `gauge`) provides the number of resources that the controller cannot successfully translate to {{site.base_gateway}} configuration.

{% endif_version %}

{% if_version gte:3.2.x %}

### ingress_controller_fallback_translation_count

`ingress_controller_fallback_translation_count` (type: `counter`) provides the count of translations from Kubernetes state to Kong state in fallback mode.

This metric provides the `success` label:

* `success` logs the status of the translation. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the translation succeeded without errors.

{% if_version gte:3.3.x %}

### ingress_controller_fallback_translation_duration_milliseconds

`ingress_controller_fallback_translation_duration_milliseconds` (type: `histogram`) provides the amount of time, in milliseconds, 
that it takes to translate the Kubernetes state to the {{site.base_gateway}} state in fallback mode.

This metric provides the `success` label:

* `success` logs the status of the translation. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the translation succeeded without errors.

{% endif_version %}

### ingress_controller_fallback_translation_broken_resource_count

`ingress_controller_fallback_translation_broken_resource_count` (type: `gauge`) provides the number of resources that the controller cannot successfully translate to Kong configuration in fallback mode.

### ingress_controller_fallback_configuration_push_count

`ingress_controller_fallback_configuration_push_count` (type: `counter`) provides the count of successful/failed fallback configuration pushes to Kong.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push.
* `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`.
* `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the push succeeded without errors.
* `failure_reason` is populated if `success="false"`. It describes the reason for the failure:
  * `conflict`: A configuration conflict that must be manually fixed.
  * `network`: A network related issue, such as {{site.base_gateway}} being offline.
  * `other`: Other issues, such as {{site.base_gateway}} reporting a non-conflict error.

### ingress_controller_fallback_configuration_push_last

`ingress_controller_fallback_configuration_push_last` (type: `gauge`) provides the time of the last successful fallback configuration push.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push.

### ingress_controller_fallback_configuration_push_duration_milliseconds

`ingress_controller_fallback_configuration_push_duration_milliseconds` (type: `histogram`) provides the amount of time, in milliseconds, that it takes to push the fallback configuration to Kong.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push.
* `protocol` describes the configuration protocol in use, which can be `db-less` or `deck`.
* `success` logs the status of configuration updates. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the push succeeded without errors.

{% if_version gte:3.4.x %}

### ingress_controller_fallback_configuration_push_size

`ingress_controller_fallback_configuration_push_size` (type: `gauge`) is the size of the configuration pushed to Kong in fallback mode, in bytes.

This metric provides these labels:

* `dataplane` describes the dataplane that was the target of the configuration push.
* `protocol` describes the configuration protocol (metric is presented for `db-less`, for `deck` it doesn't exist) in use.
* `success` describes whether there were unrecoverable errors (`false`) or not (`true`).

{% endif_version %}

### ingress_controller_fallback_configuration_push_broken_resource_count

`ingress_controller_fallback_configuration_push_broken_resource_count` (type: `gauge`) provides the number of resources not accepted by Kong when attempting to push the fallback configuration.

This metric provides these labels:

* `dataplane` describes the data plane that was the target of the configuration push.

### ingress_controller_fallback_cache_generation_duration_milliseconds

`ingress_controller_fallback_cache_generation_duration_milliseconds` (type: `histogram`) provides the amount of time, in milliseconds, that it takes to generate a fallback cache.

This metric provides the `success` label:

* `success` logs the status of cache generation. If `success` is `false`, an unrecoverable error occurs. If `success` is `true`, the cache generation succeeded without errors.

### ingress_controller_processed_config_snapshot_cache_hit

`ingress_controller_processed_config_snapshot_cache_hit` (type: `counter`) provides the count of times the controller hit the processed configuration snapshot cache and skipped generating a new one.

### ingress_controller_processed_config_snapshot_cache_miss

`ingress_controller_processed_config_snapshot_cache_miss` (type: `counter`) provides the count of times the controller missed the processed configuration snapshot cache and had to generate a new one.

{% endif_version %}

## Low-level performance metrics

In addition, {{site.kic_product_name}} exposes more low-level performance metrics, but these may change from version to version because they are provided by underlying frameworks of {{site.kic_product_name}}.

A non-exhaustive list of these low-level metrics is described in the following:
* [Controller-runtime metrics](https://github.com/kubernetes-sigs/controller-runtime/blob/master/pkg/internal/controller/metrics/metrics.go)
* [Workqueue metrics](https://github.com/kubernetes/component-base/blob/release-1.20/metrics/prometheus/workqueue/metrics.go#L29)

[kongplugin-guide]: /kubernetes-ingress-controller/{{page.release}}/plugins/custom/
[grafana-guide]: /kubernetes-ingress-controller/{{page.release}}/production/observability/prometheus-grafana
[prom-plugin]: /hub/kong-inc/prometheus/
