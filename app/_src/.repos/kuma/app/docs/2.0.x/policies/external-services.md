---
title: External Service
---

This policy allows services running inside the mesh to consume services that are not part of the mesh. The `ExternalService` resource allows you to declare specific external resources by name within the mesh, instead of implementing the default [passthrough mode](/docs/{{ page.version }}/policies/mesh#controlling-the-passthrough-mode). Passthrough mode allows access to any non-mesh host by specifying its domain name or IP address, without the ability to apply any traffic policies. The `ExternalService` resource enables the same observability, security, and traffic manipulation for external traffic as for services entirely inside the mesh

When you enable this policy, you should also [disable passthrough mode](/docs/{{ page.version }}/policies/mesh#controlling-the-passthrough-mode) for the mesh and enable the [data plane proxy builtin DNS](/docs/{{ page.version }}/networking/dns) name resolution.

## Usage

Simple configuration of external service requires `name` of the resource, `kuma.io/service: service-name`, and `address`. By default, a protocol used for communication is `TCP`. It's possible to change that by configuring `kuma.io/protocol` tag. Apart from that, it's possible to define TLS configuration used for communication with external services. More information about configuration options can be found [here](#available-policy-fields).

Below is an example of simple HTTPS external service:

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: ExternalService
mesh: default
metadata:
  name: httpbin
spec:
  tags:
    kuma.io/service: httpbin
    kuma.io/protocol: http # optional, one of http, http2, tcp, grpc, kafka
  networking:
    address: httpbin.org:443
    tls: # optional
      enabled: true
      allowRenegotiation: false
      sni: httpbin.org # optional
      caCert: # one of inline, inlineString, secret
        inline: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t... # Base64 encoded cert
      clientCert: # one of inline, inlineString, secret
        secret: clientCert
      clientKey: # one of inline, inlineString, secret
        secret: clientKey
```

Then apply the configuration with `kubectl apply -f [..]`.

{% endtab %}

{% tab usage Universal %}
```yaml
type: ExternalService
mesh: default
name: httpbin
tags:
  kuma.io/service: httpbin
  kuma.io/protocol: http # optional, one of http, http2, tcp, grpc, kafka
networking:
  address: httpbin.org:443
  tls:
    enabled: true
    allowRenegotiation: false
    sni: httpbin.org # optional
    caCert: # one of inline, inlineString, secret
      inline: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t... # Base64 encoded cert
    clientCert: # one of inline, inlineString, secret
      secret: clientCert
    clientKey: # one of inline, inlineString, secret
      secret: clientKey
```

Then apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](/docs/{{ page.version }}/reference/http-api).

Universal mode is best combined with [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying). For backward compatibility only, you can consume an external service from within the mesh by filling the proper `outbound` section of the relevant data plane resource:

```yaml
type: Dataplane
mesh: default
name: redis-dp
networking:
  address: 127.0.0.1
  inbound:
  - port: 9000
    tags:
      kuma.io/service: redis
  outbound:
  - port: 10000
    tags:
      kuma.io/service: httpbin
```

Then `httpbin.org` is accessible at `127.0.0.1:10000`.

{% endtab %}
{% endtabs %}

### Accessing the External Service

Consuming the defined service from within the mesh for both Kubernetes and Universal deployments (assuming [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying)) can be done:

* With the `.mesh` naming of the service `curl httpbin.mesh`. With this approach, specify port 80.
* With the real name and port, in this case `curl httpbin.org:443`. This approach works only with [the data plane proxy builtin DNS](/docs/{{ page.version }}/networking/dns) name resolution.

It's possible to define TLS origination and validation at 2 different layers:
*  Envoy is responsible for originating and verifying TLS.
*  Application itself is responsible for originating and verifying TLS and Envoy is just passing the connection to a proper destination.
 
In the first case, the external service is defined as HTTPS, but it's consumed as plain HTTP. This is possible because when `networking.tls.enabled` is set to `true` then Envoy is responsible for originating and verifying TLS.
 
The second approach allows consuming the service using HTTPS. It's possible when `kuma.io/protocol: tcp` and `networking.tls.enabled=false` are set in the configuration of the external service.

The first approach has an advantage that we can apply HTTP based policies, because Envoy is aware of HTTP protocol and can apply request modifications before the request is encrypted. Additionally, we can modify TLS certificates without restarting applications.

### Available policy fields

* `tags` the external service can include an arbitrary number of tags, where:
  *  `kuma.io/service` is mandatory.
  *  `kuma.io/protocol` tag is also taken into account and supports the standard {{site.mesh_product_name}} protocol values. It designates the specific protocol for the service (one of: `http`, `https`, `tcp`, `grpc`, `kafka`, default: `tcp`).
  *  `kuma.io/zone` tag is taken into account when [`locality aware load balancing`](#external-services-and-locality-aware-load-balancing) is enabled or external service should be [accessible only from the specific zone](#external-services-accessible-from-specific-zone-through-zoneegress).
* ` networking` describes the networking configuration of the external service:
    * `address` is the address where the external service can be reached.
    * `tls` is the section to configure the TLS originator when consuming the external service:
        * `enabled` turns on and off the TLS origination.
        * `allowRenegotiation` turns on and off TLS renegotiation. It's not recommended enabling this for [security reasons](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/transport_sockets/tls/v3/tls.proto).
          However, some servers require this setting to fetch client certificate after TLS handshake. TLS renegotiation is not available in TLS v1.3.
        * `sni` overrides the default Server Name Indication. Set this value to empty string to disable SNI.
        * `caCert` the CA certificate for the external service TLS verification.
        * `clientCert` the client certificate for mTLS.
        * `clientKey` the client key for mTLS.

As with other services, avoid duplicating service names under `kuma.io/service` with already existing ones. A good practice is to derive the tag value from the domain name or IP of the actual external service.

### External Services and Locality Aware Load Balancing

There are might be scenarios when a particular external service should be accessible only from the particular zone. 
In order to make it work we should use `kuma.io/zone` tag for external service. When this tag is set and [locality aware load balancing](/docs/{{ page.version }}/policies/locality-aware) is enabled
then the traffic from the zone will be redirected only to external services associated with the zone using `kuma.io/zone` tag.

Example:

```yaml
type: ExternalService
mesh: default
name: httpbin-for-zone-1
tags:
  kuma.io/service: httpbin
  kuma.io/protocol: http
  kuma.io/zone: zone-1
networking:
  address: zone-1.httpbin.org:80
---
type: ExternalService
mesh: default
name: httpbin-for-zone-2
tags:
  kuma.io/service: httpbin
  kuma.io/protocol: http
  kuma.io/zone: zone-2
networking:
  address: zone-2.httpbin.org:80
```

In this example, when [locality aware load balancing](/docs/{{ page.version }}/policies/locality-aware) is enabled, if the service in zone-1 is trying to set connection with
`httpbin.mesh` it will be redirected to `zone-1.httpbin.org:80`. Whereas the same request from zone-2 will be redirected to `zone-2.httpbin.org:80`.

### External Services and ZoneEgress

In scenarios when traffic to external services needs to be sent through a unique set of hosts you will [configure ZoneEgress](/docs/{{ page.version }}/explore/zoneegress).

For example when there is:
* [disabled passthrough mode](/docs/{{ page.version }}/policies/mesh#controlling-the-passthrough-mode)
* `ZoneEgress` deployed
* `ExternalService` configuration that allows communicating with `https://example.com`.
```yaml
type: ExternalService
mesh: default
name: example
tags:
  kuma.io/service: example
  kuma.io/protocol: tcp
networking:
  address: example.com:443
  tls:
    enabled: false
```

When application makes a request to `https://example.com`, it will be first routed to `ZoneEgress` and then to `https://example.com`.
You can completely block your instances to communicate to things outside the mesh by [disabling passthrough mode](/docs/{{ page.version }}/policies/mesh#controlling-the-passthrough-mode).
In this setup, applications will only be able to communicate with other applications in the mesh or external-services via the `ZoneEgress`.

### External Services accessible from specific zone through ZoneEgress

There are might be scenarios when a specific `ExternalService` might be accessible only through the specific zone. To make it work we should use the `kuma.io/zone` tag for external service. In order to make it work, we need a multi-zone setup with `ZoneIngress` and `ZoneEgress` deployed. Also,
[zone egress](/docs/{{ page.version }}/explore/zoneegress#configuration) needs to be enabled.
 
Example:
 
```yaml
type: ExternalService
mesh: default
name: httpbin-only-in-zone-2
tags:
 kuma.io/service: httpbin
 kuma.io/protocol: http
 kuma.io/zone: zone-2
networking:
 address: httpbin.org:80
```
 
In this example, when all the conditions mentioned above are fulfilled if the service in `zone-1` is trying to set a connection with
`httpbin.mesh` it will be redirected to the `ZoneEgress` instance within the `zone-1`. Next, this request goes to the `ZoneIngress` instance in `zone-2` which redirects it to the `ZoneEgress` cluster instance from where it goes outside to the `ExternalService`.

## Builtin Gateway support

{{site.mesh_product_name}} Gateway fully supports external services.
Note that mesh Dataplanes can be configured with the same `kuma.io/service` tag as an external service resource.
In this scenario, {{site.mesh_product_name}} Gateway will prefer the ExternalService and not route any traffic to the Dataplanes.
Note that before gateway becomes generally available this behaviour will change to be the same as for any other dataplanes.
