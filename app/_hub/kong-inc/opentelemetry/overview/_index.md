---
nav_title: Overview
---

Propagate distributed tracing spans and report low-level spans to a OTLP-compatible server.

{% if_version gte:3.3.x %}
## Queueing

The OpenTelemetry plugin uses a queue to decouple the production and
consumption of data. This reduces the number of concurrent requests
made to the upstream server under high load situations and provides
buffering during temporary network or upstream outages.

You can set several parameters to configure the behavior and capacity
of the queues used by the plugin. For more information about how to
use these parameters, see
[Plugin Queuing Reference](/gateway/latest/kong-plugins/queue/reference/)
in the {{site.base_gateway}} documentation.

The queue parameters all reside in a record under the key `queue` in
the `config` parameter section of the plugin.

Queues are not shared between workers and queueing parameters are
scoped to one worker.  For whole-system capacity planning, the number
of workers need to be considered when setting queue parameters.
{% endif_version %}

{% if_version gte:3.5.x %}
## Trace IDs in serialized logs

When the OpenTelemetry plugin is configured along with a plugin that uses the 
[Log Serializer](/gateway/latest/plugin-development/pdk/kong.log/#konglogserialize),
the trace ID of each request is added to the key `trace_id` in the serialized log output.

The value of this field is an object that can contain different formats
of the current request's trace ID. In case of multiple tracing headers in the
same request, the `trace_id` field includes one trace ID format
for each different header format, as in the following example:

```
"trace_id": {
  "w3c": "4bf92f3577b34da6a3ce929d0e0e4736",
  "datadog": "11803532876627986230"
},
```
{% endif_version %}

## Usage

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
* Using a OpenTelemetry compatible backend directly, like Jaeger (v1.35.0+)
   All the vendors supported by OpenTelemetry are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).
* Using the OpenTelemetry Collector, which is middleware that can be used to proxy OpenTelemetry spans to a compatible backend.
   You can view all the available OpenTelemetry Collector exporters at [open-telemetry/opentelemetry-collector-contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter).

### Set up {{site.base_gateway}}

