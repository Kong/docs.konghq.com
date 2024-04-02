---
title: Feature Gates
type: reference
purpose: |
  What feature gates are available? What are the default values? What do they do?
---

Feature gates enables contributors to add and manage new (and potentially experimental) functionality to the KIC in a controlled manner. The features will be "hidden" until generally available (GA) and the progress and maturity of features on their path to GA will be documented. Feature gates also create a clear path for deprecating features.

Upstream [Kubernetes][k8s] includes [feature gates][gates], which enable or disable features with flags and track the maturity of a feature using [feature stages][stages].
The same definitions of `feature gates` and `feature stages` from upstream Kubernetes are used to define KIC's list of features.

* [Kubernetes](https://kubernetes.io)
* [Kubernetes feature gates](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/)
* [Feature stages](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-stages)

## Available feature gates

| Feature      | Default | Stage | Since  | Until |
|--------------|---------|-------|--------|-------|
| GatewayAlpha | `false` | Alpha | 2.6.0  | TBD   |
| FillIDs      | `true`  | Beta  | 3.0.0  | TBD   |
| RewriteURIs  | `false` | Alpha | 2.12.0 | TBD   |

## Using feature gates

To enable feature gates, provide the `--feature-gates` flag when launching KIC, or set the `CONTROLLER_FEATURE_GATES` environment variable.

Feature gates consist of a comma-delimited set of `key=value` pairs. For example, if you wanted to enable `FillIDs` and `RewriteURIs`, you'd set `CONTROLLER_FEATURE_GATES=FillIDs=true,RewriteURIs=true`.

To enable features via Helm, set the following in your `values.yaml`:

```yaml
ingressController:
  env:
    feature_gates: FillIDs=true,RewriteURIs=true
```

To test a feature gate in an existing deployment, use `kubectl set env`.

```bash
kubectl set env -n kong deployment/kong-controller CONTROLLER_FEATURE_GATES="FillIDs=true,RewriteURIs=true" -c ingress-controller
```

## Feature gate availability

* The **since** and **until** rows in the table above refer to [KIC Releases][releases].
* Most features will be planned using [Kubernetes Enhancement Proposals (KEP)][k8s-keps]. If you're interested in developing features, familiarize yourself with KIC's [KEPs][kic-keps].
* Features that are currently in alpha or beta states may become deprecated at any time. Deprecated features are removed during the next minor release.
* Until a feature becomes GA, there are no guarantees that will continue being available. For more information, see the [changelog](https://github.com/Kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md).

{:.important}
>**Important:** To avoid disruption to your services consider not using features until they have reached GA status. 

[k8s]:https://kubernetes.io
[gates]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/
[stages]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-stages
[specs]: /kubernetes-ingress-controller/latest/reference/custom-resources/
[guides]: /kubernetes-ingress-controller/latest/guides/overview/
[k8s-keps]:https://github.com/kubernetes/enhancements
[kic-keps]:https://github.com/Kong/kubernetes-ingress-controller/tree/main/keps
[releases]:https://github.com/Kong/kubernetes-ingress-controller/releases

