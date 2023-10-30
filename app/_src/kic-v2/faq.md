---
title: FAQs
---

{% if_version lte: 2.9.x %}
### Why Endpoints and not Services?

The {{site.kic_product_name}} does not use [Services][k8s-service] to route traffic to the pods.
Instead, it uses the [Endpoints][k8s-endpoints] API to bypass
[kube-proxy][kube-proxy] to allow Kong features such as session affinity and custom
load balancing algorithms.
It also removes overhead such as `conntrack` entries for iptables DNAT.
{% endif_version %}
{% if_version gte: 2.10.x %}
### Why EndpointSlices and not Services?

The {{site.kic_product_name}} does not use [Services][k8s-service] to route traffic to the pods.
Instead, it uses the [EndpointSlice][k8s-endpointslices] API
(which is available since Kubernetes v1.21) to bypass [kube-proxy][kube-proxy]
to allow Kong features such as session affinity and custom load balancing algorithms.
It also removes overhead such as `conntrack` entries for iptables DNAT.
{% endif_version %}

### Is it possible to create consumers using the Admin API?

In version 0.5.0 and later, the {{site.kic_product_name}} tags each entity
that it manages inside Kong's database and only manages the entities that
it creates.
This means that if consumers and credentials are created dynamically, they are not deleted by the Ingress Controller.

[k8s-service]: https://kubernetes.io/docs/concepts/services-networking/service
[kube-proxy]: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy
[k8s-endpointslices]: https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/
[k8s-endpoints]: https://kubernetes.io/docs/concepts/services-networking/service/#endpoints
