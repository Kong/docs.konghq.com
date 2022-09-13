---
title: Kong for Kubernetes Enterprise
toc: false
---

Kong for Kubernetes Enterprise (K4K8S) is a Kubernetes Ingress Controller. A Kubernetes Ingress Controller is a proxy that exposes Kubernetes services from applications (e.g., Deployments, RepliaSets) running on a Kubernetes cluster to client applications running outside of the cluster. The intent of an Ingress Controller is to provide a single point of control for all incoming traffic into the Kubernetes cluster. 

For example, in a common use case, if an application deployed to Kubernetes exposes an API that needs to be used by Web or mobile-client applications or services in another cluster, then a Kubernetes Ingress Controller is required. It is important for the Ingress Controller to secure and manage traffic according to various policies that can be changed on the fly based on the use-case and application.

Kong for Kubernetes Enterprise stores all of the configuration in the Kubernetes datastore (etcd) using Custom Resource Definitions (CRDs), meaning you can use Kubernetes' native tools to manage Kong and benefit from Kubernetes' declarative configuration, RBAC, namespacing, and scalability. Also, because the configuration is stored in Kubernetes, no database needs to be deployed for Kong. Kong runs in in-memory mode, making it operationally easy to run, upgrade, and backup Kong.

Kong for Kubernetes Enterprise natively integrates with the Cloud Native Computing Foundation (CNCF) eco-system to provide out of the box monitoring, logging, certificate management, tracing, and scaling.


<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">

<div class="docs-grid">

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/kong-for-kubernetes/install">Install</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/kong-for-kubernetes/install">
        Install Kong for Kubernetes Enterprise &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/kong-for-kubernetes/using-kong-for-kubernetes/">Using Kong for Kubernetes Enterprise</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/kong-for-kubernetes/using-kong-for-kubernetes/">
        Learn More &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/kong-for-kubernetes/changelog">Changelog</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/kong-for-kubernetes/changelog">
        Read the latest updates to Kong for Kubernetes Enterprise &rarr;
    </a>
  </div>

</div>
