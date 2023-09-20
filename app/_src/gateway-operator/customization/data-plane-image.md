---
title: Customizing the Data Plane image
---

Customizing the image that you use for your `DataPlane` is one of the most common use cases.

## Using DataPlane

{:.note}
> This method is only available when running in [hybrid mode](/gateway-operator/{{ page.release }}/topologies/hybrid/)

The `DataPlane` resource uses the Kubernetes [PodTemplateSpec](/gateway-operator/{{ page.release }}/customization/pod-template-spec/) to define how pods should be run. If you need to customize the {{ site.base_gateway }} image being used, you can set `spec.deployment.podTemplateSpec.spec.containers[].name`:

```yaml
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-example
  namespace: kong
spec:
  deployment:
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
```

## Using GatewayConfiguration

{:.note}
> This method is only available when running in [DB-less mode](/gateway-operator/{{ page.release }}/topologies/dbless/)

The `GatewayConfiguration` resource is a Kong-specific API which allows you to set both `controlPlaneDeploymentOptions` and `dataPlaneDeploymentOptions`.

You can customize both the `containerImage` and `version`:

```yaml
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1alpha1
metadata:
  name: kong
  namespace: default
spec:
  controlPlaneDeploymentOptions:
    containerImage: kong/kubernetes-ingress-controller
    version: {{ site.data.kong_latest_KIC.version }}
  dataPlaneDeploymentOptions:
    containerImage: kong/kong
    version: {{ site.data.kong_latest_gateway.ee-version }}
```

To make your deployment use this configuration, reference it in your `GatewayClass` resource:

```yaml
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1beta1
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