---
name: OpenTelemetry
publisher: Kong Inc.
version: 0.1.0
desc: Propagate spans and report space to a backend server through OTLP protocol.
description: |
  Propagate distributed tracing spans, and report low-level spans to a OTLP-compatible server.
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible:
      - 3.0.x
  enterprise_edition:
    compatible:
      - 3.0.x
params:
  name: opentelemetry
  konnect_examples: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:
    - name: endpoint
      required: true
      value_in_examples: 'http://opentelemetry.collector:4318/v1/traces'
      datatype: string
      description: |
        The full HTTP(S) endpoint to which OpenTelemetry spans should be sent by Kong.
        The endpoint must be a [OTLP/HTTP](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md#otlphttp) endpoint.
    - name: headers
      required: false
      datatype: map
      value_in_examples: '`{ "X-Auth-Token": "secret-token" }`'
      description: |
        The custom headers to be added in the HTTP request sent to OTLP server.
        It's useful to add the authentication headers (token) for the APM backend.
    - name: resource_attributes
      required: false
      datatype: map
      description: |
        The attributes specified on this property will be added to the OpenTelemetry resource object.
        Kong follows the OpenTelemetry specification for [Semantic Attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/README.md#service).

        The following attributes are automatically added to the resource object:
        - `service.name`: The name of the service, `kong` by default.
        - `service.version`: The version of Kong.
        - `service.instance.id`: The node id of Kong.

        The default values for the above attributes can be overridden by specifying them in this property. For example,
        to override the default value of `service.name` to `my-service`, you can specify `{ "service.name": "my-service" }`.
    - name: batch_span_count
      required: true
      default: 200
      datatype: number
      description: |
        The number of spans to be sent in a single batch.
    - name: batch_flush_delay
      required: true
      default: 3
      datatype: number
      description: |
        The delay in seconds between two consecutive batches.
    - name: connect_timeout
      default: 1000
      datatype: number
      description: |
        The timeout in milliseconds for the connection to the OTLP server.
    - name: send_timeout
      default: 5000
      datatype: number
      description: |
        The timeout in milliseconds for the sending of the spans to the OTLP server.
    - name: read_timeout
      default: 5000
      datatype: number
      description: |
        The timeout in milliseconds for the reading of the response from the OTLP server.
---

The OpenTelemetry plugin is build on top of Kong's tracing API,
and is intended to be fully compatible with the OpenTelemetry specification.

## Usage

**NOTE:**
The OpenTelemetry plugin only works with Kong's configuration `opentelemetry_tracing` enabled.

The OpenTelemetry is fully compatible with the OpenTelemetry specification, and can be used with any OpenTelemetry compatible backend.

There are two ways to set up an OpenTelemetry backend:
1. Using a OpenTelemetry compatible backend directly, like Jaeger (v1.35.0+).
   All the vendors supported by OpenTelemetry are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).
2. Using the OpenTelemetry Collector, which is a middleware that can be used to proxy OpenTelemetry spans to a compatible backend.
   All the OpenTelemetry Collector exporters are available on [open-telemetry/opentelemetry-collector-contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter).

### Set up {{site.base_gateway}}

Enable the OpenTelemetry tracing capability in Kong's configuration:

- `opentelemetry_tracing = all`, Valid values can be found in the [Kong's configuration](/gateway/latest/reference/configuration/#opentelemetry_tracing).
- `opentelemetry_tracing_sampling_rate = 1.0`, Tracing instrumentation sampling rate.
  Tracer samples a fixed percentage of all spans following the sampling rate.
  Set to lower values to reduce the impact of the instrumentation on Kong's proxy performance in production.

### Set up a OpenTelemetry compatible backend

This section is optional if you are using a OpenTelemetry compatible APM vendor.
All the vendors supported by OpenTelemetry are listed in the [OpenTelemetry's Vendor support](https://opentelemetry.io/vendors/).

Jaeger [natively supports OpenTelemetry](https://www.jaegertracing.io/docs/features/#native-support-for-opentracing-and-opentelemetry) since v1.35, and can be used with the OpenTelemetry plugin.

Deploy a Jaeger instance with Docker:

```bash
docker run --name jaeger \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  jaegertracing/all-in-one:1.36
```

The `COLLECTOR_OTLP_ENABLED` environment variable must be set to `true` to enable the OpenTelemetry Collector.

The `4318` port is the OTLP/HTTP port, and the `4317` port is the OTLP/GRPC port which OpenTelemetry plugin not supported yet.

### Set up a OpenTelemetry Collector (Optional)

This section only relevant if you are using a OpenTelemetry non-compatible APM vendor.

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
```

Run the OpenTelemetry Collector with Docker:

```bash
docker run --name opentelemetry-collector
  -p 4317:4317 \
  -p 4318:4318 \
  -p 55679:55679 \
  -v ./otelcol.yaml:/etc/otel-collector-config.yaml \
  otel/opentelemetry-collector-contrib:0.52.0 \
  --config=/etc/otel-collector-config.yaml
```

Refer to the [OpenTelemetry Collector documentation](https://opentelemetry.io/docs/collector/configuration/) for more information.

### Configure the OpenTelemetry plugin

Enable the plugin:

```bash
curl -X POST http://<admin-hostname>:8001/plugins \
    --data "name=opentelemetry"  \
    --data "config.endpoint=http://<opentelemetry-backend>:4318/v1/traces" \
    --data "config.resource_attributes.service.name=kong-dev"
```

## Hot it works

This section describes how the OpenTelemetry plugin works.

### Build-in tracing instrumentations

Kong has a series of built-in tracing instrumentations,
which are configured by Kong's configuration `opentelemetry_tracing`.

Kong will create a top level span for each request by default when `opentelemetry_tracing` is set and is not `off`.

The top level span will have the following attributes:
- `http.method` - HTTP method
- `http.url` - HTTP URL
- `http.host` - HTTP host
- `http.scheme` - HTTP scheme (http or https)
- `http.flavor` - HTTP version
- `net.peer.ip` - Client IP

<!-- TODO: link to Gateway 3.0 tracing docs for details -->

### Propagation

The OpenTelemetry plugin will propagate the following headers:
- `w3c` - [W3C trace context](https://www.w3.org/TR/trace-context/)
- `b3`, `b3-single` - [Zipkin headers](https://github.com/openzipkin/b3-propagation)
- `jaeger` - [Jaeger headers](https://www.jaegertracing.io/docs/client-libraries/#propagation-format)
- `ot` - [OpenTracing headers](https://github.com/opentracing/specification/blob/master/rfc/trace_identifiers.md)
- `datadog` - [Datadog headers](https://docs.datadoghq.com/tracing/agent/propagation/)

The plugin will detect the propagation format from the headers, and will use the appropriate format to propagate the span context.
If no appropriate format is found, the plugin will fallback to the default format, which is `w3c`.

### OTLP exporter

The OpenTelemetry plugin implemented the [OTLP/HTTP](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md#otlphttp) exporter, which uses Protobuf payloads encoded in binary format and send via HTTP/1.1.

`connect_timeout`, `read_timeout` and `write_timeout` are used to set the timeouts for the HTTP request.

`batch_span_count` and `batch_flush_delay` are used to set the maximum number of spans and the delay between two consecutive batches.

## Customize OpenTelemetry spans (for Developers)

<!-- TODO: link to Gateway 3.0 tracing pdk docs for reference -->

The OpenTelemetry plugin is built on top of the Kong tracing PDK.

It's possible to customize the spans and add your own spans by through the universal tracing PDK.

A quick example for adding a custom span using Kong's serverless plugin:

1. Create a file named `custom-span.lua` with the following content:

    ```lua
      -- Modify the root span
      local root_span = kong.tracing.active_span()
      root_span:set_attribute("custom.attribute", "custom value")

      -- Create a custom span
      local span = kong.tracing.start_span("custom-span")

      -- Append attributes
      span:set_attribute("custom.attribute", "custom value")
    ```

2. Apply the Lua code using the `post-function` plugin using cURL file upload:

    ```bash
    $ curl -i -X POST http://<admin-hostname>:8001/plugins \
        -F "name=post-function" \
        -F "config.access[1]=@custom-span.lua"

    HTTP/1.1 201 Created
    ...
    ```

## Troubleshooting

The OpenTelemetry spans will be printed to the console when the log level is set to `debug`.

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

## Known limitations

- Only supports the HTTP protocols (http/https) of Kong.
- May have impact on the performance of the Kong.
