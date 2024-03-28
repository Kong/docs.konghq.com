---
title: MeshGlobalRateLimit Policy (beta)  
content_type: reference
beta: true
badge: enterprise
---

This policy adds Global Rate Limit support for {{site.mesh_product_name}}.

## What is global rate limiting 

Rate limiting is a mechanism used to control the number of requests received by a service in a time unit. 
For example, you can limit your service to receive only 100 requests per second. 
Typical rate limit use cases include the following:
- Protecting your service from DoS (Denial of Service) attack
- Limiting your API usage
- Controlling traffic throughput

All rate limit algorithms are based on some form of request counting. In {{site.mesh_product_name}}, there are two rate limiting mechanisms: 
local and global rate limit. 

Local rate limit is applied per service instance. Because of this, counters can be stored in memory and rate limit 
decisions can be made instantaneously. Local rate limiting should be enough in most cases (for example, DoS protection and controlling traffic throughput).
You can find more information about local rate limit and how to configure it in [MeshRateLimit docs](/mesh/{{page.release}}/policies/meshratelimit).

There are some cases when local rate limit won't solve your problems. For example, you may want to limit the number of requests that non-paying users can 
make to your public API. To do that, you must coordinate request counting between service instances, which the global rate limit can help you with.
Global rate limit moves counters from data plane proxy to distributed cache. Because of this, you can configure longer time units (like
week, month, or year) which will be immune to your service restarts.

## How Global Rate limit works

Global rate limiting is a more complex than local rate limit. It needs an additional service that will manage the global counters.

### Architecture overview

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service.png"/>
</center>
> Figure 1: Diagram of how the global rate limit interacts with two services (Service A and Service B), {{site.service_mesh_name}}, and Redis.

