{% assign kgo_version = include.release | replace: ".x", "" %}
{% if include.release.label == "unreleased" %}
{% assign kgo_version = "nightly" %}
{% endif %}

Update the Helm repository:

```bash
helm repo add kong https://charts.konghq.com
helm repo update kong
```

Install {{ site.kgo_product_name }} with Helm:

{% if include.mode == "konnect" %}

```bash
helm upgrade --install kgo kong/gateway-operator -n kong-system --create-namespace --set image.tag={{ kgo_version }} --set env.ENABLE_CONTROLLER_KONNECT="true" --set kubernetes-configuration-crds.enabled="true"
```

{% endif %}

{% if include.mode == "aigateway" %}

```bash
helm upgrade --install kgo kong/gateway-operator -n kong-system --create-namespace --set image.tag={{ kgo_version }} --set env.ENABLE_CONTROLLER_AIGATEWAY="true"
```

{% endif %}

{% if include.mode == "default" %}

```bash
helm upgrade --install kgo kong/gateway-operator -n kong-system --create-namespace --set image.tag={{ kgo_version }}
```

{% endif %}

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/kgo-gateway-operator-controller-manager
```
