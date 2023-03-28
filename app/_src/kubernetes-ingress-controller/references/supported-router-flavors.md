---
title: Supported Kong Router Flavors
---


{{site.base_gateway}} (open-source and enterprise edition) includes an [expression-based router][gateway-expression-router] in versions 3.0 and later.
The router can be configured in the following [modes][gateway-router-flavor]:

- `traditional`: uses the pre-3.0 router.
- `traditional_compatible`: uses the expression based router, but the router configuration interface remains the same as `traditional`.
- `expressions`: uses the expression-based router, and expressions must be provided in the router configuration interface.

The compatibilities of router flavors between different {{site.kic_product_name}} versions and {{site.base_gateway}} are shown in the following table.
{{site.kic_product_name}} in versions 2.6.x and lower does not support {{site.base_gateway}} 3.0 and later, so the version of {{site.kic_product_name}} begins at 2.7.x.

| {{site.kic_product_name}}            |             2.7.x              |             2.8.x              |             2.9.x              |
|:-------------------------------------|:------------------------------:|:------------------------------:|:------------------------------:|
| Kong 3.0.x  `traditional`            |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   |
| Kong 3.0.x  `traditional_compatible` | <i class="fa fa-times"></i>(*) | <i class="fa fa-times"></i>(*) | <i class="fa fa-times"></i>(*) |
| Kong 3.0.x  `expressions`            |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   |
| Kong 3.1.x  `traditional`            |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   |
| Kong 3.1.x  `traditional_compatible` | <i class="fa fa-times"></i>(*) | <i class="fa fa-times"></i>(*) | <i class="fa fa-times"></i>(*) |
| Kong 3.1.x  `expressions`            |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   |

(*) Most use cases are supported. Regexes with a backslash (`\`) followed by a non-escaped character (for example, `\j` or `\/`) in matches of paths or headers
may not be accepted when {{site.base_gateway}} 3.0 is configured to use the `traditional_compatible` router.

[gateway-expression-router]:/gateway/latest/key-concepts/routes/expressions/
[gateway-router-flavor]:/gateway/latest/reference/configuration/#router_flavor
