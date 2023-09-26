---
title: Install
---

{{ site.kgo_product_name }} can be installed using Kong provided Kubernetes manifests.

If you intend to use {{ site.kic_product_name }} with {{ site.kgo_product_name }} you will need to install the KIC and Gateway API CRDs before installing {{ site.kgo_product_name }}:

```bash
kubectl apply -k https://github.com/Kong/kubernetes-ingress-controller/config/crd
kubectl apply -k "https://github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.8.1"
```

{% include snippets/gateway-operator/install_with_kubectl.md %}
