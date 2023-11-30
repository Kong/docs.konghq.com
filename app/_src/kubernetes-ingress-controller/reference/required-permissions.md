---
title: Required permissions to use Kong Ingress Controller
type: reference
purpose: |
  What permissions are required to install Kong Ingress Controller if I am not a super admin of the cluster? What permissions are required to run Kong Ingress Controller?
---

To install {{ site.kic_product_name }}, you need to have the permissions to WRITE (create, update, get, list, watch in Kubernetes's RBAC model) these resources.

* For creating RBAC rules to enable {{ site.kic_product_name }} to access required resources, you need to have the permissions to create or update `ClusterRole`, `ClusterRoleBinding` in the cluster scope, and create or update `Role`,`RoleBinding` in the namespace in which you want to install {{ site.kic_product_name }}.

* To install CRDs required to configure Kong specific entities (for example, `KongPlugin` to configure plugins), you need to have the permissions to create and update `CustomResourceDefinition`.

* For creating resources required for {{ site.kic_product_name }}, you need to have the permissions to create or update `Deployment`, `Service`, `ServiceAccount`, `Secret`,  or `ConfigMap` to create deployments, services, and to specify their configurations. 

* If you run {{ site.kic_product_name }} with database-backed {{site.base_gateway}}, you also need to have the permissions to create or update `PersistentVolumeClaim` to set volumes used for the database, and `Job` to run migration jobs. 

* If you want to enable auto scaling, you also need permissions to create or update `HorizontalPodAutoscaler`.

* You also need the permissions to create or update `IngressClass` to install a ingress class managed by {{ site.kic_product_name }}, and `ValidatingWebhookConfiguration` to create a webhook to validate managed resources.

You need write access to the following resources to install {{ site.kic_product_name }}:

| Resource Kind                    | Resource APIVersion               | Resource Scope | Usage                              |
|----------------------------------|-----------------------------------|----------------|------------------------------------|
| `CustomResourceDefinition`       | `apiextensions.k8s.io/v1`         | cluster        | install CRDs                       | 
| `ClusterRole`                    | `rbac.authorization.k8s.io/v1`    | cluster        | install RBAC rules                 |
| `ClusterRoleBinding`             | `rbac.authorization.k8s.io/v1`    | cluster        | install RBAC rules                 |
| `Role`                           | `rbac.authorization.k8s.io/v1`    | namespaced     | install RBAC rules                 |
| `RoleBinding`                    | `rbac.authorization.k8s.io/v1`    | namespaced     | install RBAC rules                 |
| `Deployment`                     | `apps/v1`                         | namespaced     | install components                 |
| `Service`                        | `v1`                              | namespaced     | install components                 | 
| `ServiceAccount`                 | `v1`                              | namespaced     | install components                 |
| `Secret`                         | `v1`                              | namespaced     | set configurations and credentials |
| `ConfigMap`                      | `v1`                              | namespaced     | set configurations                 |
| `PersistentVolumeClaim`          | `v1`                              | namespaced     | claime volume for DB               |
| `Job`                            | `v1`                              | namespaced     | create DB migration jobs           | 
| `HorizontalPodAutoscaler`        | `autoscaling/v2`                  | namespaced     | configure auto scaling             |
| `IngressClass`                   | `networking.k8s.io/v1`            | cluster        | install ingress class              | 
| `ValidatingWebhookConfiguration` | `admissionregistration.k8s.io/v1` | cluster        | configure validating webhooks      |
