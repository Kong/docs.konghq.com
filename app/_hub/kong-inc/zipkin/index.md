---
name: Zipkin
publisher: Kong Inc.
redirect_from:
  - /hub/kong-inc/zipkin/http-log/
version: 1.3.x
# internal handler version 1.3.0 4-26-2021

source_url: https://github.com/Kong/kong-plugin-zipkin

desc: Propagate Zipkin spans and report space to a Zipkin server
description: |
  Propagate Zipkin distributed tracing spans, and report spans to a Zipkin server.


type: plugin
cloud: false
categories:
  - analytics-monitoring

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
  enterprise_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x

params:
  name: zipkin
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols: ['http', 'https', 'tcp', 'tls', 'udp', 'grpc', 'grpcs']
  dbless_compatible: yes
  config:
    - name: http_endpoint
      required: false
      default: ''
      value_in_examples: http://your.zipkin.collector:9411/api/v2/spans
      datatype: string
      description: |
        The full HTTP(S) endpoint to which Zipkin spans should be sent by Kong.
        If not specified, the Zipkin plugin will only act as a tracing header
        generator/transmitter.
    - name: sample_ratio
      required: false
      default: '`0.001`'
      value_in_examples: 0.001
      datatype: number
      description: |
        How often to sample requests that do not contain trace ids.
        Set to `0` to turn sampling off, or to `1` to sample **all** requests. The
        value must be between zero (0) and one (1), inclusive.
    - name: include_credential
      required: true
      default: true
      value_in_examples: true
      datatype: boolean
      description: |
        Should the credential of the currently authenticated consumer be included in metadata sent to the Zipkin server?
    - name: traceid_byte_count
      required: true
      default: 16
      datatype: integer
      description: |
        The length in bytes of each request's Trace ID. The value can be either `8` or `16`.
    - name: header_type
      required: true
      default: preserve
      datatype: string
      description: |
        All HTTP requests going through the plugin will be tagged with a tracing HTTP request.
        This property codifies what kind of tracing header the plugin expects on incoming requests.
        Possible values are `b3`, `b3-single`, `w3c`, `preserve`, `jaeger`, or `ot`. The `b3` option means that
        the plugin expects [Zipkin's B3 multiple headers](https://github.com/openzipkin/b3-propagation#multiple-headers)
        on incoming requests, and will add them to the transmitted requests if they are missing from it.
        The `b3-single` option expects or adds Zipkin's B3 single-header tracing headers.
        The `w3c` option expects or adds W3C's traceparent tracing header. The `preserve` option
        does not expect any format, and will transmit whatever header is recognized or present,
        with a default of `b3` if none is found. In case of a mismatch between the expected and incoming
        tracing headers (for example, when `header_type` is set to `b3` but a w3c-style tracing header is
        found in the incoming request), then the plugin will add both kinds of tracing headers
        to the request and generate a mismatch warning in the logs. `jaeger` will use and expect
        [Jaeger-style tracing headers](https://www.jaegertracing.io/docs/1.22/client-libraries/#propagation-format) (`uber-trace-id`).
        The `ot` option is for [OpenTelemetry tracing headers](https://github.com/open-telemetry/opentelemetry-java/blob/96e8523544f04c305da5382854eee06218599075/extensions/trace_propagators/src/main/java/io/opentelemetry/extensions/trace/propagation/OtTracerPropagator.java) of the form `ot-tracer-*`.
    - name: default_header_type
      required: true
      default: b3
      datatype: string
      description: |
        Allows specifying the type of header to be added to requests with no pre-existing tracing headers
        and when `config.header_type` is set to `"preserve"`.
        When `header_type` is set to any other value, `default_header_type` is ignored. Possible values are
        `b3`, `b3-single`, `w3c`, `jaeger`, or `ot`.
    - name: tags_header
      required: true
      default: Zipkin-Tags
      datatype: string
      description: |
        The Zipkin plugin will add extra headers to the tags associated with any HTTP
        requests that come with a header named as configured by this property. The
        format is `name_of_tag=value_of_tag`, separated by commas. For example:
        with the default value, a request with the header
        `Zipkin-Tags: fg=blue, bg=red` will generate a trace with the tag `fg` with
        value `blue`, and another tag called `bg` with value `red`.
    - name: static_tags
      required: false
      default: []
      value_in_examples:
      datatype: array of string tags
      description: |
        The tags specified on this property will be added to the generated request traces. For example:
        `[ { "name": "color", "value": "red" } ]`.

---

## How it Works

When enabled, [this plugin](https://github.com/Kong/kong-plugin-zipkin) traces requests in a way compatible with [zipkin](https://zipkin.io/).

The code is structured around an [opentracing](http://opentracing.io/) core using the [opentracing-lua library](https://github.com/Kong/opentracing-lua) to collect timing data of a request in each of Kong's phases.
The plugin uses opentracing-lua compatible extractor, injector, and reporters to implement Zipkin's protocols.

### Reporter

An opentracing "reporter" is how tracing data is reported to another system.
This plugin records tracing data for a given request, and sends it as a batch to a Zipkin server using [the Zipkin v2 API](https://zipkin.io/zipkin-api/#/default/post_spans). Note that zipkin version 1.31 or higher is required.

The `http_endpoint` configuration variable must contain the full uri including scheme, host, port and path sections (i.e. your uri likely ends in `/api/v2/spans`).

### See also

For more information, read the [Kong blog post](https://konghq.com/blog/tracing-with-zipkin-in-kong-2-1-0/).
