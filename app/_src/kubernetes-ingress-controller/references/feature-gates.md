---
title: Feature Gates
---

Upstream [Kubernetes][k8s] includes [feature gates][gates], which enable or disable features with flags and track the maturity of a feature using [feature stages][stages]. Here in the Kubernetes Ingress Controller (KIC), we use the same definitions of `feature gates` and `feature stages` from upstream Kubernetes to define our own list of features.

Using feature gates enables contributors to add and manage new (and potentially experimental) functionality to the KIC in a controlled manner. The features will be "hidden" until generally available (GA) and the progress and maturity of features on their path to GA will be documented. Feature gates also create a clear path for deprecating features.

See below for current features and their statuses, and follow the links to the relevant feature documentation:

* [Kubernetes](https://kubernetes.io)
* [Kubernetes feature gates](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/)
* [Feature stages](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-stages)


## Feature gates for alpha and beta features

Features that reach GA and become stable are removed from this table, but they can be found in the main [KIC CRD documentation][specs] and [guides][guides]. This table is an overview of features at various maturity levels:


| Feature                | Default | Stage | Since | Until |
|------------------------|---------|-------|-------|-------|
| Knative                | `true`  | Alpha | 0.8.0 | TBD   |

{% if_version lte: 2.5.x %}
| Gateway                | `false` | Alpha | 2.2.0 | 2.5.0 |
{% endif_version %}

{% if_version gte: 2.6.x %}
| Gateway                | `true`  | Beta  | 2.6.0 | TBD   |
| GatewayAlpha           | `false` | Alpha | 2.6.0 | TBD   |
{% endif_version %}

| CombinedRoutes         | `false` | Alpha | 2.4.0 | TBD   |
| IngressClassParameters | `false` | Alpha | 2.6.0 | TBD   |

### Feature gates details

- The **since** and **until** rows in the table refer to [KIC Releases][releases].
- Most features will be planned using [Kubernetes Enhancement Proposals (KEP)][k8s-keps]. If you're interested in developing features, familiarize yourself with our [KEPs][kic-keps].
- Features that are currently in alpha or beta states may become deprecated at any time. Deprecated features are removed during the next minor release. 
- Until a feature becomes GA, there are no guarantees that it's going to continue being available. For more information, see the [changelog](https://github.com/Kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md).

{:.important}
>**Important:** To avoid disruption to your services consider not using features until they have reached GA status. 

### Documentation

You can find feature preview documentation for alpha maturity features in the [kubernetes-ingress-controller repository](https://github.com/Kong/kubernetes-ingress-controller/blob/main/FEATURE_PREVIEW_DOCUMENTATION.md)..


[k8s]:https://kubernetes.io
[gates]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/
[stages]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-stages
[specs]: /kubernetes-ingress-controller/latest/references/custom-resources/
[guides]: /kubernetes-ingress-controller/latest/guides/overview/
[k8s-keps]:https://github.com/kubernetes/enhancements
[kic-keps]:https://github.com/Kong/kubernetes-ingress-controller/tree/main/keps
[releases]:https://github.com/Kong/kubernetes-ingress-controller/releases
[kong-docs]:https://github.com/Kong/docs.konghq.com
[kic-guides]: /kubernetes-ingress-controller/latest/guides/overview/