---
title: Using Kubernetes Secrets in Plugins
type: how-to
purpose: |
  How to use a Kubernetes secret to configure a plugin
---

{{ site.kic_product_name }} allows you to configure {{ site.base_gateway }} plugins using the contents of a Kubernetes secret. The `configFrom` field in the `KongPlugin` resource allows you to set a `secretKeyRef` pointing to a Kubernetes secret.

This `KongPlugin` definition points to a secret named `rate-limit-redis` that contains a complete configuration for the plugin:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
 name: rate-limiting-example
plugin: rate-limiting
configFrom:
  secretKeyRef:
    name: rate-limit-redis
    key: config
" | kubectl apply -f -
```

The `rate-limit-redis` secret contains a complete configuration as a string:

```yaml
echo "
apiVersion: v1
kind: Secret
metadata:
  name: rate-limit-redis
stringData:
  config: |
    minute: 10
    policy: redis
    redis_host: redis-master
    redis_password: PASSWORD
type: Opaque
" | kubectl apply -f -
```

{{ site.kic_product_name }} resolves the referenced secrets and sends a complete configuration to {{ site.base_gateway }}.

{:.important}
> {{ site.kic_product_name }} resolves secrets _before_ sending the configuration to {{ site.base_gateway }}. Anyone with access to the {{ site.base_gateway }} pod can read the configuration, including secrets, from the admin API.