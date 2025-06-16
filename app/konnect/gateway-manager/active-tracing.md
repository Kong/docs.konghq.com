---
title: Active Tracing in Konnect
content_type: reference
alpha: true
---

Active tracing enables control plane administrators to initiate targeted "deep tracing" sessions in specific data plane nodes. During an active tracing session, the selected data plane generates detailed, OpenTelemetry-compatible traces for all requests matching the sampling criteria. The detailed spans are captured for the entire request/response lifecycle. These traces can be visualized with {{site.konnect_short_name}}'s built-in span viewer with no additional instrumentation or telemetry tools.

{{site.konnect_product_name}}'s active tracing capability offers exclusive, in-depth insights that cannot be replicated by third-party telemetry tools. The detailed traces generated during live active tracing session are unique to Kong and provide unparalleled visibility into system performance. 

Active Tracing adheres to OpenTelemetry naming conventions for spans and attributes, wherever possible, ensuring consistency and interoperability.

## Key highlights

- Traces can be generated for a service or per route
- Refined traces can be generated for all requests matching a sampling criteria
- Sampling criteria can be defined with simple expressions language, for example: `http.method == GET`
- Trace sessions are retained for up to 7 days
- Traces can be visualized in {{site.konnect_short_name}}'s built in trace viewer 

Although active tracing is designed as a debug and troubleshooting tool, it can unlock in-depth insights into the API traffic and serve as a monitoring and observability tool. 
Under normal conditions, active tracing adds negligible latency. However, under heavy loads, it may affect the throughput.

## Reading traces in {{site.konnect_short_name}} trace viewer

Traces captured in an active tracing session can be visualized in {{site.konnect_short_name}}'s built-in trace viewer. The trace viewer displays a **Summary** view and a **Trace** view. You can gain instant insights with the summary view while the trace view will help you dive deeper.

### Summary view  

Summary view helps you visualize the entire API request-response flow in a single glance. This view provides a concise overview of critical metrics and a transaction map. The transaction map includes the plugins executed by {{site.base_gateway}} on both the request and the response along with the times spent in each phase. Use the summary view to quickly understand the end-to-end API flow, identify performance bottlenecks, and optimize your API strategy. 

### Trace view

The trace view gives you unparalleled visibility into {{site.base_gateway}}'s internal workings. 
This detailed view breaks down into individual spans, providing a comprehensive understanding of:
- {{site.base_gateway}}'s internal processes and phases
- Plugin execution and performance
- Request and response handling

Use the trace view to troubleshoot issues, optimize performance, and refine your configuration.

## Get started with tracing

Active Tracing requires the following **data plane version** and **environment variables** in `kong.conf`:

- **Version:** 3.9.1 or above
- **Environment variables:**
  - `KONG_CLUSTER_RPC=on`
  - `KONG_ACTIVE_TRACING=on`

### Start a trace session

1. Navigate to **Gateway Manager**.
2. Select a **Control Plane** which has the data plane to be traced.
3. Click on **Active Tracing** in left navigation menu.
4. Click **New tracing session**, define the criteria and, click **Start Session**.

Once started, traces will begin to be captured. Click on a trace to visualize it in the trace viewer.

The **default session duration** is **5 minutes** or **200 traces per session**. Note the sessions are retained for up to 7 days.

### Sampling rules

To capture only the relevant API traffic, use sampling rules. Sampling rules filter and refine the requests to be matched. The matching requests are then traced and captured in the session. There are two options. 
* **Basic sampling rules**: Allow filtering on route and services.
* **Advanced sampling rules**: Specify the desired criteria using expressions. For example, to capture traces for all requests matching 503 response code, specify the following rule
  ```
  http.response.status_code==503
  ```

### Known issues in tech preview

Here is a list of known issues in the tech preview:

- **Incorrect span orders**
    - When spans have very short duration few spans may be displayed in wrong order.
- **Incorrect handling of certain error conditions**
  - Traces may be broken when there are certain error conditions. For example, when DNS name resolution fails.
- **Missing spans during high traffic volumes**
    - When no sampling rule is enabled during a high traffic volume scenario, some traces could be missing spans.

## Sample trace

A sample trace is shown below. By inspecting the **spans**, it is clear that the **bulk of the latency** occurs in the **pre-function plugin** during the **access phase**.

![Active-Tracing Spans](/assets/images/products/gateway/active-tracing-spans.png)

## Spans
<!--vale off-->
### kong

