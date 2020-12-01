---
title: Kong Enterprise in Kubernetes
---

# Install Options

Kong provides two main Enterprise packages that you can deploy with Kubernetes. These packages are normally deployed in one of three ways, each with its pros and cons which are outlined below:

1. **[Kong for Kubernetes Enterprise (K4K8s)](/enterprise/{{page.kong_version}}/deployment/installation/kong-for-kubernetes/)**: The Kong Ingress Controller (KIC) with
Enterprise plugins. \
_**Pros:** No DB required. Majority Kong Enterprise plugins are compatible_\
_**Cons:** Kong Manager, Vitals (analytics), Developer Portal, RBAC, Immunity, Workspaces are **disabled**._\
\
If you're interested in deploying this option, please click [here](/enterprise/{{page.kong_version}}/deployment/installation/kong-for-kubernetes/) for additional information and instructions.

2. **[Kong Enterprise on Kubernetes (w/KIC)](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes/)**: The whole Kong Enterprise platform
deployed on Kubernetes, **including**  Kong's Ingress Controller (documentation <a href="https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/design.md">here</a>).\
_**Pros:** Full platform is included: Kong Manager, Vitals (analytics), Developer Portal, RBAC, Immunity, Workspaces, etc. By installing Kong's Ingress Controller (KIC), you can configure the gateway the same way you configure K8s, using kubectl with declarative configuration files._\
_**Cons:** Requires a database. Need to deploy an ingress controller._\
\
If you're interested in deploying this option, please click [here](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes/) for additional information and instructions.

3. **[Kong Enterprise on Kubernetes (without KIC)](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes-without-kic/)**: The whole Kong Enterprise platform
deployed on Kubernetes, **without** the Kong Ingress Controller.\
_**Pros:** Full platform is included (Kong Manager, Vitals (analytics), Developer Portal, RBAC, Immunity, Workspaces, etc._\
_**Cons:** Requires a database. By **not** installing Kong's Ingress Controller (KIC),  you may need create Kubernetes services and DNS entries to properly expose the applications that live in your K8s cluster. _\
\
If you're interested in deploying this option, please click [here](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes-without-kic/) for additional information and instructions.


## See Also

For more information about the architecture of Kong's Ingress Controller (KIC), see
[Kong Ingress Controller Design](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/design.md).