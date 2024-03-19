{% assign kgo_version = include.version %}
{% if include.release.label == "unreleased" %}
{% assign kgo_version = "nightly" %}
{% endif %}

Update the Helm repository:

```bash
helm repo update kong
```

Install {{ site.kgo_product_name }} with Helm:

```bash
helm upgrade --install kgo kong/gateway-operator -n kong-system --create-namespace --set image.tag={{ kgo_version }}
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/kgo-gateway-operator-controller-manager
```
