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

### Is it possible to deploy {{site.kic_product_name}} with {{site.base_gateway}} as DaemonSet?

It is possible. Such configuration may be useful in environments where LoadBalancer or NodePort Service
is not a desired choice. Deploy Kong as DaemonSet and configure Pods to use the network of the host they run on instead
of a dedicated network namespace. The benefit of this approach is that the Kong can bind ports 80 and 443 directly to
Kubernetes nodes' network interfaces, without the extra network translation imposed by NodePort Services. Read more about
such configuration in the [dedicated Helm chart docs section][chart-using-a-daemonset].

[chart-using-a-daemonset]: (https://github.com/Kong/charts/blob/main/charts/kong/README.md#using-a-daemonset)
