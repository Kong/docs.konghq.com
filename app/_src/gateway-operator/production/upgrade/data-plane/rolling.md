---
title: Rolling Upgrades
---

The `GatewayConfiguration` API can be used to provide the image and the image version desired for either the `ControlPlane` or `DataPlane` component of the `Gateway` e.g.:

```yaml
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1alpha1
metadata:
  name: kong
  namespace: default
spec:
  dataPlaneDeploymentOptions:
    containerImage: kong/kong
    version: 2.7.0
  controlPlaneDeploymentOptions:
    containerImage: kong/kubernetes-ingress-controller
    version: 2.4.2
```

The above configuration will deploy all `DataPlane` resources connected to the
`GatewayConfiguration` (by way of `GatewayClass`) using `kong/kong:2.7.0` and any `ControlPlane` will be deployed with `kong/kubernetes-ingress-controller:2.4.2`.

Given the above, a manual upgrade or downgrade can be performed simply by changing the version.
For example: assuming that at least one `Gateway` is currently deployed and running using the above `GatewayConfiguration`, an upgrade could be performed by running the following:

```bash
kubectl edit gatewayconfiguration kong
```

And updating the `dataPlaneDeploymentOptions.version` to `3.1.1`.
The result will be a replacement `Pod` will roll out with the new version and once healthy the old `Pod` will be terminated.