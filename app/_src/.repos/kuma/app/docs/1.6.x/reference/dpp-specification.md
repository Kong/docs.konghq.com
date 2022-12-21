---
title: Data plane proxy specification
---

The [`Dataplane`](/docs/{{ page.version }}/explore/dpp#dataplane-entity) entity includes the networking and naming configuration that a data-plane proxy (`kuma-dp`) must have attempting to connect to the control-plane (`kuma-cp`).

This specification is useful mostly in Universal and for troubleshooting as on Kubernetes Kuma-cp will generate it for you.

The `Dataplane` entity includes a few sections:

* `type`: must be `Dataplane`.
* `mesh`: the `Mesh` name we want to associate the data-plane with.
* `name`: this is the name of the data-plane instance, and it must be **unique** for any given `Mesh`. We might have multiple instances of a Service, and therefore multiple instances of the sidecar data-plane proxy. Each one of those sidecar proxy instances must have a unique `name`.
* `networking`: this is the meaty part of the configuration. It determines the behavior of the data-plane on incoming (`inbound`) and outgoing (`outbound`) requests.
    * `address` IP address or domain name at which this dataplane will be accessible to other data plane proxies. Domain name will be resolved to IP in the control plane.
    * `advertisedAddress`: In some situation, dataplane resides in a private network and not reachable via `address`. `advertisedAddress` is configured with public routable address for such dataplane so that other dataplanes in the mesh can connect to it over `advertisedAddress` and not via `address` Note: Envoy binds to the `address` not `advertisedAddress`
    * `inbound`: an array of objects that determines what services are being exposed via the data-plane. Each object only supports one port at a time, and you can specify more than one objects in case the service opens up more than one port.
        * `port`: determines the port at which other data plane proxies will consume the service
        * `serviceAddress`: IP at which the service is listening. Defaults to `127.0.0.1`. Typical usecase is Universal mode, where `kuma-dp` runs ina  separate netns, container or host than the service.
        * `servicePort`: determines the port of the service deployed next to the dataplane. This can be omitted if service is exposed on the same port as the dataplane, but only listening on `serviceAddress` or `127.0.0.1` and differs from `networking.address`.
        * `address`: IP at which inbound listener will be exposed. By default it is inherited from `networking.address`
        * `tags`: each data-plane can include any arbitrary number of tags, with the only requirement that `kuma.io/service` is **mandatory** and it identifies the name of service. You can include tags like `version`, `cloud`, `region`, and so on to give more attributes to the `Dataplane` (attributes that can later on be used to apply policies).
    * `gateway`: determines if the data-plane will operate in [Gateway](/docs/{{ page.version }}/explore/gateway) mode. It replaces the `inbound` object and enables Kuma to integrate with existing API gateways like [Kong](https://github.com/Kong/kong).
        * `type`: Type of gateway this dataplane manages. The default is a DELEGATED gateway, which is an external proxy. The BUILTIN gateway type causes the dataplane proxy itself to be configured as a gateway.
        * `tags`: each data-plane can include any arbitrary number of tags, with the only requirement that `kuma.io/service` is **mandatory** and it identifies the name of service. You can include tags like `version`, `cloud`, `region`, and so on to give more attributes to the `Dataplane` (attributes that can later on be used to apply policies).
    * `outbound`: every outgoing request made by the service must also go thorugh the DP. This object specifies ports that the DP will have to listen to when accepting outgoing requests by the service:
        * `port`: the port that the service needs to consume locally to make a request to the external service
        * `address`: the IP at which outbound listener is exposed. By default it is `127.0.0.1` since it should only be consumed by the app deployed next to the dataplane.
        * `tags`: traffic on `port:address` will be sent to each data-plane that matches those tags. You can put many tags here. However, it is recommended to keep the list short and then use [`TrafficRoute`](/docs/{{ page.version }}/policies/traffic-route) for dynamic management of the traffic.
    * `admin`: determines parameters related to Envoy Admin API
        * `port`: the port that Envoy Admin API will listen to

For example:

```yaml
type: Dataplane
mesh: default
name: {{ name }}
networking:
  address: {{ address }}
  inbound:
  - port: 8000
    servicePort: 80
    tags:
      kuma.io/service: backend
      kuma.io/protocol: http
  outbound:
  - port: 10000
    tags:
      kuma.io/service: redis
```
