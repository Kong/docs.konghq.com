---
title: Kong for Kubernetes Enterprise
toc: false
---

Kong for Kubernetes Enterprise is a deployment of {{site.base_gateway}} onto Kubernetes as an ingress controller. A Kubernetes ingress controller is a proxy that exposes Kubernetes services from applications (e.g., Deployments, StatefulSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an ingress controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster.

For example, here's a common use case: an application deployed to Kubernetes exposes an API that needs to be used by Web or mobile-client applications or services in another cluster. It uses a Kubernetes ingress controller, which can secure and manage traffic according to various policies that can be changed on the fly based on the use case and application.

Here are some benefits of using Kong for Kubernetes Enterprise:
* It stores all of the configuration in the Kubernetes datastore (etcd) using Custom Resource Definitions (CRDs), meaning you can use Kubernetes' native tools to manage Kong and benefit from Kubernetes' declarative configuration, RBAC, namespacing, and scalability.
* Because the configuration is stored in Kubernetes, no database needs to be deployed for Kong. Kong runs in DB-less mode, making it operationally easy to run, upgrade, and back up.
* It natively integrates with the Cloud Native Computing Foundation (CNCF) ecosystem to provide out of the box monitoring, logging, certificate management, tracing, and scaling.

Alternatively, you can also deploy Kong Enterprise on Kubernetes to use features such as Kong Manager, Kong Developer Portal, and others. For a comparison of the options, see [Deployment Options](/enterprise/{{page.kong_version}}/kong-for-kubernetes/deployment-options).

For more information about the architecture, see [Kong Ingress Controller Design](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/design.md).

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">
