---
title: Fallback Configuration
type: explanation
purpose: |
  Explain how the Fallback Configuration feature works
---

{{site.kic_product_name}} in version 3.2.0 introduced the Fallback Configuration
feature. It is designed to isolate issues related to individual parts
of the configuration, allowing updates to the rest of it to proceed with no
interruption. If you're using {{site.kic_product_name}} in a multi-team environment, the
fallback configuration mechanism can help you avoid lock-ups when one team's
configuration is broken.

{:.note}
> **Note:** The Fallback Configuration is an opt-in feature. You must
> enable it by setting `FallbackConfiguration=true` in the controller's feature
> gates configuration.

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
  - Backfilling the broken object along with its dependants using the last valid Kubernetes objects' in-memory cache (if `--use-last-valid-config-for-fallback` flag is set).
- Enables users to inspect and identify what objects were excluded from or backfilled in the configuration using
  diagnostic endpoints.

Below table summarizes the behavior of the Fallback Configuration feature based on the configuration:

| `FallbackConfiguration` feature gate value | `--use-last-valid-config-for-fallback` flag value | Behavior                                                                                                                                             |
|--------------------------------------------|---------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `false`                                    | `false`/`true` (has no effect)                    | The last valid configuration is used as a whole to recover (if stored).                                                                              |
| `true`                                     | `false`                                           | The Fallback Configuration is triggered - broken objects and their dependants are excluded.                                                          |
| `true`                                     | `true`                                            | The Fallback Configuration is triggered - broken objects and their dependants are excluded and backfilled with their last valid version (if stored). |

Below diagram illustrates how the Fallback Configuration feature works in detail:

![fallback-config](/assets/images/products/kubernetes-ingress-controller/fallback-config.png "Fallback Configuration diagram")

## Example Scenario

In this example we'll demonstrate how the Fallback Configuration works in practice.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false %}

To test the Fallback Configuration, make sure your {{site.kic_product_name}} instance is running with
the Fallback Configuration feature, diagnostics server enabled, and the Admission Webhook server disabled
(that will enable us to slip a broken configuration to the controller):

```bash
helm upgrade --install kong kong/ingress -n kong \
  --set ingressController.env.feature_gates=FallbackConfiguration=true \
  --set ingressController.admissionWebhook.enabled=false
```

In the example, we'll consider a situation where:

1. We have two `HTTPRoutes` pointing to the same `Service` and working correctly.
2. One of the `HTTPRoutes` gets broken because of referencing an invalid `KongPlugin`.

First, let's deploy the `Service` and its backing `Deployment`:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```
The results should look like this:
```text
service/echo created
deployment.apps/echo created
```

Next, let's deploy the `HTTPRoutes`:

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

Let's ensure that the `HTTPRoutes` are working as expected:

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

```bash
curl -i $PROXY_IP/route-b
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

Now, let's introduce a breaking change in the `route-2` by attaching a broken `KongPlugin` to it.

Create a `KongPlugin` with an invalid configuration:

```bash
echo 'apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: key-auth
plugin: key-auth
config:
  # Should be 'key_names', not 'keys'.
  keys: ["key"]' | kubectl apply -f -
```

The results should look like this:
```text
kongplugin.configuration.konghq.com/key-auth created
```

Now, let's attach the `KongPlugin` to `route-b`:

```bash
kubectl annotate httproute route-b konghq.com/plugins=key-auth
```

The results should look like this:
```text
httproute.gateway.networking.k8s.io/route-b patched
```

This will cause the `route-b` to break. Let's verify this:

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

The route is not configured because the Fallback Configuration mechanism has excluded the broken `KongPlugin` and its
dependants, including the `HTTPRoute`, from the configuration.

We can verify this by inspecting the diagnostic endpoint:

```bash
kubectl port-forward -n kong deploy/kong-controller 8010:10256 &
curl -i localhost:8010/debug/config/problems
```

The results should look like this:
```text
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 2
Connection: keep-alive
Server: kong/3.2.0

{"brokenObjects": [{}]}
```

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
kubectl patch httproute route-a --type merge -p '{"spec":{"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/route-a-modified"}}],"backendRefs":[{"name":"echo","port":80}]}]}}'
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

{:.note}
> An alternative way to recover is to backfill broken objects with their last valid version.
> To change the behavior, make sure {{site.kic_product_name}}'s `--use-last-valid-config-for-fallback` flag is set.

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
> [Prometheus Metrics](/production/observability/prometheus) for more information.
