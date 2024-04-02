---
title: Managed Gateways
---

{{ site.kgo_product_name }} reconciles `Gateway` resources differently to {{ site.kic_product_name }}. KGO's approach is known as _managed_ gateways, and the KIC approach is referred to as _unmanaged_ gateways.

## Managed Gateways

When {{ site.kgo_product_name }} detects a new `Gateway`, it creates a `ControlPlane` ({{ site.kic_product_name }}) and a `DataPlane` ({{ site.base_gateway }}). This `ControlPlane` reconciles exactly one `Gateway`.

As {{ site.kgo_product_name }} manages the lifecycle of {{ site.base_gateway }} deployments, it can dynamically configure the `DataPlane` based on information in the `Gateway` listeners.

For example, when creating a Gateway with only one HTTP listener on port 80, the `DataPlane` ingress service will be configured so that only port 80 will be exposed. If you add a `Gateway` HTTPS listener on port 443, this change will be taken by {{ site.kgo_product_name }} and applied to the `DataPlane`. The final result will be an ingress service exposing ports 80 for HTTP traffic and 443 for HTTPS traffic.

{:.note}
> Port 80 and 443 are only examples. You can configure any combination of `Gateway` listeners that you need, and {{ site.kgo_product_name }} will configure your `DataPlane` appropriately.

## Unmanaged Gateways

Using {{ site.kic_product_name }} without {{ site.kgo_product_name }} results in all `Gateway` resources being merged in to a single configuration. {{ site.base_gateway }} deployments are created externally to {{ site.kic_product_name }}, which means that we cannot dynamically control the configuration in response to `Gateway` listeners.

When using _unmanaged_ mode, routes from all `Gateway` instances are merged together and sent to all {{ site.base_gateway }} instances being managed by the single {{ site.kic_product_name }}.