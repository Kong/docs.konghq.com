---
title: Gateway API
---

Both {{ site.kgo_product_name }} and {{ site.kic_product_name }} can be configured using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api). Configure your vendor independent `GatewayClass` and `Gateway` objects and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

In DB-less mode, {{ site.kgo_product_name }} watches for `GatewayClass` resources where the `spec.controllerName` is `konghq.com/gateway-operator`. When a `GatewayClass` resource is detected, {{ site.kgo_product_name }} deploys an instance of {{ site.kic_product_name }} to act as a `ControlPlane` and an instance of {{ site.base_gateway }} to act a `DataPlane`.

Configure traffic routing using Gateway API resources such as `HTTPRoute`, `GRPCRoute`, `TCPRoute` and `UDPRoute`. These resources are translated in to Kong configuration objects by {{ site.kic_product_name }} which proxies traffic to your internal services through {{ site.base_gateway }} .