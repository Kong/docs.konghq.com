---
title: Overview
book: kubernetes-install
chapter: 1
---

{{ site.base_gateway }} can be installed on Kubernetes in several different modes.

* [DB-less mode, configured using Kubernetes resources and the {{ site.kic_product_name }}](/kubernetes-ingress-controller/latest/get-started/)
* [Data Planes integrated with {{ site.konnect_saas }}](/konnect/gateway-manager/data-plane-nodes/)
* Hybrid mode with the Control Plane and Data Plane in a Kubernetes cluster
* Traditional mode, where each node connects to a PostgreSQL database

This documentation offers instructions for deploying {{ site.base_gateway }} in Hybrid mode within a Kubernetes cluster.
