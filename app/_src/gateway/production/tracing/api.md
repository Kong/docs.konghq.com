---
title: Tracing API Referenece
content-type: Reference
---

## Before you start

In Gateway version 3.0.0, the tracing API became part of the Kong core application.
The API is in the `kong.tracing` namespace.

The tracing API follows the [OpenTelemetry API specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md).
This specification defines how to use the API as an instrument to your module.
If you are familiar with the OpenTelemetry API, the tracing API will be familiar.

With the tracing API, you can set the instrumentation of your module with the following operations:
- [Span](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md#span)
- [Attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/span-general.md)

## Create a tracer

Kong uses a global tracer internally to instrument the core modules and plugins.

{% if_version lte:3.1.x %}
By default, the tracer is a [NoopTracer](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md#get-a-tracer). The tracer is first initialized when `opentelemetry_tracing` configuration is enabled.

{% endif_version %}
{% if_version gte:3.2.x %}
By default, the tracer is a [NoopTracer](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md#get-a-tracer). The tracer is first initialized when `tracing_instrumentations` configuration is enabled.
{% endif_version %}
You can create a new tracer manually, or use the global tracer instance:

```lua
local tracer

-- Create a new tracer
tracer = kong.tracing.new("custom-tracer")

-- Use the global tracer
tracer = kong.tracing
```

### Sampling traces

The sampling rate of a tracer can be configured:

```lua
local tracer = kong.tracing.new("custom-tracer", {
  -- Set the sampling rate to 0.1
  sampling_rate = 0.1,
})
```

A `sampling_rate` of `0.1` means that 1 of every 10 requests will be traced. A rate of `1` means that all requests will be traced.

## Create a span

A span represents a single operation within a trace. Spans can be nested to form trace trees. Each trace contains a root span, which typically describes the entire operation and, optionally, one or more sub-spans for its sub-operations.

```lua
local tracer = kong.tracing

local span = tracer:start_span("my-span")
```

The span properties can be set by passing a table to the `start_span` method.

```lua
local span = tracer:start_span("my-span", {
  start_time_ns = ngx.now() * 1e9, -- override the start time
  span_kind = 2, -- SPAN_KIND
                  -- UNSPECIFIED: 0
                  -- INTERNAL: 1
                  -- SERVER: 2
                  -- CLIENT: 3
                  -- PRODUCER: 4
                  -- CONSUMER: 5
  should_sample = true, -- by setting it to `true` to ignore the sampling decision
})
```

Make sure to ends the span when you are done:

```lua
span:finish() -- ends the span
```

{:.Note}
>**Note:** The span table will be cleared and put into the table pool after the span is finished,
do not use it after the span is finished.

## Get or set the active span

The active span is the span that is currently being executed.

To avoid overheads, the active span is manually set by calling the `set_active_span` method.
When you finish a span, the active span becomes the parent of the finished span.


To set or get the active span, you can use the following example code:

```lua
local tracer = kong.tracing
local span = tracer:start_span("my-span")
tracer.set_active_span(span)

local active_span = tracer.active_span() -- returns the active span
```

### Scope

The tracers are scoped to a specific context by a namespace key.

To get the active span for a specific namespace, you can use the following:

```lua
-- get global tracer's active span, and set it as the parent of new created span
local global_tracer = kong.tracing
local tracer = kong.tracing.new("custom-tracer")

local root_span = global_tracer.active_span()
local span = tracer.start_span("my-span", {
  parent = root_span
})
```

## Set the span attributes

The attributes of a span are a map of key-value pairs
and can be set by passing a table to the `set_attributes` method.

```lua
local span = tracer:start_span("my-span")
```

The OpenTelemetry specification defines the general semantic attributes, it can be used to describe the span.
It could also be meaningful to visualize the span in a UI.

```lua
span:set_attribute("key", "value")
```

The following semantic conventions for spans are defined:

* [General](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/span-general.md): General semantic attributes that may be used in describing different kinds of operations.
* [HTTP](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/http.md): For HTTP client and server spans.
* [Database](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/database.md): For SQL and NoSQL client call spans.
* [RPC/RMI](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/rpc.md): For remote procedure call (e.g., gRPC) spans.
* [Messaging](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/messaging.md): For messaging systems (queues, publish/subscribe, etc.) spans.
* [FaaS](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/faas.md): For [Function as a Service](https://en.wikipedia.org/wiki/Function_as_a_service) (e.g., AWS Lambda) spans.
* [Exceptions](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/exceptions.md): For recording exceptions associated with a span.
* [Compatibility](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/compatibility.md): For spans generated by compatibility components, e.g. OpenTracing Shim layer.

## Set the span events

The events of a span are time-series events that can be set by passing a table to the `add_event` method.

```lua
local span = kong.tracing:start_span("my-span")
span:add_event("my-event", {
  -- attributes
  ["key"] = "value",
})
```

### Record error message

The event could also be used to record error messages.

```lua
local span = kong.tracing:start_span("my-span")
span:record_error("my-error-message")

-- or (same as above)
span:add_event("exception", {
  ["exception.message"] = "my-error-message",
})
```

## Set the span status

The status of a span is a status code and can be set by passing a table to the `set_status` method.

```lua
local span = kong.tracing:start_span("my-span")
-- Status codes:
-- - `0` unset
-- - `1` ok
-- - `2` error
```

## Release the span (optional)

The spans are stored in a pool, and can be released by calling the `release` method.

```lua
local span = kong.tracing:start_span("my-span")
span:release()
```

By default, the span will be released after the Nginx request ends.

## Visualize the trace

Because of the compatibility with OpenTelemetry, the traces can be natively visualized through any OpenTelemetry UI.

Please refer to the [OpenTelemetry plugin](/hub/kong-inc/opentelemetry/) to see how to visualize the traces.

## References

- [Tracing PDK](/gateway/{{page.release}}/plugin-development/pdk/kong.tracing/)
- [OpenTelemetry plugin](/hub/kong-inc/opentelemetry/)