The root span.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>url.full</td>
      <td>The full url, but without query params</td>
    </tr>
    <tr>
      <td>client.address</td>
      <td>Remote address of the client making the request. This considers forwarded addresses in cases when a load balancer is in front of Kong. Note: this requires configuring the real_ip_header and trusted_ips global configuration options.</td>
    </tr>
    <tr><td>client.port</td><td>Remote port of the client making the request. This considers forwarded ports in cases when a load balancer is in front of Kong. Note: this requires configuring the real_ip_header and trusted_ips global configuration options.</td></tr>
    <tr><td>network.peer.address</td><td>IP of the component that is connecting to Kong</td></tr>
    <tr><td>network.peer.port</td><td>Port of the component that is connecting to Kong</td></tr>
    <tr><td>server.address</td><td>Kong's dns name or ip used in client connection</td></tr>
    <tr><td>server.port</td><td>Kong's public port</td></tr>
    <tr><td>network.protocol.name</td><td>http, grpc, ws, kafka etc</td></tr>
    <tr><td>http.request.method</td><td>the http request method</td></tr>
    <tr><td>http.request.body.size</td><td>request content-length or equivalent in bytes</td></tr>
    <tr><td>http.request.size</td><td>request.body.size + request.headers.size in bytes</td></tr>
    <tr><td>http.response.body.size</td><td>response content-length or equivalent in bytes</td></tr>
    <tr><td>http.response.size</td><td>response.body.size + response.headers.size in bytes</td></tr>
    <tr><td>proxy.kong.request.id</td><td>proxy.kong.request_id - unique id for each request</td></tr>
    <tr><td>proxy.kong.request.time</td><td>request time as measured by nginx ($request_time)</td></tr>
    <tr><td>url.scheme</td><td>Protocol identifier</td></tr>
    <tr><td>network.protocol.version</td><td>version of the http protocol used in establishing connection [1.2, 2.0]</td></tr>
    <tr><td>tls.client.server_name</td><td>SNI</td></tr>
    <tr><td>http.request.header.host</td><td>Host header if present. This can be different from SNI</td></tr>
    <tr><td>proxy.kong.consumer_id</td><td>authenticated consumer_id if present</td></tr>
    <tr><td>proxy.kong.upstream_id</td><td>resolved upstream_id</td></tr>
    <tr><td>proxy.kong.upstream_status_code</td><td>status code returned by upstream</td></tr>
    <tr><td>http.response.status_code</td><td>status code sent back by Kong</td></tr>
    <tr><td>proxy.kong.latency.upstream</td><td>time between connect() to upstream and last byte of response ($upstream_response_time)</td></tr>
    <tr><td>proxy.kong.latency.total</td><td>first byte into kong, last byte out of kong</td></tr>
    <tr><td>proxy.kong.latency.internal</td><td>Time taken by Kong to process the request. Excludes client and upstream read/write times, and i/o times</td></tr>
    <tr><td>proxy.kong.latency.net_io_timings</td><td>array of (ip, connect_time, rw_time) - i/o outside of request context is not considered</td></tr>
    <tr><td>proxy.kong.client_KA</td><td>did downstream use a KeepAlive connection</td></tr>
    <tr><td>tls.resumed</td><td>was the TLS session reused</td></tr>
    <tr><td>tls.client.subject</td><td>x509 client DN (if mtls)</td></tr>
    <tr><td>tls.server.subject</td><td>x509 DN for cert Kong presented</td></tr>
    <tr><td>tls.cipher</td><td>the negotiated cipher</td></tr>
  </tbody>
</table>
<!--vale on-->
## kong.phase.certificate
A span capturing the execution of the `certificate` phase of request processing. Any plugins configured for running in this phase will show up as individual child spans.

### kong.certificate.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `certificate` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
 <table>
 <thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>

## kong.tls_handshake
A span that captures the execution of the TLS handshake between the client and Kong. This span includes any I/O operations involved in the handshake, which may be prolonged due to slow client behavior.

## kong.read_client_http_headers
A span capturing the time taken to read HTTP headers from the client. 
This span is useful for detecting clients that are coming over a slow network or a buggy CDN, or simply take too long to send in the HTTP headers.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.http_headers_count</td>
      <td>The number of headers sent by the client</td>
    </tr>
    <tr>
      <td>proxy.kong.http_headers_size</td>
      <td>The size (in bytes) of headers sent by the client</td>
    </tr>
  </tbody>
</table>

## kong.read_client_http_body
A span capturing the total time taken to read the full body sent by the client. This span can identify slow clients, a buggy CDN and very large body submissions.

## kong.phase.rewrite
A span capturing the execution of the `rewrite` phase of request processing. Any plugins configured for running in this phase will show up as individual child spans.

### kong.rewrite.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `rewrite` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>

## kong.io.<func>
A span capturing network i/o timing that occurs during plugin execution or other request processing. 

Can be one of:
* kong.io.http.request (requests done by the internal http client during the flow)
* kong.io.http.connect (connections done by the internal http client during the flow)
* kong.io.redis.<function> (redis functions)
* kong.io.socket.<function> (functions called on the internal nginx socket)

Examples:
* OIDC plugin making calls to IdP
* Rate Limiting Advanced plugin making calls to Redis
* Custom plugins calling HTTP URLs 

Multiple instances of this span can occur anywhere in the trace when i/o happens.

This span has the following attributes:

