<!---shared with logging plugins: file-log, http-log, loggly, syslog, tcp-log, udp-log DOCS-1617 --->

* `service` properties about the Service associated with the requested Route.
* `route` properties about the specific Route requested.
* `request` properties about the request sent by the client.
* `response` properties about the response sent to the client.
* `latencies` latency data.
  * `kong` time in ms that it took to run all the plugins.
  * `request` time in ms time elapsed between the first bytes were read from the client and the last bytes sent to the client. This is useful for detecting slow clients.
  * `proxy` time in ms it took for the upstream to process the request.
* `tries` a list of iterations made by the load balancer for this request.
  * `balancer_start` unix timestamp for when the balancer started.
  * `ip` of the contacted balancer.
  * `port` of the contacted balancer.
  * `balancer_latency` in ms.
* `client_ip` the original client IP address.
* `workspace` the UUID of the workspace associated with this request.
* `upstream_uri` the URI, including query parameters, for the configured upstream.
* `authenticated_entity` properties about the authenticated credential (if an authentication plugin has been enabled).
* `consumer` the authenticated Consumer (if an authentication plugin has been enabled).
* `started_at` the unix timestamp of when the request has started to be processed.

Log plugins enabled on services and routes contain information about the service or route.
