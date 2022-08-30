---
title: Tracing Reference
content-type: reference
---

In this section, we will describe the tracing capabilities of Kong.

## Core instrumentations

**Note**
Only works for the plugins that are built on top of Kong's tracing API.
e.g. OpenTelemetry plugin.

Kong provides a set of core instrumentations for tracing, these can be configured in the `opentelemetry_tracing` configuration.

- `off`: do not enable instrumentations.
- `request`: only enable request-level instrumentations.
- `all`: enable all the following instrumentations.
- `db_query`: trace database query, including PostgresSQL and Cassandra.
- `dns_query`: trace DNS query.
- `router`: trace router execution, including router rebuilding.
- `http_client`: trace OpenResty HTTP client requests.
- `balancer`: trace balancer retries.
- `plugin_rewrite`: trace plugins iterator execution with rewrite phase.
- `plugin_access`: trace plugins iterator execution with access phase.
- `plugin_header_filter`: trace plugins iterator execution with `header_filter` phase.

## Propagation

The tracing API support to propagate the following headers:
- `w3c` - [W3C trace context](https://www.w3.org/TR/trace-context/)
- `b3`, `b3-single` - [Zipkin headers](https://github.com/openzipkin/b3-propagation)
- `jaeger` - [Jaeger headers](https://www.jaegertracing.io/docs/client-libraries/#propagation-format)
- `ot` - [OpenTracing headers](https://github.com/opentracing/specification/blob/master/rfc/trace_identifiers.md)
- `datadog` - [Datadog headers](https://docs.datadoghq.com/tracing/agent/propagation/)

The tracing API will detect the propagation format from the headers, and will use the appropriate format to propagate the span context.
If no appropriate format is found, then will fallback to the default format, which can be specified.

The propagation api works for both the OpenTelemetry plugin and the Zipkin plugin.
