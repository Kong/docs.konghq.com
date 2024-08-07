---
title: Defining PodDisruptionBudget for DataPlane
---

`DataPlane` resources can be configured with a `PodDisruptionBudget` to control the number of pods that can be unavailable
during maintenance. This is useful when you want to ensure that a certain number of pods are always available. See the
[Specifying a Disruption Budget for your Application](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) guide
for more details on `PodDisruptionBudget` API itself.

## Creating DataPlane with PodDisruptionBudget

For `DataPlane` resources, you can define a `PodDisruptionBudget` in the `spec.resources.podDisruptionBudget` field.
`DataPlane`'s `spec.resources.podDisruptionBudget.spec` matches the `PodDisruptionBudget` API, excluding
the `selector` field, which is automatically set by {{ site.kgo_product_name }} to match the `DataPlane` pods.

Here is an example of a `DataPlane` resource with a `PodDisruptionBudget`:

```yaml
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-with-pdb
spec:
  resources:
    podDisruptionBudget:
      spec:
        maxUnavailable: 1
  deployment:
    replicas: 3
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:3.7
```

If you leave the `resources.podDisruptionBudget` field empty, {{ site.kgo_product_name }} will not create a
`PodDisruptionBudget` for the `DataPlane`.
