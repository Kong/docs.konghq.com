<!---shared with logging plugins: file-log, http-log, loggly, syslog, tcp-log, udp-log DOCS-1617 --->

* `service`: Properties about the service associated with the requested route.
* `route`: Properties about the specific route requested.
* `request`: Properties about the request sent by the client.
* `response`: Properties about the response sent to the client.
* `latencies`: Latency data.
{% if_plugin_version gte:3.7.x %}
  * `kong`: The internal {{site.base_gateway}} latency, in milliseconds, that it takes to process the request.
    * For requests that are proxied to an upstream, it is equivalent to the `X-Kong-Proxy-Latency` [response header](/gateway/latest/reference/configuration/#headers).
    * For requests that generate a response within {{ site.base_gateway }} (typically the result of an error or a plugin-generated response), it is equivalent to the `X-Kong-Response-Latency` [response header](/gateway/latest/reference/configuration/#headers).
  * `request`: The time in milliseconds that has elapsed between when the first bytes were read from the client and the last byte was sent to the client. This is useful for detecting slow clients.
  * `proxy`: The time in milliseconds that it took for the upstream to process the request. In other words, it's the time elapsed between transferring the 
  request to the final service and when {{site.base_gateway}} starts receiving the response.
  * `receive`: The time in milliseconds that it took to receive and process the response (headers and body) from the upstream.
{% endif_plugin_version %}
{% if_plugin_version lte:3.6.x %}
  * `kong`: The internal {{site.base_gateway}} latency, in milliseconds, that it takes to process the request. It varies based on the actual processing flow. Generally, it consists of three parts:
    * The time it took to find the right upstream.
    * The time it took to receive the whole response from upstream.
    * The time it took to run all plugins executed before the log phase.
  * `request`: The time in milliseconds that has elapsed between when the first bytes were read from the client and the last byte was sent to the client. This is useful for detecting slow clients.
  * `proxy`: The time in milliseconds that it took for the upstream to process the request. In other words, it's the time elapsed between transferring the 
  request to the final service and when {{site.base_gateway}} starts receiving the response.
{% endif_plugin_version %}
* `tries`: a list of iterations made by the load balancer for this request.
  * `balancer_start`: A Unix timestamp for when the balancer started.
  * `ip`: The IP address of the contacted balancer.
  * `port`: The port number of the contacted balancer.
  * `balancer_latency`: The latency of the balancer expressed in milliseconds.
* `client_ip`: The original client IP address.
* `workspace`: The UUID of the workspace associated with this request.
{% if_plugin_version gte:3.4.x %}
* `workspace_name`: The name of the workspace associated with this request.
{% endif_plugin_version %}
* `upstream_uri`: The URI, including query parameters, for the configured upstream.
* `authenticated_entity`: Properties about the authenticated credential (if an authentication plugin has been enabled).
* `consumer`: The authenticated consumer (if an authentication plugin has been enabled).
* `started_at`: The unix timestamp of when the request has started to be processed.

Log plugins enabled on services and routes contain information about the service or route.
