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

| Feature                    | Default | Stage | Since  | Until |
|----------------------------|---------|-------|--------|-------|
| GatewayAlpha               | `false` | Alpha | 2.6.0  | TBD   |
| FillIDs                    | `true`  | Beta  | 3.0.0  | TBD   |
| RewriteURIs                | `false` | Alpha | 2.12.0 | TBD   |
| KongServiceFacade          | `false` | Alpha | 3.1.0  | TBD   |
| SanitizeKonnectConfigDumps | `true`  | Beta  | 3.1.0  | TBD   |
{% if_version gte:3.2.x %}
| FallbackConfiguration      | `false` | Alpha | 3.2.0  | TBD   |
| KongCustomEntity           | `false` | Alpha | 3.2.0  | 3.3.0 |
| KongCustomEntity           | `true`  | Beta  | 3.3.0  | 3.4.0 |
| KongCustomEntity           | `true`  | GA    | 3.4.0  | TBD   |
{% endif_version %}
{% if_version gte:3.4.x %}
| CombinedServicesFromDifferentHTTPRoutes  | `false` | GA | 3.4.0  | TBD   |
{% endif_version %}

## Using feature gates

To enable feature gates, provide the `--feature-gates` flag when launching KIC, or set the `CONTROLLER_FEATURE_GATES` environment variable.

Feature gates consist of a comma-delimited set of `key=value` pairs. For example, if you wanted to enable `FillIDs` and `RewriteURIs`, you'd set `CONTROLLER_FEATURE_GATES=FillIDs=true,RewriteURIs=true`.

To enable features via Helm, set the following in your `values.yaml`:

{% navtabs %}
{% navtab kong chart %}
```yaml
ingressController:
  env:
    feature_gates: FillIDs=true,RewriteURIs=true
```
{% endnavtab %}
{% navtab ingress chart %}
```yaml
controller:
  ingressController:
    env:
      feature_gates: FillIDs=true,RewriteURIs=true
```
{% endnavtab %}
{% endnavtabs %}

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
>**Important:** To avoid disrupting your services, consider not using features until they have reached GA status.

[k8s]:https://kubernetes.io
[gates]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/
[stages]:https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-stages
[k8s-keps]:https://github.com/kubernetes/enhancements
[kic-keps]:https://github.com/Kong/kubernetes-ingress-controller/tree/main/keps
[releases]:https://github.com/Kong/kubernetes-ingress-controller/releases

## Feature gate details

### SanitizeKonnectConfigDumps

The `SanitizeKonnectConfigDumps` feature enables the sanitization of configuration dumps that are sent to Konnect.
This means {{site.kic_product_name}} will obfuscate all sensitive information that your Kong config contains, such as
private keys in `Certificate` entities and `Consumer` entities' credentials.

{:.important}
> **Warning:** `KongPlugin`'s and `KongClusterPlugin`'s `config` fields are not sanitized. If you have sensitive information
> in your `KongPlugin`'s `config` field, it will be sent to Konnect as is. To avoid that, please consider using
> [KongVault](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongvault).

{% if_version gte:3.4.x %}
### CombinedServicesFromDifferentHTTPRoutes

The `CombinedServicesFromDifferentHTTPRoutes` feature enables translating `HTTPRoute` rules
with the same set of backends (combination of namespace, name, port and weight) from different `HTTPRoute`s in the same namespace
into a single {{site.base_gateway}} service. Enabling the feature gate can reduce the number of translated {{site.base_gateway}} services.

The names of {{site.base_gateway}} services will change if the feature gate is enabled.
You can refer to the [reference page](/kubernetes-ingress-controller/{{page.release}}/reference/combined-services-from-different-httproutes) for further details.
{% endif_version %}
