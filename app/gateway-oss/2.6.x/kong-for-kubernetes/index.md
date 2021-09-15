---
title: Kong for Kubernetes
---

Running {{site.base_gateway}} with the Kong Ingress Controller provides the following benefits:

- Kong is configured dynamically and responds to the changes in your infrastructure.
- Kong is deployed onto Kubernetes with a Controller, which is responsible for configuring Kong.
- All of Kong’s configuration is done using Kubernetes resources, stored in Kubernetes’ data-store (etcd).
- Use the power of kubectl (or any custom tooling around kubectl) to configure Kong and get benefits of all Kubernetes, such as declarative configuration, cloud-provider agnostic deployments, RBAC, reconciliation of desired state, and elastic scalability.
- Kong is configured using a combination of Ingress Resource and Custom Resource Definitions(CRDs).
- DB-less by default, meaning Kong has the capability of running without a database and using only memory storage for entities.

<img src="https://doc-assets.konghq.com/kubernetes/Kong-for-Kubernetes-Diagram.png" alt="Kong for Kubernetes control diagram">

## See also
* [Install](/gateway-oss/{{page.kong_version}}/kong-for-kubernetes/install) {{site.base_gateway}} with the Kong Ingress controller
* [Kong Ingress Controller docs](/kubernetes-ingress-controller/)
* [Kong Ingress Controller changelog](https://github.com/Kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md)
* [{{site.base_gateway}} changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md)
