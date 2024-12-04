---
title: Active Tracing - Debugging issues in Dataplanes
content_type: reference
---

The Active Tracing feature allows Control Plane Administrators to initiate "deep tracing" sessions in selected Dataplanes. During an active tracing session, the selected Dataplane records Open Telemetry compatible Traces with very detailed spans covering the entire request and response lifecycle for all requests that match a supplied sampling criteria. These traces are pushed up to Konnect where they can inspected using the Konnect builtin span viewed. No additional instrumentation or telemetry technology is needed for generating these traces. 

"Active Tracing" traces are only generated during an Active-Tracing session. These traces cannot be generated with 3rd party telemetry software. "Active Tracing" can have an impact on throughput under heavy load conditions. Active-Tracing itself adds negligible latency to request-response processing under normal load conditions.

List of spans and associated attributes:
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
<tr><td>tls.cipher</td></tr>

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
  </tbody>
</table>


