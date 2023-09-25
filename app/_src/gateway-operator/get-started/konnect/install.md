---
title: Install Kong Gateway Operator
content-type: tutorial
book: kgo-konnect-get-started
chapter: 1
---

{{ site.kgo_product_name }} can deploy and manage data planes attached to a {{ site.konnect_short_name }} control plane. All the services, routes, and plugins are configured in {{ site.konnect_short_name }} and sent to the data planes automatically.

Use `kubectl` to install {{ site.kgo_product_name }}:

```bash
kubectl apply -f {{site.links.web}}/assets/gateway-operator/v{{page.version}}/crds.yaml --server-side
kubectl apply -f {{site.links.web}}/assets/gateway-operator/v{{page.version}}/default.yaml
```

You can wait for the operator to be ready using `kubectl wait`.

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/gateway-operator-controller-manager
```

Once the `gateway-operator-controller-manager` deployment is ready, you can deploy a `DataPlane` resource that is attached to a {{ site.konnect_short_name }} control plane.
