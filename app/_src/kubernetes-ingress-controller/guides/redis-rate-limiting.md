---
title: Using Redis for rate limiting
---

Kong can rate limit your traffic without any external dependency. In such a
case, Kong stores the request counters in-memory and each Kong node applies the
rate limiting policy independently. There is no synchronization of information
being done in this case. But if Redis is available in your cluster, Kong can
take advantage of it and synchronize the rate limit information across multiple
Kong nodes and enforce a slightly different rate limiting policy.

This guide walks through the steps of using Redis for rate limiting in a
multi-node Kong deployment.

This guide also covers use of the {{site.ee_product_name}} **Secrets
Management** feature along with the example rate-limiting plugin. If you have
an existing plugin you wish to use Secrets Management with, you can skip
directly to [the Secrets Management section](#optional-use-secrets-management)
and use it for your plugin instead of the example rate-limiting plugin.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version %}

## Set up rate limiting

Create an instance of the rate-limiting plugin:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 5
  policy: local
plugin: rate-limiting
" | kubectl apply -f -
```

The results should look like this:
```text
kongclusterplugin.configuration.konghq.com/global-rate-limit created
```

After, attach it to the example Service:

```bash
kubectl annotate service echo konghq.com/plugins=rate-limit
```

The results should look like this:
```text
service/echo annotated
```

Requests through this Service will now return rate limiting response headers:

```bash
curl -si http://kong.example/echo --resolve kong.example:80:$PROXY_IP | grep RateLimit
```

The results should look like this:
```text
RateLimit-Limit: 5
X-RateLimit-Remaining-Minute: 4
X-RateLimit-Limit-Minute: 5
RateLimit-Reset: 60
RateLimit-Remaining: 4
```

Sending repeated requests will decrement the remaining limit headers, and will
block requests after the fifth request:

```
for i in `seq 6`; do curl -sv http://kong.example/echo --resolve kong.example:80:$PROXY_IP 2>&1 | grep "< HTTP"; done
```

The results should look like this:
```text
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 200 OK
< HTTP/1.1 429 Too Many Requests
```

## Scale to multiple pods

To demonstrate behavior with multiple proxy instances, scale your Deployment
beyond a single replica:

```bash
kubectl scale --replicas 3 -n kong deployment ingress-kong
```
{:.note}
> Your Deployment name will vary depending on your install method. You can list
> your Deployment(s) with `kubectl get deploy -n kong`. Replace `ingress-kong`
> with your actual Deployment name.

The results should look like this:
```text
deployment.extensions/ingress-kong scaled
```

Once `kubectl get pods -n kong` shows all new Pods as Ready, sending requests
will no longer reliably decrement the remaining counter:

```
for i in `seq 10`; do curl -sv http://kong.example/echo --resolve kong.example:80:$PROXY_IP 2>&1 | grep "X-RateLimit-Remaining-Minute"; done
```

The results should look similar to this:
```text
< X-RateLimit-Remaining-Minute: 4
< X-RateLimit-Remaining-Minute: 4
< X-RateLimit-Remaining-Minute: 3
< X-RateLimit-Remaining-Minute: 4
< X-RateLimit-Remaining-Minute: 3
< X-RateLimit-Remaining-Minute: 2
< X-RateLimit-Remaining-Minute: 3
< X-RateLimit-Remaining-Minute: 2
< X-RateLimit-Remaining-Minute: 1
< X-RateLimit-Remaining-Minute: 1
```

The `policy: local` setting in the plugin configuration tracks request counters
in each Pod's local memory separately. Counters are not synchronized across
Pods, so clients can send requests past the limit without being throttled if
they route through different Pods.

Using a load balancer that distributes client requests to the same Pod can
alleviate this somewhat, but changes to the number of replicas can still
disrupt accurate accounting. To consistently enforce the limit, the plugin
needs to use a shared set of counters across all Pods. The `redis` policy can
do this when a Redis instance is available.

## Deploy Redis to your Kubernetes cluster

Redis provides an external database for Kong components to store shared data,
such as rate limiting counters. There are several options to install it:

Bitnami provides a [Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis)
for Redis with turnkey options for authentication. To install it, first create
a password Secret:

```bash
kubectl create -n kong secret generic redis-password-secret --from-literal=redis-password=PASSWORD
```
Replace `PASSWORD` with your actual password.

The results should look like this:

```text
secret/redis-password-secret created
```

After, install a chart release using the Secret:

```bash
helm install -n kong kong oci://registry-1.docker.io/bitnamicharts/redis \
  --set auth.existingSecret=redis-password-secret \
  --set architecture=standalone
