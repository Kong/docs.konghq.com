---
title: Deploying a Gateway to Konnect
---

Gateways must be configured with `KIC` [`ControlPlane`s](/konnect/gateway-manager/#control-planes). This means that the `controlPlane` entity referenced (via KonnectID or NamespacedRef) by the `KonnectExtension` object must belong to that category.

{% include md/kgo/konnect-dataplanes-prerequisites.md disable_accordian=true version=page.version release=page.release is-kic-cp=true manual-secret-provisioning=false skip_install=true %}

## Create the GatewayConfiguration

In order to specify the `KonnectExtension` in `Gateway`'s configuration you need to create a `GatewayConfiguration` object which will hold the `KonnectExtension` reference.

```bash
echo '
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1beta1
metadata:
  name: kong
  namespace: default
spec:
  extensions:
  - kind: KonnectExtension
    name: my-konnect-config
    group: konnect.konghq.com ' | kubectl apply -f -
```

## Create the GatewayClass

Now you need to create a `GatewayClass` object that references the `GatewayConfiguration` object created in the previous step:

```bash
echo '
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
    namespace: default ' | kubectl apply -f -
```

## Create the Gateway

Finally you can create the `Gateway` object that references the `GatewayClass`:

```bash
echo '
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
    port: 80 ' | kubectl apply -f -
```

To verify, you can visit your Gateway Manager in {{ site.konnect_short_name }} and check if the dataplanes have been created successfully.
