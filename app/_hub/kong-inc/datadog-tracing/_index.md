---
name: Datadog Tracing
publisher: Kong Inc.
version: 0.1.0
desc: Integrate Kong with the Datadog APM Platform
description: |
  This plugin integrates Kong with the Datadog Application Performance Monitoring (APM) platform so that
  proxy requests handled by Kong can be identified and analyzed in
  Datadog. This plugin reports request and response timestamps and error information to the Datadog platform, to
  be analyzed using Datadog's Request Flow Map, and also correlated with other
  systems handling API requests.
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: false
  enterprise_edition:
    compatible: true
params:
  name: datadog-tracing
  konnect_examples: false
  protocols:
    - name: http
    - name: https
  dbless_compatible: 'yes'
  config:
    - name: endpoint
      required: false
      referenceable: true
      value_in_examples: 'http://localhost:8126/v0.4/traces'
      datatype: string
      description: |
        The full HTTP(S) endpoint that Kong Gateway should send spans to.
        If this is not specified, the plugin will try to get the endpoint from the
        `DD_AGENT_HOST` and `DD_AGENT_PORT` environment variables.
    - name: service_name
      required: true
      default: 'kong'
      value_in_examples: 'my-service'
      datatype: string
      description: |
        The name of the service that is sending the spans.
    - name: environment
      required: false
      default: 'none'
      value_in_examples: 'production'
      datatype: string
      description: |
        The environment that the service is running in.
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
        The delay, in seconds, between two consecutive batches.
    - name: connect_timeout
      default: 1000
      datatype: number
      description: |
        The timeout, in milliseconds, for the OTLP server connection.
    - name: send_timeout
      default: 5000
      datatype: number
      description: |
        The timeout, in milliseconds, for sending spans to the OTLP server.
    - name: read_timeout
      default: 5000
      datatype: number
      description: |
        The timeout, in milliseconds, for reading the response from the OTLP server.
---

## Usage

## Prerequisites

Before using this plugin:

* Enable {{site.base_gateway}}'s `tracing_instrumentations` configuration. We recommend setting the `tracing_instrumentations` configuration to `request`, to avoid impacting performance, and only trace requests.
* The Datadog Agent is required to run the Datadog Tracing plugin. The Datadog Agent can be installed on the same machine as {{site.base_gateway}} or on a different machine. The Datadog Tracing plugin sends spans to the Datadog Agent over HTTP.

### Set up {{site.base_gateway}}

Enable the OpenTelemetry tracing capability in {{site.base_gateway}}'s configuration:

- `tracing_instrumentations = request`: Valid values can be found in the [tracing instrumentations](/gateway/latest/reference/configuration/#tracing_instrumentations) section of the configuration documentation.
- `tracing_sampling_rate = 1.0`: Tracing instrumentation sampling rate.
  The tracer samples a fixed percentage of all spans following the sampling rate.
  This allows you to set the sampling rate to a lower value to reduce the impact of the instrumentation on {{site.base_gateway}}'s proxy performance in production.

### Set up the Datadog Agent

Set up the Datadog Agent. You can use the following example Docker configuration, substituting the `example-api-key` with your own key:

```bash
docker run -d -p 8126:8126 \
  --cgroupns host \
  --pid host \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY=<example-api-key> \
  -e DD_APM_NON_LOCAL_TRAFFIC=true \
   -e DD_APM_ENABLED=true \
   gcr.io/datadoghq/agent:latest
```

For more information about installing the Datadog Agent on Docker, see [Datadog's documentation](https://docs.datadoghq.com/agent/docker/apm/?tab=linux). If you want to install another container option, you can find the instructions in [Datadog's container list](https://docs.datadoghq.com/containers/).

### Configure the Datadog Tracing plugin

Enable the plugin:

```bash
curl -X POST http://<admin-hostname>:8001/plugins \
    --data "name=datadog-tracing"  \
    --data "config.endpoint=http://localhost:8126/v1/traces" \
    --data "config.service_name=kong" \
    --data "config.environment=prod"
```

## OpenTelemetry functionality

### Instrumentations

{{site.base_gateway}} has a series of built-in tracing instrumentations
which are configured by the `tracing_instrumentations` configuration.

{{site.base_gateway}} creates a top-level span for each request by default when `tracing_instrumentations` is enabled.

The top level span has the following attributes:
- `http.method`: HTTP method
- `http.url`: HTTP URL
- `http.host`: HTTP host
- `http.scheme`: HTTP scheme (http or https)
- `http.flavor`: HTTP version
- `net.peer.ip`: Client IP address
- `kong.route_id`: Id of the {{site.base_gateway}} route matched by the request
- `kong.route_name`: Name of the {{site.base_gateway}} route matched by the request (if available)
- `kong.service_id`: Id of the {{site.base_gateway}} service matched by the request (if available)
- `kong.service_name`: Name of the {{site.base_gateway}} service matched by the request (if available)
- `kong.consumer`: Id of the {{site.base_gateway}} consumer authenticated by the request (if available)


### Propagation

The Datadog Tracing plugin propagates the following headers:
- `w3c`: [W3C trace context](https://www.w3.org/TR/trace-context/)
- `b3` and `b3-single`: [Zipkin headers](https://github.com/openzipkin/b3-propagation)
- `jaeger`: [Jaeger headers](https://www.jaegertracing.io/docs/client-libraries/#propagation-format)
- `ot`: [OpenTracing headers](https://github.com/opentracing/specification/blob/master/rfc/trace_identifiers.md)
- `Datadog`: [Datadog headers](https://docs.datadoghq.com/tracing/agent/propagation/)

The plugin detects the propagation format from the headers and will use the appropriate format to propagate the span context.
If no appropriate format is found, the plugin will fallback to the default format, which is `Datadog`.

## Troubleshooting

The Datadog Tracing spans are printed to the console when the log level is set to `debug` in the Kong configuration file.

Here's an example of the debug log output:

```bash
2022/06/02 15:28:42 [debug] 650#0: *111 [lua] instrumentation.lua:302: runloop_log_after(): [tracing] collected 6 spans:
Span #1 name=GET /wrk duration=1502.994944ms attributes={"http.url":"/wrk","http.method":"GET","http.flavor":1.1,"http.host":"127.0.0.1","http.scheme":"http","net.peer.ip":"172.18.0.1"}
Span #2 name=rewrite phase: datadog-tracing duration=0.391936ms
Span #3 name=router duration=0.013824ms
Span #4 name=access phase: cors duration=1500.824576ms
Span #5 name=cors: heavy works duration=1500.709632ms attributes={"username":"kongers"}
Span #6 name=balancer try #1 duration=0.99328ms attributes={"net.peer.ip":"104.21.11.162","net.peer.port":80}
```

### Known issues

- Datadog Tracing only supports the HTTP protocols (`http`/`https`) of {{site.base_gateway}}.
- This plugin may impact the performance of {{site.base_gateway}}.
  We recommend setting the sampling rate (`tracing_sampling_rate`)
  in the {{site.base_gateway}} configuration file when using the Datadog Tracing plugin.
