---
title: Router Flavor
type: reference
purpose: |
  What is the router flavor? What's the default? What difference does it make? (Gateway API only possible with expressions).
---

{{ site.kic_product_name }} supports the `traditional`, `traditional_compatible` and `expressions` {{ site.base_gateway }} routers. Set `gateway.env.router_flavor` in your `values.yaml` when installing with Helm to configure the router used.

When using Gateway API resources we recommend using the `expressions` router because it supports advanced features such as query string matching, which the `traditional` and `traditional_compatible` routers do not support
