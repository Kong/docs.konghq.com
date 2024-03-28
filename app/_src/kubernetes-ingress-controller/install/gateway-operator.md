---
title: Install Kong Ingress Controller with the KGO
type: how-to
purpose: |
  Using KGO to install KIC
---

{{ site.kgo_product_name }} configures and manages {{ site.kic_product_name }} automatically using [Gateway API](https://github.com/kubernetes-sigs/gateway-api) resources. This is in contrast to Helm, which provides an ingress controller that has the [`konghq.com/gatewayclass-unmanaged: 'true'` annotation](/kubernetes-ingress-controller/latest/gateway-api/#gatewayclass--gateway).

For more information, see the [{{ site.kgo_product_name }} with KIC](/gateway-operator/latest/get-started/kic/install/) getting started guide.