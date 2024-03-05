---
title: Managed Gateways
---

{{ site.kgo_product_name }} handles `Gateway`s in the so-called managed mode, which implies the following characteristics:

## 1:1 relationship between `Gateway`s and `ControlPlane`s

When {{ site.kgo_product_name }} detects a new `Gateway`, it creates a `ControlPlane` and a `DataPlane`. The `ControlPlane` is a {{ site.kic_product_name }} instance configured with a specific flag that allows it to reconcile and manage one `Gateway` only, which is bound to.
This is a key aspect that differentiates {{ site.kgo_product_name }} from {{ site.kic_product_name }} when used as a standalone to reconcile `Gateway`s. In that scenario, indeed, all the `Gateway`s are merged into the same {{ site.kong_product_name }} configuration, and pushed to the same {{ site.kong_product_name }} instance. The {{ site.kic_product_name }} operates in the so-called unmanaged mode.

## Dynamic configuration

The `Gateway` spec is dynamically mapped to the `DataPlane` configuration, which means that it is possible to apply a modification on the `Gateway` listeners and expect a change on the `DataPlane` configuration. For example, when creating a Gateway with only one HTTP listener on port 80, the `DataPlane` ingress service will be configured so that only port 80 will be exposed. If one wants to add a `Gateway` HTTPS listener on port 443, this change will be taken by {{ site.kgo_product_name }} and applied to the `DataPlane`. The final result will be an ingress service exposing ports 80 for HTTP traffic and 443 for HTTPS traffic. Port 80 and 443 are only examples; this dynamic behavior is applied to all the possible `Gateway` configurations and with as many `Gateway` listeners as one wants.
