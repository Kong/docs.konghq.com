---
title: FAQs
---

### Why endpoints and not services?

The {{site.kic_product_name}} does not use
[Services][k8s-service] to route traffic
to the pods. Instead, it uses the Endpoints API
to bypass [kube-proxy][kube-proxy]
to allow Kong features like session affinity and
custom load balancing algorithms.
It also removes overhead
such as conntrack entries for iptables DNAT.

### Is it possible to create consumers using the Admin API?

From version 0.5.0 onward, the {{site.kic_product_name}} tags each entity
that it manages inside Kong's database and only manages the entities that
it creates.
This means that if consumers and credentials are created dynamically, they
won't be deleted by the Ingress Controller.

[k8s-service]: https://kubernetes.io/docs/concepts/services-networking/service
[kube-proxy]: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy
