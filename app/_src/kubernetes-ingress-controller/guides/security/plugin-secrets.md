---
title: Using Kubernetes Secrets in Plugins
type: how-to
purpose: |
  How to use a Kubernetes secret to configure a plugin
---

## Loading complete plugin's configuration from a secret 

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

{% if_version gte:3.1.x %}
## Loading a single plugin's configuration's field from a secret 

{{ site.kic_product_name }} from version v3.1 allows you to load a single field of a plugin's configuration from a Kubernetes secret.
`configPatches` field in the `KongPlugin` resource allows you to set a `path` to a field in the `KongPlugin`
and a `valueFrom` that points to a Kubernetes secret (and its field) that the configuration field value should be loaded from.

Let's say you have a `KongPlugin` definition that contains a `password` field. 
```bash
echo "
apiVersion: v1
kind: Secret
metadata:
  name: rate-limit-redis
stringData:
  password: PASSWORD
type: Opaque" | kubectl apply -f -
```

You can use the following `KongPlugin` definition to load the `password` field from the `rate-limit-redis` secret.

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
 name: rate-limiting-example
plugin: rate-limiting
config: # You can define the non-sensitive part of the config explicitly here.
  minute: 10
  policy: redis
  redis_host: redis-master
configPatches:
  - path: redis_password # This is the path to the field in the plugin's configuration this patch will populate.
    valueFrom:
      secretKeyRef:
        name: rate-limit-redis # This is the name of the secret.
        key: password          # This is the key in the secret.
" | kubectl apply -f -
```

This way, {{ site.kic_product_name }} resolves the referenced secret and builds the complete configuration for the plugin
that is sent to {{ site.base_gateway }}. The assembled configuration will look like this:

```yaml
minute: 10
policy: redis
redis_host: redis-master
redis_password: PASSWORD
```
{% endif_version %}
