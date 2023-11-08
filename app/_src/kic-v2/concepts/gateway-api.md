---
title: Gateway API
---

[Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. It expands on Ingress to configure
additional types of routes (TCP, UDP, and TLS in addition to HTTP/HTTPS),
support backends other than Service, and manage the proxies that implement
routes.

Gateway API and Kong's implementation of Gateway API are both under active
development. Features and implementation specifics will change before their
initial general availability release.

## Gateway management

A [Gateway resource](https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway)
describes an application or cluster feature that can handle Gateway API routing
rules, directing inbound traffic to Services following the rules provided. For
Kong's implementation, a Gateway corresponds to a Kong Deployment managed by
the ingress controller.

Typically, Gateway API implementations manage the resources associated with a
Gateway on behalf of users: creating a Gateway resource will trigger automatic
provisioning of Deployments/Services/etc. with configuration matching the
Gateway's listeners and addresses. The Kong alpha implementation does _not_
automatically manage Gateway provisioning: you must create the Kong and ingress
controller Deployment and proxy Service yourself following the [Gateway installation guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-gateway-api/).

Because the Kong Deployment and its configuration are not managed
automatically, listener and address configuration are not set for you. You must
configure your Deployment and Service to match your Gateway's configuration.
For example, with this Gateway:

```
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: example
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
  - name: proxy-ssl
    port: 443
    protocol: HTTPS
  - name: proxy-tcp-9901
    port: 9901
    protocol: TCP
  - name: proxy-udp-9902
    port: 9902
    protocol: UDP
  - name: proxy-tls-9903
    port: 9903
    protocol: TLS
```
requires a proxy Service that includes all the requested listener ports:

```
apiVersion: v1
kind: Service
metadata:
  name: proxy
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8000
  - port: 443
    protocol: TCP
    targetPort: 8443
  - port: 9901
    protocol: TCP
    targetPort: 9901
  - port: 9902
    protocol: UDP
    targetPort: 9902
  - port: 9903
    protocol: TCP
    targetPort: 9903
```
and matching Kong `proxy_listen` configuration in the container environment:

```
KONG_PROXY_LISTEN="0.0.0.0:8000 reuseport backlog=16384, 0.0.0.0:8443 http2 ssl reuseport backlog=16384 http2"
KONG_STREAM_LISTEN="0.0.0.0:9901 reuseport backlog=16384, 0.0.0.0:9902 reuseport backlog=16384 udp", 0.0.0.0:9903 reuseport backlog=16384 ssl"
```

[The Helm chart](https://github.com/Kong/charts/tree/main/charts/kong) manages
both of these from the `proxy` configuration block:

```
proxy:
  http:
    enabled: true
    servicePort: 80
    containerPort: 8000

  tls:
    enabled: true
    servicePort: 443
    containerPort: 8443

  stream: []
    - containerPort: 9901
      servicePort: 9901
      protocol: TCP
    - containerPort: 9902
      servicePort: 9902
      protocol: UDP
    - containerPort: 9903
      servicePort: 9903
      protocol: TCP
      parameters:
        - "ssl"
```

Ports missing appropriate Kong-side configuration will result in an error
condition in the Gateway's status:

```
message: no Kong listen with the requested protocol is configured for the
  requested port
reason: PortUnavailable
```

### Listener compatibility and handling multiple Gateways

During the alpha, without automatic Gateway Deployment provisioning, Kong's
implementation can only handle a single GatewayClass, and only one Gateway in
that GatewayClass. Although the controller will attempt to handle configuration
from all Gateways in its GatewayClass, adding more than one Gateway is not yet
supported and will likely result in unexpected behavior. If you wish to use
multiple Gateways, define multiple GatewayClasses and install a separate
Deployment for each.

For background, Gateway API allows implementations to collapse compatible
listens and Gateways:

> An implementation MAY group Listeners by Port and then collapse each group of
> Listeners into a single Listener if the implementation determines that the
> Listeners in the group are “compatible”. An implementation MAY also group
> together and collapse compatible Listeners belonging to different Gateways.

Compatibility means that listeners can coexist: for example, two HTTP listens
can coexist on the same port because Gateways can still route inbound requests
using the HTTP `Host` header, whereas two TCP listens cannot coexist on the
same port because the port is the only characteristic that can select between
TCP routes.

If there is a conflict between listeners on a Gateway, the controller will mark
the conflict in the Gateway status and not add routes that require the
conflicting listener. The controller cannot, however, perform these same
validity checks across separate Gateway resources.

### Binding {{site.base_gateway}} to a Gateway resource

{% if_version lte: 2.5.x %}
Because {{site.kic_product_name}} and {{site.base_gateway}} instances are
installed independent of their Gateway resource, we set the
`konghq.com/gateway-unmanaged` annotation to the `NAMESPACE/NAME` of the
Kong proxy Service. This instructs KIC to populate that {{site.base_gateway}}
resource with listener and status information.
{% endif_version %}

{% if_version gte:2.6.x %}
To configure KIC to reconcile the Gateway resource, you must set the 
`konghq.com/gatewayclass-unmanaged` annotation as the example in GatewayClass resource used in 
`spec.gatewayClassName` in Gateway resource. Also, the 
`spec.controllerName` of GatewayClass needs to be same as the value of the
`--gateway-api-controller-name` flag configured in KIC. For more information, see [kic-flags](/kubernetes-ingress-controller/{{page.kong_version}}/references/cli-arguments/#flags).
{% endif_version %}

You can check to confirm if KIC has updated the bound Gateway by 
inspecting the list of associated addresses:

```bash
kubectl get gateway kong -o=jsonpath='{.status.addresses}' | jq
```

```
[
  {
    "type": "IPAddress",
    "value": "10.96.179.122"
  },
  {
    "type": "IPAddress",
    "value": "172.18.0.240"
  }
]
```
