---
title: Using plugins across namespaces
type: how-to
purpose: |
  Configure plugins in one namespace that interact with resources in another.
---

Plugins can interact with resources across different Kubernetes namespaces.
`KongClusterPlugin` resources can be referenced from any
namespace, but require cluster-level permissions and may not be appropriate for
all environments. This guide covers the use of `ReferenceGrant` to
grant selective permissions that allow `KongPlugin` resources in one namespace to
modify resources in another.

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false %}

The examples provided use `HTTPRoute` from the Gateway API project, but `ReferenceGrant` resources may be used with Ingress too.

{:.important}
> **Note**: This guide requires {{site.kic_product_name}} version 3.2 or higher
> and the [`ReferenceGrant`](https://gateway-api.sigs.k8s.io/api-types/referencegrant/)
> resource definition from the [Gateway API](https://gateway-api.sigs.k8s.io/).
> `ReferenceGrant` may not be available on all Kubernetes clusters. 

## Example use case

Alice manages [consumers](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongconsumer)
for ACME Inc. They have permission to creates consumers and credentials in the `golf` namespace.

Bob manages ACME Inc's `httpbin` Service in the `foxtrot`
namespace. Bob wants to apply different rate limits to different consumers,
but they do not have full access to the `golf` namespace, and Alice does not
have access to the `foxtrot` namespace. To manage these limits, Alice can
create `ReferenceGrants` that permit Bob's `KongPlugins` in `foxtrot` to
interact with `KongConsumers` in the `golf` namespace.

## Create namespaces

Create the two test namespaces:

```bash
kubectl create namespace golf
kubectl create namespace foxtrot
```

The result should look like:

```text
namespace/golf created
namespace/foxtrot created
```

## Create routes and services

Create a Service and Deployment in `foxtrot`:

```bash
kubectl apply -f https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/httpbin-service.yaml -n foxtrot
```

The result should look like:

```text
service/httpbin created
deployment.apps/httpbin created
```

Create an HTTPRoute to access the Service:

```bash
echo "
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: demo-route
  namespace: foxtrot
  annotations:
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - name: kong
    namespace: default
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /demo-route
    backendRefs:
    - name: httpbin
      kind: Service
      port: 80
" | kubectl apply -f -
```

The result should look like:
```text
httproute.gateway.networking.k8s.io/demo-route created
```

Create an authentication plugin:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: httpbin-basic-auth
  namespace: foxtrot
config:
  hide_credentials: true
plugin: basic-auth
' | kubectl apply -f -
```

The result should look like:
```text
kongplugin.configuration.konghq.com/httpbin-basic-auth created
``` 
and attach it to the Service:

```bash
kubectl annotate service httpbin -n foxtrot konghq.com/plugins=httpbin-basic-auth
``` 

The result should look like:
```text
service/httpbin annotated
``` 

## Create consumers and credentials

1. Create Secrets to add `basic-auth` credentials for two consumers:

    ```bash
    echo '
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: charlie-basic-auth
      namespace: golf
      labels:
        konghq.com/credential: basic-auth
    stringData:
        username: charlie
        password: charlie-password
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: david-basic-auth
      namespace: golf
      labels:
        konghq.com/credential: basic-auth
    stringData:
        username: david
        password: david-password
    ' | kubectl apply -f -
    ```

    The results should look like:
    ```text
    secret/charlie-basic-auth created
    secret/david-basic-auth created
    ```

1. Create consumers named `charlie` and `david` that use these credentials:

{% include /md/kic/consumer.md release=page.release name='charlie' credName='charlie-basic-auth' namespace='golf' %}

{% include /md/kic/consumer.md release=page.release name='david' credName='david-basic-auth' namespace='golf' %}

## Grant cross-namespace permissions

Bob and Alice wants to limit the amount of requests to the `httpbin` Service on
a per-consumer basis.  Because they only have access to their own namespaces,
they need to create rules that allow interactions across them.

By default, resources that support the [`konghq.com/plugins` annotation](/kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcomplugins)
can only attach plugins in their same namespace. `ReferenceGrant` resources can
grant permission to use plugins to resources in other namespaces.

To allow this cross-namespace interaction, Alice asks Bob to create a
ReferenceGrant in `foxtrot` that allows KongConsumers in `golf` to use
KongPlugins in `foxtrot`:

```bash
echo '
apiVersion: gateway.networking.k8s.io/v1beta1
kind: ReferenceGrant
metadata:
  name: golf-rate-limit
  namespace: foxtrot
spec:
  from:
  - group: "configuration.konghq.com"
    kind: KongConsumer
    namespace: golf
  to:
  - group: "configuration.konghq.com"
    kind: KongPlugin
' | kubectl apply -f -
```

The results should look like:
```text
referencegrant.gateway.networking.k8s.io/golf-rate-limit created
```

Such ReferenceGrants allow the `from` resource (KongConsumers in the `golf`
namespace) to interact with KongPlugins in the ReferenceGrant's namespace
(`foxtrot`).

## Create the cross-namespace plugins

With the ReferenceGrant in place, Bob can create the `rate-limiting`
KongPlugins:

```bash
echo '
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-charlie
  namespace: foxtrot
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 10
  policy: local
plugin: rate-limiting
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-david
  namespace: foxtrot
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 5
  policy: local
plugin: rate-limiting
' | kubectl apply -f -
```

The result should look like:
```text
kongplugin.configuration.konghq.com/rate-limit-charlie created
kongplugin.configuration.konghq.com/rate-limit-david created
``` 

## Attach the plugins to their resources

With the plugins in place, each namespace administrator can attach them to the
resources in their respective namespaces.

Alice attaches the plugins to the KongConsumers in `golf`. They use the
`<namespace>:<kongplugin-resource-name>` format in the plugin name to indicate
that the requested KongPlugin resides in another namespace:

```bash
kubectl annotate kongconsumer charlie -n golf konghq.com/plugins=foxtrot:rate-limit-charlie
kubectl annotate kongconsumer david -n golf konghq.com/plugins=foxtrot:rate-limit-david
``` 

The result should look like:

```text
kongconsumer.configuration.konghq.com/charlie annotated
kongconsumer.configuration.konghq.com/david annotated
``` 

Bob attaches the plugins to the `httpbin` Service in `foxtrot`:

```bash
kubectl annotate service httpbin --overwrite -n foxtrot konghq.com/plugins=httpbin-basic-auth,rate-limit-charlie,rate-limit-david
``` 

Note that this command overrides the entire plugin annotation, so it needs to
include the `httpbin-basic-auth` plugin from earlier in the list, not just the
new rate limiting plugins.

The result should look like:

```text
service/httpbin annotated
``` 

## Test the configuration

Send a request using the `charlie` consumer:

```bash
curl -sv $PROXY_IP/demo-route/status/200 -u charlie:charlie-password 2>&1 | grep "X-RateLimit-Remaining-Minute"
```
The results should show the remaining limit expected for `charlie`. Since
`charlie` can send 10 requests per minute, and has sent 1, the response should
indicate there are 9 requests remaining:

```text
< X-RateLimit-Remaining-Minute: 9
```

Send a request using the `david` consumer:

```bash
curl -sv $PROXY_IP/demo-route/status/200 -u david:david-password 2>&1 | grep "X-RateLimit-Remaining-Minute"
```
The results should show the remaining limit expected for `david`. Since
`david` can send 5 requests per minute, and has sent 1, the response should
indicate there are 4 requests remaining:

```text
< X-RateLimit-Remaining-Minute: 4
```
