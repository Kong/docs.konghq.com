---
title: Kong for Kubernetes Enterprise
toc: false
---

**Kong for Kubernetes Enterprise includes the following features:**

- Kong is configured dynamically and responds to the changes in your infrastructure.
- Kong is deployed onto Kubernetes with a Controller, which is responsible for configuring Kong.
- All of Kong’s configuration is done using Kubernetes resources, stored in Kubernetes’ data-store (etcd).
- Use the power of kubectl (or any custom tooling around kubectl) to configure Kong and get benefits of all Kubernetes, such as declarative configuration, cloud-provider agnostic deployments, RBAC, reconciliation of desired state, and elastic scalability.
- Kong is configured using a combination of Ingress Resource and Custom Resource Definitions(CRDs).
- DB-less by default, meaning Kong has the capability of running without a database and using only memory storage for entities.
- Includes Kong Enterprise Plugins
- Subscription for Kong Support services

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">
<div class="docs-grid">
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{page.kong_version}}/kong-for-kubernetes/overview">Get Started with Kong for Kubernetes Enterprise &rarr;</a>
    </h3>
  </div>
</div>
