---
title: Plugin Development - Measuring your plugin
book: plugin_dev
chapter: 11
---

This guide will provide you with step-by-step instructions
that will make it possible to measure your plugin at the runtime.

These steps should be applied to each node in your Kong cluster, to ensure the
custom plugin(s) are available on each one of them.

## Tracing

Kong bundled the tracing framework since version 3.0.0, the tracing API is a part of the Kong core,
and the API is in the `kong.tracing` namespace.

### Reference

- [Tracing PDK](/pdk/kong.tracing)
- [Tracing Framework](/observability/tracing-framework)
