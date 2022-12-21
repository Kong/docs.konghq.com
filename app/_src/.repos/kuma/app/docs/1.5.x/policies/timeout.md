---
title: Timeout
---

This policy enables Kuma to set timeouts on the outbound connections depending on the protocol.

## Usage

Specify the proxy to configure with the `sources` selector, and the outbound connections from the proxy with the `destinations` selector.

The policy lets you configure timeouts for `HTTP`, `GRPC`, and `TCP` protocols.

## Example

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Timeout
mesh: default
metadata:
  name: timeouts-backend
spec:
  sources:
    - match:
        kuma.io/service: '*'
  destinations:
    - match:
        kuma.io/service: 'backend_default_svc_80'
  conf:
    # connectTimeout defines time to establish connection, 'connect_timeout' on Cluster, default 10s
    connectTimeout: 10s
    tcp:
      # 'idle_timeout' on TCPProxy, disabled by default
      idleTimeout: 1h
    http:
      # 'timeout' on Route, disabled by default
      requestTimeout: 5s
      # 'idle_timeout' on Cluster, disabled by default
      idleTimeout: 1h
    grpc:
      # 'stream_idle_timeout' on HttpConnectionManager, disabled by default
      streamIdleTimeout: 5m
      # 'max_stream_duration' on Cluster, disabled by default
      maxStreamDuration: 30m
```
We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}
```yaml
type: Timeout
mesh: default
name: timeouts-backend
sources:
  - match:
      kuma.io/service: '*'
destinations:
  - match:
      kuma.io/service: 'backend'
conf:
  # connectTimeout defines time to establish connection, 'connect_timeout' on Cluster, default 10s
  connectTimeout: 10s
  tcp:
    # 'idle_timeout' on TCPProxy, disabled by default
    idleTimeout: 1h
  http:
    # 'timeout' on Route, disabled by default
    requestTimeout: 5s
    # 'idle_timeout' on Cluster, disabled by default
    idleTimeout: 1h
  grpc:
    # 'stream_idle_timeout' on HttpConnectionManager, disabled by default
    streamIdleTimeout: 5m
    # 'max_stream_duration' on Cluster, disabled by default
    maxStreamDuration: 30m
```
We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

## Matching

`Timeout` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
The only supported value for `destinations.match` is `kuma.io/service`.

## Builtin Gateway support

Timeouts are connection policies and are supported by configuring the timeout parameters on the target Envoy cluster.
Request timeouts are configured on the Envoy routes and may select a different Timeout policy when a route backend forwards to more than one distinct service.

Mesh configures an idle timeout on the HTTPConnectionManager, but doesn’t consistently use the Timeout policy values for this, so the semantica are ambiguous.
There’s no policy that configures the idle timeout for downstream connections to the Gateway.
