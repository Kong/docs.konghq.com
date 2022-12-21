---
title: Timeout
---

{% tip %}
Timeout is an outbound policy. Dataplanes whose configuration is modified are in the `sources` matcher.
{% endtip %}

This policy enables {{site.mesh_product_name}} to set timeouts on the outbound connections depending on the protocol.

## Usage

Specify the proxy to configure with the `sources` selector, and the outbound connections from the proxy with the `destinations` selector.

The policy lets you configure timeouts for `HTTP`, `GRPC`, and `TCP` protocols.
More about [Protocol support in {{site.mesh_product_name}}](/docs/{{ page.version }}/policies/protocol-support-in-kuma). 

## Configuration

Timeouts applied when communicating with services of **any protocol**:

Field: **connectTimeout**<br>
Description: time to establish a connection<br>
Default value: 10s<br>
Envoy conf: [Cluster](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/cluster/v3/cluster.proto#envoy-v3-api-field-config-cluster-v3-cluster-connect-timeout)

Timeouts applied when communicating with **TCP** services:

Field: **tcp.idleTimeout**<br>
Description: period in which there are no bytes sent or received 
on either the upstream or downstream connection<br>
Default value: disabled<br>
Envoy conf: [TCPProxy](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/network/tcp_proxy/v3/tcp_proxy.proto#envoy-v3-api-field-extensions-filters-network-tcp-proxy-v3-tcpproxy-idle-timeout)

Timeouts applied when communicating with **HTTP**, **HTTP2** or **GRPC** services:

Field: **http.requestTimeout**<br>
Description: is a span between the point at which the entire 
downstream request (i.e. end-of-stream) has been processed and when the 
upstream response has been completely processed<br>
Default value: disabled<br>
Envoy conf: [Route](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/route/v3/route_components.proto#envoy-v3-api-field-config-route-v3-routeaction-timeout)

Field: **http.idleTimeout**<br>
Description: time at which a downstream or upstream connection 
will be terminated if there are no active streams<br>
Default value: disabled<br>
Envoy conf: [HTTPConnectionManager and Cluster](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/protocol.proto#envoy-v3-api-field-config-core-v3-httpprotocoloptions-idle-timeout)

Field: **http.streamIdleTimeout**<br>
Description: amount of time that the connection manager 
will allow a stream to exist with no upstream or downstream activity<br>
Default value: disabled<br>
Envoy conf: [HTTPConnectionManager](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto#envoy-v3-api-field-extensions-filters-network-http-connection-manager-v3-httpconnectionmanager-stream-idle-timeout)

Field: **http.maxStreamDuration**<br>
Description: maximum time that a stream’s lifetime will span<br>
Default value: disabled<br>
Envoy conf: [Cluster](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/protocol.proto#envoy-v3-api-field-config-core-v3-httpprotocoloptions-max-stream-duration)

## Default general-purpose Timeout policy

By default, {{site.mesh_product_name}} creates the following Timeout policy:

{% tabs timeout-policy useUrlFragment=false %}
{% tab timeout-policy Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Timeout
mesh: default
metadata:
  name: timeout-all-default
spec:
  sources:
    - match:
        kuma.io/service: '*'
  destinations:
    - match:
        kuma.io/service: '*'
  conf:
    connectTimeout: 5s # all protocols
    tcp: # tcp, kafka
      idleTimeout: 1h 
    http: # http, http2, grpc
      requestTimeout: 15s 
      idleTimeout: 1h
      streamIdleTimeout: 30m
      maxStreamDuration: 0s
```
{% endtab %}

{% tab timeout-policy Universal %}
```yaml
type: Timeout
mesh: default
name: timeout-all-default
sources:
  - match:
      kuma.io/service: '*'
destinations:
  - match:
      kuma.io/service: '*'
conf:
  connectTimeout: 5s # all protocols
  tcp: # tcp, kafka
    idleTimeout: 1h
  http: # http, http2, grpc
    requestTimeout: 15s
    idleTimeout: 1h
    streamIdleTimeout: 30m
    maxStreamDuration: 0s
```
{% endtab %}
{% endtabs %}

{% warning %}
Default timeout policy works fine in most cases. 
But if your application is using [GRPC streaming](https://grpc.io/docs/what-is-grpc/core-concepts/) 
make sure to set `http.requestTimeout` to 0s. 
{% endwarning %}

## Matching

`Timeout` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
The only supported value for `destinations.match` is `kuma.io/service`.

## Builtin Gateway support

Timeouts are connection policies and are supported by configuring the timeout parameters on the target Envoy cluster.
Request timeouts are configured on the Envoy routes and may select a different Timeout policy when a route backend forwards to more than one distinct service.

Mesh configures an idle timeout on the HTTPConnectionManager, but doesn’t consistently use the Timeout policy values for this, so the semantica are ambiguous.
There’s no policy that configures the idle timeout for downstream connections to the Gateway.

## Inbound timeouts

Currently, there is no policy to set inbound timeouts.
Timeouts on the inbound side have constant values:

```yaml
connectTimeout: 10s 
tcp:
  idleTimeout: 2h
http:
  requestTimeout: 0s
  idleTimeout: 2h
  streamIdleTimeout: 1h
  maxStreamDuration: 0s
```

If you still need to change inbound timeouts you can use a [ProxyTemplate](/docs/{{ page.version }}/policies/proxy-template):

{% tabs inbound-timeouts useUrlFragment=false %}
{% tab inbound-timeouts Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: ProxyTemplate
mesh: default
metadata:
  name: custom-template-1
spec:
  selectors:
    - match:
        kuma.io/service: '*'
  conf:
    imports:
      - default-proxy 
    modifications:
      - networkFilter:
          operation: patch
          match:
            name: envoy.filters.network.http_connection_manager
            origin: inbound 
          value: |
            name: envoy.filters.network.http_connection_manager
            typedConfig:
              '@type': type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
              streamIdleTimeout: 0s # disable http.streamIdleTimeout 
              common_http_protocol_options: 
                idle_timeout: 0s # disable http.idleTimeout
```
{% endtab %}

{% tab inbound-timeouts Universal %}
```yaml
type: ProxyTemplate
mesh: default
name: custom-template-1
selectors:
  - match:
      kuma.io/service: "*"
conf:
  imports:
    - default-proxy 
  modifications:
    - networkFilter:
        operation: patch
        match:
          name: envoy.filters.network.http_connection_manager
          origin: inbound 
        value: |
          name: envoy.filters.network.http_connection_manager
          typedConfig:
            '@type': type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
            streamIdleTimeout: 0s # disable http.streamIdleTimeout 
            common_http_protocol_options: 
              idle_timeout: 0s # disable http.idleTimeout
```
{% endtab %}
{% endtabs %}

{% warning %}
It's not recommended disabling `streamIdleTimeouts` and `idleTimeout`
since it has a high likelihood of yielding connection leaks.
{% endwarning %}
