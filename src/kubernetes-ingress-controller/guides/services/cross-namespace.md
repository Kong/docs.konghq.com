---
title: Configuring Gateway API resources across namespaces
type: how-to
purpose: |
  Attach an HTTPRoute to a Gateway and Service that reside in different
  namespaces.
---

Unlike Ingress, Gateway API routing resources can use Services in another
namespace if the Service's namespace permits it. This guide shows how to create
a `HTTPRoute` in one namespace that routes to a Service in another, bound to a
Gateway in a third namespace.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false %}

## Create namespaces and allow references

1. Create separate namespaces to hold the `HTTPRoute` and target Service:

   ```bash
   kubectl create namespace test-source
   kubectl create namespace test-destination
   ```

   The results should look like this:
   ```text
   namespace/test-source created
   namespace/test-destination created
   ```

1. Create [a `ReferenceGrant` resource](https://gateway-api.sigs.k8s.io/api-types/referencegrant/)
   in the destination namespace:

   ```bash
   echo 'kind: ReferenceGrant
   apiVersion: gateway.networking.k8s.io/v1beta1    
   metadata:                                    
     name: test-grant
     namespace: test-destination
   spec:                        
     from:
     - group: gateway.networking.k8s.io
       kind: HTTPRoute                 
       namespace: test-source
     to:                     
     - group: ""
       kind: Service
   ' | kubectl create -f -
   ```

   The results should look like this:
   ```text
   referencegrant.gateway.networking.k8s.io/test-grant created
   ```

ReferenceGrants allow namespaces to opt in to references from other resources.
They reside in the namespace of the target resource and list resources and
namespaces that can talk to specific resources in the ReferenceGrant's
namespace. The above example allows HTTPRoutes in the `test-source` namespace
to reference Services in the `test-destination` namespace.

## Using a Gateway resource in a different namespace

Gateway resources may also allow references from resources (`HTTPRoute`,
`TCPRoute`, etc.) in other namespaces. However, these references _do not_ use
ReferenceGrants, as they are defined per listener in the Gateway resource, not for the entire Gateway.
A listener's [`allowedRoutes` field](https://gateway-api.sigs.k8s.io/concepts/security-model/#1-route-binding)
lets you define which routing resources can bind to that listener.

The default Gateway in this guide only allows routes from its same namespace
(`default`). You'll need to expand its scope to allow routes from the
`test-source` namespace:

```bash
kubectl patch --type=json gateways.gateway.networking.k8s.io kong -p='[{"op":"replace","path": "/spec/listeners/0/allowedRoutes/namespaces/from","value":"All"}]'
```

The results should look like this:
```text
gateway.gateway.networking.k8s.io/kong patched
```

This results in a `Gateway` resource with the following configuration:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: All
```

Listeners can allow routes in their own namespace (`from: Same`), any namespace (`from: Any`), or a
labeled set of namespaces (`from: Selector`).

## Deploy a Service and HTTPRoute

1. Deploy an echo Service to the `test-destination` resource.

   ```bash
   kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml -n test-destination
   ```

   The results should look like this:

   ```text
   service/echo created
   deployment.apps/echo created
   ```

1. Deploy a HTTPRoute that sends traffic to the service.

   ```bash
   echo 'apiVersion: gateway.networking.k8s.io/v1
   kind: HTTPRoute
   metadata:
     name: echo
     namespace: test-source
     annotations:
       konghq.com/strip-path: "true"
   spec:
     parentRefs:
     - name: kong
       namespace: default
     rules:
     - matches:
       - path:
           type: PathPrefix
           value: /echo
       backendRefs:
       - name: echo
         kind: Service
         port: 1027
         namespace: test-destination
   ' | kubectl apply -f -
   ```

   The results should look like this:
   ```text
   httproute.gateway.networking.k8s.io/echo created
   ```

   Note the `namespace` fields in both the parent and backend references. By
   default, entries here attempt to use the same namespace as the HTTPRoute if
   you do not specify a namespace.

1. Send requests through the route.

   ```bash
   curl -s "$PROXY_IP/echo"
   ```

   The results should look like this:

   ```text
   Welcome, you are connected to node kind-control-plane.
   Running on Pod echo-965f7cf84-z9jv2.
   In namespace test-destination.
   With IP address 10.244.0.6.
   ```
