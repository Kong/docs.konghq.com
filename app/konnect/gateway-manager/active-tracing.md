---
title: Active Tracing in Konnect
content_type: reference
---

Active tracing enables control plane administrators to initiate targeted "deep tracing" sessions in specific data plane nodes. During an active tracing session, the selected data plane generates detailed, OpenTelemetry-compatible traces for all requests matching the sampling criteria. The detailed spans are captured for the entire request/response lifecycle. These traces can be visualized with Konnect's built-in span viewer with no additional instrumentation or telemetry tools.

Konnect's active tracing capability offers exclusive, in-depth insights that cannot be replicated by third-party telemetry tools. The detailed traces generated during live active tracing session are unique to Kong and provide unparalleled visibility into system performance. 

Active Tracing adheres to OpenTelemetry naming conventions for spans and attributes, wherever possible, ensuring consistency and interoperability.

## Key Highlights
- Traces can be generated for a service or per route
- Refined traces can be generated for all requests matching a sampling criteria
- Samplign criteria can be defined with simple expressions language ex: http.method == "GET"
- Trace sessions are retained for upto 7 days

Although active tracing is desinged to be as a debug and troubleshooting tool, it can unlock in-depth insights into the API traffic and serve as a monitoring and observability tool. Under normal conditions, active tracing adds negligible latency. However it may affect throughput under heavy loads.

## Get Started with tracing

Active Tracing requires the following **data plane version** and **environment variables** in `kong.conf`:

- **Version:** 3.9 or above
- **Environment Variables:**
  - `KONG_CLUSTER_RPC=on`
  - `KONG_ACTIVE_TRACING=on`

## Start a Trace Session

1. Navigate to **Gateway Manager**.
2. Select a **Control Plane** which has the data plane to be traced.
3. Click on **Active Tracing** in left navigation menu.
4. Click **"New tracing session"**, define the criteria and, click **Start Session**.

Once started, traces will begin to be captured and shown. The **default session duration** is **5 minutes** or **200 traces per session**. Note the sessions are retained for upto **7 days**

For **advanced sampling rules**, specify the desired criteria using expression. For example, to capture traces for all requests matching 503 response code, specify the following rule
- http.response.status_code==503


## Sample Trace

A sample trace is shown below. By inspecting the **spans**, it is clear that the **bulk of the latency** occurs in the **pre-function plugin** during the **access phase**.


![Active-Tracing Spans](/assets/images/products/gateway/active-tracing-spans.png)


#### Full list of spans and associated attributes:
<table>
  <thead>
    <th>Span Name</th>
    <th>Note</th>
    <th>Attributes</th>
  </thead>
  <tbody>
    <tr>
      <td>kong</td>
      <td>root span</td>
      <td>
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
              <td>IP address of the peer connecting to Kong</td>
            </tr>
            <tr><td>client.port</td><td>if available</td></tr>
