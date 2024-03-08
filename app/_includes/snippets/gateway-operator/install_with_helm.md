{% assign kgo_version = include.version %}
{% if include.release.label == "unreleased" %}
{% assign kgo_version = "nightly" %}
{% endif %}

{:.important}
> TODO: Use the actual chart rather than a local one in the following command.

```
helm install kgo ./gateway-operator -n kong-system --create-namespace --set image.tag={{ kgo_version }}
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/kgo-gateway-operator-controller-manager
```
