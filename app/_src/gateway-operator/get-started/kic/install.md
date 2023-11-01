---
title: Install KIC with Kong Gateway Operator
content-type: tutorial
book: kgo-kic-get-started
chapter: 1
alpha: true
---

Both {{ site.kgo_product_name }} and {{ site.kic_product_name }} can be configured using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api). 

You configure your `GatewayClass` and `Gateway` objects in a vendor independent way and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

This means that we need to install CRDs for both the Gateway API and {{ site.kic_product_name }}:

```bash
kubectl apply -k https://github.com/Kong/kubernetes-ingress-controller/config/crd
kubectl apply -k "https://github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.8.1"
```

{% include snippets/gateway-operator/install_with_kubectl_all_controllers.md version=page.version%}
