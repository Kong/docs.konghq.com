---
title: Kong for Kubernetes with Kong Enterprise
---

Kong for Kubernetes is a {{site.kic_product_name}} built on top
of Open-Source Kong Gateway.

If you are an Enterprise customer, you have an option of running the
[Enterprise version](/gateway/latest/install-and-run/kubernetes/)
of the Ingress Controller, which includes
all the Enterprise plugins but does not include Kong Manager or any
other Enterprise features. This makes it possible to
run the Ingress layer without a database, providing a very low
operational and maintenance footprint.

However, in some cases, those enterprise features are necessary,
and for such use-cases we support another deployment - Kong for
Kubernetes with Kong Enterprise.

As seen in the diagram below, this deployment consists of
Kong for Kubernetes deployed in Kubernetes, and is hooked up with
a database. If there are services running outside Kubernetes,
a regular Kong Gateway proxy can be deployed there and connected to the
same database. This provides a single pane of visibility of
all services that are running in your infrastructure.

![architecture-overview](/assets/images/docs/kubernetes-ingress-controller/k4k8s-with-kong-enterprise.png "K4K8S with Kong Enterprise")

In this deployment model, the database for Kong can be hosted anywhere.
It can be a managed DBaaS service like Amazon RDS, Google Cloud
SQL or a Postgres instance managed in-house or even an instance
deployed on Kubernetes.
If you are following this model, please keep in mind the following:
- It is recommended to not deploy Postgres on Kubernetes,
  due to the fact that running stateful applications on Kubernetes
  is challenging to get right.
- Ensure that you have the same image/package of Kong Enterprise
  running across the fleet. This means that all Kong instances that are
  connected to the same database must use the
  same version of kong enteprise package.

[This guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/kong-enterprise)
walks through the setup of the above architecture.
