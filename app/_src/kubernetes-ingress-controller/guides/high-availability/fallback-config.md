---
title: Fallback Configuration
type: explanation
purpose: |
  Explain how the Fallback Configuration feature works
---

In this guide you'll learn about the Fallback Configuration feature. We'll explain its
implementation details and provide an example scenario to demonstrate how it works in practice.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false %}

## Overview

{{site.kic_product_name}} 3.2.0 introduced the Fallback Configuration
feature. It is designed to isolate issues related to individual parts
of the configuration, allowing updates to the rest of it to proceed with no
interruption. If you're using {{site.kic_product_name}} in a multi-team environment, the
fallback configuration mechanism can help you avoid lock-ups when one team's
configuration is broken.

{:.note}
> **Note:** The Fallback Configuration is an opt-in feature. You must
> enable it by setting `FallbackConfiguration=true` in the controller's feature
> gates configuration. See [Feature Gates](/kubernetes-ingress-controller/{{page.release}}/reference/feature-gates)
> to learn how to do that.

## How it works

{{site.kic_product_name}} translates Kubernetes objects it gets from the Kubernetes API and pushes
the translation result via Kong’s Admin API to {{site.base_gateway}} instances. However, issues
can arise at various stages of this process:

1. Admission Webhook: Validates individual Kubernetes objects against schemas and basic rules.
2. Translation Process: Detects issues like cross-object validation errors.
3. Kong Response: Kong rejects the configuration and returns an error associated with a specific object.

Fallback Configuration is triggered when an issue is detected in the 3rd stage and provides the following benefits:
- Allows unaffected objects to be updated even when there are configuration errors.
- Automatically builds a fallback configuration that Kong will accept without requiring user intervention by
  either:
  - Excluding the broken objects along with its dependants.
  - Backfilling the broken object along with its dependants using the last valid Kubernetes objects' in-memory cache (if `CONTROLLER_USE_LAST_VALID_CONFIG_FOR_FALLBACK` environment variable is set to `true`).
- Enables users to inspect and identify what objects were excluded from or backfilled in the configuration using
  diagnostic endpoints.

Below table summarizes the behavior of the Fallback Configuration feature based on the configuration:

| `FallbackConfiguration` feature gate value | `CONTROLLER_USE_LAST_VALID_CONFIG_FOR_FALLBACK` value | Behavior                                                                                                                                             |
|--------------------------------------------|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `false`                                    | `false`/`true` (has no effect)                        | The last valid configuration is used as a whole to recover (if stored).                                                                              |
| `true`                                     | `false`                                               | The Fallback Configuration is triggered - broken objects and their dependants are excluded.                                                          |
| `true`                                     | `true`                                                | The Fallback Configuration is triggered - broken objects and their dependants are excluded and backfilled with their last valid version (if stored). |

Below diagram illustrates how the Fallback Configuration feature works in detail:

