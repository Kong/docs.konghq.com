---
title: Requirements
---

This page expose the different requirements to run Kuma.

## Kubernetes

Kuma is validated against Kubernetes `1.19.x`, `1.20.x`, `1.21.x` and `1.22.x`.

## Envoy

Versions of envoy supported are: `~1.21.1` which means `>=1.21.1` and `<1.22.0`.

## Sizing your control-plane

In short, a control-plane with 4vCPU and 2GB of memory will be able to accommodate more than 1000 data planes.

While it's really hard to give a precise number, a good rule of thumb is to assign about 1MB of memory per data plane.
When it comes to CPUs Kuma handles parallelism extremely well (its architecture uses a lot of shared nothing go-routines) so more CPUs usually enable quicker propagation of changes.

That being said we highly recommend you to run your own load tests prior to going to production.
There are many ways to run workloads and deploy applications and while we test some of them, you are in the best place to build a realistic benchmark of what you do.

To see if you may need to increase your control-plane's spec, there are two main metrics to pay attention to:

- propagation time (xds_delivery): this is the time it takes between a change in the mesh and the dataplane receiving its updated configuration. Think about it as the "reactivity of your mesh".
- configuration generation time (xds_generation): this is the time it takes for the configuration to be generated.

For any large mesh using transparent-proxy it's highly recommended to use [reachable-services](/docs/{{ page.version }}/networking/transparent-proxying#reachable-services).

You can also find tuning configuration in the [fine-tuning](/docs/{{ page.version }}/documentation/fine-tuning) section of the docs.
