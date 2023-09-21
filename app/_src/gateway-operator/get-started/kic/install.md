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

Once that is done, install {{ site.kgo_product_name }} using `kubectl apply`:

```bash
kubectl apply -k "https://github.com/kong/gateway-operator-docs/config/crd" --server-side
kubectl apply -k "https://github.com/kong/gateway-operator-docs/config/default"
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/gateway-operator-controller-manager
```