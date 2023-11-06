---
title: Kubernetes runtimes
type: reference
purpose: |
  Provide information on supported k8s versions and how we decide what to support for example, cloud vendor lifetimes
---

## Kubernetes

### General

The following table presents the general compatibility of {{site.kic_product_name}} with specific Kubernetes versions.
Users should expect all the combinations marked with <i class="fa fa-check"></i> to work and to be supported.

| {{site.kic_product_name}} |            2.6.x            |            2.7.x            |            2.8.x            |            2.9.x            |            2.10.x           |           2.11.x            |           2.12.x            |          3.0.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Kubernetes 1.16           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.17           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.18           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.19           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.20           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.21           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.22           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.23           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.24           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.25           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.26           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.27           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.28           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

{:.note}
> In Kubernetes version 1.24 [CRD Validating Expressions](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation-rules) is disabled by default and hence `KongUpstreamPolicy` validations is limited.

