---
title: Get Started with the OpenTelemetry plugin
nav_title: Get Started with the OpenTelemetry plugin
---

{% if_version gte:3.2.x %}
{:.note}
> **Note**: The OpenTelemetry plugin's tracing capabilities only work when {{site.base_gateway}}'s `tracing_instrumentations` configuration is enabled.
{% endif_version %}

{% if_version lte:3.1.x %}
{:.note}
> **Note**: The OpenTelemetry plugin only works when {{site.base_gateway}}'s `opentelemetry_tracing` configuration is enabled.
{% endif_version %}

The OpenTelemetry plugin is fully compatible with the OpenTelemetry specification and can be used with any OpenTelemetry compatible backend.

There are two ways to set up an OpenTelemetry backend:
* Using a [OpenTelemetry compatible backend](#set-up-an-opentelemetry-compatible-backend) directly, like Jaeger (v1.35.0+)
   All the vendors supported by OpenTelemetry are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).
* Using the [OpenTelemetry Collector](#set-up-an-opentelemetry-collector), which is middleware that can be used to proxy OpenTelemetry spans to a compatible backend.
   You can view all the available OpenTelemetry Collector exporters at [open-telemetry/opentelemetry-collector-contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter).

## Set up {{site.base_gateway}}

The OpenTelemetry tracing capability supported by this plugin requires the following {{site.base_gateway}} configuration:

{% if_version lte:3.1.x %}
- `opentelemetry_tracing = all`: Enables all possible tracing instrumentations. 
Valid values can be found in [Kong's configuration reference](/gateway/latest/reference/configuration/#tracing_instrumentations).
- `opentelemetry_tracing_sampling_rate = 1.0`: Tracing instrumentation sampling rate.
  Tracer samples a fixed percentage of all spans following the sampling rate.
  Set the sampling rate to a lower value to reduce the impact of the instrumentation on {{site.base_gateway}}'s proxy performance in production.
{% endif_version %}
{% if_version gte:3.2.x %}
- `tracing_instrumentations = all`: Enables all possible tracing instrumentations. 
Valid values can be found in [Kong's configuration reference](/gateway/latest/reference/configuration/#tracing_instrumentations).
- `tracing_sampling_rate = 1.0`: Tracing instrumentation sampling rate.
  Tracer samples a fixed percentage of all spans following the sampling rate.
  Set the sampling rate to a lower value to reduce the impact of the instrumentation on {{site.base_gateway}}'s proxy performance in production.
{% endif_version %}

## Set up an OpenTelemetry compatible backend

This section is optional if you are using a OpenTelemetry compatible APM vendor.
All the supported vendors are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).

Jaeger [natively supports OpenTelemetry](https://www.jaegertracing.io/docs/features/#native-support-for-opentracing-and-opentelemetry) starting with v1.35 and can be used with the OpenTelemetry plugin.

Deploy a Jaeger instance with Docker:

```bash
docker run --name jaeger \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  jaegertracing/all-in-one:1.36
```

* The `COLLECTOR_OTLP_ENABLED` environment variable must be set to `true` to enable the OpenTelemetry Collector.

* The `4318` port is the OTLP/HTTP port and the `4317` port is the OTLP/GRPC port that isn't supported by the OpenTelemetry plugin yet.

## Set up an OpenTelemetry Collector

This section is required if you are using an incompatible OpenTelemetry APM vendor.

Create a config file (`otelcol.yaml`) for the OpenTelemetry Collector:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

exporters:
  logging:
    loglevel: debug
  zipkin:
    endpoint: "http://some.url:9411/api/v2/spans"
    tls:
      insecure: true

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging, zipkin]
    {% if_version gte:3.8.x %}logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]{% endif_version %}
```

Run the OpenTelemetry Collector with Docker:

```bash
docker run --name opentelemetry-collector \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 55679:55679 \
  -v $(pwd)/otelcol.yaml:/etc/otel-collector-config.yaml \
  otel/opentelemetry-collector-contrib:0.52.0 \
  --config=/etc/otel-collector-config.yaml
```

See the [OpenTelemetry Collector documentation](https://opentelemetry.io/docs/collector/configuration/) for more information.

## Configure the OpenTelemetry plugin

<!--vale off-->
{% if_version lte:3.7.x %}
{% plugin_example %}
plugin: kong-inc/opentelemetry
name: opentelemetry
config:
  endpoint: "http://<opentelemetry-backend>:4318/v1/traces"
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
{% endif_version %}

{% if_version gte:3.8.x %}
{% plugin_example %}
plugin: kong-inc/opentelemetry
name: opentelemetry
config:
  traces_endpoint: "http://<opentelemetry-backend>:4318/v1/traces"
  logs_endpoint: "http://<opentelemetry-backend>:4318/v1/logs"
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
{% endif_version %}
<!--vale on-->

## More information

* [Troubleshooting the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#troubleshooting)
* [Set up Dynatrace with OpenTelemetry](/hub/kong-inc/opentelemetry/how-to/dynatrace/)
* [How logging works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#logging)
* [How tracing works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#tracing)
