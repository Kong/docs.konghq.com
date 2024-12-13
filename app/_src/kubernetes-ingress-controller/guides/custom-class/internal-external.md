---
title: Using Custom Classes to split Internal/External traffic
---

{{ site.kic_product_name }} automatically creates a `kong` `IngressClass` when installed. All of the example ingress definitions in the documentation set `spec.ingressClassName: kong`, which allows things to work by default.

Advanced users of {{ site.kic_product_name }} may want to split traffic into internal and external ingress definitions. This requires multiple {{ site.kic_product_name }} instances, each pointing to a different `IngressClass`.

You can also split traffic into different gateways when you are using Gateway APIs with multiple {{ site.kic_product_name }} instances and multiple `Gateway`s.

## Understanding IngressClass

The `IngressClass` resource binds an `Ingress` definition to an ingress controller. The value in the `spec.controller` field defines which ingress controller will process those ingress definitions. {{ site.kic_product_name }} processes any `IngressClass` where `spec.controller` is set to `ingress-controllers.konghq.com/kong`.

You can use the following command to create `internal` and `external` ingress classes:

```bash
echo 'apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: internal
spec:
  controller: ingress-controllers.konghq.com/kong
---
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: external
spec:
  controller: ingress-controllers.konghq.com/kong' | kubectl apply -f -

```

## Creating Gateways

For splitting traffic into different gateways using the Kubernetes Gateway API, create two `Gateway`s in the Kubernetes cluster, where each is reconciled by one {{ site.kic_product_name }} instance:

```bash
echo 'apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: kong
  annotations:
    konghq.com/gatewayclass-unmanaged: "true"
spec:
  controllerName: konghq.com/kic-gateway-controller
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: kong
  namespace: internal
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: kong
  namespace: external
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80' | kubectl apply -f -
```

## Installing Kong

{{ site.kic_product_name }} processes one `IngressClass` per installation. {{ site.kic_product_name }} requires two deployments to split internal and external traffic.

Each deployment lives in its namespace, and the `controller.ingressController.ingressClass` value is set depending on whether that deployment should handle internal or external traffic.

You can split traffic into different `Gateway`s in the Kubernetes Gateway APIs by using the environment variable `CONTROLLER_GATEWAY_TO_RECONCILE`. Configure the variable to instruct {{ site.kic_product_name }} to reconcile specific `Gateway` instances and routes attached to the gateway:

```bash
helm upgrade --install kong-internal kong/ingress -n internal --create-namespace --set controller.ingressController.ingressClass=internal --set controller.ingressController.env.gateway_to_reconcile=internal/kong
helm upgrade --install kong-external kong/ingress -n external --create-namespace --set controller.ingressController.ingressClass=external --set controller.ingressController.env.gateway_to_reconcile=external/kong
```

## Creating Routes

Rather than setting `spec.ingressClassName: kong` in your `Ingress` definitions, you should now use either `internal` or `external`. Ingress definitions that target `internal` will only be available via {{ site.base_gateway }} running in the `internal` namespace. Definitions that target `external` will only be available via the `external` gateway.

For routes in Kubernetes Gateway APIs (like `HTTPRoute`), refer to the corresponding `Gateway` in its `spec.parentRef`.

For example, this is how you can create a `Ingress` or `HTTPRoute` for routing internal traffic:

{% include /md/kic/http-test-routing-resource.md release=page.release path='/echo' name='echo-internal' service='echo' namespace='internal' ingress_class='internal' skip_host=true no_results=true %}
