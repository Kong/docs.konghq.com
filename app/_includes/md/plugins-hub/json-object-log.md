<!---shared with logging plugins: file-log, http-log, loggly, syslog, tcp-log, udp-log DOCS-1617 --->

A few considerations on the JSON object:

* `request` contains properties about the request sent by the client.
* `response` contains properties about the response sent to the client.
* `tries` contains the list of (re)tries (successes and failures) made by the load balancer for this request.
* `route` contains {{site.base_gateway}} properties about the specific Route requested.
* `service` contains {{site.base_gateway}} properties about the Service associated with the requested Route.
* `authenticated_entity` contains {{site.base_gateway}} properties about the authenticated credential (if an authentication plugin has been enabled).
* `workspaces` contains {{site.base_gateway}} properties of the Workspaces associated with the requested
   Route. **Only in {{site.base_gateway}} version >= 0.34.x**. For {{site.base_gateway}} version >= 2.1.x, 
   there is a `ws_id` on services and routes that reference the workspace ID.
* `consumer` contains the authenticated Consumer (if an authentication plugin has been enabled).
* `latencies` contains some data about the latencies involved:
  * `proxy` is the time it took for the final service to process the request. In other words, it's the time elapsed between transferring the request to the final service and when {{site.base_gateway}} started receiving the response.
  * `kong` is the internal {{site.base_gateway}} latency that it takes to process the request. It varies based on the actual processing flow. Generally, it consists of three parts:
    * The time it took to find the right upstream.
    * The time it took to receive the whole response from upstream.
    * The time it took to run all plugins executed before the log phase.
  * `request` is the time elapsed between the first bytes were read from the client and after the last bytes were sent to the client. Useful for detecting slow clients.
* `client_ip` contains the original client IP address.
* `started_at` contains the UTC timestamp of when the request has started to be processed.

Log plugins enabled on services and routes contain information about the service or route.
