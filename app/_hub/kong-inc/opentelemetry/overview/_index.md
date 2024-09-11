---
nav_title: Overview
---

Propagate distributed tracing spans and report low-level spans to a OTLP-compatible server.

The OpenTelemetry plugin is fully compatible with the OpenTelemetry specification and can be used with any OpenTelemetry compatible backend.

## How it works

This section describes how the OpenTelemetry plugin works.

### Collecting telemetry data

There are two ways to set up an OpenTelemetry backend:
* Using a OpenTelemetry compatible backend directly, like Jaeger (v1.35.0+)
   All the vendors supported by OpenTelemetry are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).
* Using the OpenTelemetry Collector, which is middleware that can be used to proxy OpenTelemetry spans to a compatible backend.
   You can view all the available OpenTelemetry Collector exporters at [open-telemetry/opentelemetry-collector-contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter).

{% if_version gte:3.8.x %}
### Metrics
Metrics are enabled using the `contrib` version of the [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/installation/).

The `spanmetrics` connector allows you to aggregate traces and provide metrics to any third party observability platform. 
For an example configuration, see the [Basic config examples](/hub/opentelemetry/how-to/basic-examples/).
{% endif_version %}

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


## More information

* [Configuration reference](/hub/kong-inc/opentelemetry/configuration/)
* [Basic configuration example](/hub/kong-inc/opentelemetry/how-to/basic-example/)
* [Get started with the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/how-to/getting-started/)
* [Set up Dynatrace with OpenTelemetry](/hub/kong-inc/opentelemetry/how-to/dynatrace/)
* [Customize OpenTelemetry spans as a developer](/hub/kong-inc/opentelemetry/how-to/spans/)