---
title: Using Kong Gateway Enterprise
---

{{ site.kic_product_name }} supports both {{ site.base_gateway }} OSS and Enterprise. If you install {{ site.kic_product_name }} using the default Helm charts, {{ site.base_gateway }} OSS will be installed.

To switch from {{ site.base_gateway }} OSS to {{ site.base_gateway }} Enterprise, choose the tab for the Helm chart that you're using, then set the following keys in your `values.yaml`:

{% navtabs %}
{% navtab kong/kong %}
```yaml
image:
  repository: kong/kong-gateway
  tag: {{ site.data.kong_latest_gateway.ee-version }}
```
{% endnavtab %}
{% navtab kong/ingress %}
```yaml
gateway:
  image:
    repository: kong/kong-gateway
    tag: {{ site.data.kong_latest_gateway.ee-version }}
```
{% endnavtab %}
{% endnavtabs %}

Once these changes have been made, switch to the new image:

```sh
helm upgrade <release_name> <chart_name> -n <namespace> --values ./values.yaml
```

You can check which images are being used with the following query:

```bash
kubectl get pods -n kong -o jsonpath="{.items[*].spec.containers[*].image}"
```
