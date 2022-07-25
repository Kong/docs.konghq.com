---
name: OpenTelemetry
publisher: Kong Inc.
version: 0.1.0
desc: Propagate spans and report space to a backend server through OTLP protocol.
description: |
  Propagate distributed tracing spans, and report spans to a OTLP-compatible server.
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

The OpenTelemetry plugin uses the [tracing PDK]()
