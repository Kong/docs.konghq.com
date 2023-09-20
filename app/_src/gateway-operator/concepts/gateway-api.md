---
title: Gateway API
---

Both {{ site.kgo_product_name }} and {{ site.kic_product_name }} can be configured using using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api). You configure your `GatewayClass` and `Gateway` objects in a vendor independent way and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

When running in DB-less mode, {{ site.kgo_product_name }} watches for instances of `GatewayClass` where the `spec.controllerName` is `konghq.com/gateway-operator`. When a `GatewayClass` is detected, {{ site.kgo_product_name }} deploys an instance of {{ site.kic_product_name }} to act as a `ControlPlane` and an instance of {{ site.base_gateway }} to act a a `DataPlane`.

Traffic routing is configured using Gateway API resources such as `HTTPRoute`, `GRPCRoute`, `TCPRoute` and `UDPRoute`. These resources are translated in to Kong configuration objects by {{ site.kic_product_name }} which allows {{ site.base_gateway }} to proxy traffic to your internal services.