<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>network.peer.address</td>
      <td>The address of the peer Kong connected with</td>
    </tr>
    <tr>
      <td>network.protocol.name</td>
      <td>The protocol that was used (redis, tcp, http, grpc etc)</td>
    </tr>
  </tbody>
</table>


## kong.router
A span capturing the execution of the Kong router.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.router.matched</td>
      <td>yes/no - did the router find a match for the request</td>
    </tr>
    <tr>
      <td>proxy.kong.router.route_id</td>
      <td>The ID of the route that was matched</td>
    </tr>
    <tr>
      <td>proxy.kong.router.service_id</td>
      <td>The ID of the service that was matched</td>
    </tr>
    <tr>
      <td>proxy.kong.router.upstream_path</td>
      <td>The path of the upstream url returned by the match</td>
    </tr>
    <tr>
      <td>proxy.kong.router.cache_hit</td>
      <td>yes/no - was the match returned from cache</td>
    </tr>
  </tbody>
</table>

## kong.phase.access
A span capturing the execution of the `access` phase of request processing. 
Any plugins configured for running in this phase will show up as individual child spans.

### kong.access.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `access` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>

## kong.dns
A span capturing the time spent in looking up DNS.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.dns.entry</td>
      <td>A list of DNS attempts, responses and errors if any</td>
    </tr>
  </tbody>
</table>


## kong.upstream.selection
A span capturing the total time spent in finding a healthy upstream. 
Depending on configuration, Kong will try to find a healthy upstream by trying various targets in order determined by the load balancing algorithm. 
Child spans of this span capture the individual attempts.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.upstream.lb_algorithm</td>
      <td>the load balancing algorithm used for finding the upstream</td>
    </tr>
  </tbody>
</table>


### kong.upstream.find_upstream
A span capturing the attempt to verify a specific upstream. 
Kong attempts to open a TCP connection (if not KeepAlive cache is found), do a TLS handshake and send down the HTTP headers. 
If all of this succeeds, the upstream is healthy and Kong will finish sending the full request and wait for a response. 
If any of the step fails, Kong will switch to the next target and try again.
The last of these spans (or the only one, if the first attempt succeeds) ends as soon as the connection is established, ensuring that the total time captured by the parent `kong.upstream.selection` span always reflects only the time spent *connecting* to the selected upstream.

Depending on how the [proxy_next_upstream](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream) directive is configured, earlier (failed) tries may involve additional I/O. For example, if retries are triggered based on the upstream’s status code or header validity, those attempts will include sending the request and reading the response status line and headers; enough for Kong to determine whether to retry.


This span has the following attributes:
<!--vale off-->
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>network.peer.address</td>
      <td>the IP address of the target upstream</td>
    </tr>
    <tr>
      <td>network.peer.name</td>
      <td>the DNS name of the target upstream</td>
    </tr>
    <tr>
      <td>network.peer.port</td>
      <td>the port number of the target</td>
    </tr>
    <tr>
      <td>try_count</td>
      <td>The number of attempts Kong has made to find a healthy upstream</td>
    </tr>
    <tr>
      <td>keepalive</td>
      <td>Is this a KeepAlive connection?</td>
    </tr>
  </tbody>
</table>
<!--vale on-->

## kong.send_request_to_upstream
A span capturing the time taken to write the http request (headers and body) to upstream.
This span can be used to identify network delays between Kong and an upstream.

## kong.read_headers_from_upstream
A span capturing the time taken for the upstream to generate the response headers. 
This span can be used to identify slowness in response generation from upstreams.
If there is a delay after the request is sent but before the upstream starts responding, that *time to first byte* is also included in this span.

## kong.read_body_from_upstream
A span capturing the time taken for the upstream to generate the response body. 
This span can be used to identify slowness in response generation from upstreams.


## kong.phase.response
A span capturing the execution of the `response` phase. 
Any plugins configured for running in this phase will show up as individual child spans. This phase will not run if response streaming is enabled.

### kong.response.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `response` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>


## kong.phase.header_filter
A span capturing the execution of the header filter phase of response processing. Any plugins configured for running in this phase will show up as individual child spans.

### kong.header_filter.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `header_filter` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>

## kong.phase.body_filter
A span capturing the execution of the body filter phase of response processing. Any plugins configured for running in this phase will show up as individual child spans.

### kong.body_filter.plugin.{plugin_name}
A span capturing the execution of a plugin configured to run in the `body_filter` phase. Multiple such spans can occur in a trace.

This span has the following attributes:
<table>
<thead>
  <th>Name</th>
  <th>Description</th>
</thead>
  <tbody>
    <tr>
      <td>proxy.kong.plugin.instance_id</td>
      <td>The instance id of the plugin configuration that ran</td>
    </tr>
  </tbody>
</table>

## kong.wait_for_client_read
A span that measures the time Kong spends finishing the response write to the client. This duration may be extended for slow-reading clients, resulting in a longer span.