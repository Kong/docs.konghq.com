{% assign exampleVersion = "v2.12.2" %}
{% assign kustomizeURL = "https://github.com/Kong/kubernetes-ingress-controller/config/crd" %}
{% if_version gte:3.4.x %}
{% assign exampleVersion = "v1.0.0" %}
{% assign kustomizeURL = "https://github.com/Kong/kubernetes-configuration/config/crd/ingress-controller" %}
{% endif_version %}

Helm's CRD management does not support the same version-aware logic used
elsewhere to provide older-version compatibility, so the chart cannot install
the definitions for the configured controller version. If you use an older
version of {{site.kic_product_name}} compatible with your Kubernetes version,
you can install its definitions separately. For example, to install the {{ exampleVersion }} CRD
definitions and install with Helm's CRD installer disabled:

```bash
kubectl kustomize {{ kustomizeURL }}?ref={{ exampleVersion }} | kubectl apply -f -

helm install myrelease kong/ingress --skip-crds
```

Note that even when you _do_ use Helm to install CRDs, Helm does not update
CRDs when running `helm upgrade`. You must separately install updated CRDs using
the above `kubectl` command versions before running a `helm upgrade` that
installs a newer controller release.
