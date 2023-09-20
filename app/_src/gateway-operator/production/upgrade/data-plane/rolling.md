---
title: Rolling Upgrades
---

## Using DataPlane

{:.note}
> This method is only available when running in [hybrid mode](/gateway-operator/{{ page.release }}/topologies/hybrid/)

To change the image used for your `DataPlane` resources, set the `spec.deployment.podTemplateSpec.spec.containers[].name` field in your resource:

```bash
kubectl edit dataplane dataplane-example
```

Once the resource is saved, Kubernetes will perform a rolling upgrade of your pods.

## Using GatewayConfiguration

{:.note}
> This method is only available when running in [DB-less mode](/gateway-operator/{{ page.release }}/topologies/dbless/)

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
    version: {{ site.data.kong_latest_gateway.ee-version }}
  controlPlaneDeploymentOptions:
    containerImage: kong/kubernetes-ingress-controller
    version: {{ site.data.kong_latest_KIC.version }}
```

The above configuration will deploy all `DataPlane` resources connected to the
`GatewayConfiguration` (by way of `GatewayClass`) using `kong/kong:{{ site.data.kong_latest_gateway.ee-version }}` and any `ControlPlane` will be deployed with `kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}`.

Given the above, a manual upgrade or downgrade can be performed simply by changing the version.
For example: assuming that at least one `Gateway` is currently deployed and running using the above `GatewayConfiguration`, an upgrade could be performed by running the following:

```bash
kubectl edit gatewayconfiguration kong
```

And updating the `dataPlaneDeploymentOptions.version` to `3.3.0`.
The result will be a replacement `Pod` will roll out with the 9od version and once healthy the old `Pod` will be terminated.