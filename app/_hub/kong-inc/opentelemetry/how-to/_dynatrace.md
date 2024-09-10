---
title: Set up Dynatrace with OpenTelemetry
nav_title: Using Dynatrace
minimum_version: 3.8.x
---

Set up the OpenTelemetry plugin to send logs and metrics to Dynatrace.

## Prerequisites
* Install the [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/installation/)
* {{site.base_gateway}} 3.8+

## Configure {{site.base_gateway}}

Set the following parameters in your [`kong.conf`](/gateway/latest/production/kong-conf/) file:

```
tracing_instrumentations = all
tracing_sampling_rate = 1.0
```

## Configure the OpenTelemetry plugin

Adjust the `{OPENTELEMETRY_COLLECTOR}` variable with your own Collector endpoint:

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/opentelemetry
name: opentelemetry
config:
  traces_endpoint: "http://{OPENTELEMETRY_COLLECTOR}:4318/v1/traces"
  logs_endpoint: "http://{OPENTELEMETRY_COLLECTOR}:4318/v1/logs"
  resource_attributes:
    service.name: kong-dev
targets:
  - service
  - route
  - consumer
  - global
formats:
  - curl
  - konnect
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on-->

## Configure the OpenTelemetry Collector

Configure your OpenTelemetry Collector to send data to your Dynatrace environment. 

The following example shows how to export traces and logs:

```yaml
receivers:
  otlp:
    protocols:
      http:
        endpoint: 0.0.0.0:4318

exporters:
  otlphttp:
    endpoint: "${env:DT_BASEURL}/api/v2/otlp"
    headers:
      "Authorization": "Api-Token ${env:DT_API_TOKEN}"

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: []
      exporters: [otlphttp]
    logs:
      receivers: [otlp]
      processors: []
      exporters: [otlphttp]
```

## Export application span metrics

To include span metrics for application traces, configure the collector exporters section of 
the OpenTelemetry Collector configuration:

```yaml
connectors:
  spanmetrics:
    dimensions:
      - name: http.method
        default: GET
      - name: http.status_code
      - name: http.route
    exclude_dimensions:
      - status.code
    metrics_flush_interval: 15s
    histogram:
      disable: false

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: []
      exporters: [spanmetrics]
    metrics:
      receivers: [spanmetrics]
      processors: []
      exporters: [otlphttp]
```

## More information

* [Troubleshooting](/hub/kong-inc/opentelemetry/#troubleshooting)
* [How logging works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#logging)
* [How tracing works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#tracing)
* [Dynatrace documentation](https://docs.dynatrace.com/docs/setup-and-configuration/technology-support/application-software/nginx/kong-gateway#kong-observability-opentelemetry)