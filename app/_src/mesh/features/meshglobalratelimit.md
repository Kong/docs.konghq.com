---
title: MeshGlobalRateLimit (beta) - Global Rate Limiting Policy 
content_type: reference
beta: true
---

This policy adds Global Rate Limit support for {{site.mesh_product_name}}.

## What is Global Rate limiting 

Rate limiting is a mechanism used to control the number of requests received by a service in a time unit. 
For example, you can limit your service to receive only 100 requests per second. 
Typical rate limit use cases:
- protect your service from DoS (Denial of Service) attack
- limit your API usage
- control traffic throughput

All rate limit algorithms are based on some form of request counting. In {{site.mesh_product_name}} we have two rate limiting mechanisms: 
local and global rate limit. Local rate limit is applied per service instance, because of this counters can be stored in memory and rate limit 
decision can be made instantaneously. Local rate limit should be enough in most cases (DoS protection and controlling traffic throughput).
You can find more information about local rate limit and how to configure it in [MeshRateLimit docs](/mesh/{{page.kong_version}}/policies/meshratelimit).

There are some cases when local rate limit won't solve your problems. For example, you may want to limit the number of requests that not paying users can 
make to your public API. In order to do that, you need to coordinate request counting between service instances. And that's where the Global Rate limit will be useful. 
Global rate limit moves counters from Data Plane Proxy to distributed cache. Thanks to this, you can configure longer time units like
week, month or year which will be immune to your service restarts.

## How Global Rate limit works

Global Rate limit is a more complex mechanism than local rate limit. It needs additional service that will take care of our global counters.

### Architecture overview

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service.png"/>
</center>

