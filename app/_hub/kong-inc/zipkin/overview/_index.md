---
nav_title: Overview
---

Propagate Zipkin distributed tracing spans and report spans to a Zipkin server.

{% if_version gte:3.3.x %}
## Queueing

The zipkin plugin uses a queue to decouple the production and
consumption of data. This reduces the number of concurrent requests
made to the upstream server under high load situations and provides
buffering during temporary network or upstream outages.

You can set several parameters to configure the behavior and capacity
of the queues used by the plugin. For more information about how to
use these parameters, see
[Plugin Queuing Reference](/gateway/latest/kong-plugins/queue/reference/)
in the {{site.base_gateway}} documentation.

The queue parameters all reside in a record under the key `queue` in
the `config` parameter section of the plugin.
{% endif_version %}

{% if_plugin_version gte:3.5.x %}
## Trace IDs in serialized logs

When the Zipkin plugin is configured along with a plugin that uses the 
[Log Serializer](/gateway/latest/plugin-development/pdk/kong.log/#konglogserialize),
the trace ID of each request is added to the key `trace_id` in the serialized log output.

The value of this field is an object that can contain different formats
of the current request's trace ID. In case of multiple tracing headers in the
same request, the `trace_id` field includes one trace ID format
for each different header format, as in the following example:

```
"trace_id": {
  "b3": "4bf92f3577b34da6a3ce929d0e0e4736",
  "datadog": "11803532876627986230"
},
```
{% endif_plugin_version %}

---
## How it Works

When enabled, [this plugin](https://github.com/Kong/kong-plugin-zipkin) traces requests in a way compatible with [zipkin](https://zipkin.io/).

The code is structured around an [OpenTracing](http://opentracing.io/) core using the [opentracing-lua library](https://github.com/Kong/opentracing-lua) to collect timing data of a request in each of Kong's phases.
The plugin uses `opentracing-lua` compatible extractor, injector, and reporters to implement Zipkin's protocols.

### Reporter

An OpenTracing "reporter" is how tracing data is reported to another system.
This plugin records tracing data for a given request, and sends it as a batch to a Zipkin server using [the Zipkin v2 API](https://zipkin.io/zipkin-api/#/default/post_spans). Note that zipkin version 1.31 or higher is required.

The `http_endpoint` configuration variable must contain the full uri including scheme, host, port and path sections (i.e. your uri likely ends in `/api/v2/spans`).

### Spans

The plugin does *request sampling*. For each request which triggers the plugin, a random number between 0 and 1 is chosen.

If the number is smaller than the configured `sample_ratio`, then a trace with several spans will be generated. If `sample_ratio` is set to 1, then all requests will generate a trace (this might be very noisy).

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

For more information, read the [Kong blog post](https://konghq.com/blog/tracing-with-zipkin-in-kong-2-1-0).
