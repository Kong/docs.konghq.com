Set `ingressController.enabled` to `true` in your `values-{{ include.release }}.yaml` file to enable {{ site.kic_product_name }}. When enabling the ingress controller, set `env.publish_service` to ensure that {{ site.kic_product_name }} populates the address field in the managed `Ingress` resources.

You must also set `ingressController.env.kong_admin_token` to the value stored in `env.password` to enable communication between {{ site.kic_product_name }} and the {{ site.base_gateway }} Admin API.

```yaml
ingressController:
  enabled: true
  env:
    publish_service: kong/kong-dp-kong-proxy
    kong_admin_token: kong_admin_password
```