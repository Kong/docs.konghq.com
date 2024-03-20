---
title: Install KIC with Kong Gateway Operator
content-type: tutorial
book: kgo-kic-get-started
chapter: 1
---

{% if_version lte: 1.1.x %}
{:.note}
> **Note:** `Gateway` and `ControlPlane` controllers are still `alpha` so be sure
> to use the [installation steps from this guide](/gateway-operator/{{ page.release }}/get-started/kic/install/)
> in order to get your `Gateway` up and running.
{% endif_version %}

Both {{ site.kgo_product_name }} and {{ site.kic_product_name }} can be configured using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api).

You can configure your `GatewayClass` and `Gateway` objects in a vendor independent way and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

This means that CRDs for both the Gateway API and {{ site.kic_product_name }} have to be installed.

{% include md/kgo/prerequisites-kic.md disable_accordian=true version=page.version release=page.release %}
