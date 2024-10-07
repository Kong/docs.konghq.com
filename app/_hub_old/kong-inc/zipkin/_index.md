---
name: Zipkin
publisher: Kong Inc.
version: 1.5.x
source_url: 'https://github.com/Kong/kong-plugin-zipkin'
desc: Propagate Zipkin spans and report space to a Zipkin server
description: |
  Propagate Zipkin distributed tracing spans, and report spans to a Zipkin server.
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible:
      - 2.8.x
      - 2.7.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
params:
  name: zipkin
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols:
    - http
    - https
    - tcp
    - tls
    - udp
    - grpc
    - grpcs
  dbless_compatible: 'yes'
  config:
    - name: local_service_name
      required: true
      default: kong
      datatype: string
      description: |
        The name of the service as displayed in Zipkin. Customize this name to
        tell your Kong Gateway services apart in Zipkin request traces.
    - name: http_endpoint
      required: false
      default: ''
      value_in_examples: 'http://your.zipkin.collector:9411/api/v2/spans'
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
        How often to sample requests that do not contain trace IDs.
        Set to `0` to turn sampling off, or to `1` to sample **all** requests. The
        value must be between zero (0) and one (1), inclusive.
    - name: include_credential
      required: true
      default: true
      value_in_examples: true
      datatype: boolean
      description: |
        Specify whether the credential of the currently authenticated consumer
        should be included in metadata sent to the Zipkin server.
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
        All HTTP requests going through the plugin are tagged with a tracing HTTP request.
        This property codifies what kind of tracing header the plugin expects on incoming requests.

        Possible values: `b3`, `b3-single`, `w3c`, `preserve`, `jaeger`, `ot`, or `ignore`.
        * `b3`: Expects [Zipkin's B3 multiple headers](https://github.com/openzipkin/b3-propagation#multiple-headers)
        on incoming requests, and will add them to the transmitted requests if the headers are missing from those requests.
        * `b3-single`: Expects or adds Zipkin's B3 single-header tracing headers.
        * `w3c`: Expects or adds W3C's traceparent tracing header.
        * `preserve`: Does not expect any format, and will transmit whatever header is recognized or present,
        with a default of `b3` if none is found. In case of a mismatch between the expected and incoming
        tracing headers (for example, when `header_type` is set to `b3` but a w3c-style tracing header is
        found in the incoming request), then the plugin will add both kinds of tracing headers
        to the request and generate a mismatch warning in the logs.
        * `jaeger`: Expects or adds
        [Jaeger-style tracing headers](https://www.jaegertracing.io/docs/1.22/client-libraries/#propagation-format) (`uber-trace-id`).
        * `ot`: Expects or adds [OpenTelemetry tracing headers](https://github.com/open-telemetry/opentelemetry-java/blob/96e8523544f04c305da5382854eee06218599075/extensions/trace_propagators/src/main/java/io/opentelemetry/extensions/trace/propagation/OtTracerPropagator.java) of the form `ot-tracer-*`.
        * `ignore`: Does not read any tracing headers from the incoming request.
        Starts a new request using the `default_header_type` value, or falls back to
        `b3` if there is no `default_header_type` value set.
    - name: default_header_type
      required: true
      default: b3
      datatype: string
      description: |
        Allows specifying the type of header to be added to requests with no pre-existing tracing headers
        and when `config.header_type` is set to `"preserve"`.
        When `header_type` is set to any other value, `default_header_type` is ignored.

        Possible values are `b3`, `b3-single`, `w3c`, `jaeger`, or `ot`.
        See the entry for `header_type` for value definitions.
    - name: tags_header
      required: true
      default: Zipkin-Tags
      datatype: string
      description: |
        The Zipkin plugin will add extra headers to the tags associated with any HTTP
        requests that come with a header named as configured by this property. The
        format is `name_of_tag=value_of_tag`, separated by commas.

        For example: with the default value, a request with the header
        `Zipkin-Tags: fg=blue, bg=red` will generate a trace with the tag `fg` with
        value `blue`, and another tag called `bg` with value `red`.
    - name: static_tags
      required: false
      default: []
      value_in_examples: null
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

### Spans

The plugin does *request sampling*. For each request which triggers the plugin, a random number between 0 and 1 is chosen.

If the number is greater than the configured `sample_ratio`, then a trace with several spans will be generated. If `sample_ratio` is set to 1, then all requests will generate a trace (this might be very noisy).

For each request that gets traced, the following spans are produced:

* **Request span**: 1 per request. Encompasses the whole request in kong (kind: SERVER).
  The Proxy and Balancer spans are children of this span. It contains the following logs/annotations for the rewrite phase:

  * `krs` - `kong.rewrite.start`
  * `krf` - `kong.rewrite.finish`

  The Request span has the following tags:

  * `lc`: Hardcoded to `kong`.
  * `kong.service`: The uuid of the service matched when processing the request, if any.
  * `kong.service_name`: The name of the service matched when processing the request, if service exists and has a `name` attribute.
  * `kong.route`: The uuid of the route matched when processing the request, if any (it can be nil on non-matched requests).
  * `kong.route_name`: The name of the route matched when processing the request, if route exists and has a `name` attribute.
  * `http.method`: The HTTP method used on the original request (only for HTTP requests).
  * `http.path`: The path of the request (only for HTTP requests).
  * If the plugin `tags_header` config option is set, and the request contains headers with the appropriate name and correct encoding tags, then the trace will include the tags.
  * If the plugin `static_tags` config option is set, then the tags in the config option will be included in the trace.

* **Proxy span**: 1 per request, encompassing most of Kong's internal processing of a request (kind: CLIENT).
  Contains the following logs/annotations for the start/finish of the of the Kong plugin phases:
  * `kas` - `kong.access.start`
  * `kaf` - `kong.access.finish`
  * `kbs` - `kong.body_filter.start`
  * `kbf` - `kong.body_filter.finish`
  * `khs` - `kong.header_filter.start`
  * `khf` - `kong.header_filter.finish`
  * `kps` - `kong.preread.start` (only for stream requests)
  * `kpf` - `kong.preread.finish` (only for stream requests)

* **Balancer span(s)**: 0 or more per request, each encompassing one balancer attempt (kind: CLIENT).
Contains the following tags specific to load balancing:
  * `kong.balancer.try`: A number indicating the attempt (1 for the first load-balancing attempt, 2 for the second, and so on).
  * `peer.ipv4` or `peer.ipv6` for the balancer IP.
  * `peer.port` for the balanced port.
  * `error`: Set to `true` if the balancing attempt was unsuccessful, otherwise unset.
  * `http.status_code`: The HTTP status code received, in case of error.
  * `kong.balancer.state`: An NGINX-specific description of the error, `next/failed` for HTTP failures, or `0` for stream failures.
     Equivalent to `state_name` in OpenResty's balancer's `get_last_failure` function.

### See also

For more information, read the [Kong blog post](https://konghq.com/blog/tracing-with-zipkin-in-kong-2-1-0/).

---

## Changelog

### 1.5.x

* Added a new parameter: `local_service_name`
* Added a new `ignore` option for the `header_type` parameter
