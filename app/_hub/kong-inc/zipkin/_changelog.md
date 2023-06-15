## Changelog

**{{site.base_gateway}} 3.1.x**
* Added the parameter `response_header_for_traceid`.

**{{site.base_gateway}} 3.0.x**

* Added support for including the HTTP path in the span name with the
`http_span_name` configuration parameter.
[#8150](https://github.com/Kong/kong/pull/8150)
* Added support for socket connect and send/read timeouts
  through the `connect_timeout`, `send_timeout`,
  and `read_timeout` configuration parameters. This can help mitigate
  `ngx.timer` saturation when upstream collectors are unavailable or slow.
  [#8735](https://github.com/Kong/kong/pull/8735)

**{{site.base_gateway}} 2.7.x**

* Added a new parameter: `local_service_name`.
* Added a new `ignore` option for the `header_type` parameter.

**{{site.base_gateway}} 2.5.x**
* The plugin now includes the following tags: `kong.route`, `kong.service_name`, and `kong.route_name`.

**{{site.base_gateway}} 2.4.x**
* Added support for OT and Jaeger style `uber-trace-id` headers.
* The plugin now allows insertion of custom tags on the Zipkin request trace.
* The plugin now allows the creation of baggage items on child spans.

**{{site.base_gateway}} 2.3.x**
* Added the `default_header_type` and `static_tags` configuration parameters.
