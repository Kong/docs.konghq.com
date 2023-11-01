---
title: Workspaces
type: tutorial
purpose: |
  How to use KIC to sync resources to a specific Kong Gateway workspace. Deploy multiple namespaces and use the --watch-namespace flag with a workspace.
enterprise: true
---


{{ site.kic_product_name }} can manage configuration in multiple workspaces when running in [DB-backed mode](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/db-backed/). Each workspace needs a different {{ site.kic_product_name }} instance with the `--watch-namespace` and `--kong-workspace` flags set.

* `--watch-namespace`: Namespace(s) to watch for Kubernetes resources. Defaults to all namespaces. To watch multiple namespaces, use a comma-separated list of namespaces.
* `--kong-workspace`: Kong Enterprise workspace to configure. Leave this empty if not using Kong workspaces.

Use this `values.yaml` when you install {{ site.kic_product_name }} using Helm to configure the namespace and workspace.

```yaml
gateway:
  ingressController:
    env:
      watch_namespace: mynamespacehere
      kong_workspace: workspacename
```

{{ site.kic_product_name }} watches for resources in the defined namespace and send them to the configured workspace. This allows teams to manage their own resources in Kubernetes and send them to their own workspace within {{ site.base_gateway }}.

