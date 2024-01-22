---
title: Configure the Admin API
book: kubernetes-install
chapter: 3
---

{{ site.base_gateway }} is now running on Kubernetes. The Admin API is a `NodePort` service, which means it's not publicly available. The proxy service is a `LoadBalancer` which provides a public address.

To make the admin API accessible without using `kubectl port-forward`, you can create an internal load balancer on your chosen cloud. This is required to use [Kong Manager]({{ page.book.next.url }}) to view or edit your configuration.

Update your `values-cp.yaml` file with the following Ingress configuration.

{% include md/k8s/ingress-setup.md service="admin" release="cp" type="private" %}
