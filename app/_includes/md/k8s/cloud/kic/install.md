Set `ingressController.enabled` to `true` in your `values-{{ include.release }}.yaml` file to enable {{ site.kic_product_name }}.

You must also set `ingressController.env.kong_admin_token` to the value stored in `env.password` to enable communication between {{ site.kic_product_name }} and the {{ site.base_gateway }} Admin API.

```yaml
ingressController:
  enabled: true
  env:
    kong_admin_token: kong_admin_password
```