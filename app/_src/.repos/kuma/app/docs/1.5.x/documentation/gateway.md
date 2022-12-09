---
title: Gateway
---

Kuma Gateway is a Kuma component that routes network traffic from outside a Kuma mesh to services inside the mesh.
The gateway can be thought of as having one foot outside the mesh to receive traffic and one foot inside the mesh to route this external traffic to services inside the mesh.

When you use a data plane proxy with a service, both inbound traffic to a service and outbound traffic from the service flows through the proxy.
Gateway should be deployed as any other service within the mesh. However, in this case we want inbound traffic to go directly to the gateway,
otherwise clients would have to be provided with certificates that are generated dynamically for communication between services within the mesh.
Security for an entrance to the mesh should be handled by Gateway itself.

Kuma Gateway is deployed as a Kuma Dataplane, i.e. an instance of the `kuma-dp` process.
Like all Kuma Dataplanes, the Kuma Gateway Dataplane manages an Envoy proxy process that does the actual network traffic proxying.

There exists two types of gateways:

- Delegated: Which enables users to use any existing gateway like [Kong](https://github.com/Kong/kong).
- Builtin: configures the data plane proxy to expose external listeners to drive traffic inside the mesh.

{% warning %}
Gateways exist within a mesh.
If you have multiple meshes, each mesh will need its own gateway.
{% endwarning %}

## Delegated
The `Dataplane` entity can operate in `gateway` mode. This way you can integrate Kuma with existing API Gateways like [Kong](https://github.com/Kong/kong).

Gateway mode lets you skip exposing inbound listeners so it won't be intercepting ingress traffic.

### Usage

{% tabs usage useUrlFragment=false %}
{% tab usage Universal %}

On Universal, you can define the `Dataplane` entity like this:

```yaml
type: Dataplane
mesh: default
name: kong-01
networking:
  address: 10.0.0.1
  gateway:
    type: DELEGATED
    tags:
      kuma.io/service: kong
  outbound:
  - port: 33033
    tags:
      kuma.io/service: backend
```

When configuring your API Gateway to pass traffic to _backend_ set the url to `http://localhost:33033`

{% endtab %}
{% tab usage Kubernetes %}

While most ingress controllers are supported in Kuma, the recommended gateway in Kubernetes is [Kong](https://docs.konghq.com/gateway).
You can use [Kong ingress controller for Kubernetes](https://docs.konghq.com/kubernetes-ingress-controller/) to implement authentication, transformations, and other functionalities across Kubernetes clusters with zero downtime.
To work with Kuma, most ingress controllers require an annotation on every Kubernetes `Service` that you want to pass traffic to [`ingress.kubernetes.io/service-upstream=true`](https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/references/annotations/#ingresskubernetesioservice-upstream).
Kuma automatically injects this annotation for every Service that is in a namespace part of the mesh i.e. has `kuma.io/sidecar-injection: enabled` label.

Like for regular dataplanes the `Dataplane` entities are automatically generated.
To inject gateway data planes, mark your API Gateway's Pod with `kuma.io/gateway: enabled` annotation.
For example:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  ...
spec:
  template:
    metadata:
      annotations:
        kuma.io/gateway: enabled
      ...
```

Services can be exposed to an API Gateway in one specific zone, or in multi-zone.
For the latter, we need to expose a dedicated Kubernetes `Service` object with type `ExternalName`, which sets the `externalName` to the `.mesh` DNS record for the particular service that we want to expose, that will be resolved by Kuma's internal [service discovery](/docs/{{ page.version }}/networking/dns).

#### Example setting up Kong Ingress Controller

We will follow these instructions to setup an echo service that is reached through Kong.
These instructions are mostly taken from the [Kong docs](https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/guides/getting-started/).

To get started [install Kuma](/docs/{{ page.version }}/installation/kubernetes) on your cluster and have the `default` [namespace labelled with sidecar-injection](/docs/{{ page.version }}/documentation/dps-and-data-model.md#kubernetes).

Install [Kong using helm](https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/k4k8s/#helm).

Start an echo-service:

```shell
kubectl apply -f https://bit.ly/echo-service
```

And an ingress:

```shell
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
" | kubectl apply -f -
```

You can access your ingress with `curl -i $PROXY_IP/foo` where `$PROXY_IP` is the ip retrieved from the service that exposes Kong outside your cluster.

You can check that the sidecar is running by checking the number of containers in each pod:
```shell
kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
echo-5fc5b5bc84-zr9kl                   2/2     Running   0          41m
kong-1645186528-kong-648b9596c7-f2xfv   3/3     Running   2          40m
```

#### Example Gateway in Multi-Zone

In the previous example, we setup a `echo` (that is running on port `80`) and deployed in the `default` namespace.

We will now make sure that this service works correctly with multi-zone. In order to do so, the following `Service` needs to be created manually:


```shell
echo "
apiVersion: v1
kind: Service
metadata:
  name: echo-multizone
  namespace: default 
spec:
  type: ExternalName
  externalName: echo.default.svc.80.mesh
" | kubectl apply -f -
```

Finally, we need to create a corresponding Kubernetes `Ingress` that routes `/bar` to the multi-zone service:

```shell
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-multizone
  namespace: default
spec:
  ingressClassName: kong
  rules:
    - http:
        paths:
          - path: /bar
            pathType: ImplementationSpecific
            backend:
              service:
                name: echo-multizone
                port:
                  number: 80
" | kubectl apply -f -
```

Note that since we are addressing the service by its domain name `echo.default.svc.8080.mesh`, we should always refer to port `80` (this port is only a placeholder and will be automatically replaced with the actual port of the service).

If we want to expose a `Service` in one zone only (as opposed to multi-zone), we can just use the service name in the `Ingress` definition without having to create an `externalName` entry, this is what we did in our first example.

For an in-depth example on deploying Kuma with [Kong for Kubernetes](https://github.com/Kong/kubernetes-ingress-controller), please follow this [demo application guide](https://github.com/kumahq/kuma-demo/tree/master/kubernetes).

{% endtab %}
{% endtabs %}

## Builtin

{% warning %}
The builtin gateway is currently experimental and is enabled with the kuma-cp flag `--experimental-meshgateway` or the environment variable `KUMA_EXPERIMENTAL_MESHGATEWAY`
{% endwarning %}

The builtin type of gateway is integrated into the core Kuma control plane.
You can therefore configure gateway listeners and routes to service directly using Kuma policies.

As with provided gateway, the builtin gateway is configured with a dataplane:

```yaml
type: Dataplane
mesh: default
name: gateway-instance-1
networking:
  address: 127.0.0.1
  gateway:
    type: BUILTIN
    tags:
      kuma.io/service: edge-gateway
```

A builtin gateway Dataplane does not have either inbound or outbound configuration.

To configure your gateway Kuma has these resources:

- [MeshGateway](/docs/{{ page.version }}/policies/mesh-gateway) is used to configure listeners exposed by the gateway
- [MeshGatewayRoute](/docs/{{ page.version }}/policies/mesh-gateway-route) is used to configure route to route traffic from listeners to other services.

### Usage

We will set up a simple gateway that exposes a http listener and 2 routes to imaginary services: "frontend" and "api". 

{% tabs listener useUrlFragment=false %}
{% tab listener Universal %}

The first thing you'll need is to create a dataplane object for your gateway:

```yaml
type: Dataplane
mesh: default
name: gateway-instance-1
networking:
  address: 127.0.0.1
  gateway:
    type: BUILTIN
    tags:
      kuma.io/service: edge-gateway
```

Note that this gateway has a `kuma.io/service` tag. We will use this to bind policies to configure this gateway.

As we're in universal you now need to run kuma-dp:

```shell
kuma-dp run \
  --cp-address=https://localhost:5678/ \
  --dns-enabled=false \
  --dataplane-token-file=kuma-token-gateway \ # this needs to be generated like for regular Data plane
  --dataplane-file=my-gateway.yaml # the dataplane resource described above 
```
{% endtab %}
{% tab listener Kubernetes %}
To ease starting gateways on Kubernetes Kuma comes with a builtin type "MeshGatewayInstance".
This type requests that the control plane create and manage a Kubernetes Deployment and Service suitable for providing service capacity for the Gateway with the matching service tags.

```shell
echo "
apiVersion: kuma.io/v1alpha1
kind: MeshGatewayInstance
metadata:
  name: edge-gateway
  namespace: default
spec:
  replicas: 1
  serviceType: LoadBalancer
  tags:
    kuma.io/service: edge-gateway
" | kubectl apply -f -
```

In the example above, the control plane will create a new Deployment in the `gateways` namespace.
This deployment will have the requested number of builtin gateway Dataplane pod replicas, which will be configured as part of the service named in the `MeshGatewayInstance` tags.
When a Kuma `MeshGateway` is matched to the `MeshGatewayInstance`, the control plane will also create a new Service to send network traffic to the builtin Dataplane pods.
The Service will be of the type requested in the `MeshGatewayInstance`, and its ports will automatically be adjusted to match the listeners on the corresponding `MeshGateway`.
{% endtab %}
{% endtabs %}

Now that the dataplane is running we can describe the gateway listener:

{% tabs dataplane useUrlFragment=false %}
{% tab dataplane Universal %}
```yaml
type: MeshGateway
mesh: default
name: edge-gateway
selectors:
- match:
    kuma.io/service: edge-gateway
conf:
  listeners:
  - port: 8080
    protocol: HTTP
    hostname: foo.example.com
    tags:
      port: http/8080
```
{% endtab %}
{% tab dataplane Kubernetes %}
```shell
echo "
apiVersion: kuma.io/v1alpha1
kind: MeshGateway
mesh: default
metadata:
  name: edge-gateway
spec:
  selectors:
  - match:
    kuma.io/service: edge-gateway
  conf:
    listeners:
      - port: 8080
        protocol: HTTP
        hostname: foo.example.com
        tags:
          port: http/8080
" | kubectl apply -f -  
```
{% endtab %}
{% endtabs %}

This policy creates a listener on port 8080 and will receive any traffic which has the `Host` header set to `foo.example.com`.
Notice that listeners have tags like dataplanes. This will be useful when binding routes to listeners.

{% tip %}
These are Kuma policies so if you are running on multi-zone they need to be created on the Global CP.
See the [dedicated section](/docs/{{ page.version }}/deployments/multi-zone) for detailed information.
{% endtip %}

We will now define our routes which will take traffic and route it either to our `api` or our `frontend` depending on the path of the http request: 

{% tabs define-route useUrlFragment=false %}
{% tab define-route Universal %}
```yaml
type: MeshGatewayRoute
mesh: default
name: edge-gateway-route 
selectors:
  - match:
      kuma.io/service: edge-gateway
      port: http/8080 
conf:
  http:
    rules:
      - matches:
          - path:
              match: PREFIX
              value: /
        backends:
          - destination:
              kuma.io/service: demo-app_kuma-demo_svc_5000
```
{% endtab %}
{% tab define-route Kubernetes %}
```shell
echo "
apiVersion: kuma.io/v1alpha1
kind: MeshGatewayRoute
mesh: default
metadata:
  name: edge-gateway-route 
spec:
  selectors:
    - match:
        kuma.io/service: edge-gateway
        port: http/8080 
  conf:
    http:
      rules:
        - matches:
            - path:
                match: PREFIX
                value: /
          backends:
            - destination:
                kuma.io/service: demo-app_kuma-demo_svc_5000
" | kubectl apply -f -
```
{% endtab %}
{% endtabs %}

Because routes are applied in order of specificity the first route will take precedence over the second one.
So `/api/foo` will go to the `api` service whereas `/asset` will go to the `frontend` service.

### Multi-zone

The Kuma Gateway resource types, `MeshGateway` and `MeshGatewayRoute`, are synced across zones by the Kuma control plane.
If you have a multi-zone deployment, follow existing Kuma practice and create any Kuma Gateway resources in the global control plane.
Once these resources exist, you can provision serving capacity in the zones where it is needed by deploying builtin gateway Dataplanes (in Universal zones) or `MeshGatewayInstances` (Kubernetes zones).

### Policy support

Not all Kuma policies are applicable to Kuma Gateway (see table below).
Kuma connection policies are selected by matching the source and destination expressions against sets of Kuma tags.
In the case of Kuma Gateway the source selector is always matched against the Gateway listener tags, and the destination expression is matched against the backend destination tags configured on a Gateway Route.

When a Gateway Route forwards traffic, it may weight the traffic across multiple services.
In this case, matching the destination for a connection policy becomes ambiguous.
Although the traffic is proxied to more than one distinct service, Kuma can only configure the route with one connection policy.
In this case, Kuma employs some simple heuristics to choose the policy.
If all the backend destinations refer to the same service, Kuma will choose the oldest connection policy that has a matching destination service.
However, if the backend destinations refer to different services, Kuma will prefer a connection policy with a wildcard destination (i.e. where the destination service is `*`).

Kuma may select different connection policies of the same type depending on the context.
For example, when Kuma configures an Envoy route, there may be multiple candidate policies (due to the traffic splitting across destination services), but when Kuma configures an Envoy cluster there is usually only a single candidate (because clusters are defined to be a single service).
This can result in situations where different policies (of the same type) are used for different parts of the Envoy configuration.

| Policy                                                     | GatewaySupport |
| ---------------------------------------------------------- | -------------- |
| [Circuit Breaker](/docs/{{ page.version }}/policies/circuit-breaker)          | Full           |
| [External Services](/docs/{{ page.version }}/policies/external-services)      | Full           |
| [Fault Injection](/docs/{{ page.version }}/policies/fault-injection)          | Full           |
| [Health Check](/docs/{{ page.version }}/policies/health-check)                | Full           |
| [Proxy Template](/docs/{{ page.version }}/policies/proxy-template)            | Full           |
| [Rate Limits](/docs/{{ page.version }}/policies/rate-limit)                   | Full           |
| [Retries](/docs/{{ page.version }}/policies/retry)                            | Full           |
| [Traffic Permissions](/docs/{{ page.version }}/policies/traffic-permissions)  | Full           |
| [Traffic Routes](/docs/{{ page.version }}/policies/traffic-route)             | None           |
| [Traffic Log](/docs/{{ page.version }}/policies/traffic-log)                  | Partial        |
| [Timeouts](/docs/{{ page.version }}/policies/timeout)                         | Full           |
| [VirtualOutbounds](/docs/{{ page.version }}/policies/virtual-outbound)        | None           |

You can find in each policy's dedicated information with regard to builtin gateway support.
