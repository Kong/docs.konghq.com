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

| {{site.kic_product_name}}          |             2.7.x              |             2.8.x              |             2.9.x              |           2.10.x               |
|:-----------------------------------|:------------------------------:|:------------------------------:|:------------------------------:|:------------------------------:|
| Kong 3.x  `traditional`            |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   |  <i class="fa fa-check"></i>   | <i class="fa fa-check"></i>    |
| Kong 3.x  `traditional_compatible` | <i class="fa fa-check"></i>(1) | <i class="fa fa-check"></i>(1) | <i class="fa fa-check"></i>(1) | <i class="fa fa-check"></i>(1) | 
| Kong 3.x  `expressions`            |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   |  <i class="fa fa-times"></i>   | <i class="fa fa-times"></i>(2) |

(1) Most use cases are supported. The incompatible cases comes from the difference of regular expression standards in different routers:
`traditional` router accepts [PCRE 2][pcre-2-regex] regular expressions, but `traditional_compatible` and `expressions` routers accepts regular expression in [Rust][rust-regex].
The most significant difference is that Regular expressions with a backslash (`\`) followed by a non-escaped character (for example, `\j` or `\/`) in matches of paths or headers
are accepted in `traditional` router but not accepted when {{site.base_gateway}} 3.x is configured to use the `traditional_compatible` router.

(2) Limited support of expression based router (alpha maturity). Please refer to [expression router concept page][kic-expression-router-2-10]
to see detailed status of supporting {{site.base_gateway}} with expression router.

[gateway-expression-router]:/gateway/latest/key-concepts/routes/expressions/
[gateway-router-flavor]:/gateway/latest/reference/configuration/#router_flavor
[pcre-2-regex]:https://www.pcre.org/current/doc/html/pcre2syntax.html
[rust-regex]:https://docs.rs/regex/latest/regex/
[kic-expression-router-2-10]:/kubernetes-ingress-controller/2.10.x/concepts/expression-based-router
