---
title: Write a custom trace exporter
---

Kong bundled OpenTelemetry plugin in core with a implementation of [OTLP/HTTP](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md#otlphttp), but you can still write your own exporter at scale.

The following sections shows how to write a custom trace exporter.

## Before you start

Please make sure you have read the following sections:

- [Documentation of tracing framework](/gateway/{{page.kong_version}}/observability/tracing-framework)
- [Plugin Development](/gateway/{{page.kong_version}}/plugin-development)

## Gathering the spans

The spans are stored in the tracer's buffer.
The buffer is a queue of spans that are awaiting to be sent to the backend.

You can access the buffer and process the span using the `process_span` function.

```lua
-- Use the global tracer
local tracer = kong.tracing

-- Process the span
local span_processor = function(span)
    -- clone the span so it can be processed after the original one is cleared
    local span_dup = table.clone(span)
    -- you can transform the span, add tags, etc. to other specific data structures
end
```

The `span_processor` function should be called in the `log` phase of the plugin.

## Full example

Refer to [Github](https://github.com/Kong/kong/tree/master/spec/fixtures/custom_plugins/kong/plugins/tcp-trace-exporter) to see the example of a custom trace exporter.
