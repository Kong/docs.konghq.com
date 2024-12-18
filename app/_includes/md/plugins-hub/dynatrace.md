
## Prerequisites
* Install the [Dynatrace Collector](https://docs.dynatrace.com/docs/ingest-from/opentelemetry/collector)
* {{site.base_gateway}} 3.8+

## Configure {{site.base_gateway}}

Set the following parameters in your [`kong.conf`](/gateway/latest/production/kong-conf/) file:

```
tracing_instrumentations = all
tracing_sampling_rate = 1.0
```

## Configure the OpenTelemetry plugin

Adjust the `{your-environment-id}` variable with your own Collector endpoint:

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/opentelemetry
name: opentelemetry
config:
  traces_endpoint: "https://{your-environment-id}.live.dynatrace.com/api/v2/otlp/v1/traces"
  logs_endpoint: "https://{your-environment-id}.live.dynatrace.com/api/v2/otlp/v1/logs"
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
  - terraform
{% endplugin_example %}
<!--vale on-->

## Configure the OpenTelemetry Collector

Configure your Dynatrace OpenTelemetry Collector to send data to the Dynatrace environment. 

The following example OpenTelemetry configuration shows how to export traces and logs:

```yaml
receivers:
  otlp:
    protocols:
      http:
        endpoint: 0.0.0.0:4318

exporters:
  otlphttp:
    endpoint: "https://{your-environment-id}.live.dynatrace.com/api/v2/otlp"
    headers: 
      "Authorization": "Api-Token <your-api-token>"

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

Kong relies on the OpenTelemetry Collector to calculate the metrics based on the traces the OpenTelemetry plugin generates.

To include span metrics for application traces, configure the collector exporters section of 
the OpenTelemetry Collector configuration file: 

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