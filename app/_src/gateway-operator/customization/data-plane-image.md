---
title: Customizing the Data Plane image
---

You can customize the image of your `DataPlane` using  the `DataPlane` resource or the `GatewayConfiguration` CRD .

## Using DataPlane

{:.note}
> This method is only available when running in [hybrid mode](/gateway-operator/{{ page.release }}/topologies/hybrid/)

The `DataPlane` resource uses the Kubernetes [PodTemplateSpec](/gateway-operator/{{ page.release }}/customization/pod-template-spec/) to define how the Pods should run. Set the`spec.deployment.podTemplateSpec.spec.containers[].image` to customize the {{ site.base_gateway }} image.

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

You can customize both the container image and version.
1.  Define the image in the `GatewayConfiguration`.
    ```yaml
    kind: GatewayConfiguration
    apiVersion: gateway-operator.konghq.com/v1alpha1
    metadata:
      name: kong
      namespace: default
    spec:
      dataPlaneOptions:
        deployment:
          podTemplateSpec:
            spec:
              containers:
              - name: proxy
                image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
      controlPlaneOptions:
        deployment:
          podTemplateSpec:
            spec:
              containers:
              - name: controller
                image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
    ```

1.  Reference this configuration in the `GatewayClass` resource for the deployment.

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