<tr><td>network.peer.address</td><td>client ip</td></tr>
<tr><td>network.peer.port</td><td>client port</td></tr>
<tr><td>server.address</td><td>our dns/ip the client used to reach us</td></tr>
<tr><td>server.port</td><td>our public port</td></tr>
<tr><td>network.protocol.name</td><td>http, grpc, ws, kafka etc</td></tr>
<tr><td>http.request.method</td><td>the http method</td></tr>
<tr><td>http.request.body.size</td><td>content-length or equivalent in bytes</td></tr>
<tr><td>http.request.size</td><td>body.size + headers.size in bytes</td></tr>
<tr><td>http.response.body.size</td><td>response content-length or equivalent in bytes</td></tr>
<tr><td>http.response.size</td><td>response.body.size + resp.headers.size in bytes</td></tr>
<tr><td>kong.request.id</td><td>proxy.kong.request_id</td></tr>
<tr><td>url.scheme</td><td>scheme of the request</td></tr>
<tr><td>network.protocol.flavor</td><td>http flavor [1.2, 2.0]</td></tr>
<tr><td>tls.client.server_name</td><td>SNI</td></tr>
<tr><td>http.request.header.host</td><td>Host header if present. This can be different from SNI</td></tr>
<tr><td>proxy.kong.consumer_id</td><td>authenticated consumer_id if present</td></tr>
<tr><td>proxy.kong.upstream_id</td><td>resolved upstream_id</td></tr>
<tr><td>proxy.kong.upstream_status_code</td><td>status code returned by upstream</td></tr>
<tr><td>http.response.status_code</td><td>status code sent back by Kong</td></tr>
<tr><td>proxy.kong.latency.upstream</td><td>time between connect() to upstream and last byte of response ($upstream_response_time)</td></tr>
<tr><td>proxy.kong.latency.total</td><td>first byte into kong, last byte out of kong ($request_time)</td></tr>
<tr><td>proxy.kong.latency.internal</td><td>see Appendix-D</td></tr>
<tr><td>proxy.kong.latency.net_io_timings</td><td>array of (ip, connect_time, rw_time) - i/o outside of request context is not considered</td></tr>
<tr><td>proxy.kong.client_KA</td><td>did downstream use a KeepAlive connection</td></tr>
<tr><td>tls.resumed</td><td>was the TLS session reused</td></tr>
<tr><td>tls.client.subject</td><td>x509 client DN (if mtls)</td></tr>
<tr><td>tls.server.subject</td><td>x509 DN for cert we presented</td></tr>
<tr><td>tls.cipher</td><td>the negotiated cipher</td></tr>

          </tbody>
        </table>
      </td>
    </tr>

    <tr>
      <td>kong.phase.certificate</td>
      <td>span capturing the execution of the certificate phase of request processing. Any plugins configured for running in this phase will show up as individual child spans</td>
    </tr>
  
    <tr>
      <td>kong.certificate.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the certificate phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
    
    <tr>
    <td>kong.read_client_http_headers</td>
    <td>span capturing the time taken to read http headers from the client. This span is useful for detecting clients that are coming over a slow network or a buggy CDN, or simply take too long to send in the http headers.</td> 
     <td>
        <table>
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
      </td>
    </tr>

    <tr>
      <td>kong.read_client_http_body</td>
      <td>span capturing the total time taken to read the full body sent by the client. This span can identify slow clients, buggy CDNs and very large body submissions</td>
    </tr>

    <tr>
      <td>kong.phase.rewrite</td>
      <td>span capturing the execution of the rewrite phase of request processing. Any plugins configured for running in this phase will show up as individual child spans</td>
    </tr>
    
    <tr>
      <td>kong.rewrite.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the rewrite phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>

    <tr>
      <td>kong.io.func</td>
      <td>span capturing network i/o timing that occurs during plugin execution or other request processing. Examples including the OIDC plugin making calls to IdP, RLA plugin making calls to redis, custom plugins calling http urls and so forth. Multiple instances of this span can occur anywhere in the trace when i/o happens</td>
      <td>
        <table>
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
      </td>
    </tr>

    <tr>
    <td>kong.router</td>
    <td>span capturing the execution of the Kong router</td>
    <td>
        <table>
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
      </td>
    </tr>

   <tr>
      <td>kong.phase.access</td>
      <td>span capturing the execution of the access phase of request processing. Any plugins configured for running in this phase will show up as individual child spans</td>
    </tr>
    
    <tr>
      <td>kong.access.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the access phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>

  <tr>
    <td>kong.dns</td>
    <td>span capturing the time spent in looking up DNS</td>
    <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.dns.entry</td>
              <td>a list of DNS attempts, respones and errors if any</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>

<tr>
    <td>kong.upstream_selection</td>
    <td>span capturing the total time spent in finding a healthy upstream. Depending on configuration, Kong will try to find a healthy upstream by trying various targets in order determined by the load balancing algorithm. Child spans of this span capture the individual attempts</td>
    <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.upstream.lb_algorithm</td>
              <td>the load balancing algorithm used for finding the upstream</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>

    <tr>
    <td>kong.upstream.try_select</td>
    <td>span capturing the attempt to verify a specific upstream. Kong attempts to open a TCP connection (if not KeepAlive cache is found), do a TLS handshake and send down the http headers. If all of this succeeds, the upstream is healthy and Kong will finish sending the full request and wait for a response. If any of the step fails, Kong will switch to the next target and try again</td>
    <td>
        <table>
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
      </td>
    </tr>

 <tr>
      <td>kong.upstream_ttfb</td>
      <td>span capturing the "time to first byte" from the upstream. This includes the time taken to finish writing the http request to upstream, and the time taken by the upstream to start generating a response. This span can be used to identify network delays between Kong and an upstream as well as identifying upstreams that take long to start generating responses</td>
</tr>

<tr>
      <td>kong.upstream_read_response</td>
      <td>span capturing the time taken for the upstream to generate a full response. This effectively measures the time Kong sees between the first byte of the response header and the last byte of the response body comng from the upstream. This span can be used to identify slowness in response generation from upstreams</td>
</tr>

    <tr>
      <td>kong.phase.response</td>
      <td>span capturing the execution of the response phase. Any plugins configured for running in this phase will show up as individual child spans. This phase will not run if response streaming is enabled</td>
    </tr>
    
    <tr>
      <td>kong.response.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the response phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>

    <tr>
      <td>kong.phase.header_filter</td>
      <td>span capturing the execution of the header filter phase of response processing. Any plugins configured for running in this phase will show up as individual child spans</td>
    </tr>
    
    <tr>
      <td>kong.header_filter.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the header_filter phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>


    <tr>
      <td>kong.phase.body_filter</td>
      <td>span capturing the execution of the body filter phase of response processing. Any plugins configured for running in this phase will show up as individual child spans</td>
    </tr>
    
    <tr>
      <td>kong.body_filter.plugin.{plugin_name}</td>
      <td>span capturing the execution of a plugin configured to run in the body_filter phase. Multiple such spans can occur in a trace</td>
      <td>
        <table>
          <tbody>
            <tr>
              <td>proxy.kong.plugin.instance_id</td>
              <td>The instance id of the plugin configuration that ran</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
    
  </tbody>
</table>