<!--vale off-->
{% mermaid %}
flowchart TD
classDef sub opacity:0
classDef note stroke:#e1bb86,fill:#fdf3d8
classDef externalCall fill:#9e8ebf,stroke:none,color:#fff
classDef decision fill:#d0e1fb
classDef startEnd fill:#545454,stroke:none,color:#fff

    A([Update loop triggered]) --> B[Generate Kubernetes objects' store
    snapshot to be passed to the Translator]
    B --> C[Translator: generate Kong configuration
    based on the generated snapshot]
    C --> D(Configure Kong Gateways using generated
    declarative configuration)
    D --> E{Configuration
    rejected?}
    E --> |No| G[Store the Kubernetes objects' snapshot
    to be used as the last valid state]
    E --> |Yes| F[Build a dependency graph of Kubernetes
    objects - using the snapshot]
    G --> H[Store the declarative configuration to be
    used as the last valid configuration]
    H --> Z([End of the loop])
    F --> I[Exclude an object along with all its
    dependants from the fallback Kubernetes objects snapshot]
    I --> J[Add a previous valid version of the object along
    with its dependants' previous versions to the fallback snapshot]
    J --> K[Translator: generate Kong configuration
    based on the fallback snapshot]
    K --> L(Configure Kong Gateways using generated
    fallback declarative configuration)
    L --> M{Fallback
    configuration
    rejected?}
    M --> |Yes| N{Was the last
    valid configuration
    preserved?}
    N --> |Yes| O(Configure Kong Gateways using the
    last valid declarative configuration)
    O --> Z
    N --> |No| Z
    M --> |No| P[Store the fallback Kubernetes objects' snapshot
     to be used as the last valid state]
    P --> R[Store the fallback declarative configuration
    to be used as the last valid configuration]

    subgraph subI [" "]
        I
        noteI[For every invalid object
        reported by the Gateway]
    end

    subgraph subJ [" "]
        J
        noteJ[Given there was a last valid
        Kubernetes objects' store snapshot
        preserved and the object is present]
    end

    class subI,subJ sub
    class noteI,noteJ note
    class D,L,O externalCall
    class A,Z startEnd
    class E,M,N decision

{% endmermaid %}
<!--vale on-->

![fallback-config](/assets/images/products/kubernetes-ingress-controller/fallback-config.png "Fallback Configuration diagram")

## Example Scenario

In this example we'll demonstrate how the Fallback Configuration works in practice.

### Excluding broken objects

First, we'll demonstrate the default behavior of the Fallback Configuration feature, which is to exclude broken objects
and their dependants from the configuration.

To test the Fallback Configuration, make sure your {{site.kic_product_name}} instance is running with
the Fallback Configuration feature and diagnostics server enabled.

```bash
helm upgrade --install kong kong/ingress -n kong \
  --set controller.ingressController.env.feature_gates=FallbackConfiguration=true \
  --set controller.ingressController.env.dump_config=true
```

In the example, we'll consider a situation where:

1. We have two `HTTPRoute`s pointing to the same `Service`. One of `HTTPRoute`s is configured with `KongPlugin`s providing
   authentication and base rate-limiting. Everything works as expected.
2. We add one more rate-limiting `KongPlugin` that is to be associated with the second `HTTPRoute` and a specific `KongConsumer`
   so that it can be rate-limited in a different way than the base rate-limiting, but we forget associate the `KongConsumer`
   with the `KongPlugin`. It results in the `HTTPRoute` being broken because of duplicated rate-limiting plugins.

#### Deploying valid configuration

First, let's deploy the `Service` and its backing `Deployment`:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```
The results should look like this:
```text
service/echo created
deployment.apps/echo created
```

Next, let's deploy the `HTTPRoute`s. `route-b` will refer three `KongPlugin`s (`key-auth`, `rate-limit-base,` `rate-limit-consumer`):

```bash
echo 'apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: route-a
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /route-a
    backendRefs:
    - name: echo
      port: 1027
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: route-b
  annotations:
    konghq.com/plugins: key-auth, rate-limit-base, rate-limit-consumer
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /route-b
    backendRefs:
    - name: echo
      port: 1027
      ' | kubectl apply -f -
```

The results should look like this:
```text
httproute.gateway.networking.k8s.io/route-a created
httproute.gateway.networking.k8s.io/route-b created
```

Let's also create the `KongPlugin`s:

```bash
echo 'apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: key-auth
plugin: key-auth
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-base
plugin: rate-limiting
config:
  second: 1
  policy: local
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-consumer
plugin: rate-limiting
config:
  second: 5
  policy: local' | kubectl apply -f -
```

The results should look like this:
```text
kongplugin.configuration.konghq.com/key-auth created
kongplugin.configuration.konghq.com/rate-limit-base created
kongplugin.configuration.konghq.com/rate-limit-consumer created
```

And finally, let's create the `KongConsumer` with credentials and the `rate-limit-consumer` `KongPlugin` associated:

```bash
echo 'apiVersion: v1
kind: Secret
metadata:
  name: bob-key-auth
  labels:
    konghq.com/credential: key-auth
stringData:
  key: bob-password
---
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: bob
  annotations:
    konghq.com/plugins: rate-limit-consumer
    kubernetes.io/ingress.class: kong
username: bob
credentials:
- bob-key-auth
' | kubectl apply -f -
```

#### Verifying routes are functional

Let's ensure that the `HTTPRoute`s are working as expected:

```bash
curl -i $PROXY_IP/route-a
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/3.6.0
X-Kong-Request-Id: 5bf50016730eae43c359c17b41dc8614

Welcome, you are connected to node orbstack.
Running on Pod echo-74c66b778-szf8f.
In namespace default.
With IP address 192.168.194.13.
```

Authenticated requests with the valid `apikey` header on the `route-b` should be accepted:

```bash
curl -i $PROXY_IP/route-b -H apikey:bob-password
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 0
Via: kong/3.6.0
X-Kong-Request-Id: 14ae28589baff9459d5bb3476be6f570

Welcome, you are connected to node orbstack.
Running on Pod echo-74c66b778-szf8f.
In namespace default.
With IP address 192.168.194.13.
```

While the requests without the `apikey` header should be rejected:

```bash
curl -i $PROXY_IP/route-b
```

The results should look like this:

```text
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 96
X-Kong-Response-Latency: 0
Server: kong/3.6.0
X-Kong-Request-Id: 520c396c6c32b0400f7c33531b7f9b2c

{
  "message":"No API key found in request",
  "request_id":"520c396c6c32b0400f7c33531b7f9b2c"
}
```

#### Introducing a breaking change to the configuration

Now, let's simulate a situation where we introduce a breaking change to the configuration. We'll remove the `rate-limit-consumer`
`KongPlugin` from the `KongConsumer` so that the `route-b` will now have two `rate-limiting` plugins associated with it,
which will cause it to break.

```bash
 kubectl annotate kongconsumer bob konghq.com/plugins-
```

The results should look like this:

```text
kongconsumer.configuration.konghq.com/bob annotated
```

#### Verifying the broken route was excluded

This will cause the `route-b` to break as there are two `KongPlugin`s using the same type (`rate-limiting`). We expect
the route to be excluded from the configuration.

Let's verify this:

```bash
curl -i $PROXY_IP/route-b
```

The results should look like this:

```text
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 103
X-Kong-Response-Latency: 0
Server: kong/3.6.0
X-Kong-Request-Id: 209a6b14781179103528093188ed4008

{
  "message":"no Route matched with those values",
  "request_id":"209a6b14781179103528093188ed4008"
}%
```

#### Inspecting diagnostic endpoints

The route is not configured because the Fallback Configuration mechanism has excluded the broken `HTTPRoute`.

We can verify this by inspecting the diagnostic endpoint:

```bash
kubectl port-forward -n kong deploy/kong-controller 10256 &
curl -i localhost:10256/debug/config/problems
```

The results should look like this:

```text
HTTP/1.1 200 OK
Content-Type: application/json

{
    "brokenObjects": [
        {"kind": "KongPlugin", "name": "rate-limit-consumer", "namespace": "default"},
        {"kind": "HTTPRoute", "name": "route-b", "namespace": "default"}
    ],
    "excludedObjects": [
        {"kind": "KongPlugin", "name": "rate-limit-consumer", "namespace": "default"},
        {"kind": "HTTPRoute", "name": "route-b", "namespace": "default"}
    ]
}
```

#### Verifying the working route is still operational and can be updated

We can also ensure the other `HTTPRoute` is still working:

```bash
curl -i $PROXY_IP/route-a
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/3.6.0
X-Kong-Request-Id: 5bf50016730eae43c359c17b41dc8614

Welcome, you are connected to node orbstack.
Running on Pod echo-74c66b778-szf8f.
In namespace default.
With IP address 192.168.194.13.
```

What's more, we're still able to update the correct `HTTPRoute` without any issues. Let's modify `route-a`'s path:

```bash
kubectl patch httproute route-a --type merge -p '{"spec":{"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/route-a-modified"}}],"backendRefs":[{"name":"echo","port":1027}]}]}}'
```

The results should look like this:
```text
httproute.gateway.networking.k8s.io/route-a patched
```

Let's verify the updated `HTTPRoute`:

```bash
curl -i $PROXY_IP/route-a-modified
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 0
Via: kong/3.6.0
X-Kong-Request-Id: f26ce453eeeda50e3d53a26f44f0f21f

Welcome, you are connected to node orbstack.
Running on Pod echo-74c66b778-szf8f.
In namespace default.
With IP address 192.168.194.13.
```

The Fallback Configuration mechanism has successfully isolated the broken `HTTPRoute` and allowed the correct one to be
updated.

### Backfilling broken objects

Another mode of operation that the Fallback Configuration feature supports is backfilling broken objects with their last
valid version. To demonstrate this, we'll use the same setup as in the default mode, but this time we'll set the
`CONTROLLER_USE_LAST_VALID_CONFIG_FOR_FALLBACK` environment variable to `true`.

```bash
helm upgrade --install kong kong/ingress -n kong \
--set controller.ingressController.env.feature_gates=FallbackConfiguration=true \
--set controller.ingressController.env.use_last_valid_config_for_fallback=true
```

#### Attaching the plugin back

As this mode of operation leverages the last valid Kubernetes objects' cache state, we need to make sure that
we begin with a clean slate, allowing {{site.kic_product_name}} to store it.

{:.note}
> **Note:** {{site.kic_product_name}} stores the last valid Kubernetes objects' cache state in memory. It is not persisted
> across restarts. That means that if you've got broken objects in the configuration that were backfilled using the
> last valid version, after a restart the last valid version will be lost, effectively excluding these objects from the
> configuration.

Let's remove one `KongPlugin` so we get an entirely valid configuration:

```bash
kubectl annotate kongconsumer bob konghq.com/plugins=rate-limit-consumer
```

The results should look like this:
```text
kongconsumer.configuration.konghq.com/bob annotated
```

#### Verifying both routes are operational again

Now, let's verify that both `HTTPRoute`s are operational back again.

```bash
curl -i $PROXY_IP/route-a-modified
```

```bash
curl -i $PROXY_IP/route-b
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 0
Via: kong/3.6.0
X-Kong-Request-Id: 0d91bf2d355ede4d2b01c3306886c043

Welcome, you are connected to node orbstack.
Running on Pod echo-74c66b778-szf8f.
In namespace default.
With IP address 192.168.194.13.
```

```text
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 96
X-Kong-Response-Latency: 0
Server: kong/3.6.0
X-Kong-Request-Id: 0bc94b381edeb52f5a41e23a260afe40

{
  "message":"No API key found in request",
  "request_id":"0bc94b381edeb52f5a41e23a260afe40"
}
```

#### Breaking the route again

As we've verified that both `HTTPRoute`s are operational, let's break `route-b` again by removing the `rate-limit-consumer`
`KongPlugin` from the `KongConsumer`:

```bash
kubectl annotate kongconsumer bob konghq.com/plugins-
```

The results should look like this:
```text
kongconsumer.configuration.konghq.com/bob annotated
```

#### Verifying the broken route was backfilled

Backfilling the broken `HTTPRoute` with its last valid version should have restored the route to its last valid working
state. That means we should be able to access `route-b` as before the breaking change:

```bash
curl -i $PROXY_IP/route-b
```

The results should look like this:

```text
HTTP/1.1 401 Unauthorized
Date: Mon, 10 Jun 2024 14:00:38 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 96
X-Kong-Response-Latency: 5
Server: kong/3.6.0
X-Kong-Request-Id: 4604f84de6ed0b1a9357e935da5cea2c

{
  "message":"No API key found in request",
  "request_id":"4604f84de6ed0b1a9357e935da5cea2c"
}
```

#### Inspecting diagnostic endpoints

Using diagnostic endpoints, we can now inspect the objects that were excluded and backfilled in the configuration:

```bash
kubectl port-forward -n kong deploy/kong-controller 10256 &
curl -i localhost:10256/debug/config/problems
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: application/json

{
    "brokenObjects": [
        {"kind": "KongPlugin", "name": "rate-limit-consumer", "namespace": "default"},
        {"kind": "HTTPRoute", "name": "route-b", "namespace": "default"}
    ],
    "excludedObjects": [
        {"kind": "KongPlugin", "name": "rate-limit-consumer", "namespace": "default"},
        {"kind": "HTTPRoute", "name": "route-b", "namespace": "default"}
    ]
    "backfilledObjects": [
        {"kind": "KongPlugin", "name": "rate-limit-consumer", "namespace": "default"},
        {"kind": "HTTPRoute", "name": "route-b", "namespace": "default"}
        {"kind": "KongConsumer", "name": "bob", "namespace": "default"}
    ]
}
```

As `rate-limit-consumer` and `route-b` were reported back as broken by the {{site.base_gateway}}, they were excluded from
the configuration. However, the Fallback Configuration mechanism backfilled them with their last valid version, restoring
the route to its working state. You may notice that also the `KongConsumer` was backfilled -
this is because the `KongConsumer` was depending on the `rate-limit-consumer` plugin in the last valid state.

{:.note}
> **Note:** The Fallback Configuration mechanism will attempt to backfill all the broken objects along with their direct
> and indirect dependants. The dependencies are resolved based on the last valid Kubernetes objects' cache state.

#### Modifying the affected objects

As we're now relying on the last valid version of the broken objects and their dependants, we won't be able to effectively
modify them until we fix the problems. Let's try and add another key for the `bob` `KongConsumer`:

Create a new `Secret` with a new key:

```bash
echo 'apiVersion: v1
kind: Secret
metadata:
  name: bob-key-auth-new
  labels:
    konghq.com/credential: key-auth
stringData:
  key: bob-new-password' | kubectl apply -f -
```

The results should look like this:
```text
secret/bob-key-auth-new created
```

Associate the new `Secret` with the `KongConsumer`:

```bash
kubectl patch kongconsumer bob --type merge -p '{"credentials":["bob-key-auth", "bob-key-auth-new"]}'
```

The results should look like this:
```text
kongconsumer.configuration.konghq.com/bob patched
```

The change won't be effective as the `HTTPRoute` and `KongPlugin` are still broken. We can verify this by trying to access the
`route-b` with the new key:

```bash
curl -i $PROXY_IP/route-b -H apikey:bob-new-password
```

The results should look like this:

```text
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 81
X-Kong-Response-Latency: 2
Server: kong/3.6.0
X-Kong-Request-Id: 4c706c7e4e06140e56453b22e169df0a

{
  "message":"Unauthorized",
  "request_id":"4c706c7e4e06140e56453b22e169df0a"
}
```

#### Modifying the working route

On the other hand, we can still modify the working `HTTPRoute`:

```bash
kubectl patch httproute route-a --type merge -p '{"spec":{"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/route-a-modified-again"}}],"backendRefs":[{"name":"echo","port":1027}]}]}}'
```

The results should look like this:
```text
httproute.gateway.networking.k8s.io/route-a patched
```

Let's verify the updated `HTTPRoute`:

```bash
curl -i $PROXY_IP/route-a-modified-again
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 136
Connection: keep-alive
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 0
Via: kong/3.6.0
X-Kong-Request-Id: 4369f15cf27cf16f5a2c82061b8d3950

Welcome, you are connected to node orbstack.
Running on Pod echo-bf9d56995-r8c86.
In namespace default.
With IP address 192.168.194.8.
```

#### Fixing the broken route

To fix the broken `HTTPRoute`, we need to associate the `rate-limit-consumer` `KongPlugin` back with the `KongConsumer`:

```bash
kubectl annotate kongconsumer bob konghq.com/plugins=rate-limit-consumer
```

This should unblock the changes we've made to the `bob-key-auth` `Secret`. Let's verify this by accessing the `route-b`
with the new key:

```bash
curl -i $PROXY_IP/route-b -H apikey:bob-new-password
```

The results should look like this now:

```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 136
Connection: keep-alive
X-RateLimit-Limit-Second: 5
RateLimit-Limit: 5
RateLimit-Remaining: 4
RateLimit-Reset: 1
X-RateLimit-Remaining-Second: 4
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 2
Via: kong/3.6.0
X-Kong-Request-Id: 183ecc2973f16529a314ca5bf205eb73

Welcome, you are connected to node orbstack.
Running on Pod echo-bf9d56995-r8c86.
In namespace default.
With IP address 192.168.194.8.
```

### Inspecting the Fallback Configuration process

Each time {{site.kic_product_name}} successfully applies a fallback configuration, it emits a Kubernetes Event
with the `FallbackKongConfigurationSucceeded` reason. It will also emit an Event with `FallbackKongConfigurationApplyFailed`
reason in case the fallback configuration gets rejected by {{site.base_gateway}}. You can monitor these events to track the
fallback configuration process.

You can check the Event gets emitted by running:

```bash
kubectl get events -A --field-selector='reason=FallbackKongConfigurationSucceeded'
```

The results should look like this:
```text
NAMESPACE   LAST SEEN   TYPE     REASON                               OBJECT                                 MESSAGE
kong        4m26s       Normal   FallbackKongConfigurationSucceeded   pod/kong-controller-7f4fd47bb7-zdktb   successfully applied fallback Kong configuration to https://192.168.194.11:8444
```

{:.note}
> Another way to monitor the Fallback Configuration mechanism is by Prometheus metrics. Please refer to the
> [Prometheus Metrics](/kubernetes-ingress-controller/{{page.release}}/production/observability/prometheus) for more information.
