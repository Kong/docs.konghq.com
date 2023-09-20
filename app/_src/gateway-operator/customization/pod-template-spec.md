---
title: Using PodTemplateSpec
---

The `DataPlane` resource uses the Kubernetes [PodTemplateSpec](/gateway-operator/{{ page.release }}/customization/pod-template-spec/) to define how pods should be run. This allows you to customize everything you need to in your deployment.

For detailed documentation see the [PodTemplateSpec documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) on the Kubernetes docs.

We have dedicated examples for the most common applications of `PodTemplateSpec`:

* [Customize the DataPlane image](/gateway-operator/{{ page.release }}/customization/data-plane-image/)
* [Deploy a sidecar container](/gateway-operator/{{ page.release }}/customization/sidecars/)

You might also want to customize the following:

* Volume mounts
* Node affinity / anti-affinity
* Service account used to run the pod

If you need help customizing your deployment, please raise an issue in [Kong/gateway-operator-docs/](https://github.com/Kong/gateway-operator-docs/issues).