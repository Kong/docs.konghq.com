{% assign kgo_version = include.release | replace: ".x", "" %}
{% assign unreleased = false %}

{% if include.release.label == "unreleased" %}
{% assign unreleased = true %}
{% assign kgo_version = "nightly" %}
{% endif %}

Update the Helm repository:

```bash
helm repo add kong https://charts.konghq.com
helm repo update kong
```

Install {{ site.kgo_product_name }} with Helm:

```bash
helm upgrade --install kgo kong/gateway-operator -n kong-system --create-namespace {% if unreleased %}\
  --set image.repository=kong/nightly-gateway-operator{% endif %} \
  --set image.tag={{ kgo_version }}{% if include.kconfCRDs %} \
  --set kubernetes-configuration-crds.enabled=true{% endif %}{% if include.konnectEntities %} \
  --set env.ENABLE_CONTROLLER_KONNECT=true{% endif %}{% if include.aiGateway %} \
  --set env.ENABLE_CONTROLLER_AIGATEWAY=true{% endif %}{% if include.kongPluginInstallation %} \
  --set env.ENABLE_CONTROLLER_KONGPLUGININSTALLATION=true{% endif %}
```

You can wait for the operator to be ready using `kubectl wait`:

```bash
kubectl -n kong-system wait --for=condition=Available=true --timeout=120s deployment/kgo-gateway-operator-controller-manager
```
