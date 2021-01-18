---
title: Runtime Manager Overview
no_search: true
no_version: true
beta: true
---

A runtime is a data plane, which is a node that serves traffic for the proxy.
Data plane nodes are not directly connected to a database.

{{site.konnect_product_name}} supports the following runtimes:
* [{{site.ee_gateway_name}}](/enterprise/latest/introduction)
* [Kubernetes Ingress Controller](https://docs.konghq.com/kubernetes-ingress-controller/latest/introduction)

<div class="alert alert-ee red"> Connections to the Kubernetes
 Ingress Controller are not available for the {{site.konnect_product_name}} beta.
 </div>
