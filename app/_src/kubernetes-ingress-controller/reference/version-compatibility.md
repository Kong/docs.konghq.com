---
title: Version Compatibility
---

Kong's Kubernetes ingress controller is compatible with different flavors of Kong.
The following sections detail on compatibility between versions for the last
five controller versions. Compatibility for older versions is available in
those versions' documentation.

## Kong

| {{site.kic_product_name}} |           2.12.x            |            3.0.x            |            3.1.x            |            3.2.x            |            3.3.x            |            3.4.x            
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Kong 2.8.x                | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| Kong 3.4.x                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kong 3.6.x                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kong 3.7.x                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kong 3.8.x                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kong 3.9.x                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## {{site.ee_product_name}}

| {{site.kic_product_name}}      |           2.12.x            |            3.0.x            |            3.1.x            |            3.2.x            |            3.3.x            |            3.4.x            |
|:-------------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| {{site.ee_product_name}} 2.8.x | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| {{site.ee_product_name}} 3.4.x | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{site.ee_product_name}} 3.6.x | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{site.ee_product_name}} 3.7.x | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{site.ee_product_name}} 3.8.x | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{site.ee_product_name}} 3.9.x | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## Kubernetes

### General

The following table presents the general compatibility of {{site.kic_product_name}} with specific Kubernetes versions.
Users should expect all the combinations marked with <i class="fa fa-check"></i> to work and to be supported.

| {{site.kic_product_name}} |           2.12.x            |            3.0.x            |            3.1.x            |            3.2.x            |            3.3.x            |            3.4.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Kubernetes 1.27           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.28           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.29           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.30           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.31           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Kubernetes 1.32           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

### Gateway API

The following table presents the compatibility of {{site.kic_product_name}}'s [Gateway API][gateway-api]
with specific Kubernetes minor versions. As {{site.kic_product_name}} implements Gateway API features using the upstream
project, which defines [its own compatibility declarations][gateway-api-supported-versions], the expected compatibility
of Gateway API features might be limited to those.

| {{site.kic_product_name}} |           2.12.x            |            3.0.x            |            3.1.x            |            3.2.x            |            3.3.x            |            3.4.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Gateway API 0.8           | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.0           | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.1           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Gateway API 1.2           | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |

For specific Gateway API resources support, please refer to the [Gateway API Support][gateway-api-support] page.

[gateway-api]:https://github.com/kubernetes-sigs/gateway-api
[gateway-api-supported-versions]:https://gateway-api.sigs.k8s.io/concepts/versioning/#supported-versions
[gateway-api-support]:/kubernetes-ingress-controller/{{page.release}}/concepts/gateway-api/

## Istio

The {{site.kic_product_name}} can be integrated with an [Istio Service Mesh][istio] to use {{site.base_gateway}} as an ingress gateway for application traffic into the mesh network. See an example of this in the [Istio Guide][istio-guide].

For each {{site.kic_product_name}} release, tests are run to verify this documentation with upcoming versions of KIC and Istio. The following table lists the tested combinations:

| {{site.kic_product_name}} |           2.12.x            |            3.0.x            |            3.1.x            |            3.2.x            |            3.3.x            |            3.4.x            |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| Istio 1.21                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Istio 1.22                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Istio 1.23                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Istio 1.24                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

[istio]:https://istio.io
[istio-guide]:/kubernetes-ingress-controller/{{page.release}}/guides/getting-started-istio/