{% if_version gte:3.8.x %}
The OpenTelemetry tracing capability supported by this plugin requires the following {{site.base_gateway}}'s configuration:
{% endif_version %}
{% if_version lte:3.7.x %}
Enable the OpenTelemetry tracing capability in {{site.base_gateway}}'s configuration:
{% endif_version %}
{% if_version lte:3.1.x %}
- `opentelemetry_tracing = all`, Valid values can be found in the [Kong's configuration](/gateway/latest/reference/configuration/#tracing_instrumentations).
- `opentelemetry_tracing_sampling_rate = 1.0`: Tracing instrumentation sampling rate.
  Tracer samples a fixed percentage of all spans following the sampling rate.
  Set the sampling rate to a lower value to reduce the impact of the instrumentation on {{site.base_gateway}}'s proxy performance in production.
{% endif_version %}
{% if_version gte:3.2.x lte:3.7.x %}
- `tracing_instrumentations = all`, Valid values can be found in the [Kong's configuration](/gateway/latest/reference/configuration/#tracing_instrumentations).
- `tracing_sampling_rate = 1.0`: Tracing instrumentation sampling rate.
  Tracer samples a fixed percentage of all spans following the sampling rate.
  Set the sampling rate to a lower value to reduce the impact of the instrumentation on {{site.base_gateway}}'s proxy performance in production.
{% endif_version %}
### Set up an OpenTelemetry compatible backend

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

### Set up a OpenTelemetry Collector

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

### Configure the OpenTelemetry plugin

Enable the plugin:

```bash
curl -X POST http://localhost:8001/plugins \
    -H 'Content-Type: application/json' \
    -d '{
      "name": "opentelemetry",
      "config": {
        {% if_version lte:3.7.x %}"endpoint": "http://<opentelemetry-backend>:4318/v1/traces",{% endif_version -%}
        {% if_version gte:3.8.x %}"traces_endpoint": "http://<opentelemetry-backend>:4318/v1/traces",
        "logs_endpoint": "http://<opentelemetry-backend>:4318/v1/logs",{% endif_version %}
        "resource_attributes": {
          "service.name": "kong-dev"
        }
      }
    }'
```

## How the OpenTelemetry plugin functions

This section describes how the OpenTelemetry plugin works.

### Tracing

#### Built-in tracing instrumentations

{% if_version gte:3.2.x %}
{{site.base_gateway}} has a series of built-in tracing instrumentations
which are configured by the `tracing_instrumentations` configuration.
{{site.base_gateway}} creates a top-level span for each request by default when `tracing_instrumentations` is enabled.
{% endif_version %}
{% if_version lte:3.1.x %}
{{site.base_gateway}} has a series of built-in tracing instrumentations
which are configured by the `opentelemetry_tracing` configuration.
{{site.base_gateway}} creates a top-level span for each request by default when `opentelemetry_tracing` is enabled.
{% endif_version %}

The top level span has the following attributes:
- `http.method`: HTTP method
- `http.url`: HTTP URL
- `http.host`: HTTP host
- `http.scheme`: HTTP scheme (http or https)
- `http.flavor`: HTTP version
- `net.peer.ip`: Client IP address

<!-- TODO: link to Gateway 3.0 tracing docs for details -->

#### Propagation

The OpenTelemetry plugin supports propagation of the following header formats:
- `w3c`: [W3C trace context](https://www.w3.org/TR/trace-context/)
- `b3` and `b3-single`: [Zipkin headers](https://github.com/openzipkin/b3-propagation)
- `jaeger`: [Jaeger headers](https://www.jaegertracing.io/docs/client-libraries/#propagation-format)
- `ot`: [OpenTracing headers](https://github.com/opentracing/specification/blob/master/rfc/trace_identifiers.md)
- `datadog`: [Datadog headers](https://docs.datadoghq.com/tracing/trace_collection/library_config/go/#trace-context-propagation-for-distributed-tracing)
{% if_version gte:3.4.x %}
- `aws`: [AWS X-Ray header](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html#xray-concepts-tracingheader)
{% endif_version %}
{% if_version gte:3.5.x %}
- `gcp`: [GCP X-Cloud-Trace-Context header](https://cloud.google.com/trace/docs/setup#force-trace)
{% endif_version %}

{% if_version gte:3.7.x %}
{% include /md/plugins-hub/tracing-headers-propagation.md %}

Refer to the plugin's [configuration reference](/hub/kong-inc/opentelemetry/configuration/#config-propagation) for a complete overview of the available options and values.


{:.note}
> **Note:** If any of the `propagation.*` configuration options (`extract`, `clear`, or `inject`) are configured, the `propagation` configuration takes precedence over the deprecated `header_type` parameter. 
If none of the `propagation.*` configuration options are set, the `header_type` parameter is still used to determine the propagation behavior.
{% endif_version %}
{% if_version lte:3.6.x %}
The plugin detects the propagation format from the headers and will use the appropriate format to propagate the span context.
If no appropriate format is found, the plugin will fallback to the default format, which is `w3c`.
{% endif_version %}


#### OTLP exporter

The OpenTelemetry plugin implements the [OTLP/HTTP](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md#otlphttp) exporter, which uses Protobuf payloads encoded in binary format and is sent via HTTP/1.1.

`connect_timeout`, `read_timeout`, and `write_timeout` are used to set the timeouts for the HTTP request.

`batch_span_count` and `batch_flush_delay` are used to set the maximum number of spans and the delay between two consecutive batches.

{% if_version gte:3.8.x %}
### Logging

This plugin supports [OpenTelemetry Logging](https://opentelemetry.io/docs/specs/otel/logs/), which can be configured as described in the [configuration reference](/hub/kong-inc/opentelemetry/configuration/#config-traces_endpoint) to export logs in OpenTelemetry format to an OTLP-compatible backend.

#### Log scopes

Two different kinds of logs are exported: **Request** and **Non-Request** scoped.
  * Request logs are directly associated with requests. They are produced during the request lifecycle. For example, this could be logs generated during a plugin's Access phase.
  * Non-request logs are not directly associated with a request. They are produced outside the request lifecycle. For examples, this could be logs generated asynchronously or during a worker's startup.

#### Log level

Logs are reported based on the log level that is configured for {{site.base_gateway}}. If a log is emitted with a level that is lower than the configured log level, it is not exported.

{:.note}
> **Note:** Not all logs are guaranteed to be exported. Logs that are not exported include those produced by the Nginx master process and low-level errors produced by Nginx. Operators are expected to capture the Nginx `error.log` file in addition to using this feature for observability purposes.

#### Log entry

Each log entry adheres to the [OpenTelemetry Logs Data Model](https://opentelemetry.io/docs/specs/otel/logs/data-model/). The available information depends on the log scope and on whether [**tracing**](#tracing) is enabled for this plugin.

Every log entry includes the following fields:
- `Timestamp`: Time when the event occurred.
- `ObservedTimestamp`: Time when the event was observed.
- `SeverityText`: The severity text (log level).
- `SeverityNumber`: Numerical value of the severity.
- `Body`: The error log line.
- `Resource`: Configurable resource attributes.
- `InstrumentationScope`: Metadata that describes Kong's data emitter.
- `Attributes`: Additional information about the event.
  - `introspection.source`: Full path of the file that emitted the log.
  - `introspection.current.line`: Line number that emitted the log.

In addition to the above, request-scoped logs include:
- `Attributes`: Additional information about the event.
  - `request.id`: Kong's request ID.

In addition to the above, when **tracing** is enabled, request-scoped logs include:
- `TraceID`: Request trace ID.
- `SpanID`: Request span ID.
- `TraceFlags`: W3C trace flag.
{% endif_version %}

## Customize OpenTelemetry spans as a developer

<!-- TODO: link to Gateway 3.0 tracing pdk docs for reference -->

The OpenTelemetry plugin is built on top of the {{site.base_gateway}} tracing PDK.

It's possible to customize the spans and add your own spans through the universal tracing PDK.

The following is an example for adding a custom span using {{site.base_gateway}}'s serverless plugin:

1. Create a file named `custom-span.lua` with the following content:

    ```lua
      -- Modify the root span
      local root_span = kong.tracing.active_span()
      root_span:set_attribute("custom.attribute", "custom value")

      -- Create a custom span
      local span = kong.tracing.start_span("custom-span")

      -- Append attributes
      span:set_attribute("custom.attribute", "custom value")
      
      -- Close the span
      span:finish()
    ```

2. Apply the Lua code using the `post-function` plugin using a cURL file upload:

    ```bash
    curl -i -X POST http://localhost:8001/plugins \
      -F "name=post-function" \
      -F "config.access[1]=@custom-span.lua"

    HTTP/1.1 201 Created
    ...
    ```

## Troubleshooting

The OpenTelemetry spans are printed to the console when the log level is set to `debug` in the Kong configuration file.

An example of debug logs output:

```bash
2022/06/02 15:28:42 [debug] 650#0: *111 [lua] instrumentation.lua:302: runloop_log_after(): [tracing] collected 6 spans:
Span #1 name=GET /wrk duration=1502.994944ms attributes={"http.url":"/wrk","http.method":"GET","http.flavor":1.1,"http.host":"127.0.0.1","http.scheme":"http","net.peer.ip":"172.18.0.1"}
Span #2 name=rewrite phase: opentelemetry duration=0.391936ms
Span #3 name=router duration=0.013824ms
Span #4 name=access phase: cors duration=1500.824576ms
Span #5 name=cors: heavy works duration=1500.709632ms attributes={"username":"kongers"}
Span #6 name=balancer try #1 duration=0.99328ms attributes={"net.peer.ip":"104.21.11.162","net.peer.port":80}
```
{% if_version gte:3.2.x %}
## Known issues

- Only supports the HTTP protocols (http/https) of {{site.base_gateway}}.
- May impact the performance of {{site.base_gateway}}.
  It's recommended to set the sampling rate (`tracing_sampling_rate`)
  via Kong configuration file when using the OpenTelemetry plugin.
{% endif_version %}

{% if_version lte:3.1.x %}
## Known issues

- Only supports the HTTP protocols (http/https) of {{site.base_gateway}}.
- May impact the performance of {{site.base_gateway}}.
  It's recommended to set the sampling rate (`opentelemetry_tracing_sampling_rate`)
  via Kong configuration file when using the OpenTelemetry plugin.
{% endif_version %}
