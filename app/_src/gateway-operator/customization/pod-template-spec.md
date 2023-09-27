---
title: Using PodTemplateSpec
---

The `DataPlane` resource uses the Kubernetes [PodTemplateSpec](/gateway-operator/{{ page.release }}/customization/pod-template-spec/) to define how pods should run. You can customize everything you need to in your deployment using this resource.

For more information see the [PodTemplateSpec documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).

Here are some examples for the most common use of `PodTemplateSpec`:

* [Customize the DataPlane image](/gateway-operator/{{ page.release }}/customization/data-plane-image/)
* [Deploy a sidecar container](/gateway-operator/{{ page.release }}/customization/sidecars/)

In addition, you can also customize:

* Volume mounts
* Node affinity / anti-affinity
* Service account used to run the Pod

If you need additional information about customizing your deployment, raise an issue in [Kong/gateway-operator-docs/](https://github.com/Kong/gateway-operator-docs/issues).