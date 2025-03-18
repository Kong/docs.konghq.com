---
title: Deploying a Gateway to konnect
---

Gateways must be configured with `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `ControlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to that category.

## Create the KonnectExtension

{% include md/kgo/secret-provisioning-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=true %}

## Create the GatewayConfiguration

TODO: add description

```yaml
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1beta1
metadata:
  name: kong
  namespace: default
spec:
  extensions:
  - kind: KonnectExtension
    name: my-konnect-config
    group: konnect.konghq.com
```

## Create the GatewayClass

TODO: add description

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: kong
spec:
  controllerName: konghq.com/gateway-operator
  parametersRef:
    group: gateway-operator.konghq.com
    kind: GatewayConfiguration
    name: kong
    namespace: default
```

## Create the Gateway

TODO: add description

```yaml
kind: Gateway
apiVersion: gateway.networking.k8s.io/v1
metadata:
  name: kong
  namespace: default
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80
```
