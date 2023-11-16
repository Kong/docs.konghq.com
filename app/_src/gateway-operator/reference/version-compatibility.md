---
title: Version Compatibility
---

## {{ site.kic_product_name }}

The following table presents the general compatibility of {{site.kgo_product_name}} with {{ site.kic_product_name }} minor versions.

## Kubernetes

| {{site.kgo_product_name}}        |            1.0.x            |
|:---------------------------------|:---------------------------:|
| {{ site.kic_product_name }} 2.11 | <i class="fa fa-check"></i> |
| {{ site.kic_product_name }} 2.12 | <i class="fa fa-check"></i> |

### General

The following table presents the general compatibility of {{site.kgo_product_name}} with specific Kubernetes versions.
Users should expect all the combinations marked with <i class="fa fa-check"></i> to work and to be supported.

| {{site.kgo_product_name}} |            1.0.x            |
|:--------------------------|:---------------------------:|
| Kubernetes 1.25           | <i class="fa fa-check"></i> |
| Kubernetes 1.26           | <i class="fa fa-check"></i> |
| Kubernetes 1.27           | <i class="fa fa-check"></i> |
| Kubernetes 1.28           | <i class="fa fa-check"></i> |

### Gateway API

The following table presents the compatibility of {{site.kgo_product_name}} with specific [Gateway API][gateway-api] versions.
As {{site.kgo_product_name}} implements Gateway API features using the upstream
project, which defines [its own compatibility declarations][gateway-api-supported-versions], the expected compatibility
of Gateway API features might be limited to those.

| {{site.kgo_product_name}} |            1.0.x            |
|:--------------------------|:---------------------------:|
| Gateway API 1.0.0         | <i class="fa fa-times"></i> |
| Gateway API 0.8.1         | <i class="fa fa-check"></i> |

[gateway-api]: https://github.com/kubernetes-sigs/gateway-api
[gateway-api-supported-versions]:https://gateway-api.sigs.k8s.io/concepts/versioning/#supported-versions
