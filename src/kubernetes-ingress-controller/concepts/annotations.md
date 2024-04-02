---
title: Annotations
type: explanation
purpose: |
  Explain what annotations are used for in KIC. List the top X annotations then link to the reference page
---

{{ site.kic_product_name }} uses annotations to add functionality to various Kubernetes resources. Annotations are used when there is not a standardized way to configure the required functionality.

Annotations can be added to a route `Ingress` or Gateway API resource such as `HTTPRoute`, `Service` or `KongConsumer`.

The most commonly used annotations are:

* [`konghq.com/plugins`](/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/#konghqcomplugins) - Add plugins to a route, service or consumer
* [`konghq.com/strip-path`](/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/#konghqcomstrip-path) - Strip the path defined in the route and then forward the request to the upstream service
* [`konghq.com/methods`](/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/#konghqcommethods) - Match specific HTTP methods in the route
* [`konghq.com/headers.*`](/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/#konghqcomheaders) - Require specific headers in the incoming request to match the defined route

See the [annotations reference](/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/) page for a complete list of available annotations and related documentation.
