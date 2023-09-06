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

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version %}

## Set up rate limiting

We will start by creating a global rate limiting policy:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: global-rate-limit
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: \"true\"
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

Here we are configuring the {{site.base_gateway}} to rate limit traffic
from any client to 5 requests per minute, and we are applying this policy in a
global sense, meaning the rate limit will apply across all services.

You can set this up for a specific Ingress or a specific service as well,
please follow [using KongPlugin resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/)
guide on steps for doing that.

Next, test the rate limiting policy by executing the following command multiple
times and observe the rate limit headers in the response:

```bash
curl -I $PROXY_IP/foo/headers
```

As there is a single Kong instance running, Kong correctly imposes the rate
limit and you can make only 5 requests in a minute.

## Scale the controller to multiple pods

Now, let's scale up the {{site.kic_product_name}} deployment to 3 pods, for
scalability and redundancy:

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

It will take a couple minutes for the new pods to start up. Once the new pods
are up and running, test the rate limiting policy by executing the following
command and observing the rate limit headers:

```bash
curl -I $PROXY_IP/foo/headers
```

You will observe that the rate limit is not consistent anymore and you can make
more than 5 requests in a minute.

To understand this behavior, we need to understand how we have configured Kong.
In the current policy, each Kong node is tracking a rate limit in-memory and it
will allow 5 requests to go through for a client. There is no synchronization
of the rate limit information across Kong nodes. In use-cases where rate
limiting is used as a protection mechanism and to avoid over-loading your
services, each Kong node tracking its own counter for requests is good enough
as a malicious user will hit rate limits on all nodes eventually. Or if the
load-balancer in-front of Kong is performing some sort of deterministic hashing
of requests such that the same Kong node always receives the requests from a
client, then we won't have this problem at all.

In some cases, a synchronization of information that each Kong node maintains
in-memory is needed. For that purpose, Redis can be used. Let's go ahead and
set this up next.

## Deploy Redis to your Kubernetes cluster

First, we will deploy redis in our Kubernetes cluster:

```bash
kubectl apply -n kong -f https://bit.ly/k8s-redis
```

The results should look like this:
```text
deployment.apps/redis created
service/redis created
```

Once this is deployed, let's update our KongClusterPlugin configuration to use
Redis as a data store rather than each Kong node storing the counter
information in-memory:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: global-rate limit
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: \"true\"
config:
  minute: 5
  policy: redis
  redis_host: redis
plugin: rate-limiting
" | kubectl apply -f -
```

The results should look like this:
```text
kongclusterplugin.configuration.konghq.com/global-rate limit configured
```

Notice, how the `policy` is now set to `redis` and we have configured Kong
to talk to the `redis`  server available at `redis` DNS name, which is the
Redis node we deployed earlier.

## Test it

Now, if you go ahead and execute the following commands, you should be able
to make only 5 requests in a minute:

```bash
$ curl -I $PROXY_IP/foo/headers
```

This guide shows how to use Redis as a data-store for rate limiting plugin, but
this can be used for other plugins which support Redis as a data-store like
proxy-cache.
