---
title: Overview
book: kubernetes-install
chapter: 1
---

{{ site.base_gateway }} can be installed on Kubernetes in a variety of modes.

* [DB-less mode, configured using Kubernetes resources and {{ site.kic_product_name }}](/kubernetes-ingress-controller/latest/get-started/)
* [Data Planes attached to {{ site.konnect_saas }}](/konnect/gateway-manager/data-plane-nodes/)
* Hybrid mode with the Control Plane and Data Plane in a Kubernetes cluster
* Traditional mode, where every node connects to a PostgreSQL database

This documentation provides instructions to deploy {{ site.base_gateway }} in Hybrid mode in a Kubernetes cluster.
