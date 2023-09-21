---
title: Install Kong Gateway Operator
content-type: tutorial
book: kgo-konnect-get-started
chapter: 1
---

{{ site.kgo_product_name }} can deploy and manage data planes attached to a {{ site.konnect_short_name }} control plane. All of your service, route and plugin configuration is performed in {{ site.konnect_short_name }} and sent down to running data planes automatically.

Use `kubectl kustomize` to install {{ site.kgo_product_name }}:

```bash
kubectl apply -k "https://github.com/kong/gateway-operator-docs/config/crd" --server-side
kubectl apply -k "https://github.com/kong/gateway-operator-docs/config/default"
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/gateway-operator-controller-manager
```

Once the operator is ready, you can deploy a `DataPlane` resource that is attached to a {{ site.konnect_short_name }} control plane.