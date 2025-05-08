---
title: Version Compatibility
---

## {{ site.kic_product_name }}

The following table presents the general compatibility of {{site.kgo_product_name}} with {{ site.kic_product_name }} minor versions.

## Kubernetes

| {{site.kgo_product_name}}        |            1.0.x            |            1.1.x            |            1.2.x            |            1.3.x            |            1.4.x            |            1.5.x            |            1.6.x            |
|:---------------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| {{ site.kic_product_name }} 2.11 | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| {{ site.kic_product_name }} 2.12 | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| {{ site.kic_product_name }} 3.0  | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| {{ site.kic_product_name }} 3.1  | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{ site.kic_product_name }} 3.2  | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{ site.kic_product_name }} 3.3  | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{ site.kic_product_name }} 3.4  | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

### General

The following table presents the general compatibility of {{site.kgo_product_name}} with specific Kubernetes versions.
Users should expect all the combinations marked with <i class="fa fa-check"></i> to work and to be supported.

| {{site.kgo_product_name}} |            1.0.x            |            1.1.x            |            1.2.x            |            1.3.x            |            1.4.x            |            1.5.x            |            1.6.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Kubernetes 1.25           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.26           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.27           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kubernetes 1.28           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.29           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.30           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.31           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.32           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

### Gateway API

The following table presents the compatibility of {{site.kgo_product_name}} with specific [Gateway API][gateway-api] versions.
As {{site.kgo_product_name}} implements Gateway API features using the upstream
project, which defines [its own compatibility declarations][gateway-api-supported-versions], the expected compatibility
of Gateway API features might be limited to those.

| {{site.kgo_product_name}} |            1.0.x            |            1.1.x            |            1.2.x            |            1.3.x            |            1.4.x            |            1.5.x            |            1.6.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Gateway API 0.8.1         | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.0.0         | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.1.0         | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.2.0         | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.3.0         | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |

[gateway-api]: https://github.com/kubernetes-sigs/gateway-api
[gateway-api-supported-versions]:https://gateway-api.sigs.k8s.io/concepts/versioning/#supported-versions

### `kubernetes-configuration` CRDs

Starting with 1.5, {{ site.kgo_product_name }} works with [`kubernetes-configuration`][kcfg] CRDs.
These CRDs are backwards compatible with CRDs from gateway-operator 1.4 and older unless stated otherwise in the release notes in [kuberentes-configuration CHANGELOG.md][kcfg_changelog].

Older versions of {{site.kgo_product_name}} used `gateway-operator` CRDs, packaged with the operator helm chart.

Below table contains a compatibility matrix for `kubernetes-configuration` CRDs and {{ site.kgo_product_name }} versions.

| {{site.kgo_product_name}}      |            1.4.x            |            1.5.x            |            1.6.x            |
|:-------------------------------|:---------------------------:|:---------------------------:|:---------------------------:|
| kubernetes-configuration 1.3.x | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| kubernetes-configuration 1.4.x | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |

[kcfg]: https://github.com/Kong/kubernetes-configuration
[kcfg_changelog]: https://github.com/Kong/kubernetes-configuration/blob/main/CHANGELOG.md
