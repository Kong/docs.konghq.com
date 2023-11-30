---
title: Install KIC with Kong Gateway Operator
content-type: tutorial
book: kgo-kic-get-started
chapter: 1
alpha: true
---

Both {{ site.kgo_product_name }} and {{ site.kic_product_name }} can be configured using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api).

You configure your `GatewayClass` and `Gateway` objects in a vendor independent way and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

This means that CRDs for both the Gateway API and {{ site.kic_product_name }} have to be installed.

Below command installs all Gateway API resources that have graduated to GA or beta,
including `GatewayClass`, `Gateway`, `HTTPRoute`, and `ReferenceGrant`.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
```

If you want to use experimental resources and fields such as `TCPRoute`s and `UDPRoute`s, please run this command.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/experimental-install.yaml
```

To install Kong specific CRDs, run the following command.

```bash
kubectl apply -k https://github.com/Kong/kubernetes-ingress-controller/config/crd
```

{% include snippets/gateway-operator/install_with_kubectl_all_controllers.md version=page.version%}
