---
title: Gateway API
type: reference
purpose: |
  How Kong translate Gateway API concepts to Kong Gateway items
---

[Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. It expands on Ingress to configure
additional types of routes such as TCP, UDP, and TLS in addition to HTTP/HTTPS,
and to support backends other than Service, and manage the proxies that implement
routes.

Gateway API and Kong's implementation of Gateway API are both Generally Available for all users.

## Gateway management

A [Gateway resource](https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway)
describes an application or cluster feature that can handle Gateway API routing
rules, directing inbound traffic to Services by following the rules provided. For
Kong's implementation, a Gateway corresponds to a Kong Deployment managed by
the Ingress controller.

Typically, Gateway API implementations manage the resources associated with a
Gateway on behalf of users for creating a Gateway resource triggers automatic
provisioning of Deployments, Services, and others with configuration by matching the
Gateway's listeners and addresses. The Kong's implementation does _not_
automatically manage Gateway provisioning.

Because the Kong Deployment and its configuration are not managed
automatically, listener and address configuration are not set for you. You must
configure your Deployment and Service to match your Gateway's configuration.
For example, with this Gateway.

```
apiVersion: gateway.networking.k8s.io/v1
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
It requires a proxy Service that includes all the requested listener ports.

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
It also matches Kong `proxy_listen` configuration in the container environment.

```
KONG_PROXY_LISTEN="0.0.0.0:8000 reuseport backlog=16384, 0.0.0.0:8443 http2 ssl reuseport backlog=16384 http2"
KONG_STREAM_LISTEN="0.0.0.0:9901 reuseport backlog=16384, 0.0.0.0:9902 reuseport backlog=16384 udp", 0.0.0.0:9903 reuseport backlog=16384 ssl"
```

Both the Service and `proxy_listen` configuration are managed via [the Helm chart](https://github.com/Kong/charts/tree/main/charts/kong) using the `proxy` configuration block.

```yaml
proxy:
  http:
    enabled: true
    servicePort: 80
    containerPort: 8000

  tls:
    enabled: true
    servicePort: 443
    containerPort: 8443

  stream:
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

Ports missing appropriate Kong-side configuration results in an error
condition in the Gateway's status.

```text
message: no Kong listen with the requested protocol is configured for the
  requested port
reason: PortUnavailable
```

### Listener compatibility and handling multiple Gateways

Each {{ site.kic_product_name }} can only handle a single GatewayClass, and only one Gateway in that GatewayClass. Although the controller attempts to handle configuration from all Gateways in its GatewayClass, adding more than one Gateway is not yet supported and results in unexpected behavior.

If you wish to use multiple Gateways, define multiple GatewayClasses and create a separate {{ site.kic_product_name }}
Deployment for each.

### Binding {{site.base_gateway}} to a Gateway resource

To configure {{site.kic_product_name}} to reconcile the Gateway resource, you must set the `konghq.com/gatewayclass-unmanaged=true` annotation in your GatewayClass resource.

In addition, the `spec.controllerName` in your GatewayClass needs to be same as the value of the `--gateway-api-controller-name` flag (or `CONTROLLER_GATEWAY_API_CONTROLLER_NAME` environment variable) configured in {{site.kic_product_name}}. You should set `spec.controllerName=konghq.com/kic-gateway-controller` if using the default values. For more information, see [kic-flags](/kubernetes-ingress-controller/{{page.kong_version}}/reference/cli-arguments/#flags).

Finally, the `spec.gatewayClassName` value in your Gateway resource should match the value in `metadata.name` from your `GatewayClass`.

You can check to confirm if {{site.kic_product_name}} has updated the Gateway by inspecting the list of associated addresses. If an IP address is shown, the `Gateway` is being managed by Kong.

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
