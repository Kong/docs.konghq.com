---
title: Required Permissions to Use {{ site.kic_product_name }}
type: reference
purpose: |
  What permissions are required to install {{ site.kic_product_name }} if I am not a super admin of the cluster? What perssions are required to run {{ site.kic_product_name }}?
---

To install {{ site.kic_product_name }}, you need to have the perssion to WRITE (create, update, get, list, watch in Kubernetes's RBAC model) the following resources:

For creating RBAC rules to enable {{ site.kic_product_name }} to access requried resources, you need to have the permissions to create or update `ClusterRole`, `ClusterRoleBinding` in the cluster scope, and create or update `Role`,`RoleBinding` in the  namespace in which you want to install {{ site.kic_product_name }}.

To install CRDs required to configure Kong specific entities, like `KongPlugin` to configure plugins, you need to have the permissions to create and update `CustomResourceDefinition`.

For creating resources required for {{ site.kic_product_name }}, you need to have the permissions to create or update `Deployment`, `Service`, `ServiceAccount`, `Secret` or `ConfigMap` to create deployments, services and specify their configurations. If you run {{ site.kic_product_name }} with database backed {{site.base_gateway}}, you also need to have the permissions to create or update `PersistentVolumeClaim`  to set volumes used for database, and `Job` to run migration jobs. If you want to enable auto scaling, permissions to create or update `HorizontalPodAutoscaler`.

You also need the permissions to create or update `IngressClass` to install a ingress class managed by {{ site.kic_product_name }}, and `ValidatingWebhookConfiguration` to create a webhook to validate managed resources.

List of resources which you need write access to install {{ site.kic_product_name }}

| Resource Kind                    | Resource APIVersion            | Resource Scope | Usage |
|----------------------------------|--------------------------------|----------------|-------|
| `CustomResourceDefinition`       | `apiextensions.k8s.io/v1`      | cluster        | install CRDs | 
| `ClusterRole`                    | `rbac.authorization.k8s.io/v1` | cluster        | install RBAC rules |
| `ClusterRoleBinding`             | `rbac.authorization.k8s.io/v1` | cluster        | install RBAC rules |
| `Role`                           | `rbac.authorization.k8s.io/v1` | namespaced     | install RBAC rules |
| `RoleBinding`                    | `rbac.authorization.k8s.io/v1` | namespaced     | install RBAC rules |
| `Deployment`                     | `apps/v1`                      | namespaced     | install components |
| `Service`                        | `v1`                           | namespaced     | install components | 
| `ServiceAccount`                 | `v1`                           | namespaced     | install components |
| `Secret`                         | `v1`                           | namespaced     | set configurations and credentials |
| `ConfigMap`                      | `v1`                           | namespaced     | set configurations |
| `PersistentVolumeClaim`          | `v1`                           | namespaced     | claime volume for DB |
| `Job`                            | `v1`                           | namespaced     | create DB migration jobs | 
| `HorizontalPodAutoscaler`        | `autoscaling/v2`               | namespaced     | configure auto scaling |
| `IngressClass`                   | `networking.k8s.io/v1`         | cluster        | install ingress class | 
| `ValidatingWebhookConfiguration` | `admissionregistration.k8s.io/v1` | cluster     | configure validating webhook |

