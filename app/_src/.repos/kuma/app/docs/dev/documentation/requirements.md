---
title: Requirements
---

This page expose the different requirements to run {{site.mesh_product_name}}.

## Architecture

{{site.mesh_product_name}} supports machines with `x86_64` architecture and since `1.7.0` it's possible to run {{site.mesh_product_name}} on `arm64`.

## Kubernetes

{{site.mesh_product_name}} is validated against Kubernetes `1.19.x`, `1.20.x`, `1.21.x` and `1.22.x`.

## Envoy

Versions of envoy supported are: `~1.22.0` which means `>=1.22.0` and `<1.23.0`.

## Sizing your control-plane

In short, a control-plane with 4vCPU and 2GB of memory will be able to accommodate more than 1000 data planes.

While it's really hard to give a precise number, a good rule of thumb is to assign about 1MB of memory per data plane.
When it comes to CPUs {{site.mesh_product_name}} handles parallelism extremely well (its architecture uses a lot of shared nothing go-routines) so more CPUs usually enable quicker propagation of changes.

That being said we highly recommend you to run your own load tests prior to going to production.
There are many ways to run workloads and deploy applications and while we test some of them, you are in the best place to build a realistic benchmark of what you do.

To see if you may need to increase your control-plane's spec, there are two main metrics to pay attention to:

- propagation time (xds_delivery): this is the time it takes between a change in the mesh and the dataplane receiving its updated configuration. Think about it as the "reactivity of your mesh".
- configuration generation time (xds_generation): this is the time it takes for the configuration to be generated.

For any large mesh using transparent-proxy it's highly recommended to use [reachable-services](/docs/{{ page.version }}/networking/transparent-proxying#reachable-services).

You can also find tuning configuration in the [fine-tuning](/docs/{{ page.version }}/documentation/fine-tuning) section of the docs.

## Sizing your sidecar container on Kubernetes

When deploying Kuma on Kubernetes, the sidecar is deployed as a separate container, `kuma-sidecar`, in your `Pods`. By default it has the following resource requests and limits:

```yaml
resources:
    requests:
        cpu: 50m
        memory: 64Mi
    limits:
        cpu: 500m
        memory: 512Mi
```

This configuration should be enough for most use cases. In some cases, like when you cannot scale horizontally or your service handles lots of concurrent traffic, you may need to change these values. You can do this using the [`ContainerPatch` resource](/docs/{{ page.version }}/explore/dpp-on-kubernetes/#custom-container-configuration). 

For example, you can modify individual parameters under `resources`:

```yaml
apiVersion: kuma.io/v1alpha1
kind: ContainerPatch
metadata:
  name: container-patch-1
  namespace: kuma-system
spec:
  sidecarPatch:
    - op: add
      path: /resources/requests/cpu
      value: '"1"'
```

you could modify the entire `limits`, `request` or `resources` sections:

```yaml
apiVersion: kuma.io/v1alpha1
kind: ContainerPatch
metadata:
  name: container-patch-1
  namespace: kuma-system
spec:
  sidecarPatch:
    - op: add
      path: /resources/limits
      value: '{
        "cpu": "1",
        "memory": "1G"
      }'
```

Check [the `ContainerPatch` documentation](/docs/{{ page.version }}/explore/dpp-on-kubernetes/#workload-matching) for how to apply these resources to specific `Pods`.

{% tip %}
**Note**: When changing these resources, remember that they must be described using [Kubernetes resource units](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes)
{% endtip %} 
