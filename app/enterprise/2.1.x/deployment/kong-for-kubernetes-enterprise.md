---
title: Kong for Kubernetes Enterprise
---

Kong provides two main Enterprise packages that you can deploy with Kubernetes,
depending on your use case:

* **Kong for Kubernetes Enterprise**: The Kong Ingress Controller with
Enterprise plugins.
* **Kong Enterprise on Kubernetes**: The whole Kong Enterprise platform
deployed on Kubernetes, optionally with the Kong Ingress Controller.

## Kong for Kubernetes Enterprise

Kong for Kubernetes Enterprise is a lightweight deployment of Kong Gateway as
a Kubernetes ingress controller. A Kubernetes ingress controller is a proxy
that exposes Kubernetes services from applications (for example, Deployments,
StatefulSets) running on a Kubernetes cluster to client applications running
outside of the cluster. The intent of an ingress controller is to provide a
single point of control for all incoming traffic into the Kubernetes cluster.

The Kong Ingress Controller runs without a database (DB-less mode) and supports
the vast majority of Kong's plugins, including the Enterprise plugins.

<div class="alert alert-ee warning">
<strong>Important:</strong> Enterprise features such as Kong Manager, Kong
Vitals (analytics), Kong Developer Portal, RBAC, Immunity, Workspaces and many
others can't run in this deployment because they require a database.
</div>

![Kong for Kubernetes Enterprise](/assets/images/docs/ee/kubernetes/k4k8s-enterprise.png)

For example, here's a common use case: an application deployed to Kubernetes
exposes an API that needs to be used by Web or mobile-client applications or
services in another cluster. It uses a Kubernetes ingress controller, which can
secure and manage traffic according to various policies that can be changed on
the fly based on the use case and application.

Here are some benefits of using Kong for Kubernetes Enterprise:
* It stores all of the configuration in the Kubernetes datastore
([etcd](https://etcd.io/docs/latest/)) using Custom Resource Definitions (CRDs),
meaning you can use Kubernetes' native tools to manage Kong and benefit from
Kubernetes' declarative configuration, RBAC, namespacing, and scalability.
* Because the configuration is stored in Kubernetes, no database needs to be
deployed for Kong. Kong runs in DB-less mode, making it operationally easy to
run, upgrade, and back up.
* It natively integrates with the Cloud Native Computing Foundation (CNCF)
ecosystem to provide out of the box monitoring, logging, certificate management,
tracing, and scaling.

## Kong Enterprise on Kubernetes

This option lets you deploy the full Kong for Kubernetes Enterprise
platform. As there are functionalities in the platform that require a stateful
environment, a database is required to run this package, which includes the
following:

* Kong Manager
* Kong Vitals
* Kong Developer Portal
* Role-based access control (RBAC)
* Workspaces
* All open-source and Enterprise plugins
* and more

Kong Enterprise on Kubernetes is the ideal install for organizations
looking to leverage Kong's complete platform. If your organization requires the
functionalities mentioned above, it is recommended to use this deployment
option.

![Kong Enterprise on Kubernetes](/assets/images/docs/ee/kubernetes/kong-enterprise-on-kubernetes.png)

## See Also

For a detailed comparison of the options, see
[Deployment Options](/enterprise/{{page.kong_version}}/deployment/kubernetes-deployment-options).

For more information about the architecture of the ingress controller, see
[Kong Ingress Controller Design](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/design.md).