Global rate limit adds two components to your {{site.mesh_product_name}} deployment. You need the ratelimit service that will manage your counters and 
highly available in-memory data store where you will store your counters. {{site.mesh_product_name}} uses [Redis](https://redis.io/) for this.

### Request flow

Let's assume that we have configured rate limiting for **Service B** from our diagram. If any service/gateway makes requests to **Service B**,
its data plane proxy will make a request to the ratelimit service to check if the request can be forwarded to **Service B**. The ratelimit service then
checks if the counter for this service is below limits. If it is below limits, it updates the counter and allows the request to pass. If counters are above
limits, deny response is returned. 

{:.note}
> **Note**: Configuring global rate limit will increase your service response times because it needs additional requests to the ratelimit service and Redis.

### Ratelimit service configuration

Besides the basic service configuration that is provided on startup, the ratelimit service needs a limits configuration. Limits configuration
is loaded dynamically from the control plane. Ratelimit service uses xDS protocol for this, which is the same protocol that the data plane proxy
uses for communicating with the control plane. The control plane will periodically compute any new limits configuration and send it to ratelimit service.

### Rate limiting algorithm

The ratelimit service uses a fixed window algorithm. It allocates a new counter for each time unit. Let's assume that we have configured limits to 
10 requests per minute. At the beginning of each minute, ratelimit service will create a new counter. 

<center>
  <img src="/assets/images/docs/mesh/ratelimit-algorithm.png"/>
</center>
> Figure 2: Diagram showing how rate limit counters are placed on timeline and how request is qualified for specific time window.

When a new request arrives, it updates the counters in the window based on the request timestamp. Be aware of the following when configuring counters:

* The counter can be depleted at the beginning of the window.
* The first counter can be depleted at the end of the window and the second can be depleted at the beginning of the window.

The first scenario can be problematic for long time units like hours and days. Because the limit is reached at the beginning of the time window,
your service will not serve any requests for the rest of the time window. To solve this issue, you can split your limit from 60 per hour to 
one per minute.

The second scenario could result in requests burst around the window switch. In this scenario, when you configure the ratelimit to 100 requests per minute
you could end up receiving 200 request in a couple of seconds.

### Multi-zone deployment

When it comes to multi-zone deployments, you should deploy the ratelimit service in every zone. As for Redis, you have two options:

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service-multizone-multi-redis.png"/>
</center>
> Figure 3: Diagram of multi-zone ratelimit setup with Redis per zone.

The first option is to deploy Redis in every zone. In this setup, limits will be applied per zone. Since each zone will have its own counters cache, 
requests will be faster, and it will be easier to distribute your system geographically.

<center>
  <img src="/assets/images/docs/mesh/ratelimit-service-multizone-single-redis.png"/>
</center>
> Figure 4: Diagram of multi-zone ratelimit setup with global Redis.

The second option is to deploy a single Redis datastore for all your zones. In this setup, the rate limit will be truly global. When deploying a single Redis datastore, remember that if your zones are distributed geographically requests to Redis can become slower which could drastically 
increase response times of service you are rate limiting. 

<!-- ### Securing communication between ratelimit service and Control Plane

Communication between the ratelimit service and control plane is encrypted. In addition, zone token authorization is used on Universal and  service account authorization is used on Kubernetes.

TODO: document how to generate and use zone token on universal.-->

## TargetRef support matrix

{% if_version gte:2.7.x %}
{% tabs targetRef useUrlFragment=false %}
{% tab targetRef Sidecar %}
| `targetRef`             | Allowed kinds                         |
| ----------------------- | ------------------------------------- |
| `targetRef.kind`        | `Mesh`, `MeshSubset`, `MeshService`   |
| `from[].targetRef.kind` | `Mesh`                                |
{% endtab %}

{% tab targetRef Builtin Gateway %}
| `targetRef`             | Allowed kinds                                             |
| ----------------------- | --------------------------------------------------------- |
| `targetRef.kind`        | `Mesh`, `MeshGateway`                                     |
| `to[].targetRef.kind` | `Mesh`                                                    |
{% endtab %}
{% endtabs %}

{% endif_version %}
{% if_version lte:2.5.x %}

| TargetRef type    | Top level | To  | From |
| ----------------- | --------- | --- | ---- |
| Mesh              | ✅        | ❌  | ✅   |
| MeshSubset        | ❌        | ❌  | ❌   |
| MeshService       | ✅        | ❌  | ❌   |
| MeshServiceSubset | ❌        | ❌  | ❌   |
| MeshGatewayRoute  | ❌        | ❌  | ❌   |

{% endif_version %}


To learn more about the information in this table, see the [matching docs](/mesh/{{page.release}}/policies/targetref).

## Configuration

In the following sections, you can find examples for the `MeshGlobalRateLimit` configuration.

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
            url: http://kong-mesh-ratelimit-service.{{ site.mesh_namespace }}:10003
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
            url: http://kong-mesh-ratelimit-service:10003
            timeout: 25ms
```

{% endnavtab %}
{% endnavtabs %}

#### Applying configuration to the data plane proxy and the ratelimit service

After applying your policy, the control plane builds two configurations, one for the data plane proxy and one for the ratelimit service. The ratelimit service configuration 
is built from you service name and `requestRate` policy parameter. The rest of the policy is translated to data plane proxy configuration. 

### Configure a reusable ratelimit service backend

To simplify your per service configuration, you can configure the ratelimit service backend for the whole mesh. 

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
            url: http://kong-mesh-ratelimit-service.{{ site.mesh_namespace }}:10003
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
            url: http://kong-mesh-ratelimit-service:10003
            timeout: 25ms
```

{% endnavtab %}
{% endnavtabs %}

Then you only have to configure limits for each service: 

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

You can combine MeshRateLimit and MeshGlobalRateLimit policies. By doing this, you can specify a local limit that is more strict than the global rate limit.
When the local rate limit is reached, the data plane proxy will stop sending requests to ratelimit service. 

This could lower network traffic between the data plane proxy and the ratelimit service. Also, it can protect your ratelimit service from a DDoS "attack" by your services. 
Moreover, this could be used to more evenly distribute traffic to the ratelimit service and mitigate the problem of depleting whole limit at the beginning of the counter window.
This is described in the [previous section](/mesh/{{page.release}}/features/meshglobalratelimit/#rate-limiting-algorithm).

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

### External service support

To rate limit requests to [External Service](/mesh/{{page.release}}/policies/external-services) you must deploy [ZoneEgress](/mesh/{{page.release}}/production/cp-deployment/zoneegress/).

After deploying Zone Egress, you must enable mTLS in your mesh and configure zone egress routing. Here's an example mesh configuration:

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

After configuring your mesh, you can create your external service:

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

When applying policies, external services are treated as normal mesh services, so we configure MeshGlobalRateLimit like this:

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

## Ratelimit service

{{site.mesh_product_name}} is using the Envoy Rate Limit service reference implementation. You can read the [source code and documentation](https://github.com/envoyproxy/ratelimit) from the Envoy Proxy GitHub repository.

### Deployment

On Universal, you must deploy Redis and the ratelimit service on your own. On Kubernetes, you can use {{site.mesh_product_name}} Helm charts 
to deploy ratelimit service, but you still need to deploy Redis on your own.

### How to read limits configuration

When you expose debug port on the ratelimit service, you can get access to the limits configuration at the `/rlconfig` path.
Here is an example configuration:

```
default.kuma.io/service_demo-app_kuma-demo_svc_5000: unit=SECOND requests_per_unit=10, shadow_mode: false
```

This configuration follows this pattern: 
```
mesh.descriptorKey_descriptorValue
```
The descriptor key will always be `kuma.io/service`, and the descriptor value will be your mesh service name. 
Therefore, we can deduct that this configuration will apply to `demo-app_kuma-demo_svc_5000` service in the `default`
mesh. For the second part of the configuration, we have information about the request limit and unit to which 
this limit will be applied. Shadow mode specifies if request should be limited after reaching the configured limit. If `shadow_mode` is set 
to `true`, the ratelimit service will not deny requests to your service, it will only update the ratelimit service metrics.

### Performance improvements

Ratelimit service offers two mechanisms for tweaking its performance. [Local cache for depleted counters](https://github.com/envoyproxy/ratelimit#local-cache) and [Redis query pipelining](https://github.com/envoyproxy/ratelimit#pipelining). 
You should refer to [ratelimit service documentation](https://github.com/envoyproxy/ratelimit#overview) for more concrete documentation and setup.

## Example Ratelimit setup

### Prerequisites

- A Kubernetes cluster to run the demo on
- `Helm` installed
- `kumactl` installed locally

### Example

The following example shows how to deploy and test a sample `MeshGlobalRateLimit` policy on Kubernetes, using the kuma-demo application.

1. First, we need to deploy Redis in our Kubernetes cluster:

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install --create-namespace --namespace {{ site.mesh_namespace }} redis bitnami/redis
    ```

1. Redis should be now installed, and you should have secret with the Redis password. You can check if it is present:
  
    ```bash
    kubectl -n kong-mesh-system get secret redis 
    ```

1. Next, you need to create value files that will be used for control plane installation:

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

1. Now we can deploy our control plane:

    ```bash
    kumactl install control-plane --values values.yaml | kubectl apply -f -
    ```

1. We now have our control plane with ratelimit setup, so we can install the demo app:

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
                url: http://kong-mesh-ratelimit-service.{{ site.mesh_namespace }}:10003
                timeout: 1s" | kubectl apply -f -
    ```

2. We are all set up. Now you can try making few requests to the external IP of your gateway and you will see an error after reaching limits. You can find the IP with command:

    ```bash
    kubectl -n kuma-demo get service demo-app-gateway
    ```

    You can configure more with this demo, such as changing limits or trying out other examples from this documentation.
## All policy options

{% json_schema MeshGlobalRateLimits %}
