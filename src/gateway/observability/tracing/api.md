---
title: Tracing API
---

## Before you start

Kong bundled the tracing framework since version 3.0.0, the tracing API is a part of the Kong core,
and the API is in the `kong.tracing` namespace.

To make the tracing API standardized and available to all plugins,
we follow the [OpenTelemetry API specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md).
This specification defines the API that should be used to instrument your module.
If you already have the experience of using the OpenTelemetry API, it should be much easier to start.

With the tracing API, you can instrument your module with the following:
- [Span](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md#span)
- [Attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/span-general.md)

## Create a tracer

Kong internally uses a global tracer instance to instrument the core modules and plugins.

By default, the tracer is a [NoopTracer](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/api.md#get-a-tracer) which does nothing to avoid any overhead. The tracer is first initialized when `opentelemetry_tracing` configuration enabled.

You can either create a new tracer manually, or use the global tracer instance.

```lua
local tracer

-- Create a new tracer
tracer = kong.tracing.new("custom-tracer")

-- Use the global tracer
tracer = kong.tracing
```

### Sampling traces

The tracer can be configured to sample traces.

```lua
local tracer = kong.tracing.new("custom-tracer", {
  -- Set the sampling rate to 0.1
  sampling_rate = 0.1,
})
```

By default, the sampling rate is 1.0, meaning that all traces are sampled.

## Create a span

A Span represents a single operation within a trace. Spans can be nested to form a trace tree. Each trace contains a root span, which typically describes the entire operation and, optionally, one or more sub-spans for its sub-operations.

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

Please make sure to ends the span when you are done.

```lua
span:finish() -- ends the span
```

**Note:** The span table will be cleared and put into the table pool after the span is finished,
do not use it after the span is finished.

## Get/Set the active span

The active span is the span that is currently being executed.

To avoid overheads, the active span is manually set by calling the `set_active_span` method.
However, When you finish a span, the active span becomes the parent of the finished span.


To set/get the active span, you can use the following:

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

Please refer to the [OpenTelemetry plugin](/hub/kong-inc/opentelemetry) to see how to visualize the traces.

## References

- [Tracing PDK](/pdk/kong.tracing)
- [Measuring your plugin](/plugin-development/telemetry)
- [OpenTelemetry plugin](/hub/kong-inc/opentelemetry)