Global Rate limit adds two components to {{site.mesh_product_name}} deployment. We need ratelimit service that will manage our counters and 
highly available in-memory data store where we will store our counters. {{site.mesh_product_name}} uses [Redis](https://redis.io/) for this.

### Request flow

Let's assume that we have configured rate limiting for **Service B** from our diagram. If any service/gateway makes requests to **Service B**
it's Data Plane Proxy will make a request to ratelimit service to check if the request can be forwarded to **Service B**. Ratelimit service then
checks if counter for this service is below limits. If it is below limits, it updates the counter and allows the request to pass. If counters are above
limit, deny response is returned. 

{:.note}
> **Note**: You need to remember that configuring global ratelimit will increase yours service response times. Since it needs additional request 
> to ratelimit service and redis.

### Ratelimit service configuration

Beside basic service configuration that is provided on startup, ratelimit service needs limits configuration. Limits configuration
is loaded dynamically from control plane. Ratelimit service uses xDS protocol for this, which is the same protocol that Data Plane Proxy
uses for communicating with Control Plane. Control Plane will periodically compute new limits configuration and send it to ratelimit service.

### Rate limiting algorithm

Rate limit service uses fixed window algorithm. It allocates a new counter for every time unit. Let's assume that we have configured limits to 
10 requests per minute. At the beginning of each minute, ratelimit service will create a new counter. 

<center>
  <img src="/assets/images/docs/mesh/ratelimit-algorithm.png"/>
</center>

When a new request arrives, it updated counters in the window based on the request timestamp. This is simple algorithm but have two main problems about
which you should be aware:

1. counter can be depleted at the begging of the window
2. first counter can be depleted at the end of the window and the second can be depleted at the beginning of the window

The first scenario can be problematic for long time units like hours, and days. Because the limit is reached at the beginning of the time window
you service will not serve any requests for the rest of the time window. To solve this issue, you can split your limit from 60 per hour to 
1 per minute.

The second scenario could result in requests burst around the window switch. In this scenario when you configure limit to 100 requests per minute
you could end up in receiving 200 request in a couple of seconds.

### Multizone deployment

When it comes to multizone deployment, you should deploy ratelimit service in every zone. As for the Redis you have two options:

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service-multizone-multi-redis.png"/>
</center>

First option is to deploy Redis in every zone. In this setup, limits will be applied per zone. Since each zone will have its own counters cache, 
requests will be faster, and it will be easier to distribute your system geographically.

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service-multizone-single-redis.png"/>
</center>

The second option is to deploy single Redis for all your zones. In this setup, the rate limit will be truly global. When deploying single Redis
you need to remember that if your zones are distributed geographically requests to Redis can become slower which could drastically 
increase response times of service you are rate limiting. 

### Ratelimit service security

#### Securing communication between ratelimit service and Control Plane

Communication between ratelimit service and control plane is encrypted. On top of that we are using on Universal we are using zone token
for authorization and on Kubernetes we are using service account for authorization. 

TODO: document how to generate and use zone token on universal. 

## TargetRef support matrix

| TargetRef type    | top level | to  | from |
| ----------------- | --------- | --- | ---- |
| Mesh              | ✅        | ❌  | ✅   |
| MeshSubset        | ❌        | ❌  | ❌   |
| MeshService       | ✅        | ❌  | ❌   |
| MeshServiceSubset | ❌        | ❌  | ❌   |
| MeshGatewayRoute  | ❌        | ❌  | ❌   |

To learn more about the information in this table, see the [matching docs](/mesh/{{page.kong_version}}/policies/targetref).

## Configuration

Below you can find examples for `MeshGlobalRateLimit` configuration

### Full example

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGlobalRateLimit
metadata:
  name: demo-rate-limit
  namespace: {{ site.mesh_namespace }}
spec:
  targetRef:
    kind: MeshService
    name: demo-app_kuma-demo_svc_5000
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
            num: 100
            interval: 1s # only 1s, 1m, 1h, 24h can be specified
          onRateLimit:
            status: 423
            headers:
              set:
                - name: "x-kuma-rate-limited"
                  value: "true"
              add:
                - name: "x-kuma-header"
                  value: "true"
        mode: Limit # allowed: Limit, Shadow
        backend:
          rateLimitService:
            url: http://ratelimit-service.{{ site.mesh_namespace }}:10003
            timeout: 25ms
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: MeshGlobalRateLimit
name: demo-rate-limit
mesh: default
spec:
  targetRef:
    kind: MeshService
    name: demo-app
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
            num: 100
            interval: 1s # only 1s, 1m, 1h, 24h can be specified
          onRateLimit:
            status: 423
            headers:
              set:
                - name: "x-kuma-rate-limited"
                  value: "true"
              add:
                - name: "x-kuma-header"
                  value: "true"
        mode: Limit # allowed: Limit, Shadow
        backend:
          rateLimitService:
            url: http://ratelimit-service:10003
            timeout: 25ms
```

{% endnavtab %}
{% endnavtabs %}

#### Applying configuration to DPP and ratelimit service

After applying your policy control plane is building two configs one for DPP and second one for ratelimit service. Ratelimit service configuration 
is build from you service name and `requestRate` policy parameter. Rest of the policy is translated to DPP configuration. 

### Configure reusable ratelimit service backend

You can configure ratelimit service backend for the whole mesh. Which will simplify per service configuration.

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGlobalRateLimit
metadata:
  name: ratelimit-backend
  namespace: {{ site.mesh_namespace }}
spec:
  targetRef:
    kind: Mesh
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          onRateLimit:
            status: 423
            headers:
              set:
                - name: "x-kuma-rate-limited"
                  value: "true"
        mode: Limit
        backend:
          rateLimitService:
            url: http://ratelimit-service.{{ site.mesh_namespace }}:10003
            timeout: 25ms
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: MeshGlobalRateLimit
name: ratelimit-backend
mesh: default
spec:
  targetRef:
    kind: Mesh
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          onRateLimit:
            status: 423
            headers:
              set:
                - name: "x-kuma-rate-limited"
                  value: "true"
        mode: Limit
        backend:
          rateLimitService:
            url: http://ratelimit-service:10003
            timeout: 25ms
```

{% endnavtab %}
{% endnavtabs %}

Then you can configure only limits for each service: 

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGlobalRateLimit
metadata:
  name: demo-rate-limit
  namespace: {{ site.mesh_namespace }}
spec:
  targetRef:
    kind: MeshService
    name: demo-app_kuma-demo_svc_5000
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
              num: 100
              interval: 1s    
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: MeshGlobalRateLimit
name: demo-rate-limit
mesh: default
spec:
  targetRef:
    kind: MeshService
    name: demo-app
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
              num: 100
              interval: 1s
```

{% endnavtab %}
{% endnavtabs %}

### Combining MeshRateLimit with MeshGlobalRateLimit

You can combine MeshRateLimit and MeshGlobalRateLimit policies. By doing this, you can specify local limit that will be more strict than the global rate limit.
When local rate limit is reached, DPP will stop sending requests to ratelimit service. 

This could **lower network traffic** between DPP and ratelimit service. Also, it can protect ratelimit service from being DDoSed by your services. 
Moreover, this could be used to more **evenly distribute traffic** to ratelimit service and mitigate the problem of depleting whole limit at the begging of counter window.
Described in [previous section](/mesh/{{page.kong_version}}/features/meshglobalratelimit/#rate-limiting-algorithm).

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshRateLimit
metadata:
  name: demo-local-rate-limit
  namespace: kuma-system
spec:
  targetRef:
    kind: MeshService
    name: demo-app_kuma-demo_svc_5000
  from:
    - targetRef:
        kind: Mesh
      default:
        local:
          http:
            requestRate:
              num: 10
              interval: 10s
---
apiVersion: kuma.io/v1alpha1
kind: MeshGlobalRateLimit
metadata:
  name: demo-global-rate-limit
  namespace: {{ site.mesh_namespace }}
spec:
  targetRef:
    kind: MeshService
    name: demo-app_kuma-demo_svc_5000
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
            num: 60
            interval: 1m
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: MeshRateLimit
mesh: default
name: demo-local-rate-limit
spec:
  targetRef:
    kind: MeshService
    name: demo-app
  from:
    - targetRef:
        kind: Mesh
      default:
        local:
          http:
            requestRate:
              num: 10
              interval: 10s
---
type: MeshGlobalRateLimit
name: demo-global-rate-limit
mesh: default
spec:
  targetRef:
    kind: MeshService
    name: demo-app
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
            num: 60
            interval: 1m
```

{% endnavtab %}
{% endnavtabs %}

### External Service support

In order to rate limit requests to [External Service](/mesh/{{page.kong_version}}/policies/external-services) you need to deploy [ZoneEgress](/mesh/{{page.kong_version}}/explore/zoneegress). 

After deploying Zone Egress, you need to enable mTLS in your mesh and configure zone egress routing. Example mesh config:

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  routing:
    zoneEgress: true
  mtls:
    enabledBackend: ca-1
    backends:
      - name: ca-1
        type: builtin
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: Mesh
name: default
routing:
  zoneEgress: true
mtls:
  enabledBackend: ca-1
  backends:
    - name: ca-1
      type: builtin
```

{% endnavtab %}
{% endnavtabs %}

After configuring your mesh you can create your External Service:

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: ExternalService
mesh: default
metadata:
  name: httpbin
spec:
  tags:
    kuma.io/service: httpbin
    kuma.io/protocol: http 
  networking:
    address: httpbin.org:443
    tls:
      enabled: true
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: ExternalService
mesh: default
name: httpbin
tags:
  kuma.io/service: httpbin
  kuma.io/protocol: http
networking:
  address: httpbin.org:443
  tls:
    enabled: true
```

{% endnavtab %}
{% endnavtabs %}

When applying policies, External Services are treated as normal Mesh Services, so we could configure MeshGlobalRatelimit like this:

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGlobalRateLimit
metadata:
  name: httpbin-rate-limit
  namespace: {{ site.mesh_namespace }}
spec:
  targetRef:
    kind: MeshService
    name: httpbin
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
              num: 100
              interval: 1s    
```

{% endnavtab %}
{% navtab Universal %}

```yaml
type: MeshGlobalRateLimit
name: httpbin-rate-limit
mesh: default
spec:
  targetRef:
    kind: MeshService
    name: httpbin
  from:
    - targetRef:
        kind: Mesh
      default:
        http:
          requestRate:
              num: 100
              interval: 1s
```

{% endnavtab %}
{% endnavtabs %}

## Ratelimit Service

{{site.mesh_product_name}} is using **Envoy Rate Limit service reference implementation**. Its source code with documentation can be found [here](https://github.com/envoyproxy/ratelimit).

### Deployment

On Universal, you need to take care of deploying Redis and ratelimit service on your own. On Kubernetes, you could use {{site.mesh_product_name}} Helm charts 
to deploy ratelimit service, but you still need to deploy Redis on your own.

### How to read limits configuration

When you expose debug port on ratelimit service, you can get access to limits configuration, at `/rlconfig` path.
Here is an example configuration that you will see something like this:

```
default.kuma.io/service_demo-app_kuma-demo_svc_5000: unit=SECOND requests_per_unit=10, shadow_mode: false
```

This config follows a pattern: 
```
mesh.descriptorKey_descriptorValue
```
Descriptor key will always be `kuma.io/service`, and descriptor value will be your Mesh Service name. 
Therefore, we can deduct that this config will apply to `demo-app_kuma-demo_svc_5000` service in `default`
mesh. The second part of the configuration is rather straight forward. We have information of request limit and unit to which 
this limit will be applied. Shadow mode specifies if request should be limited after reaching the configured limit. If `shadow_mode` is set 
to `true`, ratelimit service will not deny requests to your service, it will only update ratelimit service metrics.

### Performance improvements

Ratelimit service offers two mechanisms for tweaking its performance. [Local cache for depleted counters](https://github.com/envoyproxy/ratelimit#local-cache) and [Redis query pipelining](https://github.com/envoyproxy/ratelimit#pipelining). 
You should refer to ratelimit service documentation for more concrete documentation and setup.

## Example Ratelimit setup

### Prerequisites

- Kubernetes cluster on which you will run demo
- `Helm` installed
- `kumactl` installed locally

### Example

The following example shows how to deploy and test a sample `MeshGlobalRateLimit` policy on Kubernetes, using the kuma-demo application.

1. First, we need to deploy Redis in our Kubernetes cluster:

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install --create-namespace --namespace {{ site.mesh_namespace }} redis bitnami/redis
    ```

1. Redis should be now installed, and you should have secret with Redis password. You can check if it is present with command:
  
    ```bash
    kubectl -n kong-mesh-system get secret redis 
    ```

1. Next, you need to create value files that will be used for control plane installation

    ```
    echo "ratelimit:
      enabled: true
      exposeDebugPort: true
      redis:
        address: redis-master
        port: 6379
      secrets:
        redisAuth:
          Secret: redis
          Key: redis-password
          Env: REDIS_AUTH" > values.yaml
    ```

1. Now we can deploy our control plane

    ```bash
    kumactl install control-plane --values values.yaml | kubectl apply -f -
    ```

1. We now have our control plane with ratelimit setup, so we can install demo app

    ```bash
    kumactl install demo | k apply -f -
    ```

1. After deploying the demo app, you can apply a sample policy:

    ```bash
    echo "apiVersion: kuma.io/v1alpha1
    kind: MeshGlobalRateLimit
    metadata:
      name: demo-rate-limit
      namespace: {{ site.mesh_namespace }}
    spec:
      targetRef:
        kind: MeshService
        name: demo-app_kuma-demo_svc_5000
      from:
        - targetRef:
            kind: Mesh
          default:
            http:
              requestRate:
                num: 10
                interval: 1m
              onRateLimit:
                status: 423
            backend:
              rateLimitService:
                url: http://kong-mesh-ratelimit-service.kong-mesh-system:10003
                timeout: 1s" | kubectl apply -f -
    ```

2. We are all set up. Now you can try making few requests to external IP of your gateway, and you will see error after reaching limits. You can find this IP with command:

    ```bash
    kubectl -n kuma-demo get service demo-app-gateway
    ```

    We invite you to play more with this demo, change limits, or try out other examples from this documentation.