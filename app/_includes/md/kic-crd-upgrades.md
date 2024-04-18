Helm's CRD management does not support the same version-aware logic used
elsewhere to provide older-version compatibility, so the chart cannot install
the definitions for the configured controller version. If you use an older
version of {{site.kic_product_name}} compatible with your Kubernetes version,
you can install its definitions separately. For example, to install the 2.5.1
definitions and install with Helm's CRD installer disabled:

```bash
kubectl kustomize https://github.com/Kong/kubernetes-ingress-controller/config/crd?ref=v2.5.1 | kubectl apply -f -

helm install myrelease kong/ingress --skip-crds
```

Note that even when you _do_ use Helm to install CRDs, Helm does not update
CRDs when running `helm upgrade`. You must separately install updated CRDs using
the above `kubectl` command versions before running a `helm ugprade` that
installs a newer controller release.
