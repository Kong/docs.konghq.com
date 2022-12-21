---
title: External Service
---

This policy allows services running inside the mesh to consume services that are not part of the mesh. The `ExternalService` resource allows you to declare specific external resources by name within the mesh, instead of implementing the default [passthrough mode](/docs/{{ page.version }}/policies/mesh/#controlling-the-passthrough-mode). Passthrough mode allows access to any non-mesh host by specifying its domain name or IP address, without the ability to apply any traffic policies. The `ExternalService` resource enables the same observability, security, and traffic manipulation for external traffic as for services entirely inside the mesh

When you enable this policy, you should also [disable passthrough mode](/docs/{{ page.version }}/policies/mesh/#controlling-the-passthrough-mode) for the mesh and enable the [data plane proxy builtin DNS](/docs/{{ page.version }}/networking/dns/#data-plane-proxy-built-in-dns) name resolution.

## Usage

A simple HTTPS external service can be defined:

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: ExternalService
mesh: default
metadata:
  namespace: default
  name: httpbin
spec:
  tags:
    kuma.io/service: httpbin
    kuma.io/protocol: http
  networking:
    address: httpbin.org:443
    tls:
      enabled: true
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
  kuma.io/protocol: http
networking:
  address: httpbin.org:443
  tls:
    enabled: true
```

Then apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](/docs/{{ page.version }}/documentation/http-api).

Universal mode is best combined with [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying/). For backward compatibility only, you can consume an external service from within the mesh by filling the proper `outbound` section of the relevant data plane resource:

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

Consuming the defined service from within the mesh for both Kubernetes and Universal deployments (assuming [transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying/)) can be done:

 * With the `.mesh` naming of the service `curl httpbin.mesh`. With this approach, specify port 80.
 * With the real name and port, in this case `curl httpbin.org:443`. This approach works only with [the data plane proxy builtin DNS](/docs/{{ page.version }}/networking/dns/#data-plane-proxy-built-in-dns) name resolution.

Although the external service is HTTPS, it's consumed as plain HTTP. This is possible because of `networking.tls.enbaled=true`.
To access the service over TLS, set the service protocol to `kuma.io/protocol: tcp` and `networking.tls.enbaled=false`, or else omit it entirely.

### Available policy fields

 * `tags` the external service can include an arbitrary number of tags, where `kuma.io/service` is mandatory. The special `kuma.io/protocol` tag is also taken into account and supports the standard Kuma protocol values. It designates the specific protocol for the service.
 * ` networking` describes the networking configuration of the external service 
   * `address` is the address where the external service can be reached.
   * `tls` is the section to configure the TLS originator when consuming the external service
     * `enabled` turns on and off the TLS origination. Defaults to `true`
     * `caCert` the CA certificate for the external service TLS verification
     * `clientCert` the client certificate for mTLS
     * `clientKey` the client key for mTLS
 
As with other services, avoid duplicating service names under `kuma.io/service` with already existing ones. A good practice is to derive the tag value from the domain name or IP of the actual external service.
