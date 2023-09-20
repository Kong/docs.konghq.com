---
title: Install
---

{{ site.kgo_product_name }} can be installed using Kong provided Kubernetes manifests.

If you intend to use {{ site.kic_product_name }} with {{ site.kgo_product_name }} you will need to install the KIC and Gateway API CRDs before installing {{ site.kgo_product_name }}:

```bash
kubectl apply -k https://github.com/Kong/kubernetes-ingress-controller/config/crd 
kubectl apply -k "https://github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.8.1"
```

To install {{ site.kgo_product_name }} run:

```bash
kubectl kustomize "https://github.com/kong/gateway-operator-docs/config/crd?submodules=false" | kubectl apply --server-side -f -
kubectl kustomize "https://github.com/kong/gateway-operator-docs/config/default?submodules=false" | kubectl apply --server-side -f -
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/gateway-operator-controller-manager
```