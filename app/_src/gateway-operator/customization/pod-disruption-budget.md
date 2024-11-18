---
title: Defining PodDisruptionBudget for DataPlane
---

`DataPlane` resources can be configured with a `PodDisruptionBudget` to control:
- The number or percentage of pods that can be unavailable during maintenance (e.g. rollout).
- The number or percentage of pods that must be available during maintenance (e.g. rollout).

This is useful to ensure that a certain number or percentage of pods are always available.

See the [Specifying a Disruption Budget for your Application](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) guide
for more details on the `PodDisruptionBudget` API itself.

## Creating a DataPlane with PodDisruptionBudget

For `DataPlane` resources, you can define a `PodDisruptionBudget` in the `spec.resources.podDisruptionBudget` field.
The `DataPlane`'s `spec.resources.podDisruptionBudget.spec` matches the `PodDisruptionBudget` API, excluding
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
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
```

If you leave the `resources.podDisruptionBudget` field empty, {{ site.kgo_product_name }} will not create a
`PodDisruptionBudget` for the `DataPlane`.