```
Helm will output a page of instructions describing the new installation.

With Redis deployed, you can update your plugin configuration with the `redis`
policy, Service, and credentials:

```bash
kubectl patch kongplugin rate-limit --type json --patch '[
  {
    "op":"replace",
    "path":"/config/policy",
    "value":"redis"
  },
  {
    "op":"add",
    "path":"/config/redis_host",
    "value":"kong-redis-master"
  },
  {
    "op":"add",
    "path":"/config/redis_password",
    "value":"PASSWORD"
  }
]'
```

Replace `PASSWORD` with your actual password.

The results should look like this:
```text
kongplugin.configuration.konghq.com/rate-limit patched
```

Omitting the `redis_username` setting uses the default `redis` user.
{% if_version gte:2.11.x %}
## (Optional) Use Secrets Management 
{:.badge .enterprise}

{:.badge .enterprise}

Secrets Management is a {{site.ee_product_name}} feature for [storing sensitive
plugin configuration](/gateway/latest/kong-enterprise/secrets-management/#referenceable-plugin-fields) 
separately from the visible plugin configuration. The rate-limiting plugin
supports Secrets Management for its `redis_username` and `redis_password`
fields.

Secrets Management [supports several backend systems](/gateway/latest/kong-enterprise/secrets-management/backends/).
This guide will use the environment variable backend, which requires minimal
configuration and integrates well with Kubernetes' standard Secret-sourced
environment variables.

### Add environment variable from Secret

Update your proxy Deployment with an environment variable sourced from the
`redis-password-secret` Secret:

```bash
kubectl patch deploy ingress-kong --patch '
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "proxy",
            "env": [
              {
                "name": "SECRET_REDIS_PASSWORD",
                "valueFrom": {
                  "secretKeyRef": {
                    "name": "redis-password-secret",
                    "key": "redis-password"
                  }
                }
              }
            ]
          }
        ]
      }
    }
  }
}'
```

The results should look like this:
```text
deployment.apps/ingress-kong patched
```


### Update the plugin to use a reference

Once a vault has an entry, you can use a special
`{vault://VAULT-TYPE/VAULT-KEY}` value in plugin configuration instead of a
literal value. Patch the `rate-limit` KongPlugin to change the `redis_password`
value to a vault reference:

```bash
kubectl patch kongplugin rate-limit --type json --patch '[
  {
    "op":"replace",
    "path":"/config/redis_password",
    "value":"{vault://env/secret-redis-password}"
  }
]'
```

### Check plugin configuration

The updated KongPlugin will propagate the reference to the proxy configuration.
You can confirm it by checking the admin API.

In one terminal, open a port-forward to the admin API:

```
kubectl port-forward deploy/ingress-kong 8444:8444
```

The results should look like this:
```text
"{vault://env/secret-redis-password}"
Forwarding from 127.0.0.1:8444 -> 8444
```

In a separate terminal, query the `/plugins` endpoint and filter out the
rate-limiting plugin:

```
curl -ks https://localhost:8444/plugins/ | jq '.data[] | select(.name="rate-limiting") | .config.redis_password'
```

The results should look like this:
```text
"{vault://env/secret-redis-password}"
```
{% endif_version %}

## Test it

Requests will now decrement counters sequentially regardless of the
{{site.base_gateway}} replica count:

```bash
for i in `seq 10`; do curl -sv http://kong.example/echo --resolve kong.example:80:$PROXY_IP 2>&1 | grep "X-RateLimit-Remaining-Minute"; done
```

The results should look like this:
```text
< X-RateLimit-Remaining-Minute: 4
< X-RateLimit-Remaining-Minute: 3
< X-RateLimit-Remaining-Minute: 2
< X-RateLimit-Remaining-Minute: 1
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Remaining-Minute: 0
```
