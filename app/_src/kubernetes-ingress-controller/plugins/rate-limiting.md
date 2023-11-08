---
title: Rate-Limiting
type: how-to
purpose: |
  How to configure the Rate-Limiting plugin
---
Kong can rate limit traffic without any external dependency. Kong stores the request counters in-memory and each Kong node applies the rate limiting policy independently without  synchronization of information. However, if Redis is available in your cluster, Kong can take advantage of it and synchronize the rate limit information across multiple Kong nodes and enforce a slightly different rate limiting policy. You can use Redis for rate limiting in a multi-node Kong deployment.

You can use the {{site.ee_product_name}} **Secrets Management** feature along with the example rate-limiting plugin. If you have an existing plugin that you wish to use Secrets Management with, you can skip directly to [the Secrets Management section](#optional-use-secrets-management) and use it for your plugin instead of the rate-limiting plugin.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

{% include /md/kic/test-service-echo.md kong_version=page.kong_version skip_host=true %}

{% include /md/kic/http-test-routing.md kong_version=page.kong_version skip_host=true %}

## Set up rate limiting

1. Create an instance of the rate-limiting plugin.

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
    kongplugin.configuration.konghq.com/rate-limit created
    ```
    
1. Associate the plugin with the Service.

    ```bash
    kubectl annotate service echo konghq.com/plugins=rate-limit
    ```

    The results should look like this:
    ```text
    service/echo annotated
    ```
    
1. Send requests through this Service to rate limiting response headers.

    ```bash
    curl -si $PROXY_IP/echo | grep RateLimit
    ```

    The results should look like this:
    ```text
    RateLimit-Limit: 5
    X-RateLimit-Remaining-Minute: 4
    X-RateLimit-Limit-Minute: 5
    RateLimit-Reset: 60
    RateLimit-Remaining: 4
    ```
1. Send repeated requests to decrement the remaining limit headers, and block requests after the fifth request.

    ```bash
    for i in `seq 6`; do curl -sv $PROXY_IP/echo 2>&1 | grep "< HTTP"; done
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

1. Scale your Deployment to three replicas, to test with multiple proxy instances.

    ```bash
    kubectl scale --replicas 3 -n kong deployment kong-gateway
    ```
    The results should look like this:
    ```text
    deployment.apps/kong-gateway scaled
    ```
1.  Check if the status of all the Pods that are `READY` is `Running` using the command `kubectl get pods -n kong`.

1. Sending requests to this Service does not reliably decrement the remaining counter.

    ```bash
    for i in `seq 10`; do curl -sv $PROXY_IP/echo 2>&1 | grep "X-RateLimit-Remaining-Minute"; done
    ```

    The results should look like this:
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

    The `policy: local` setting in the plugin configuration tracks request counters in each Pod's local memory separately. Counters are not synchronized across Pods, so clients can send requests past the limit without being throttled if they route through different Pods.

    Using a load balancer that distributes client requests to the same Pod can alleviate this somewhat, but changes to the number of replicas can still disrupt accurate accounting. To consistently enforce the limit, the plugin needs to use a shared set of counters across all Pods. The `redis` policy can do this when a Redis instance is available.

## Deploy Redis to your Kubernetes cluster

Redis provides an external database for Kong components to store shared data,
such as rate limiting counters. There are several options to install it:

Bitnami provides a [Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis)
for Redis with turnkey options for authentication.

1.  Create a password Secret and replace `PASSWORD` with a password of your choice.

    ```bash
    kubectl create -n kong secret generic redis-password-secret --from-literal=redis-password=PASSWORD
    ```
    The results should look like this:

    ```text
    secret/redis-password-secret created
    ```

1. Install Redis

    ```bash
    helm install -n kong redis oci://registry-1.docker.io/bitnamicharts/redis \
      --set auth.existingSecret=redis-password-secret \
      --set architecture=standalone
    ```
    Helm displays the instructions that describes the new installation.

1. Update your plugin configuration with the `redis` policy, Service, and credentials. Replace `PASSWORD` with the password that you set for Redis.

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
        "value":"redis-master"
      },
      {
        "op":"add",
        "path":"/config/redis_password",
        "value":"PASSWORD"
      }
    ]'
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/rate-limit patched
    ```

    If the `redis_username` is not set , it uses the default `redis` user.

## Test rate limiting is a multi-node Kong deployment

Send requests to the Service with rate limiting response headers.

```bash
for i in `seq 10`; do curl -sv $PROXY_IP/echo 2>&1 | grep "X-RateLimit-Remaining-Minute"; done
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
The counters decrement sequentially regardless of the {{site.base_gateway}} replica count.

{% if_version gte:2.11.x %}
## (Optional) Use Secrets Management 
{:.badge .enterprise}

Secrets Management is a {{site.ee_product_name}} feature for [storing sensitive
plugin configuration](/gateway/latest/kong-enterprise/secrets-management/#referenceable-plugin-fields) 
separately from the visible plugin configuration. The rate-limiting plugin
supports Secrets Management for its `redis_username` and `redis_password`
fields.

Secrets Management [supports several backend systems](/gateway/latest/kong-enterprise/secrets-management/backends/).
This guide uses the environment variable backend, which requires minimal
configuration and integrates well with Kubernetes' standard Secret-sourced
environment variables.

### Add environment variable from Secret

Update your proxy Deployment with an environment variable sourced from the
`redis-password-secret` Secret.

```bash
kubectl patch deploy -n kong kong-gateway --patch '
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
deployment.apps/kong-gateway patched
```


### Update the plugin to use a reference

After the vault has an entry, you can use a special
`{vault://VAULT-TYPE/VAULT-KEY}` value in plugin configuration instead of a
literal value. Patch the `rate-limit` KongPlugin to change the `redis_password`
value to a vault reference.

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

The updated KongPlugin propagates the reference to the proxy configuration.
You can confirm it by checking the admin API.

In one terminal, open a port-forward to the admin API:

```
kubectl port-forward deploy/kong-gateway -n kong 8444:8444
```

The results should look like this:
```text
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
